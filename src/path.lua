local LuauClass = require(script.Parent.LuauClass)
local CatRom = require(script.Parent.CatRom)

local get_vector3_points = require(script.Parent.get_vector3_points)

local Walker = require(script.Parent.walker)
local types = require(script.Parent.types)


local Path = LuauClass {_type = 'Path'} :: types.Path

function Path:__init(effect, alpha, tension, ...)
    self.__walkers = {}
    self.__points = get_vector3_points(...)

    self.__spline = CatRom.new(self.__points, alpha, tension)
    self.__effect = effect

    self.length = self.__spline:SolveLength()

    self.__spline:PrecomputeUnitSpeedData('now', 'fast')
end

function Path:start()
    if self.__cleanup  then
        error('Path already started')
    end

    self.__cleanup = self.__effect(function(delta: number)
        for _, walker in self.__walkers do
            local alpha_passed = (delta * walker.speed) / self.length

            local new_alpha = math.clamp(walker.time + alpha_passed, 0, 1)
            local new_point = self:solve_cframe(new_alpha)

            walker:update(new_alpha, new_point)

            if walker.time == 1 then
                self:remove_walker(walker)
            end
        end
    end)
end

function Path:solve_cframe(alpha: number)
    return self.__spline:SolveCFrameLookAlong(alpha, true)
end

function Path:remove_walker(walker: types.Walker)
    local index = table.find(self.__walkers, walker)

    if index then
        table.remove(self.__walkers, index)
    end
end

function Path:stop()
    if not self.__cleanup then
        error('Path not running yet')
    end

    self.__cleanup()
    self.__cleanup = nil
end

function Path:walker(speed: number)
    local walker = Walker(speed)
    table.insert(self.__walkers, 1, walker)

    return walker
end


return function(effect: types.effect, alpha: number, tension: number, ...): types.Path
    return Path.new(effect, alpha, tension, ...)
end
