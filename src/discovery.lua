--St libarays
local capabilities = require("st.capabilities")
local Driver = require("st.driver")
local utils = require("st.utils")
local net_utils = require("st.net_utils")
local log = require("log")
local socket = require("socket")
local mDNS = require("st.mdns")

--local imports
local config = require("config")


local Discovery = {}

function Discovery.discovery_Handler(driver, _, should_continue)
	log.info("Starting Discovery-------")
	--tmp Variable to store found devices in this Search
	local foundDevices = {}
	
	--Get known devices
	local knownDevices = {}
	local deviceList = driver:get_devices();
		for _, device in ipairs(deviceList) do
			knownDevices[device.device_network_id] = true
		end

	
	while should_continue() do 
		--Searching WLED mDNS Space
			local mdnsResponse = mDNS.discover(config.MDNS_SERVICE_NAME, config.MDNS_PROTOCOL) or {};

			for _, found in pairs(mdnsResponse) do
				found = found[1] --One Step down in hierachy because of false Smartthings Plattform Documentation
				--Security Check for Service Name, nil and IPv4
				if found == nil or found.service_info.name ~= config.MDNS_SERVICE_NAME and not net_utils.validate_ipv4_string(found.host_info.address) then
					goto continue
				end
				--Process mdns Response
				--Create Network ID from Hostname and mDNS Service Name ('HostName:ServiceName')
				local deviceNetworkId = found.host_info.name..config.DEVICE_ID_SPLIT_SYMBOL..found.service_info.service_type

				--If Device ist not known to the hub and has not been added in the current Search, add it to the hub
				if not knownDevices[deviceNetworkId] and not foundDevices[deviceNetworkId] then
					--Create Metadata of device
					local metaData = {
						type = "LAN",
						device_network_id = deviceNetworkId,
						label = found.host_info.name,
						profile = config.MAIN_PROFILE_NAME,
						manufacturer = "Aircookie",
						model = "WLED"
					}

					--Add device with Metadata
					log.info("Trying to create Device with: "..utils.stringify_table(metaData))
					foundDevices[deviceNetworkId] = true
					assert(driver:try_create_device(metaData))
				
				else
					log.info("Discovered already known or found Device: "..deviceNetworkId)
					log.warn(should_continue())
				end
				::continue::
			end
		
		--small sleep on end of discovery (To let the Plattform check whether search is still being performed)
		socket.sleep(4)
	end
	log.info("Stopping Discovery-------")
end

return Discovery