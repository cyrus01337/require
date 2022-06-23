local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utils = require(ReplicatedStorage.Utils)
local Types = require(script.Types)

local requireMeta = {}
local _require = setmetatable({}, requireMeta)


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
    if not condition then return end

    local formatted = string.format(message, ...)

    error(formatted)
end


local function findFirstModule(name: string, from: Instance, path: string): Instance?
    local instance = from:FindFirstChild(name)

    maybeThrow(
        "cannot locate module %s in %s from import %s",
        not instance,
        name,
        from:GetFullName(),
        path
    )

    return instance
end


local function processPath(path: Instance | string, moduleDirectory: Instance): (Instance, Array<string?>)
    local instance, routes;
    local parent = moduleDirectory
    local partitions = path:split("/")
    local totalPartitions = #partitions

    for i, partition in ipairs(partitions) do
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


function requireMeta:__call(...: Instance | string): ...{any} | ((...any) -> any) | nil
    local paths = {...}
    local options = paths[#paths]
    local allowDuplicates = false
    local moduleDirectory = ReplicatedStorage
    local modules = {}

    maybeThrow("expected 1 or more modules, got 0", #paths == 0)

    if options and typeof(options) == "table" then
        allowDuplicates = options.AllowDuplicates or allowDuplicates
        moduleDirectory = options.Directory or moduleDirectory

        table.remove(paths, #paths)
    end

    maybeThrow("cannot import duplicate modules", not allowDuplicates and containsDuplicate(paths))

    for _, path in ipairs(paths) do
        local instance = path
        local routes = {}

        maybeThrow("cannot import nil", path == nil)

        if typeof(path) == "string" then
            instance, routes = processPath(path, moduleDirectory)
        end

        local module = require(instance)

        for _, route in ipairs(routes) do
            module = module[route]
        end

        table.insert(modules, module)
    end

    return table.unpack(modules)
end


function _require.monkeyPatch(level)
    level = level or 2

    local env = getfenv(level)
          env.require = _require

    setfenv(level, env)
end


return function(ranThroughSideEffect)
    local level = if ranThroughSideEffect then 2 else 3

    _require.monkeyPatch(level)
end

