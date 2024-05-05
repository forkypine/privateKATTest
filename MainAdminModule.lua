local cache = {}
local tagcolor
local namecolor

local EData = game.ReplicatedStorage.GameEvents.Data
local tag
local prefixA = ">"
local name
local lrtdplayers = {}
local ParentThing = game.Players.LocalPlayer.PlayerGui:WaitForChild("Chat").Frame.ChatBarParentFrame.Frame.BoxFrame.Frame or script.Parent.Parent.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame
local KATFrame = ParentThing.Parent.KATFrame


local function ConfirmDestruction(plr, weaponName)
	local backpack = plr:FindFirstChild("Backpack")
	local character = plr.Character

	if backpack then
		local weaponInBackpack = backpack:FindFirstChild(weaponName)
		if weaponInBackpack then
			local clientEvent = weaponInBackpack:FindFirstChild("ClientEvent")
			if clientEvent then
				clientEvent:FireServer("ConfirmDestruction", {})
			end
		end
	end

	if character then
		local weaponInCharacter = character:FindFirstChild(weaponName)
		if weaponInCharacter then
			local clientEvent = weaponInCharacter:FindFirstChild("ClientEvent")
			if clientEvent then
				clientEvent:FireServer("ConfirmDestruction", {})
			end
		end

		local workspaceWeapon = character:FindFirstChild(weaponName)
		if workspaceWeapon then
			local clientEvent = workspaceWeapon:FindFirstChild("ClientEvent")
			if clientEvent then
				clientEvent:FireServer("ConfirmDestruction", {})
			end
		end
	end
end

local function deleteWeapons(player, tool)
	if player then
		ConfirmDestruction(player, "Knife")
		ConfirmDestruction(player, "Revolver")
	end
end

local function DeleteTool(player, tool)
	if player then
		ConfirmDestruction(player, tool)
	end
end

local function removeTools(player)
	if lrtdplayers[player.Name] then
		deleteWeapons(player)
	end
end

local function loopDelete(player)
	while lrtdplayers[player.Name] do
		removeTools(player)

		if not lrtdplayers[player.Name] then
			break
		end
		wait(1)
	end
end

local function loopDeleteTool(player, tool)
	while lrtdplayers[player.Name] do
		DeleteTool(player, tool)

		if not lrtdplayers[player.Name] then
			break
		end
		wait(1)
	end
end


local function nukeFunction(intensity)
	local amount = 1 * intensity

	local args = {
		[1] = "ReplicateGearEffect",
		[2] = {
			[1] = {
				["RightArm"] = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Right Arm"),
				["ProjectileDebris"] = workspace.WorldIgnore.Projectiles,
				["Torso"] = game:GetService("Players").LocalPlayer.Character.Torso,
				["WorldIgnore"] = workspace.WorldIgnore,
				["Character"] = game:GetService("Players").LocalPlayer.Character,
				["RenderStepped"] = nil --[[RBXScriptSignal]],
				["Start"] = Vector3.new(-22.707744598388672, 13.920881271362305, -73.56349182128906),
				["Heartbeat"] = nil --[[RBXScriptSignal]],
				["Target"] = Vector3.new(-35.31388473510742, 10.997428894042969, -73.95928955078125),
				["GearModel"] = game:GetService("Players").LocalPlayer.Character.Dice.MoneyBag
			}
		}
	}

	local fireremotebackpack
	local firemote
	local player = game.Players.LocalPlayer

	if player.Backpack then
		local Dice = player.Backpack.Dice
		if Dice then
			fireremotebackpack = Dice.ClientEvent

			for i = 1, amount do
				fireremotebackpack:FireServer(unpack(args))
			end
		else
			local DiceWorkSpace = player.Character.Dice
			if DiceWorkSpace then
				firemote = DiceWorkSpace.ClientEvent

				for i = 1, amount do
					firemote:FireServer(unpack(args))
				end
			end
		end
	end
end

local IsLooping = false

local function loopnukeFunction(enableLoop)
	if enableLoop then
		nukeFunction(6000)
		game.Players.PlayerAdded:Connect(function()
			nukeFunction(10000)
		end)
	elseif not enableLoop then
		print("loop stopped.")
	end
end


local loopedrt = {}

local function SendMessage(Data, tag, name, text)
	--print(Data)
	firesignal(game:GetService("ReplicatedStorage").GameEvents.Misk.Chatted.OnClientEvent, Data, true, true)  
end

local commands = {
	settag = {
		func = function(TagName)
			tag = TagName

			SendMessage({
				TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
				NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
				CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = "changed exploiter chat tag to "..TagName},
			})
		end,

		aliases = {"st", "sett"},
		Description = {"set your exploiter chat tag"},
	},

	lrt = {
		func = function(playerName)
			for _, plr in pairs(game.Players:GetPlayers()) do
				local gamePlayer = game.Players[playerName]
				if gamePlayer  == plr then
					lrtdplayers[gamePlayer.Name] = true
					loopDelete(gamePlayer)
					SendMessage({
						TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
						NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
						CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = "loopedremovedtools for " .. gamePlayer.Name},
					})
					elseif not gamePlayer and playerName == "all" or playerName == "All" then
						lrtdplayers[plr.Name] = true
						loopDelete(plr)
					end
				end
			end,
		aliases = {"lt", "loopremovetools"},
		Description = {"loop remove tools for specified player"}
	},


	removetools = {
		func = function(player, tool, looped)

			if tool == "revolver" then
				tool = "Revolver"
			elseif tool == "knife" then
				tool = "Knife"
			end


			local ActualName = game.Players:FindFirstChild(player)

			if not ActualName then
				for _, p in ipairs(game.Players:GetPlayers()) do
					if p.Name:lower() == player:lower() then
						player = p
						break
					end
				end
			end

			print(player.Name)

			if player then
				tool = player.Backpack[tool] or player.Character[tool]
				if tool and not looped then
					DeleteTool(player, tool)
				elseif tool and looped then
					loopedrt[player.Name] = true

					loopDeleteTool(player, tool)
				end
			end
		end,

		aliases = {"rt"},
		Description = {"remove tool from any player, {player} {tool} {looped}"}
	},


	dupe = {
		func = function(Enabled)

		end,

		aliases = {},
		Description = {"disables datastore"}
	},

	playradio = {
		func = function(audioID, volume, looping)
			local soundData = {
				"PlaySound",
				game.Players.LocalPlayer.Name,
				"rbxassetid://" .. tonumber(audioID),
				{workspace},
				tonumber(tonumber(volume)),
				looping
			}

			game.ReplicatedStorage.GameEvents.Misk.PlaySound:FireServer(unpack(soundData))
		end,
		aliases = {"pr"},
		Description = {"play the specified audio id {audioid} {volume 1-10} {looped}"}
	},

	stopradio = {
		func = function()
			local RadioEvent = game.ReplicatedStorage.GameEvents.Misk.ReplicateSoundStop:FireServer()
		end,
		aliases = {"sr"},
		Description = {"stop playing any audio"}
	},

	credits = {
		func = function()
			SendMessage({
				TG = {COL = Color3.fromRGB(255, 255, 0), TXT = "KAT Admin"},
				NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
				CHAT = {COL = Color3.fromRGB(45, 45, 45), TXT = "Script And Ui Were Made By Me (You Know Who You Got This From). Thanks To Amari For Helping Me Test it (mostly, fuck you)"},
			})
		end,
		aliases = {},
		Description = {"who made the script and contributed."}
	},

	unlrt = {
		func = function(playerName)
			if playerName == "all" or playerName == "All" then
				for _, plr in pairs(game.Players:GetPlayers()) do
					local player = plr.Name
					lrtdplayers[plr.Name] = false

					SendMessage({
						TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
						NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
						CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = "unloopedremovetools for " .. player},
					})
				end
			else
				local player = game.Players:FindFirstChild(playerName)
				if player then
					lrtdplayers[playerName] = false
					loopedrt[playerName] = false	

					SendMessage({
						TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
						NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
						CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = "unloopedremovetools for " .. player.Name},
					})
				end
			end
		end,
		aliases = {"unloopremovetools", "ulrt", "unrt"},
		Description = {"unloopremovetools from any player"}
	},

	trade = {
		func = function(playerName)
			local player = game.Players[playerName]
			local fireRemote = game.ReplicatedStorage.GameEvents.Misk.TradeRequest

			fireRemote:FireServer(player.Name)
		end,
		aliases = {},
		Description = {"send a trade request to any player"}
	},

	nuke = {
		func = function(intensity)
			nukeFunction(tonumber(intensity))

			SendMessage({
				TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
				NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
				CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = "nuked the server with an intensity of "..intensity}
			})
		end,

		aliases = {},
		Description = {"crashes the server, highly depends on intensity"}
	},

	loopnuke = {
		func = function()
			loopnukeFunction(true)

			SendMessage({
				TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
				NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
				CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = "loopnuke: enabled"}
			})
		end,
		aliases = {"lnuke", "ln"},
		Description = {"loopnuke the server"}
	},

	unloopnuke = {
		func = function()
			loopnukeFunction(false)

			SendMessage({
				TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
				NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
				CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = "loopnuke: disabled"}
			})
		end,
		aliases = {"unln", "uln", "ulnuke"},
		Description = {"stops the loopnuke"}
	},

	setprefix = {
		func = function(prefixChangedTo)
			prefixA = prefixChangedTo
		end,
		aliases = {"sp", "spx", "prefix"},
		Description = {"changes the command prefix"}
	},



	dropknife = {
		func = function(player)

			player = game.Players[player]

			if player then
				local char = player.Character

				if char then
					local knife = char:FindFirstChild("Knife")
					if knife then
						local knifeClientEvent = knife:FindFirstChild("ClientEvent")
						if knifeClientEvent then
							knifeClientEvent:FireServer("SetVisible", false)
							wait(0.1)
							knifeClientEvent:FireServer("DropRequest")
						end
					end
				end
			end
		end,
		aliases = {"dk"},
		Description = {"drops the specified players knife"}
	},

	loopdropknife = {
		func = function(player)
			player = game.Players[player]

			local function knifeLoop()
				while true do
					if player then
						local char = player.Character
	
						if char then
							local knife = char:FindFirstChild("Knife")
	
							while not knife do
								knife = char:FindFirstChild("Knife")
								wait(0.1)
							end
	
							local knifeClientEvent = knife:FindFirstChild("ClientEvent")
							if knifeClientEvent then
								knifeClientEvent:FireServer("SetVisible", false)
								wait(0.1)
								knifeClientEvent:FireServer("DropRequest")
							end
						end
					end
					wait(0.1)
				end
			end
			coroutine.wrap(knifeLoop)()
		end,
		aliases = {"ldk"},
		Description = {"loop drops the player's knife"}
	},
	

	test1 = {
		func = function(NameForPlayer)

			local player = game.Players[NameForPlayer]
			EData.RequestDisplayInfo:FireServer(player.Name)


			local Connection; Connection = EData.RequestDisplayInfo.OnClientEvent:Connect(function(p, data)
				if p == player then
					local Items = data.Items
					local ItemS = ""

					for _, v in pairs(Items) do
						ItemS = ItemS .. ":" .. v[1] .. ":"
					end


					SendMessage({
						TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
						NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
						CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = ":?: " .. p.Name .. ": " .. ItemS}
					})
				end
			end)
		end,
		aliases = {"t1"},
		Description = {"a test command"}
	},
	test2 = {
		func = function(NameForPlayer)

			local player = game.Players[NameForPlayer]
			EData.RequestDisplayInfo:FireServer(player.Name)


			local Connection; Connection = EData.RequestDisplayInfo.OnClientEvent:Connect(function(p, data)
				if p == player then
					local Items = data.Lvl
					local ItemS = ""

					for _, v in pairs(Items) do
						ItemS = ItemS .. ":" .. v[1] .. ":"
					end


					SendMessage({
						TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
						NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
						CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = ":?: " .. p.Name .. ": " .. ItemS}
					})
				end
			end)
		end,

		aliases = {"t2"},
		Description = {"a test command"}
	},


	listbackpack = {
		func = function(player)
			player = game.Players[player]

			if player then
				EData.RequestDisplayInfo:FireServer(player.Name)

				local Connection; Connection = EData.RequestDisplayInfo.OnClientEvent:Connect(function(p, data)
					if p == player then
						local Inv = data.Inventory

						local InvS = ""

						for _, v in pairs(Inv) do
							InvS = InvS .. ":" .. v[1] .. ":"
						end

						SendMessage({
							TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
							NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
							CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = ":?: " .. p.Name .. ": " .. InvS}
						})
					end
				end)
			end
		end,
		aliases = {"lbk", "listinv", "lb", "li"},
		Description = {"list the players backpack"}
	},	


	help = {
		func = function(commands, command)
			local foundCommand = nil

			for cmd, cmdData in pairs(commands) do
				if cmd == command or (cmdData.aliases and table.find(cmdData.aliases, command)) then
					foundCommand = cmd
					break
				end
			end
			if foundCommand then
				local description = commands[foundCommand].Description
				local aliases = table.concat(commands[foundCommand].aliases or {}, ", ")

				local message = description .. ". Aliases: " .. (aliases ~= "" and aliases or "None")
				SendMessage({
					TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
					NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
					CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = message},
				})
			else
				SendMessage({
					TG = {COL = Color3.fromRGB(45, 45, 45), TXT = "KAT Admin"},
					NM = {COL = Color3.fromRGB(255, 255, 255), TXT = "System"},
					CHAT = {COL = Color3.fromRGB(255, 255, 0), TXT = "Command not found."},
				})
			end
		end,

		aliases = {},
		Description = {"why'd you even run this:?:"}
	},

	setname = {
		func = function(Name)
			name = Name
		end,

		aliases = {"sn", "name"},
		Description = {"set your exploiter chat name"}
	},

	tickspeed = {
		func = function(tickSpeed)
			if tonumber(tickSpeed) then
				_G.TICKSPEED = tonumber(tickSpeed)
			end
		end,

		aliases = {"ts", "speed", "s"},
		Description = {"changes the games speed"}
	},

	settagcolor = {
		func = function(RGBColor)
			tagcolor = tonumber(RGBColor)
		end,

		aliases = {"stc"},
		Description = {"set your exploiterchat tag color"}
	},

	setnamecolor = {
		func = function(RGBColor)
			namecolor = tonumber(RGBColor)
		end,

		aliases = {"stc"},
		Description = {"set your exploiterchat name color"}
	}
}

ParentThing.ChatBar.FocusLost:Connect(function(enterPressed)
	local text = ParentThing.ChatBar.Text

	if enterPressed and string.sub(text, 1, 1) == prefixA then
		local command, argumentsStr = text:match(prefixA .. "(%w+)%s*(.*)")

		if command then
			local foundCommand = false
			for cmd, data in pairs(commands) do
				if cmd == command or table.find(data.aliases or {}, command) then
					foundCommand = true
					ParentThing.ChatBar.Text = ""
					local arguments = {}
					for arg in argumentsStr:gmatch("%S+") do
						table.insert(arguments, arg)
					end


					if command ~= "help" then
						data.func(argumentsStr)
						print("Command: " .. command .. ", Arguments: " .. argumentsStr)
					elseif cmd == "help" then
						commands.help.func(commands, argumentsStr)
					end
				end
			end

			if not foundCommand then
				local message = text:match(prefixA .. "%s*(.*)") 

				if message then
					ParentThing.ChatBar.Text = ""
					ChatSendMessage(name, tag, message)
				end
			end
		end
	end
end)


local commandLabels = {
	["7777"]= {label = "messageName", yPos = 0.095}, --semi works
	playradio = {label = "radioName", yPos = 0.15}, --broke somehow!?
	nuke = {label = "nukeName", yPos = 0.205}, --works
	help = {label = "helpCommand", yPos = 0.26}, --works
	settag = {label = "settagName", yPos = 0.315}, --this does not work
	lrt = {label = "lrtName", yPos = 0.481}, --this does not work
	credits = {label = "credits", yPos = 0.37}, --works
	unlrt = {label = "unlrt", yPos = 0.425}, --works
	trade = {label = "trade", yPos = 0.536}, --works
	loopnuke = {label = "loopNuke", yPos = 0.591}, --works (?)
	unloopnuke = {label = "unloopNuke", yPos = 0.646}, --works(?)
	setprefix = {label = "prefixName", yPos = 0.701}, --works
	stopradio = {label = "stopradio", yPos = 0.756}, --should work
	listbackpack = {label = "listbackpackName", yPos = 0.811}, --untested, should work
	dropknife = {label = "dropknifeName", yPos = 0.867}, --untested, should work
	loopdropknife = {label = "loopdropknifeName", yPos = 0.921}, --untested, should work
	setname = {label = "setnameName", yPos = 0.977},
	tickspeed = {label = "tickspeed", yPos = 1.032},
	settagcolor = {label = "settagcolor", yPos = 1.087},
	setnamecolor = {label = "setnamecolor", yPos = 1.142}
}

local foundLabels = {}
local notFoundLabels = {}

ParentThing.ChatBar:GetPropertyChangedSignal("Text"):Connect(function()
	local text = ParentThing.ChatBar.Text
	local searchText = text:sub(#prefixA + 1):lower()
	KATFrame.Visible = text:sub(1, #prefixA) == prefixA

	foundLabels = {}
	notFoundLabels = {}

	if text == prefixA then
		for command, data in pairs(commandLabels) do
			KATFrame[data.label].Visible = true
			KATFrame[data.label].Position = UDim2.new(0, 0, data.yPos, 0)
		end
	else
		if searchText ~= "" then
			local command, argument = searchText:match(">(%w+)%s*(.-)$")
			if command then
				for cmd, data in pairs(commandLabels) do
					local match = false
					local cmdData = commands[cmd]
					if cmdData then
						if cmd:lower() == command then
							match = true
						else
							for _, alias in ipairs(cmdData.aliases or {}) do
								if alias:lower() == command then
									match = true
									break
								end
							end
						end
					end
					if match then
						table.insert(foundLabels, cmd)
					else
						table.insert(notFoundLabels, cmd)
					end
				end
			else 
				local commandWithoutArg = searchText:match("(%S+)")
				if commandWithoutArg then
					for cmd, data in pairs(commandLabels) do
						local match = false
						local cmdData = commands[cmd]
						if cmdData then
							if cmd:lower():sub(1, #commandWithoutArg) == commandWithoutArg then
								match = true
							else
								for _, alias in ipairs(cmdData.aliases or {}) do
									if alias:lower():sub(1, #commandWithoutArg) == commandWithoutArg then
										match = true
										break
									end
								end
							end
						end
						if match then
							table.insert(foundLabels, cmd)
						else
							table.insert(notFoundLabels, cmd)
						end
					end
				end
			end
		end
	end

	local yPos = 0.095
	if #foundLabels == 0 then
		for command, data in pairs(commandLabels) do
			KATFrame[data.label].Visible = true
			KATFrame[data.label].Position = UDim2.new(0, 0, data.yPos, 0)
		end
	else
		for i, command in ipairs(foundLabels) do
			local labelData = commandLabels[command]
			KATFrame[labelData.label].Visible = true
			KATFrame[labelData.label].Position = UDim2.new(0, 0, yPos, 0)
			yPos = yPos + 0.055
		end

		for _, command in ipairs(notFoundLabels) do
			local labelData = commandLabels[command]
			KATFrame[labelData.label].Visible = false
		end
	end
end)

return commands
