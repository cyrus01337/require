--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(script.Types)

local requireMeta = {}

function requireMeta:__tostring(): string
	return "function: require"
end

local function containsDuplicate(container: Types.Array<Instance | string>): boolean
	local total = #container

	for index, value in container do
		for innerIndex = index + 1, total do
			if value == container[innerIndex] then
				return true
			end
		end
	end

	return false
end

local function maybeThrow(message: string, condition: boolean, ...: any): nil
	if not condition then
		return
	end

	local formatted = string.format(message, ...)

	error(formatted)
end

local function findFirstModule(name: string, from: Instance, path: string): Instance?
	local instance = from:FindFirstChild(name)

	maybeThrow("cannot locate module %s in %s from import %s", not instance, name, from:GetFullName(), path)

	return instance
end

local function processPath(path: Instance | string, moduleDirectory: Instance): (Instance, Types.Array<string>)
	local instance, routes
	local parent = moduleDirectory
	local path: string = if typeof(path) == "string" then path else path:GetFullName()
	local partitions = path:split("/")
	local totalPartitions = #partitions

	for i, partition in partitions do
		if i < totalPartitions then
			parent = findFirstModule(partition, parent, path)
		else
			routes = partition:split(".")
			local head = table.remove(routes, 1)
			instance = findFirstModule(head, parent, path)
		end
	end

	return instance, routes
end

type Props = {
	AllowDuplicates: boolean?,
	Directory: Instance?,
}

local DEFAULT_PROPS: Props = {
	AllowDuplicates = false,
	Directory = ReplicatedStorage,
}

local function processParameters(args: { Instance | string | Props }): ({ Instance | string }, Props)
	local props = args[#args]

	if typeof(props) ~= "table" then
		return args :: { Instance | string }, DEFAULT_PROPS
	end

	for property: string, defaultValue in DEFAULT_PROPS :: { [string]: any } do
		if props[property] == nil then
			props[property] = defaultValue
		end
	end

	table.remove(args, #args)

	return args :: { Instance | string }, props
end

type Require = (...Instance | string | Props) -> ...{ any } | ((...any) -> any) | nil

function requireMeta:__call(...: Instance | string | Props): ...{ any } | ((...any) -> any) | nil
	local paths, props = processParameters({ ... })
	local modules = {}

	maybeThrow("expected 1 or more modules, got 0", #paths == 0)
	maybeThrow("cannot import duplicate modules", not props.AllowDuplicates and containsDuplicate(paths))

	for _, path in paths do
		local routes: Types.Array<string> = {}

		maybeThrow("cannot import nil", path == nil)

		if typeof(path) == "string" then
			path, routes = processPath(path, props.Directory)
		end

		local module = require(path)

		for _, route in routes do
			local submodule = module[route]

			maybeThrow("cannot import %s from %s", submodule == nil, route, tostring(path))
			module = module[route]
		end

		table.insert(modules, module)
	end

	return table.unpack(modules)
end

local function unsafeForceCast<T, O>(value: T): O
	return (value :: any) :: O
end

-- for this to act like a function without being one and benefit from the custom
-- repr that __tostring provides, ive masked the type to effectively be the same
-- function type signature as __call
local newRequire: Require = unsafeForceCast(setmetatable({}, requireMeta))

return newRequire
