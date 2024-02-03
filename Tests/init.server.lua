local ReplicatedStorage = game:GetService("ReplicatedStorage")

local betterRequireModule = script.Parent :: ModuleScript
local betterRequire = require(betterRequireModule)
local testModule = ReplicatedStorage:WaitForChild("Module")

print("__tostring", tostring(betterRequire))
print("Standard implementation", betterRequire(testModule))
print("String imports", betterRequire("Module"))
print("Partial import", betterRequire("Module.test"))
print("Navigating import", betterRequire("Module/Submodule.Value"))
print("Multiple imports (instances)", betterRequire(betterRequireModule, testModule))
print("Multiple imports (strings)", betterRequire("Require", "Module"))
print("Multiple imports (mixed)", betterRequire(betterRequireModule, "Module"))
print("Multiple imports (mixed, incl. null type)", pcall(betterRequire, betterRequireModule, "Module", nil)) -- should raise type error for nil
print("Multiple partial imports", betterRequire("Module/Submodule", "Module.test"))
print("Multiple partial imports (mixed, incl. full)", betterRequire("Module", "Module.test"))
print(
	"Options (alternative module directory)",
	betterRequire("Submodule", {
		Directory = testModule,
	})
)
print(
	"Options (allow duplicates",
	betterRequire("Module", "Module", {
		AllowDuplicates = true,
	})
)
print(
	"Options (incl. full and partial imports)",
	betterRequire("Submodule", "Submodule.Value", "Submodule/Folder/NestedModule", {
		Directory = testModule,
	})
)
print("Error (null type)", pcall(betterRequire, nil))
print("Error (duplicate imports)", pcall(betterRequire, "Module", "Module"))
print("Error (non-existant instance)", pcall(betterRequire, "Balls"))
print("Error (non-existant internal navigation)", pcall(betterRequire, "Module.balls"))
print("Error (non-existant hierarchichal navigation)", pcall(betterRequire, "Module/Balls"))
print("Error (illegal premature navigation)", pcall(betterRequire, "Module.entry/Submodule"))
