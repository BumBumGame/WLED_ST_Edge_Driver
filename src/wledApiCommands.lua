--St imports
local log = require("log")
local utils = require("st.utils")
--local imports
local http = require("httpJsonRequests")


local commands = {}


--local functions
local function get_device_url(device)
	return "http://"..device:get_field("IP")
end

local function printConnectionWarning(device, httpCode)
	log.warn("Device on '"..get_device_url(device).."' doesn't react! (Code: "..httpCode..")")
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
	local httpCode = http.sendJsonPostRequest(get_device_url(device), "json/state", {}, {on = true})
	
	if httpCode == 200 then
		return true
	end
	--else
	printConnectionWarning(device, httpCode)
	return false
end

--Turn strip off --------------------------------------------------------------------------------------
function commands.wled_turn_off(device)
	local httpCode = http.sendJsonPostRequest(get_device_url(device), "json/state", {}, {on = false})
	
	if httpCode == 200 then
		return true
	end
	--else
	printConnectionWarning(device, httpCode)
	return false
end

--Set Strip level -------------------------------------------------------------------------------------
-- turns device on if level > 0
--level - value between 0-255
function commands.wled_set_level(device, level)
	local on_State = true 
	
	if level == 0 then 
		on_State = false
	end
	
	local httpCode = http.sendJsonPostRequest(get_device_url(device), "json/state", {}, {bri = level, on = on_State})
	
	if httpCode == 200 then
		return true
	end
	--else
	printConnectionWarning(device, httpCode)
	return false
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
	
	--send new info to wled
	local httpCode = http.sendJsonPostRequest(get_device_url(device), "json/state", {}, newColorInfo)
	
	if httpCode == 200 then
		return true
	end
	--else:
	printConnectionWarning(device, httpCode)
	return false
end

--Set a a wled_Preset---------------------------------------------------------------------------------
function commands.wled_set_Preset(device, presetID)
	
	local httpCode = http.sendJsonPostRequest(get_device_url(), "json/state", {}, {ps = presetID})
	
	if httpCode == 200 then
		return true
	end
	--else:
	printConnectionWarning(device, httpCode)
	return false
end

------------------Strip_Converter-----------
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
function commands.wled_get_currentPreset_from_State(wledStateObject)
	return wledStateObject.ps
end

return commands