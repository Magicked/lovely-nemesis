require "entity"
require "class"
require "utils"

local socket = require "socket"
local udp = socket.udp()

udp:settimeout(0)
udp:setsockname('*', 42424)

local universe = {}
local data, msg_or_ip, port_or_nil
local id, cmd, parms

local running = true
print "Beginning server loop."
while running do
	data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then
        data = chomp(data)
        id, cmd, parms = data:match("^(%S*) (%S*)[%s]*(.*)")
        if id == nil then
            udp:sendto("ERROR Unknown Command: id is nil\n", msg_or_ip, port_or_nil)
        else
            print ("id is ", id, " - cmd is ", cmd, " - parms is ", parms)
            if universe[id] == nil then
                -- Time to create the entity
                local ent_obj = entity:new(id)
                universe[id] = ent_obj
                if cmd == 'login' then
                    local name = parms:match("^([%a]+)$")
                    if name ~= ''  and name ~= nil then
                        ent_obj:set_position(100, 100)
                        ent_obj:set_name(name)
                        print ("User "..name.." connected!")
                    else
                        udp:sendto("ERROR Bad Username\n", msg_or_ip, port_or_nil)
                        print("Bad username: ", name)
                    end
                else
                    udp:sendto("ERROR Unknown Command\n", msg_or_ip, port_or_nil)
                end
            else
                if cmd == 'move' then
                    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                    assert(x and y) -- validation is better, but asserts will serve.
                    -- don't forget, even if you matched a "number", the result is still a string!
                    -- thankfully conversion is easy in lua.
                    x, y = tonumber(x), tonumber(y)
                    -- and finally we stash it away
                    local ent = world[id] or {x=0, y=0}
                    universe[id] = {x=ent.x+x, y=ent.y+y}
                elseif cmd == 'at' then
                    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                    assert(x and y) -- validation is better, but asserts will serve.
                    x, y = tonumber(x), tonumber(y)
                    universe[id] = {x=x, y=y}
                elseif cmd == 'update' then
                    for k, v in pairs(world) do
                        udp:sendto(string.format("%s %s %d %d", k, 'at', v.x, v.y), msg_or_ip,  port_or_nil)
                    end
                elseif cmd == 'quit' then
                    running = false;
                else
                    print("unrecognised command:", cmd)
                end
            end
        end
    elseif msg_or_ip ~= 'timeout' then
        error("Unknown network error: "..tostring(msg))
    end
   
    socket.sleep(0.01)
end

print "Server shutdown complete."