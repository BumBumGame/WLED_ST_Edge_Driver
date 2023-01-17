local cosock = require "cosock"
local http = cosock.asyncify "socket.http"
local ltn12 = require "ltn12"
local json = require 'dkjson'

local http = {}

--get parameter as table!!!
function http.sendGetRequestWithJsonResponse(url, getParameters)
    url = url .. "?";
	
	for key,value in pairs(getParameters) do 
	   url = url .. key .. "=" .. value .. "&"
	end 
	
	local answerBodyTable = {};
	
	 local success, code, headers, status = http.request({
	 url = url,
	 sink = ltn12.sink.table(answerBodyTable),
	 create = function () 
		local sock = cosock.socket.tcp()
		sock:settimeout(3)
		return sock
	 end
	 })
	 
    return json.decode(table.toString(answerBodyTable))
	
end

function http.sendGetRequestWithoutResponse(url, getParameters)

end


return http