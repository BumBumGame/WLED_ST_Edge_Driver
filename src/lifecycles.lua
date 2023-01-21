--St-imports
local log = require("log")
--local librarys
local mDNS = require("mDNS")
--local imports
local tools = require("tools")


local lifecyle_functions = {}

--init-lifecyle-----------------------------------------------
function lifecyle_functions.init(driver, device)
	log.info("Begin init lifecycle...")
	--load dns instance name 
	local instanceName = tools.split(device.device_network_id, ":")[1]
	--Get and save Device IP to transient storage
	mDNS.get_address(instanceName, function (ipAdress, port) 
		if ipAdress == nil then
			--mark device as offline and leave
			log.warn("Device: "..instanceName.." seems to be offline")
			device:offline()
			return
		end
		
		log.info("Got ip for: ["..instanceName.."] :"..ipAdress)
		device:online()
		device:set_field("IP", ipAdress)
	end)
	
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