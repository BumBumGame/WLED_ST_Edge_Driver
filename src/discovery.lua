--St libarays
local capabilities = require("st.capabilities")
local Driver = require("st.driver")
local utils = require("st.utils")
local log = require("log")

--local librarys
local mDNS = require("mDNS")
--local imports
local config = require("config")


local Discovery = {}

function Discovery.discovery_Handler(driver, _, should_continue)
	log.info("Starting Discovery-------")

	local foundDevices = {}
	
	--Get known devices
	local knownDevices = {}
	local deviceList = driver:get_devices();
		for _, device in ipairs(deviceList) do
			knownDevices[device.device_network_id] = true
		end

	
	while should_continue() do 
		--Searching WLED mDNS Space
			local dnsSpace = config.MDNS_SERVICE_NAME
			
		    mDNS.get_services(dnsSpace, function (deviceTable) 
			--iterate throught found devices
        	 for _,deviceName in ipairs(deviceTable[dnsSpace]["instances"]) do
			 
				--filter device MDns info
			    local macAdress = deviceTable[deviceName]["info"]["mac"]
				local networkID = deviceName..":"..macAdress
				
				if not knownDevices[networkID] and not foundDevices[networkID] then
				
					local metaData = {
						type = "LAN",
						device_network_id = networkID,
						label = deviceName,
						profile = config.MAIN_PROFILE_NAME,
						manufacturer = "Aircookie",
						model = "WLED"
					}
				
				  --Add Device
				  log.info("Trying to create Device with: "..utils.stringify_table(metaData))
				  assert(driver:try_create_device(metaData))
				  foundDevices[networkID] = true
			
				else
					log.info("Discovered known Device: "..networkID)
				end
			end
		
		end)
	end
	
	log.info("Stopping Discovery-------")
	
end

return Discovery