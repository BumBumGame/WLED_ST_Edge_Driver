local cosock = require("cosock")
local http = cosock.asyncify "socket.http"
local ltn12 = require("ltn12")
local json = require('dkjson')
local neturl = require("net.url")


local http = {}


--Parameters as Table (optional)
function http.getJsonRequest(url, path, parameters)
  local dest_url = url..'/'..path
  local query = neturl.buildQuery(parameters or {})
  local res_body = {}

  -- HTTP Request
  local _, code = http.request({
    method="GET",
    url=dest_url..'?'..query,
    sink=ltn12.sink.table(res_body),
    headers={
      ['Content-Type'] = "application/json"
    }})

  -- Handle response
  if code == 200 then
    return code, json.decode(res_body)
  end
  return code, nil
end

--Parameters as Table!
function http.sendJsonPostRequest(url, path, parameters, postValueTable)
  local dest_url = url..'/'..path
  local query = neturl.buildQuery(parameters or {})
  local res_body = {}
  
  local jsonPostValues = json.encode(postValueTable)

  -- HTTP Request
  local _, code = http.request({
    method="POST",
    url=dest_url..'?'..query,
    sink=ltn12.sink.table(res_body),
    headers={
      ['Content-Type'] = "application/json",
	  ["Content-Length"] = string.len(request_body)
    }})

  -- Handle response
  if code == 200 then
    return code, json.decode(res_body)
  end
    return code, nil
end


return http