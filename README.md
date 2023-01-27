# WLED Samsung Edge Driver
This Driver adds the ability to find and control RGB-Strips powered by [Aircookies WLED](https://github.com/Aircoookie/WLED) with Samsung Smartthings.
## Current Features
- [x] Turn Device on/off
- [x] Set Brightness of Device
- [x] Set Color of Device (All Segments at once!)
- [x] Smartthings Refresh functionality (Drag down to update Device-State)
- [x] Scan detection via mDns
- [x] Online/Offline marking
- [x] Dynamic Loading and starting of Device-Presets
## Planned Features
- [ ] Auto refreshing of WLED Device-State (With UDP-Broadcast or sheduled checks)
- [ ] Set Custom Transition for State-Changes in Smartthings
- [ ] Check WLED Version and only add supported devices
## Installation
1. Click on the invitation link to my WLED_Driver_Release-Channel:
	https://bestow-regional.api.smartthings.com/invite/Q1jPBXJBkp2L
2.  Log into your Samsung Account.
3. Click "Accept", to accept the invitation.
4. Click on "Drivers".
5. Click "Install" to install the driver on your Hub.
6. Start "Search for nearby devices" in your Smarthingsapp and wait for it to find all wled devices.

*Alternative: Create your own package from the source code under the release hub and enroll it manually*
## Requirements
There are no specific Requirements yet, but the following have to at least be met.

1. Smartthings hub supporting Edge drivers
2. Version of WLED which supports the JSON API, mDNS and Segments (currently tested on V. 0.13.0-b6)

A feature is planned for the driver to automatically check the running WLED Version and only add devices with a supported Version.

**Important: Currently all WLED Devices with mDns will be added to Smartthings. So please check if your WLED Version has all the needed Capabilities!**
##
## Credit
-	[toddaustin07's mDNS Library](https://github.com/toddaustin07/mDNS)
