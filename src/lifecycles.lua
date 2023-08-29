--St-imports
local log = require("log")
local mDNS = require("st.mdns")
local net_utils = require("st.net_utils")

--local imports
local tools = require("tools")
local handlers = require("handler")
local config = require("config")


local lifecyle_functions = {}

--init-lifecyle-----------------------------------------------
function lifecyle_functions.init(driver, device)
	log.info("Begin init lifecycle...")
	--Extract Dns data from Device ID
	local mdnsData = tools.split(device.device_network_id, config.DEVICE_ID_SPLIT_SYMBOL) --[1]:Hostname,[2]:ServiceName
	--Resolve device IP Adress
	local resolvedData = mDNS.resolve(mdnsData[1], mdnsData[2], "local") or {}
	--Process resolvedData (Take first IPv4 Adress found, else will be ignored)
	for _,found in pairs(resolvedData) do
		--If Valid adress is found: Save to transient Storage and Mark device as online
		if net_utils.validate_ipv4_string(found.address) then 
			log.info("Got IP for ["..mdnsData[1].."] : "..found.address)
			device:set_field("IP", found.address)
			device:online()
			--Refresh device to get init all Values
			handlers.handle_refresh(driver, device)
			--Goto end on success
			goto endInit
		end
	end
	
	::endInit::
	log.info("End init lifecycle...")
end

--removed-lifecyle-------------------------------------------
function lifecyle_functions.removed(driver, device)
	log.info("Begin removed lifecycle...")
	device:deleted()

	log.info("End removed lifecycle...")
end

--added-lifecyle---------------------------------------------
function lifecyle_functions.added()
	log.info("Begin added lifecycle...")

	log.info("End added lifecycle...")
end

--infoChanged-lifecyle---------------------------------------
function lifecyle_functions.infoChanged()
	log.info("Begin infoChanged lifecycle...")

	log.info("End infoChanged lifecycle...")
end

--driverSwitched-lifecyle------------------------------------
function lifecyle_functions.driverSwitched()
	log.info("Begin driverSwitched lifecycle...")

	log.info("End driverSwitched lifecycle...")
end

--infoChanged-lifecyle---------------------------------------
function lifecyle_functions.infoChanged()
	log.info("Begin infoChanged lifecycle...")

	log.info("End infoChanged lifecycle...")
end



return lifecyle_functions