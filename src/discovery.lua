local log = require "log"
local capabilities = require "st.capabilities"
local LANDriver = require "st.driver"

--local librarys
local mDNS = require "mDNS"
--local imports
local http = require("httpRequests")


local discovery = {}


--Functions
local function getMacFromController(){

}

local function discovery.discovery_Handler(driver, _, should_continue)
	local foundDevices = {}
	--Get known devices
	local knownDevices = {}
	local deviceList = Driver:get_devices();
		for _, device in deviceList do
			knownDevices[device.device_network_id] = true
		end

	
	while should_continue do 
		--Searching WLED mDNS Space
		local foundDevices = mDNS.get_services("_wled._tcp.local", function (deviceTable) 
			--iterate throught found devices
			for _,value in ipairs(deviceTable.instances) do
			 --get mac adress
			 local macAdress = http.sendGetRequestWithJsonResponse("http://" .. value["IP"] .. "/json/info", {})["mac"]
			 log.debug(macAdress);
			end
		
		end)
	end

end