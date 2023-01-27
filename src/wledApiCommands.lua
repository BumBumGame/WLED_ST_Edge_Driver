--St imports
local log = require("log")
local utils = require("st.utils")
--local imports
local http = require("httpJsonRequests")
require ("orderKeys")


local commands = {}


--local functions
--creates Device url
local function get_device_url(device)
	return "http://"..device:get_field("IP")
end

--prints a connection warning
local function printConnectionWarning(device, httpCode)
	log.warn("Device on '"..get_device_url(device).."' doesn't react! (Code: "..httpCode..")")
end

--sends post request to WLED state
local function send_WLED_State_POST_request(device, stateData)

	local httpCode = http.sendJsonPostRequest(get_device_url(device), "json/state", {}, stateData)
	
	if httpCode == 200 then
		return true
	end
	--else
	printConnectionWarning(device, httpCode)
	return false
end


------------------Strip_Commands-----------

--Get current Strip State ----------------------------------------------------------------------------
--Returns nil if not succesfull
function commands.wled_get_State(device)

	local httpCode, wledState = http.getJsonRequest(get_device_url(device), "json/state", {})
	
	if httpCode == 200 then
		return wledState;
	end
	
	--else
	printConnectionWarning(device, httpCode)
	return nil
end

--Get all wled Presets--------------------------------------------------------------------------------
--returns nil if not succesfull
function commands.wled_get_Presets(device)

	local httpCode, presetData = http.getJsonRequest(get_device_url(device), "presets.json", {})
	
	if httpCode == 200 then
		return presetData
	end
	
	--else
	printConnectionWarning(device, httpCode)
	return nil
end

--Turn strip on --------------------------------------------------------------------------------------
function commands.wled_turn_on(device)
	return send_WLED_State_POST_request(device, {on = true})
end

--Turn strip off --------------------------------------------------------------------------------------
function commands.wled_turn_off(device)
	return send_WLED_State_POST_request(device, {on = false})
end

--Set Strip level -------------------------------------------------------------------------------------
-- turns device on if level > 0
-- level - value between 0-255
function commands.wled_set_level(device, level)
	local on_State = true 
	
	if level == 0 then 
		on_State = false
	end
	
	return send_WLED_State_POST_request(device, {bri = level, on = on_State})
end

--Set Strip color ------------------------------------------------------------------------------------
--Color (Table) - containing {r,g,b}
function commands.wled_set_color(device, color)
	--get current state
	local currentSegmentCount = commands.wled_get_State(device).seg
	--if answer is nil - return
	if currentSegmentCount == nil then return false end
	
	--count Segments
	currentSegmentCount = #currentSegmentCount
	
	--create new color info object
	local newColorInfo = {seg = {}}
	
	--set color for each segment
	for i=1,currentSegmentCount do
		--set primary rgb to colour and every effect to static
		table.insert(newColorInfo.seg, {col = {color}, fx = 0})
	end
	
	return send_WLED_State_POST_request(device, newColorInfo)
end

--Set a a wled_Preset---------------------------------------------------------------------------------
function commands.wled_set_Preset(device, presetID)
	return send_WLED_State_POST_request(device, {ps = presetID})
end

------------------Strip_Converter--------------------------------------------------------------------
--Returns brightness level from state object (0-100%)
function commands.wled_get_Brightness_from_State(wledStateObject)
	return utils.round((wledStateObject.bri/255)*100)
end

--Returns hsl color values -> Hue,Saturation,Lightness
function commands.wled_get_Color_from_State(wledStateObject)
	--extract primary colour from main Segment
	local rgb = wledStateObject.seg[wledStateObject.mainseg + 1].col[1]
	return utils.rgb_to_hsl(rgb[1], rgb[2], rgb[3])
end

--Returns boolean wether strip is on or of
function commands.wled_get_On_from_State(wledStateObject)
	return wledStateObject.on
end

--Returns currentlySet Preset ID (-1 = no preset set)
function commands.wled_get_currentPresetID_from_State(wledStateObject)
	return wledStateObject.ps
end

--Returns string array with all preset names (Ordered!)
function commands.wled_get_presetNamesfrom_PresetTable(presetTable)
	local tmpList = {}
	
	for _,value in orderedPairs(presetTable) do
		table.insert(tmpList, value.n)
	end
	
	return tmpList
end

--Returns array with list of list[name] = id
function commands.wled_get_presetNamesWithID_from_PresetTable(presetTable)
	local tmpList = {}
	
	for key,value in pairs(presetTable) do
		tmpList[value.n] = key
	end
	
	return tmpList
end

return commands