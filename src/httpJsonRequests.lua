--St Librarys
local utils = require("st.utils")
local log = require("log")
--Lua Librarys
local cosock = require("cosock")
local http = cosock.asyncify "socket.http"
local neturl = require("net.url")

local ltn12 = require("ltn12")
local json = require('dkjson')


local httpFunctions = {}


--Uses http-GET to request a jsonObject from target
-- url (String) - Devcice url (eg. "http://xxx.xxx.xxx")
-- path (String) - Path after url
-- parameters (Table) - Get Parameters for url
--return: Http-Status-Code, decodedJsonResponse (if received)
function httpFunctions.getJsonRequest(url, path, parameters)
	local dest_url = url..'/'..path
	local query = neturl.buildQuery(parameters or {})
	local res_body = {}

	-- HTTP Request
	local _, code = http.request({
		method="GET",
		url=dest_url..'?'..query,
		sink=ltn12.sink.table(res_body),
		
		headers={
			['Content-Type'] = "application/json",
			["Content-Length"] = 0
		}
	})
	
	-- Handle response
	if code == 200 then
		return code, json.decode(table.concat(res_body))
	end
	
	return code, nil
end

--Uses http-POST to request a jsonObject from target with postValues
-- url (String) - Devcice url (eg. "http://xxx.xxx.xxx")
-- path (String) - Path after url
-- parameters (Table) - Get Parameters for url
-- postValueTable (Table) - Post parameters for request
-- return: Http-Status-Code, decodedJsonResponse (if received)
function httpFunctions.sendJsonPostRequest(url, path, parameters, postValueTable)
	local dest_url = url..'/'..path
	local query = neturl.buildQuery(parameters or {})
	local res_body = {}
  
	local jsonPostValues = json.encode(postValueTable)

	-- HTTP Request
	local _, code = http.request({
		method="POST",
		url=dest_url..'?'..query,
		
		headers={
			['Content-Type'] = "application/json",
			["Content-Length"] = string.len(jsonPostValues)
		},
		
		sink=ltn12.sink.table(res_body),
		source = ltn12.source.string(jsonPostValues)
	})

	-- Handle response
	if code == 200 then
		return code, json.decode(table.concat(res_body))
	end
	
    return code, nil
end

--Uses http-Get to request data from url
-- url (String) - Devcice url (eg. "http://xxx.xxx.xxx")
-- return: Boolean, Whether device reponded or not
function httpFunctions.getDeviceOnlineStatus(url)
	local _, code = http.request({
		method="GET",
		url=url
	})
	
	if code == 200 then
		return true;
	end
	
	return false
end


return httpFunctions