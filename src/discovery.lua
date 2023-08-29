--St libarays
local capabilities = require("st.capabilities")
local Driver = require("st.driver")
local utils = require("st.utils")
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

			for nil, found in ipairs(mdnsResponse) do
				--Security Check for Service Name, nil and IPv4
				if found == nil or found.service_info.name ~= config.MDNS_SERVICE_NAME and net_utils.validate_ipv4_string(found.host_info.address) then
					goto continue
				end
				--Process mdns Response
				--Create Network ID from Hostname and mDNS Service Name ('HostName:ServiceName')
				local deviceNetworkId = found.host_info.name..config.DEVICE_ID_SPLIT_SYMBOL..found.service_info.name

				--If Device ist not known to the hub and has not been added in the current Search, add it to the hub
				if not knownDevices[networkID] and not foundDevices[networkID] then
					--Create Metadata of device
					local metaData = {
						type = "LAN",
						device_network_id = deviceNetworkId,
						label = hostname,
						profile = config.MAIN_PROFILE_NAME,
						manufacturer = "Aircookie",
						model = "WLED"
					}

					--Add device with Metadata
					log.info("Trying to create Device with: "..utils.stringify_table(metaData))
					assert(driver:try_create_device(metaData))
					foundDevices[networkID] = true
				
				else
					log.info("Discovered already known or found Device: "..deviceNetworkId)
				end
				::continue::
			end
		
		--small sleep on end of discovery (To let the Plattform check whether search is still being performed)
		socket.sleep(4)
	end
	log.info("Stopping Discovery-------")
end

return Discovery