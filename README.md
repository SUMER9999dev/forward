# 🏃🏻 Forward
TD movement library, specially created for MelonBytes Studio

# install 
``sumer9999dev/forward@1.0.0``

# Documentation
Create path:
```lua
-- Forward.Path(effect, alpha, tension, ...points)
local path = Forward.Path(
    render_stepped_effect, 0.5, 0.6,
    {
        Vector3.new(100, 10, 100),
        Vector3.new(110, 10, 150),
        Vector3.new(120, 10, 200)
    },
    workspace.point_4,
    {
        workspace.point_5,
        workspace.point_6
    }
)
```

Create effect for path:
```lua
local function render_stepped_effect(callback)
    local connection = game:GetService('RunService').RenderStepped:Connect(callback)

    return function() connection:Disconnect() end
end
```

Start path:
```lua
path:start()
```

Stop path:
```lua
path:stop()
```

Solve cframe at point:
```lua
path:solve_cframe(0.1)
```

Walker:
```lua
local walker = path:walker(10)  -- 10 is start speed

walker.speed = 15  -- you can edit speed in runtime

walker:on_update(function(point: CFrame)
    print(point.Position)
end)

walker:on_reached(function()
    print('reached')
end)

path:remove_walker(walker)  -- also you can remove walker
```