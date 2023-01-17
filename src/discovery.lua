local log = require "log"
local capabilities = require "st.capabilities"
local Driver = require "st.driver"

--local librarys
local mDNS = require "mDNS"
--local imports
local http = require("httpRequests")


local Discovery = {}


--Functions
local function getMacFromController()

end

--tmp--------------------------------------------------------
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
--tmp--------------------------------------------------------

function Discovery.discovery_Handler(driver, _, should_continue)
	local foundDevices = {}
	--Get known devices
	local knownDevices = {}
	local deviceList = driver:get_devices();
		for _, device in ipairs(deviceList) do
			knownDevices[device.device_network_id] = true
		end

	
	while should_continue do 
		--Searching WLED mDNS Space
		    mDNS.get_services("_wled._tcp.local", function (deviceTable) 
			--iterate throught found devices
			log.info("DeviceTable: " .. dump(deviceTable)) -- -->> Contains MAC!!!!! --> Table:  DeviceTable: { ["wled-996ad8.local"] = { ["ip"] = 192.168.178.61,} ,["wled-996ad8._wled._tcp.local"] = { ["info"] = { ["mac"] = e8db84996ad8,} ,["hostnames"] = { [1] = wled-996ad8.local,} ,["port"] = 80,} ,["_wled._tcp.local"] = { ["instances"] = { [1] = wled-996ad8._wled._tcp.local,} ,} ,}
			for _,value in ipairs(deviceTable.instances) do
			 
			 
			end
		
		end)
	end

end

return Discovery