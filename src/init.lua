local capabilities = require("st.capabilities")
local Driver = require("st.driver")

local discovery = require("discovery")
local lifecycles = require("lifecycles")
local handler = require("handler")

local wledDriver = Driver("example", {
	discovery = discovery.discovery_Handler,
	lifecycle_handlers = lifecycles,
	supported_capabilities = {
        capabilties.switch,
        capabilties.switchLevel,
        capabilties.colorControl,
        capabilties.refresh
		},
	  
	capability_handlers = {
        -- Switch command handler
        [capabilties.switch.ID] = {
          [capabilties.switch.commands.on.NAME] = handler.handle_on,
          [capabilties.switch.commands.off.NAME] = handler.handle_off
        },
		
	}
})

wledDriver:run()