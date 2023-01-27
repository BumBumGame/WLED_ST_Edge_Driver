local tools = {}


--Splits a string into multiple Parts after every serperator
-- inputstr (String) - String to be splitted
-- sep (String) - Seperator 
--return Table-List with ervery string seperation
function tools.split(inputstr, sep)
   if sep == nil then
      sep = "%s"
   end
   
   local t={}
   
   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
   end
   
   return t
end


return tools