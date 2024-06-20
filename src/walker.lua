local LuauClass = require(script.Parent.LuauClass)
local types = require(script.Parent.types)


local Walker = LuauClass {_type = 'Walker'} :: types.Walker

function Walker:__init(speed: number)
    self.speed = speed
    self.time = 0
    self.point = CFrame.new()

    self.__update_listeners = {}
    self.__reached_listeners = {}
end

function Walker:on_update(listener: (CFrame) -> ())
    table.insert(self.__update_listeners, 1, listener)
end

function Walker:on_reached(listener: () -> ())
    table.insert(self.__reached_listeners, 1, listener)
end

function Walker:update(time: number, point: CFrame)
    self.time = time
    self.point = point

    for _, listener in self.__update_listeners do
        listener(self.point)
    end

    if self.time == 1 then
        for _, listener in self.__reached_listeners do
            listener()
        end
    end
end


return function(speed: number): types.Walker
    return Walker.new(speed)
end
