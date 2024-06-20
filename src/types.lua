local LuauClass = require(script.Parent.LuauClass)


type cleanup = () -> ()
export type effect = (callback: (delta: number) -> ()) -> cleanup

export type Pointable = Vector3 | BasePart
export type Spline = {
    PrecomputeUnitSpeedData: (
        self: Spline,

        when: 'now' | 'ondemand'?,
        strategy: 'fast' | 'accurate'?,
        degree: number?
    ) -> (),

    SolveCFrameLookAlong: (
        self: Spline,

        alpha: number,
        unit_speed: boolean?,
        up_vector: Vector3?
    ) -> CFrame,

    SolveLength: (
        self: Spline,

        from: number?,
        to: number?
    ) -> number
}


export type Walker = LuauClass.Class<{
    on_update: (self: Walker, (CFrame) -> ()) -> (),
    on_reached: (self: Walker, () -> ()) -> (),

    update: (self: Walker, time: number, point: CFrame) -> ()
}, {
    time: number,
    point: CFrame,
    speed: number,

    __update_listeners: {(CFrame) -> ()},
    __reached_listeners: {() -> ()}
}, number>


export type Path = LuauClass.Class<{
    walker: (self: Path, speed: number) -> Walker,
    remove_walker: (self: Path, walker: Walker) -> (),

    solve_cframe: (self: Path, alpha: number) -> CFrame,

    start: (self: Path) -> (),
    stop: (self: Path) -> ()
}, {
    __points: {Vector3},
    __spline: Spline,

    __effect: effect,
    __cleanup: cleanup,
    __walkers: {Walker},

    length: number
}, (effect, number, number, ...({Pointable} | Pointable))>


return {}