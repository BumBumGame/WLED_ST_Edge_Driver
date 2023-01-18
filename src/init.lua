local capabilities = require("st.capabilities")
local Driver = require("st.driver")

local discovery = require("discovery");
local lifecycles = require("lifecycles");

local wledDriver = Driver("example", {
discovery = discovery.discovery_Handler
})

wledDriver:run()