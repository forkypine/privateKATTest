local function CreateLabels()
    local ParentThing = game.Players.LocalPlayer.PlayerGui:WaitForChild("Chat").Frame.ChatBarParentFrame.Frame.BoxFrame.Frame or script.Parent.Parent.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame
    local KATFrame = Instance.new("Frame")
    KATFrame.Parent = ParentThing.Parent
    KATFrame.Name = "KATFrame"
    KATFrame.BackgroundColor3 = Color3.new(0,0,0)
    KATFrame.Transparency = 0.64
    KATFrame.Size = UDim2.new(0.4, 0, 0.4, 0) -- Adjusted size
    KATFrame.Position = UDim2.new(0.5, -KATFrame.Size.X.Offset / 2, 0.5, -KATFrame.Size.Y.Offset / 2) -- Centered
    KATFrame.Visible = false

    local labelSpacing = 5 -- Adjust spacing between labels

    local function CreateLabel(name, text, yPos)
        local label = Instance.new("TextLabel")
        label.Name = name
        label.Parent = KATFrame
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1,1,1)
        label.Text = text
        label.TextSize = 14
        label.Font = Enum.Font.Arial
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.FontFace = Enum.Font.SourceSansBold -- Changed to SourceSansBold
        label.Position = UDim2.new(0, labelSpacing, 0, yPos)
        label.Size = UDim2.new(1, -labelSpacing * 2, 0, 20) -- Adjusted size
    end

    CreateLabel("messageName", ">[message]", 0)
    CreateLabel("radioName", ">playaudio [audioid] [volume] [looped]", 20)
    CreateLabel("nukeName", ">nuke [intensity]", 40)
    CreateLabel("stopradio", ">stopradio [stopradio]", 60)
    CreateLabel("helpCommand", ">help [command]", 80)
    CreateLabel("settagName", ">settag [tag]", 100)
    CreateLabel("lrtName", ">lrt [playername]", 120)
    CreateLabel("credits", ">credits [credits]", 140)
    CreateLabel("unlrt", ">unlrt [playername]", 160)
    CreateLabel("trade", ">trade [playername]", 180)
    CreateLabel("loopnuke", ">loopnuke [loopnuke]", 200)
    CreateLabel("unloopnuke", ">unloopnuke [unloopnuke]", 220)
    CreateLabel("prefixC", ">setprefix [prefix]", 240)
    CreateLabel("listbackpackName", ">listbackpack [player]", 260)
    CreateLabel("dropknife", ">dropknife [player]", 280)
    CreateLabel("loopdropknife", ">loopdropknife [player]", 300)
    CreateLabel("setname", ">setname [name]", 320)
    CreateLabel("tickspeed", ">tickspeed [speed]", 340)
    CreateLabel("settagcolor", ">settagcolor [red] [green] [blue]", 360)
    CreateLabel("setnamecolor", ">setnamecolor [red] [green] [blue]", 380)

    return KATFrame
end

return CreateLabels
