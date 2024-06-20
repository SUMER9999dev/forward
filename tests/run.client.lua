task.wait(5)
print('START!')

local Forward = require(game.ReplicatedStorage.Packages.Forward)
local CollectionService = game:GetService('CollectionService')


local waypoints = {}


for _, waypoint in CollectionService:GetTagged('Waypoint') do
    table.insert(waypoints, waypoint)
end


table.sort(waypoints, function(first, second)
    return first:GetAttribute('id') < second:GetAttribute('id')
end)


local one_frame_effect = function(callback)
    local thread = task.spawn(function()
        while true do
            local delta = task.wait(1)
            callback(delta)
        end
    end)

    return function()
        task.cancel(thread)
    end
end


local render_effect = function(callback)
    local connection = game:GetService('RunService').RenderStepped:Connect(callback)

    return function()
        connection:Disconnect()
    end
end


local path = Forward.Path(render_effect, 0.5, 0.6, waypoints)

local function spawn_enemy()
    local enemy = Instance.new('Part')

    enemy.Size = Vector3.new(1, 1, 1)
    enemy.Anchored = true
    enemy.Parent = workspace

    local walker = path:walker(math.random(20, 50))

    walker:on_update(function(point)
        enemy.CFrame = point
    end)

    walker:on_reached(function()
        enemy:Destroy()
    end)
end

path:start()

for _ = 1, 20 do
    task.spawn(function()
        for _ = 1, 150 do
            spawn_enemy()
            task.wait(0.2)
        end
    end)
end