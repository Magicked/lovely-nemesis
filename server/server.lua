require "entity"
require "class"
require "utils"

local socket = require "socket"
local udp = socket.udp()

udp:settimeout(0)
udp:setsockname('*', 42424)

local entities = {}
local universe = {}
local data, msg_or_ip, port_or_nil
local id, cmd, parms
local update_frequency = 30 -- every 30 milliseconds
local last_update_time = socket.gettime() * 1000
local current_time = socket.gettime() * 1000

-- Set our universe settings
universe['world_size_x'] = 1000
universe['world_size_y'] = 1000

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
            if entities[id] == nil then
                -- Time to create the entity
                local ent_obj = entity:new(id)
                entities[id] = ent_obj
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
                    local x, y, angle, forcex, forcey = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*)$")
                    assert(x and y and angle and forcex and forcey) -- validation is better, but asserts will serve.
                    -- don't forget, even if you matched a "number", the result is still a string!
                    -- thankfully conversion is easy in lua.
                    x, y, angle, forcex, forcey = tonumber(x), tonumber(y), tonumber(angle), tonumber(forcex), tonumber(forcey)
                    entities[id]:set_position(x, y)
                    entities[id]:set_angle(angle)
                    entities[id]:set_force(forcex, forcey)
                elseif cmd == 'fire' then
                    -- <type> <x> <y> <angle> <forcex> <forcey>
                    local w_type, x, y, angle, forcex, forcey = parms:match("^(%S+) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*)$")
                    assert(w_type and x and y and angle and forcex and forcey) -- validation is better, but asserts will serve.
                    -- don't forget, even if you matched a "number", the result is still a string!
                    -- thankfully conversion is easy in lua.
                    x, y, angle, forcex, forcey = tonumber(x), tonumber(y), tonumber(angle), tonumber(forcex), tonumber(forcey)
                    entities[id]:fire_weapon(w_type, x, y, angle, forcex, forcey)
                elseif cmd == 'request_update' then
                    local option = parms:match("^(%S+)$")
                    assert(option)
                    if option == 'world_size' then
                        udp:sendto(string.format("world_size %d %d", universe[world_size_x], universe[world_size_y]), msg_or_ip, port_or_nil)
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

    -- is it time to send updates to clients?
    if current_time - last_update_time > update_frequency then

    end

    socket.sleep(0.01)
end

print "Server shutdown complete."