local http_request = require "http.request"
local json = require 'dkjson'

local http = {}

--get parameter as table!!!
local function http.sendGetRequestWithJsonResponse(url, getParameters)
    url = url .. "?";
	
	for key,value in pairs(getParameters) do 
	   url = url .. key .. "=" .. value .. "&"
	end 
	
	local headers, stream = assert(http_request.new_from_uri(url):go())
	local body = assert(stream:get_body_as_string())
	if headers:get ":status" ~= "200" then
		return nil;
	end
    return json.decode(body)
end

local function http.sendGetRequestWithoutResponse(url, getParameters)

end


return http