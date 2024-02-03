--!nolint LocalShadow
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(script.Types)

local requireMeta = {}

function requireMeta:__tostring(): string
	return "function: require"
end

local function containsDuplicate(container: Types.Array<Instance | string>): boolean
	local total = #container

	for index, value in ipairs(container) do
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

local function processPath(path: Instance | string, moduleDirectory: Instance): (Instance, Types.Array<string?>)
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

type Require = (...Instance | string) -> ...{ any } | ((...any) -> any) | nil
type Props = {
	AllowDuplicates: boolean,
	Directory: Instance,
}

local DEFAULT_PROPS: Props = {
	AllowDuplicates = false,
	Directory = ReplicatedStorage,
}

function requireMeta:__call(...: Instance | string | Props): ...{ any } | ((...any) -> any) | nil
	local paths = ({ ... } :: any) :: Types.Array<Instance | string>
	local options: Props = paths[#paths]
	local modules = {}

	if typeof(options) == "table" then
		table.remove(paths, #paths)
	else
		options = DEFAULT_PROPS
	end

	maybeThrow("expected 1 or more modules, got 0", #paths == 0)
	maybeThrow("cannot import duplicate modules", not options.AllowDuplicates and containsDuplicate(paths))

	for _, path in paths do
		local instance = path
		local routes = {}

		maybeThrow("cannot import nil", path == nil)

		if typeof(path) == "string" then
			instance, routes = processPath(path, options.Directory)
			print(path, instance, routes)
		end

		local module = require(instance)

		for _, route in ipairs(routes) do
			module = module[route]
		end

		table.insert(modules, module)
	end

	return table.unpack(modules)
end

return (setmetatable({}, requireMeta) :: any) :: Require
