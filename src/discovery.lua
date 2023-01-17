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
		
	end

end