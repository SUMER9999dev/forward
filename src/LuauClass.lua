--!native


export type Class<Methods, Implementation, InitArguments...> = {
	__init: (self: Implementation & Methods, InitArguments...) -> (),

	_type: string,
	_should_init: boolean,

	new: (InitArguments...) -> Implementation & Methods,
} & Methods  & Implementation
export type ExtendedClass<Superior, Methods, Implementation, InitArguments...> = Class<Methods & Superior, Implementation & {super: Superior}, InitArguments...>

type LuauClassType = {is: (object: any, class_type: string) -> boolean, extend: <T, I>(self: any, from: I, to: T) -> T} & <T>(class: T) -> T


local function merge<T, I>(base: T, mod: I): I & T
	base = table.clone(base)

	for key, value in mod do
		base[key] = value
	end

	return base
end


local function __index_wrapper(class: {[any]: any}, self: {[any]: any}, index: any): any
	local index_in_class = rawget(class, index)

	if index_in_class ~= nil then
		return index_in_class
	end
	
	local custom_index = class.__custom_index

	if custom_index then
		return custom_index(self, index)
	end

	return nil
end


local BaseClass = {}

BaseClass.super = nil
BaseClass._type = ''


function BaseClass:__init()
end


function BaseClass.new(class, ...)
	if not class.__custom_index then
		class.__custom_index =  class.__index or function()
			return nil
		end

		class.__index = function(...)
			return __index_wrapper(class, ...)
		end
	end

	local self = setmetatable({}, class)

	self:__init(...)

	return self
end


local LuauClass = {}
LuauClass.__index = LuauClass


function LuauClass.__call<T>(self, class: T): T  
	if type(class) ~= 'table' then
		return error('Class must be table.')
	end

	class = merge(BaseClass, class)

	class.new = function(...)
		return BaseClass.new(class, ...)
	end

	return class
end

function LuauClass.is(object: any, class_type: string): boolean
	if typeof(object) ~= 'table' then
		return false
	end

	return object._type == class_type
end

function LuauClass:extend<T, I>(from: I, to: T): T
	if type(from) ~= 'table' then
		return error('Superior class must be table.')
	end

	if type(from) ~= 'table' then
		return error('Successor class must be table.')
	end

	to = to or {}
	to.super = from

	to = merge(from, to)

	return self(to)
end


return setmetatable({}, LuauClass) :: LuauClassType