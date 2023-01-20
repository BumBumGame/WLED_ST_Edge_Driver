local mDNS = require("mDNS")
local tools = require("tools")
local log = require("log")

local lifecyle_functions = {}

function lifecyle_functions.init(driver, device)
--load dns instance name 

local instanceName = tools.split(device.device_network_id, ":")[1]
	log.info("Init run!")
--Get and save Device IP to transient storage
mDNS.get_address(instanceName, function (ipAdress, port) 
		log.info("Got ip for: ["..instanceName.."] :"..ipAdress)
		device:set_field("IP", ipAdress)
	end)
end

function lifecyle_functions.removed(driver, device)
device:deleted()
end
return lifecyle_functions