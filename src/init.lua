local capabilities = require("st.capabilities")
local Driver = require("st.driver")

local discovery = require("discovery")
local lifecycles = require("lifecycles")
local handler = require("handler")

local presetCapability = capabilities["wonderconnect56004.presets"]

local wledDriver = Driver("wled-rgb", {
	discovery = discovery.discovery_Handler,
	lifecycle_handlers = lifecycles,
	supported_capabilities = {
        capabilities.switch,
        capabilities.switchLevel,
        capabilities.colorControl,
        capabilities.refresh,
		presetCapability
		},
	  
	capability_handlers = {
        -- Switch command handler
        [capabilities.switch.ID] = {
          [capabilities.switch.commands.on.NAME] = handler.handle_on,
          [capabilities.switch.commands.off.NAME] = handler.handle_off
        },
		[capabilities.refresh.ID] = {
		  [capabilities.refresh.commands.refresh.NAME] = handler.handle_refresh
		},
		[capabilities.switchLevel.ID] = {
		  [capabilities.switchLevel.commands.setLevel.NAME] = handler.handle_setLevel
		},
		[capabilities.colorControl.ID] = {
		  [capabilities.colorControl.commands.setColor.NAME] = handler.handle_setColor
		},
		--[capabilities.mode.ID] = {
		 --[capabilities.mode.commands.setMode.NAME] = handler.handle_mode
		--}
		[presetCapability.ID] = {
		 [presetCapability.commands.setPreset.NAME] = handler.handle_scenes
		}
	}
})

wledDriver:run()