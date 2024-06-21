local t = require(script.Parent.t)
local types = require(script.Parent.types)


local point_solvers = {
    [t.Vector3] = function(point: Vector3)
        return point
    end,

    [t.CFrame] = function(point: CFrame)
        return point.Position
    end,

    [t.instanceIsA('BasePart')] = function(part: BasePart)
        return part.Position
    end
}


local function get_vector3_points(...: ({types.Pointable} | types.Pointable)): {Vector3}
    local points = {}

    for _, point in {...} do
        local matched_solver = nil

        for match, solver in point_solvers do
            if not match(point) then
                continue
            end

            matched_solver = solver
            break
        end

        if matched_solver then 
            table.insert(points, matched_solver(point))
            continue
        end

        if t.table(point) then
            local inner_points = get_vector3_points(table.unpack(point))
            table.move(inner_points, 1, #inner_points, #points + 1, points)

            continue
        end

        error(`Point expected to be Pointable, not {typeof(point)}`)
    end

    return points
end


return get_vector3_points