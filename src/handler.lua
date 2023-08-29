--ST-Libararys
local log = require("log")
local capabilities = require("st.capabilities")
local utils = require("st.utils")

--local imports
local wled_commands = require("wledApiCommands")
local presetCapability = capabilities["wonderconnect56004.presets"]


local handler = {}

--refresh_Handler---------------------------------------------------------------------------------------
function handler.handle_refresh(driver, device)

	--load state object of device
	local wledState = wled_commands.wled_get_State(device)
	--load current preset list of device
	local wledPresets = wled_commands.wled_get_Presets(device)
	
	--if unsuccessfull set device as offline
	if wledState == nil or wledPresets == nil then
		device:offline()
		return
	end
	--else:
		
	--Set device online
	device:online()
	
	--Update device state--------
	--brightness-----------------:
	device:emit_event(capabilities.switchLevel.level(wled_commands.wled_get_Brightness_from_State(wledState)))
		
	--On_off---------------------:
	if wled_commands.wled_get_On_from_State(wledState) then 
		device:emit_event(capabilities.switch.switch.on())
	else
		device:emit_event(capabilities.switch.switch.off())
	end	
	
	--color----------------------:
	local hue, sat, lightness = wled_commands.wled_get_Color_from_State(wledState)
			
	device:emit_event(capabilities.colorControl.saturation(utils.round(sat*(1-lightness/200))))
	device:emit_event(capabilities.colorControl.hue(hue))
	
	--Presets--------------------:
	local presetList, currentPresetName = wled_commands.wled_get_presetNamesfrom_PresetTable_and_searchName(wledPresets, wled_commands.wled_get_currentPresetID_from_State(wledState))
	
	device:emit_event(presetCapability.installedPresets(presetList))
	
	--check current preset
	if currentPresetName == nil then
		--Set to none if no preset is selected
		device:emit_event(presetCapability.activePreset("-"))
	else
		--Set to current preset if active
		device:emit_event(presetCapability.activePreset(currentPresetName))
	end
end

--on_Handler------------------------------------------------------------------------------------------
function handler.handle_on(driver, device, cmd)
	if wled_commands.wled_turn_on(device) then
		--change state
		device:emit_event(capabilities.switch.switch.on())
	end
end

--off_Handler-----------------------------------------------------------------------------------------
function handler.handle_off(driver, device, cmd)
	if wled_commands.wled_turn_off(device) then
		--change state
		device:emit_event(capabilities.switch.switch.off())
	end
end

--set_level Handler----------------------------------------------------------------------------------
function handler.handle_setLevel(driver, device, cmd)
	local newBrightness = utils.round(255*(cmd.args.level/100))
	
	if wled_commands.wled_set_level(device, newBrightness) then
		--change state
		device:emit_event(capabilities.switchLevel.level(cmd.args.level))
		
		if cmd.args.level == 0 then
			device:emit_event(capabilities.switch.switch.off())
		else
			device:emit_event(capabilities.switch.switch.on())
		end
	end
end

--Color_Control handler--------------------------------------------------------------------------------
function handler.handle_setColor(driver, device, cmd)
	local r, g, b = utils.hsl_to_rgb(cmd.args.color.hue, cmd.args.color.saturation)
	
	if wled_commands.wled_set_color(device, {r,g,b}) then
		--If succesfull: Emit Events
		device:emit_event(capabilities.colorControl.saturation(cmd.args.color.saturation))
		device:emit_event(capabilities.colorControl.hue(cmd.args.color.hue))
	end
end

--Mode(Preset) handler-----------------------------------------------------------------------------------------
function handler.handle_mode(driver, device, cmd)
	--get current available presets
	local currentPresetState = wled_commands.wled_get_Presets(device)
	
	if currentPresetState == nil then
		--leave if failed
		return
	end
	
	--extract ID list
	local presetIds = wled_commands.wled_get_presetNamesWithID_from_PresetTable(currentPresetState)
	
	--check if presetName has an id
	if presetIds[cmd.args.mode] == nil then
		--if not skip and goto refresh
		goto refresh
	end
	
	--send presetTo device
	if not wled_commands.wled_set_Preset(device, presetIds[cmd.args.mode]) then 
		--end
		return
	end
	
	--refresh device after setting preset
	::refresh::
	handler.handle_refresh(driver, device)
end
---------------------------------------------------------------------------------------------------------------
----Scene Preset Handler--------------
function handler.handle_scenes()
		--get current available presets
	local currentPresetState = wled_commands.wled_get_Presets(device)
	
	if currentPresetState == nil then
		--leave if failed
		return
	end
	
	--extract ID list
	local presetIds = wled_commands.wled_get_presetNamesWithID_from_PresetTable(currentPresetState)
	
	--check if presetName has an id
	if presetIds[cmd.args.preset] == nil then
		--if not skip and goto refresh
		goto refresh
	end
	
	--send presetTo device
	if not wled_commands.wled_set_Preset(device, presetIds[cmd.args.preset]) then 
		--end
		return
	end
	
	--refresh device after setting preset
	::refresh::
	handler.handle_refresh(driver, device)
end
---------------------------------

return handler