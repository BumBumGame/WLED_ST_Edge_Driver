local http = require("httpJsonRequests")
local log = require("log")
local capabilities = require("st.capabilities")

local handler = {}

--local functions
local function get_device_url(device)
return "http://"..device:get_field("IP")
end

function handler.handle_refresh(driver, device, cmd)

end

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



return handler