local capabilities = require("st.capabilities")
local Driver = require("st.driver")

local discovery = require("discovery")
local lifecycles = require("lifecycles")
local handler = require("handler")

local wledDriver = Driver("example", {
	discovery = discovery.discovery_Handler,
	lifecycle_handlers = lifecycles,
	supported_capabilities = {
        caps.switch,
        caps.switchLevel,
        caps.colorControl,
        caps.refresh
		},
	  
	capability_handlers = {
        -- Switch command handler
        [caps.switch.ID] = {
          [caps.switch.commands.on.NAME] = handler.handle_on,
          [caps.switch.commands.off.NAME] = handler.handle_off
        },
		
	}
})

wledDriver:run()