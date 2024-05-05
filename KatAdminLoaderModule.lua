local cache = {}
local function getFile(Branch, FileName)
	local FileSplit = string.split(FileName, ".")
	local FileUrl = "https://raw.githubusercontent.com/forkypine/privateKATTest/".. table.concat({Branch or "main", FileName .. (#FileSplit > 1 and "" or ".lua")}, "/")

	print("LoaderModule: Fetching file from:", FileUrl)
	
	if not cache[FileUrl] then
		print("File not found in cache. Fetching from URL.")
		print("FileName: "..FileName)
		local Data = syn.request({
			Url = FileUrl,
			Method = "GET"
		})

		
		print("Request status code:", Data.StatusCode)

		if Data.StatusCode == 200 then
			cache[FileUrl] = Data.Body
			print("File content cached.")
		else
			print("Failed to fetch file:", Data.Body)
		end

		return Data.Body
	else
		print("File found in cache.")
		return cache[FileUrl]
	end
end

getgenv().loadfile = function(Branch, FileName)
	print("Loading file:", FileName, "from branch:", Branch)
	local fileContent = getFile(Branch, FileName)

	if fileContent then
		print("Executing file content.")
		loadstring(assert(fileContent, "requested module not found."))()
	else
		print("File content is nil. Execution aborted.")
	end
end


local gameEvents = game.ReplicatedStorage.GameEvents
local EData = gameEvents.Data
local ParentThing = game.Players.LocalPlayer.PlayerGui:WaitForChild("Chat").Frame.ChatBarParentFrame.Frame.BoxFrame.Frame or script.Parent.Parent.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame
local lrtdplayers = {}
local CreateLabels = loadstring(game:HttpGet("https://raw.githubusercontent.com/forkypine/privateKAT/main/Labels.lua"))()

CreateLabels()

print("created labels")
local KATFrame = ParentThing.Parent.KATFrame

ParentThing.ChatBar.FocusLost:Connect(function()
	KATFrame.Visible = false
end)

local commands = loadfile("main", "MainAdminModule.lua")
