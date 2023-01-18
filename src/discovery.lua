local log = require "log"
local capabilities = require "st.capabilities"
local Driver = require "st.driver"
local utils = require "st.utils"

--local librarys
local mDNS = require "mDNS"
--local imports


local Discovery = {}


--Functions
local function getMacFromController()

end

function Discovery.discovery_Handler(driver, _, should_continue)
	local foundDevices = {}
	--Get known devices
	local knownDevices = {}
	local deviceList = driver:get_devices();
		for _, device in ipairs(deviceList) do
			knownDevices[device.device_network_id] = true
		end

	
	while should_continue() do 
		--Searching WLED mDNS Space
			local dnsSpace = "_wled._tcp.local"
		    mDNS.get_services(dnsSpace, function (deviceTable) 
			--iterate throught found devices
			log.info("DeviceTable: " .. utils.stringify_table(deviceTable)) -- -->> Contains MAC!!!!! --> Table:  DeviceTable: { ["wled-996ad8.local"] = { ["ip"] = 192.168.178.61,} ,["wled-996ad8._wled._tcp.local"] = { ["info"] = { ["mac"] = e8db84996ad8,} ,["hostnames"] = { [1] = wled-996ad8.local,} ,["port"] = 80,} ,["_wled._tcp.local"] = { ["instances"] = { [1] = wled-996ad8._wled._tcp.local,} ,} ,}
			for _,deviceName in ipairs(deviceTable[dnsSpace]["instances"]) do
			 local deviceInfo = {
				macAdress = deviceTable[deviceName]["info"]["mac"],
				ipAdress = deviceTable[deviceTable[deviceName]["info"]["hostnames"][1]]["ip"]
			 }
			 log.info("DeviceInfo: " .. utils.stringify_table(deviceInfo))
			end
		
		end)
	end

end

return Discovery