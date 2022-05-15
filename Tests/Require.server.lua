local ReplicatedStorage = game:GetService("ReplicatedStorage")

local require = require(ReplicatedStorage.Require)

print("__tostring", tostring(require))
print("Standard implementation", require(ReplicatedStorage.Utils))
print("String imports", require("Tycoon"))
print("Partial import", require("Utils.round"))
print("Navigating import", require("Utils/Table.map"))
print("Multiple imports (instances)", require(ReplicatedStorage.Utils, ReplicatedStorage.Objects))
print("Multiple imports (strings)", require("Utils", "Objects"))
print("Multiple imports (mixed)", require(ReplicatedStorage.Utils, "Objects"))
print("Multiple imports (mixed, incl. null type)", pcall(require, ReplicatedStorage.Utils, "Objects", nil))
print("Multiple partial imports", require("Utils/Table", "Utils.values"))
print("Multiple partial imports (mixed, incl. full)", require("Tycoon", "Utils.round"))
print("Options (alternative module directory)", require("Bidict", {
    Directory = ReplicatedStorage.Objects
}))
print("Options (allow duplicates", require("Tycoon", "Tycoon", {
    AllowDuplicates = true
}))
print("Options (incl. full and partial imports)", require("Table", "Table.map", "Constants.STRIP_REGEX", {
    Directory = ReplicatedStorage.Utils
}))
print("Error (null type)", pcall(require, nil))
print("Error (duplicate imports)", pcall(require, "Tycoon", "Tycoon"))
print("Error (non-existant instance)", pcall(require, "Balls"))
print("Error (non-existant internal navigation)", pcall(require, "Utils.balls"))
print("Error (non-existant hierarchichal navigation)", pcall(require, "Utils/Balls"))
print("Error (illegal premature navigation)", pcall(require, "Utils.to/Table"))
