local http = require("httpJsonRequests")
local log = require("log")
local capabilities = require("st.capabilities")

local handler = {}

function handler.handle_refresh(device, driver, cmd)

end

function handler.handle_on(device, driver, cmd)
	local httpCode = http.sendJsonPostRequest(get_device_url(), "json/state", {}, {on = true})
	if httpCode == 200 then
		--change state
		device:emit_event(capabilities.switch.switch.on())
	end
end

function handler.handle_off(device, driver, cmd)
	local httpCode = http.sendJsonPostRequest(get_device_url(), "json/state", {}, {on = false})
	if httpCode == 200 then
		--change state
		device:emit_event(capabilities.switch.switch.off())
	end
end

--local functions
local function get_device_url()
return "http://"..driver:get_field("IP")
end

return handler