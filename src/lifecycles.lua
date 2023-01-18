local mDNS = require("mDNS")
local tools = require("tools")

local lifecyle_functions = {}

function lifecyle_functions.init(driver, device)
--load dns instance name 
local instanceName = tools.split(driver.device_network_id, ":")[1]
--Get and save Device IP

end

return lifecyle_functions