local http = require("httpJsonRequests")
local log = require("log")
local capabilities = require("st.capabilities")
local utils = require("st.utils")

local handler = {}

--local functions
local function get_device_url(device)
return "http://"..device:get_field("IP")
end

--refresh
function handler.handle_refresh(driver, device, cmd)
	local deviceUrl = get_device_url(device)
--load state object of device
	local httpCode, wledState = http.getJsonRequest(deviceUrl, "json/state", {})
		if httpCode == 200 then
			--Set device online
			device:online()
			--Update device state
			--brightness:
			device:emit_event(capabilities.switchLevel.level((utils.round((wledState.bri/255)*100))))
			--color:
			--extract primary colour from main Segment
			local rgb = wledState.seg[wledState.mainseg + 1].col[1]
			local hue, sat, lightness = utils.rgb_to_hsl(rgb[1], rgb[2], rgb[3])
			
			device:emit_event(capabilities.colorControl.saturation(utils.round(sat*(1-lightness/100))))
			device:emit_event(capabilities.colorControl.hue(hue))
		
			--On_off:
			if wledState.on then 
				device:emit_event(capabilities.switch.switch.on())
			else
				device:emit_event(capabilities.switch.switch.off())
			end
		else
			--print error and mark as offline
			log.warn("Device: "..deviceUrl.. " not responding!")
			device:offline()
		end
end

--on_off handler
function handler.handle_on(driver, device, cmd)
	local httpCode = http.sendJsonPostRequest(get_device_url(device), "json/state", {}, {on = true})
	if httpCode == 200 then
		--change state
		device:emit_event(capabilities.switch.switch.on())
	end
end

function handler.handle_off(driver, device, cmd)
	local httpCode = http.sendJsonPostRequest(get_device_url(device), "json/state", {}, {on = false})
	if httpCode == 200 then
		--change state
		device:emit_event(capabilities.switch.switch.off())
	end
end

--set level handler
function handler.handle_setLevel(driver, device, cmd)
	local newBrightness = utils.round(255*(cmd.args.level/100))
	--turn device on if brightness bigger than 0
	local on_State = true 
	if cmd.args.level == 0 then on_State = false 
	end
	
	local httpCode = http.sendJsonPostRequest(get_device_url(device), "json/state", {}, {bri = newBrightness, on = on_State})
	if httpCode == 200 then
		--change state
		device:emit_event(capabilities.switchLevel.level(cmd.args.level))
		
		if on_State then
			device:emit_event(capabilities.switch.switch.on())
		else
			device:emit_event(capabilities.switch.switch.off())
		end
	end
end

--Color handler
function handler.handle_setColor(driver, device, cmd)
	local r, g, b = utils.hsl_to_rgb(cmd.args.color.hue, cmd.args.color.saturation)
	
	--get segment-List from Strip
	local httpCode, sateObject = http.getJsonRequest(get_device_url(device), "json/state", {})
	if httpCode == 200 then
		--generate new segment info
		local newSegmentInfo = {}
		
		for key,_ in ipairs(stateObject.seg) do
			--set primary rgb to colour
			newSegmentInfo[key].col = {{r,g,b}}
			--set effect to static
			newSegmentInfo[key].fx = 0
		end
		
		--send new info to wled
		local httpCode = sendJsonPostRequest(get_device_url(device), "json/state", {}, newSegmentInfo)
		if httpCode == 200 then
			--If succesfull: Emit Events
			device:emit_event(capabilities.colorControl.saturation(cmd.args.color.saturation))
			device:emit_event(capabilities.colorControl.hue(cmd.args.color.hue))
		end
	end
end


return handler