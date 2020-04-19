--[[
	Hi guys, thanks for checking out my code. This comment was not part of the original code that existed in here.

	The code here was the stable build where I left it. Due to many changes in Roblox's internals, this code might break.

	-- Syntax#9468     4/19/2020 1:13:14 PM  Chicago Time Zone
]]

local gui;
if not (FathomHub == nil) then
	gui = FathomHub.Tab
else
	gui = script.Parent
end

--// Functions
local httpService = {};
function httpService:Get(link,convertToTable)
	local result;
	local success,message = pcall(function()
		result = game:GetService("HttpService"):GetAsync(link)
	end)
	if not success then
		print(message)
	end
	
	if result == nil then
		pcall(function () result = game:HttpGet(link,true) end)
	end
	if not (convertToTable == nil) and convertToTable then
		print(convertToTable)
		result = game:GetService("HttpService"):JSONDecode(result)
	end
	return result
end

function httpService:Post(link,payload)
	json = game:GetService("HttpService"):JSONEncode(payload)
	local result;
	local success,message = pcall(function()
		result = game:GetService("HttpService"):PostAsync(link,json)
	end)
	if result == nil then
		return game:HttpPost(link,json,true)
	end
	return false
end

local saveService = {}

function saveService:getSave()
	if readfile and writefile then
		local file;
		pcall(function () file = readfile("FathomHubSave.txt") end)
		if file == nil then
			file = {}
		else
			file = game:GetService("HttpService"):JSONDecode(file)
		end
		
		return file
	else
		return nil
	end	
end

function saveService:setSave(newSave)
	if readfile and writefile then
		local file;
		local suc,fail = pcall(function () writefile("FathomHubSave.txt",game:GetService("HttpService"):JSONEncode(newSave)) end)
		
		return suc
	else
		return false
	end	
end

local notificationService = {}
local notificationTemp = {}


notificationTemp.infoNotif = gui.Parent.infoNotif:Clone()
gui.Parent.infoNotif:Destroy()
notificationTemp.infoRegular = gui.Parent.infoNotifSmall:Clone()
gui.Parent.infoNotifSmall:Destroy()


function notificationService:extendednotify(title,content)
	local ui = notificationTemp.infoNotif:Clone()
	materializeb(ui.dismiss)
	ui:WaitForChild("title").Text = tostring(title)
	local startClone = ui.data.message:Clone()
	ui.data.message:Destroy()
	for i,v in pairs(content) do
		local more = startClone:Clone()
		more.Text = v
		more.Parent = ui.data
	end
	ui.Parent = gui.Parent
	ui.Visible = true
	ui:TweenPosition(UDim2.new(0.5, -240,0.5, -108),"Out",[[Quint]],0.4)
		
	startClone:Destroy() -- clear the memory up babyyyyy
	ui.dismiss.MouseButton1Up:Connect(function()
		ui:TweenPosition(UDim2.new(0.5, -240,1.195, -108),"Out",[[Quint]],0.4)
		wait(0.4)
		ui:Destroy()
	end)
end

function notificationService:notify(content)
	local ui = notificationTemp.infoRegular:Clone()
	materializeb(ui.dismiss)
	ui:WaitForChild("message").Text = content
	ui.Parent = gui.Parent
	ui.Visible = true
	ui:TweenPosition(UDim2.new(0.5, -240,0.5, -108),"Out",[[Quint]],0.4)
	
	ui.dismiss.MouseButton1Up:Connect(function()
		ui:TweenPosition(UDim2.new(0.5, -240,1.195, -108),"Out",[[Quint]],0.4)
		wait(0.4)
		ui:Destroy()
	end)
end


function materializet(textbox, color, revertedtext)
	for i,v in pairs(textbox) do
		local parent = v;local mouse = game:GetService'Players'.LocalPlayer:GetMouse();local underlinecolor = color or parent.TextColor3;local ptext = revertedtext or parent.Text
		local xsize = parent.Size.X.Offset;local ysize = parent.Size.Y.Offset
		parent.Visible = true;parent.Active = true;parent.Selectable = true
		function CreateInstance(cls,props)	inst = Instance.new(cls)	for i,v in pairs(props) do inst[i] = v end return inst end
		local Underline = CreateInstance("Frame", {Name="Underline",ZIndex=parent.ZIndex, Parent=parent,BackgroundColor3=underlinecolor, BorderSizePixel=0,Position=UDim2.new(0,0,1,0),Size=UDim2.new(0, 0, 0, 2)})
		local UnderlineBase = CreateInstance("Frame", {Name="Underline",ZIndex=parent.ZIndex,Parent= parent,BackgroundColor3=underlinecolor,BackgroundTransparency=0.85,BorderSizePixel=0,Position=UDim2.new(0,0,1,0),Size=UDim2.new(0, xsize, 0, 1)})
		parent.Focused:connect(function()
			if Underline.Size.X.Offset == xsize then return end
			parent.PlaceholderText= ""
			local x = (mouse.X) - (parent.AbsolutePosition.X);Underline.BackgroundTransparency = 0;Underline.Position = UDim2.new(0,x,1,0);wait()
			Underline:TweenSizeAndPosition(UDim2.new(0, xsize, 0, 2),UDim2.new(0, 0, 1, 0),"Out","Quint",0.2)
		end)
		parent.FocusLost:connect(function()
			if parent.Text == "" then parent.PlaceholderColor3 = parent.TextColor3	parent.PlaceholderText = ptext	end
			game:GetService("TweenService"):Create(Underline,TweenInfo.new(0.15,Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0,false, 0 ),{BackgroundTransparency = 1}):Play()	
			wait(0.15)	Underline.Size = UDim2.new(0,0,0,2)
		end)
	end
end


--[[
	BETTER MATERIALIZEB WITH MOUSEBUTTON2 FUNCTIONS
]]

function materializeb(buttons, color, transp, speed)
    if typeof(buttons) == "table" then
        for i,button in pairs(buttons) do
                local ripplespeed = speed or 1
				local transparency = transp or 0.8
				speed = speed or 1
				transp = transp or 0.8
				local parent = button;local circlecolor = color or parent.TextColor3
				color = color or parent.TextColor3
				local mouse = game:GetService'Players'.LocalPlayer:GetMouse();local diagonal = math.sqrt((parent.Size.X.Offset) ^ 2 + (parent.Size.Y.Offset) ^ 2)
				parent.ClipsDescendants = true;parent.Active = true;parent.Selectable = true;parent.Visible = true;parent.AutoButtonColor = false
				parent.MouseButton1Down:Connect(function()
				function CreateInstance(cls,props)	inst = Instance.new(cls)	for i,v in pairs(props) do inst[i] = v end return inst end
				local circle = CreateInstance('ImageLabel', {Name = "CircleLabel", Parent = parent,ZIndex = parent.ZIndex, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0,0,0,0), Size = UDim2.new(0,50,0,50), Visible = false, Image = "rbxasset://textures/whiteCircle.png", ImageColor3 = circlecolor})
	 		    local x = (mouse.X) - (parent.AbsolutePosition.X);local y = (mouse.Y) - (parent.AbsolutePosition.Y)
				parent.MouseLeave:Connect(function() game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play() wait(.2) circle:Destroy() end)
				parent.MouseButton1Up:Connect(function() wait(0.15)
 				game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play()
					wait(.2)
					circle:Destroy()	
				end)
		circle.Position = UDim2.new(0,x,0,y);circle.Size = UDim2.new(0,5,0,5) -- edit this to make it bigger before animation
		circle.ImageTransparency = transparency;circle.Visible = true
		wait()
		circle:TweenSize(UDim2.new(0, diagonal * 2, 0, diagonal * 2),"Out","Quad",ripplespeed)
	end)
				parent.MouseButton2Click:Connect(function()
			function CreateInstance(cls,props)	inst = Instance.new(cls)	for i,v in pairs(props) do inst[i] = v end return inst end
			local circle = CreateInstance('ImageLabel', {Name = "CircleLabel", Parent = parent,ZIndex = parent.ZIndex, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0,0,0,0), Size = UDim2.new(0,50,0,50), Visible = false, Image = "rbxasset://textures/whiteCircle.png", ImageColor3 = circlecolor})
	 	  	local x = (mouse.X) - (parent.AbsolutePosition.X);local y = (mouse.Y) - (parent.AbsolutePosition.Y)
			parent.MouseLeave:Connect(function() game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play() wait(.2) circle:Destroy() end)
			parent.MouseButton2Click:Connect(function() wait(0.15)
 			game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play()
			wait(.2)
			circle:Destroy()	
			end)
			circle.Position = UDim2.new(0,x,0,y);circle.Size = UDim2.new(0,5,0,5) -- edit this to make it bigger before animation
			circle.ImageTransparency = transparency;circle.Visible = true
			wait()
			circle:TweenSize(UDim2.new(0, diagonal * 2, 0, diagonal * 2),"Out","Quad",ripplespeed)
		end)
        end
    else
        local button = buttons
        local ripplespeed = speed or 1
		local transparency = transp or 0.8
		speed = speed or 1
		transp = transp or 0.8
		local parent = button;local circlecolor = color or parent.TextColor3
		button = button or script.Parent;color = color or parent.TextColor3
		local mouse = game:GetService'Players'.LocalPlayer:GetMouse();local diagonal = math.sqrt((parent.Size.X.Offset) ^ 2 + (parent.Size.Y.Offset) ^ 2)
		parent.ClipsDescendants = true;parent.Active = true;parent.Selectable = true;parent.Visible = true;parent.AutoButtonColor = false
		parent.MouseButton1Down:Connect(function()
		function CreateInstance(cls,props)	inst = Instance.new(cls)	for i,v in pairs(props) do inst[i] = v end return inst end
		local circle = CreateInstance('ImageLabel', {Name = "CircleLabel", Parent = parent,ZIndex = parent.ZIndex, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0,0,0,0), Size = UDim2.new(0,50,0,50), Visible = false, Image = "rbxasset://textures/whiteCircle.png", ImageColor3 = circlecolor})
	    local x = (mouse.X) - (parent.AbsolutePosition.X);local y = (mouse.Y) - (parent.AbsolutePosition.Y)
		parent.MouseLeave:Connect(function() game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play() wait(.2) circle:Destroy() end)
		parent.MouseButton1Up:Connect(function() wait(0.15)
 			game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play()
			wait(.2)
			circle:Destroy()	
		end)
		circle.Position = UDim2.new(0,x,0,y);circle.Size = UDim2.new(0,5,0,5) -- edit this to make it bigger before animation
		circle.ImageTransparency = transparency;circle.Visible = true
		wait()
		circle:TweenSize(UDim2.new(0, diagonal * 2, 0, diagonal * 2),"Out","Quad",ripplespeed)
	end)
		parent.MouseButton2Click:Connect(function()
			function CreateInstance(cls,props)	inst = Instance.new(cls)	for i,v in pairs(props) do inst[i] = v end return inst end
			local circle = CreateInstance('ImageLabel', {Name = "CircleLabel", Parent = parent,ZIndex = parent.ZIndex, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0,0,0,0), Size = UDim2.new(0,50,0,50), Visible = false, Image = "rbxasset://textures/whiteCircle.png", ImageColor3 = circlecolor})
	 	  	local x = (mouse.X) - (parent.AbsolutePosition.X);local y = (mouse.Y) - (parent.AbsolutePosition.Y)
			parent.MouseLeave:Connect(function() game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play() wait(.2) circle:Destroy() end)
			parent.MouseButton2Click:Connect(function() wait(0.15)
 			game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play()
			wait(.2)
			circle:Destroy()	
			end)
			circle.Position = UDim2.new(0,x,0,y);circle.Size = UDim2.new(0,5,0,5) -- edit this to make it bigger before animation
			circle.ImageTransparency = transparency;circle.Visible = true
			wait()
			circle:TweenSize(UDim2.new(0, diagonal * 2, 0, diagonal * 2),"Out","Quad",ripplespeed)
		end)
    end
end

local function CreateInstance(cls,props)
local inst = Instance.new(cls)
for i,v in pairs(props) do
	inst[i] = v
end
return inst
end
function createmenudropbox(parent,changetext,insert_table,backgroundcolor,textcolor)
	local function materializeb(buttons, color, transp, speed)
        local button = buttons
        local ripplespeed = speed or 1
		local transparency = transp or 0.8
		speed = speed or 1
		transp = transp or 0.8
		local parent = button;local circlecolor = color or parent.TextColor3
		button = button or script.Parent;color = color or parent.TextColor3
		local mouse = game:GetService'Players'.LocalPlayer:GetMouse();local diagonal = math.sqrt((parent.Size.X.Offset) ^ 2 + (parent.Size.Y.Offset) ^ 2)
		parent.ClipsDescendants = true;parent.Active = true;parent.Selectable = true;parent.Visible = true;parent.AutoButtonColor = false
		parent.MouseButton1Down:Connect(function()
		function CreateInstance(cls,props)	inst = Instance.new(cls)	for i,v in pairs(props) do inst[i] = v end return inst end
		local circle = CreateInstance('ImageLabel', {Name = "CircleLabel",ZIndex=parent.ZIndex, Parent = parent, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0,0,0,0), Size = UDim2.new(0,50,0,50), Visible = false, Image = "rbxasset://textures/whiteCircle.png", ImageColor3 = circlecolor})
	    local x = (mouse.X) - (parent.AbsolutePosition.X);local y = (mouse.Y) - (parent.AbsolutePosition.Y)
		parent.MouseLeave:Connect(function() game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play() wait(.2) circle:Destroy() end)
		parent.MouseButton1Up:Connect(function() wait(0.15)
 			game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play()
			wait(.2)
			circle:Destroy()	
		end)
		circle.Position = UDim2.new(0,x,0,y);circle.Size = UDim2.new(0,5,0,5) -- edit this to make it bigger before animation
		circle.ImageTransparency = transparency;circle.Visible = true
		wait()
		circle:TweenSize(UDim2.new(0, diagonal * 2, 0, diagonal * 2),"Out","Quad",ripplespeed)
	end)
end
local function CreateInstance(cls,props)	local inst = Instance.new(cls)	for i,v in pairs(props) do	inst[i] = v
end
return inst
end

local Holder = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=backgroundcolor or parent.BackgroundColor3,BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0, 0, 1, 0),Rotation=0,Selectable=false,Size=UDim2.new(1, 0, 0, 0),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=parent.ZIndex,Name = 'Holder',Parent = parent})
Holder.ClipsDescendants = true
CreateInstance('UIListLayout', {Padding = UDim.new(0, 0), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.Name, VerticalAlignment = Enum.VerticalAlignment.Center, Name = 'UIListLayout', Parent = Holder })
local open = false
for i,v in next, insert_table do
	local MenuSelect = CreateInstance('TextButton',{Font=Enum.Font.SourceSansSemibold,FontSize=parent.FontSize,Text=i,TextColor3=textcolor or parent.TextColor3,TextScaled=true,TextSize=21,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,AutoButtonColor=true,Modal=false,Selected=false,Style=Enum.ButtonStyle.Custom,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=backgroundcolor or parent.BackgroundColor3,BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0, 0, 0.350318462, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, parent.Size.X.Offset, 0, parent.Size.Y.Offset),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=parent.ZIndex,Name='Selectormmm',Parent = Holder})
	materializeb(MenuSelect) MenuSelect.AutoButtonColor = false
	MenuSelect.MouseButton1Up:Connect(function()
		open = false
		if changetext == true then	parent.Text = i end
		v()
		Holder:TweenSize(UDim2.new(1,0,0,0), "Out", "Quint", .4, true)
	end)
end

parent.MouseButton1Up:Connect(function()
	if open == false then
		open = true
		Holder:TweenSize(UDim2.new(1,0,0,(parent.Size.Y.Offset+5)*(#Holder:GetChildren()-1)), "Out", "Quint", .4, true)
	else
		open = false
		Holder:TweenSize(UDim2.new(1,0,0,0), "Out", "Quint", .4, true)
	end
end)
end
--[[
	Documentation:
	If you need to make an Http Request, do:
	httpService:Get(link);
	
	If you need to make an Http post do:
	httpService:Post(link,data)
	The 'data' will automatically be converted to JSON
	
	Once you've read this, delete the message.
--]]

--// Variables
local tS = game:GetService("TweenService")
materializet({gui.Holder.Main.SearchTab.data.SearchQuery, gui.Holder.Main.ScriptsFrame.search, gui.Holder.Main.AudioTab.AudioQuery, gui.Holder.Main.GuisFrame.search, gui.Parent.ScriptViewer.Holder.Main.Parameter})
function buttoneffect(parent,enum, timer, before, after)
	parent.MouseEnter:Connect(function()
		tS:Create(parent,TweenInfo.new(timer,Enum.EasingStyle[enum], Enum.EasingDirection.Out, 0,false, 0 ),{ImageColor3 = after}):Play()
	end)
	parent.MouseLeave:Connect(function()
		tS:Create(parent,TweenInfo.new(timer,Enum.EasingStyle[enum], Enum.EasingDirection.Out, 0,false, 0 ),{ImageColor3 = before}):Play()
	end)
end
--// Main Code

local caller = gui.Parent.Intro
caller.Main.Visible = true
local RS = game:GetService("RunService")
caller.Main:TweenSize(UDim2.new(0, 277,0, 317), "Out", "Quint", .5)
wait(.35)
game:GetService("TweenService"):Create(caller.Main.quote,TweenInfo.new(0.3,Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0,false, 0 ),{TextTransparency = 0}):Play()
game:GetService("TweenService"):Create(caller.Main.Cheez,TweenInfo.new(0.4,Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0,false, 0 ),{ImageTransparency = 0, Size=UDim2.new(0, 111,0, 111), Position=UDim2.new(0.3, 0,0.1, 0)}):Play()
game:GetService("TweenService"):Create(caller.Main.TextLabel,TweenInfo.new(0.4,Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0,false, 0 ),{TextTransparency = 0}):Play()

if pcall(function() httpService:Get("https://pastebin.com/raw/LQTiwHSL") loadstring("print(\"loadstring compatibility test ploz ignore message kthex\")")() end)  then
	loadstring(httpService:Get("https://pastebin.com/raw/LQTiwHSL"))()
	chosen_one = math.random(1, #quotes)
	caller.Main.quote.Text = string.upper(quotes[chosen_one])
end
function spinnerEasingFunc(a, b, t)
	t = t * 2
	if t < 1 then
		return b / 2 * t*t*t + a
	else
		t = t - 2
		return b / 2 * (t * t * t + 2) + b
	end
end
turnCycleTime = 1.3
RS.RenderStepped:Connect(function()
	local currentTime = tick()
	local timeInCycle = currentTime % turnCycleTime
	local cycleAlpha = spinnerEasingFunc(0, 1, timeInCycle / turnCycleTime)
	caller.Main.Cheez.Rotation = cycleAlpha * 360
end)
wait(3)
game:GetService("TweenService"):Create(caller.Main.quote,TweenInfo.new(0.3,Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0,false, 0 ),{TextTransparency = 1}):Play()
game:GetService("TweenService"):Create(caller.Main.TextLabel,TweenInfo.new(0.3,Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0,false, 0 ),{TextTransparency = 1}):Play()
game:GetService("TweenService"):Create(caller.Main.Cheez,TweenInfo.new(0.4,Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0,false, 0 ),{ImageTransparency = 1, Size=UDim2.new(0, 4,0, 4), Position=UDim2.new(0.5, 0,0.34, 0)}):Play()
wait(.15)
caller.Main:TweenSize(UDim2.new(0, 277,0, 4), "Out", "Quint", .5)
game:GetService("TweenService"):Create(caller.Main,TweenInfo.new(0.55,Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0,false, 0 ),{BackgroundTransparency = 1}):Play()
game:GetService("TweenService"):Create(caller.Main.Shadow,TweenInfo.new(0.55,Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0,false, 0 ),{ImageTransparency = 1}):Play()

--// intro done
materializeb(gui.Holder.Main.ScriptsFrame.InsertScriptFrame.CancelInsert)
gui.Holder.Main.ScriptsFrame.AddScript.MouseButton1Up:Connect(function()
	gui.Holder.Main.ScriptsFrame.InsertScriptFrame:TweenPosition(UDim2.new(0.026, 0,0.057, 0), "Out", "Quint", .4, true)
end)
gui.Holder.Main.ScriptsFrame.InsertScriptFrame.CancelInsert.MouseButton1Up:Connect(function()
	gui.Holder.Main.ScriptsFrame.InsertScriptFrame:TweenPosition(UDim2.new(0.026, 0,1, 0), "Out", "Quint", .4, true)
end)
gui.MouseEnter:Connect(function()
	tS:Create(gui.Minimize, TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {ImageTransparency=0}):Play()
end)
gui.MouseLeave:Connect(function()
	tS:Create(gui.Minimize, TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {ImageTransparency=1}):Play()
end)
local isclosed = false
gui.Minimize.MouseButton1Up:Connect(function()
	if isclosed then
		gui.Holder.TabController:TweenPosition(UDim2.new(0.016, 0,0.02, 0), "Out", "Quint", .5, true)
		gui.Holder.MenuButtons:TweenPosition(UDim2.new(-0.35,0,0,0), "Out", "Quint", .3, true)
		gui.Holder.TabController.Rotation=0;
		tS:Create(gui.Holder.TabController, TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 0}):Play()
		gui.Holder.Main:TweenPosition(UDim2.new(0,0,0,0), "Out", "Sine", .2, true)
		isclosed = false
	else
		gui.Holder.TabController:TweenPosition(UDim2.new(-0.08, 0,0.02, 0), "Out", "Quint", .5, true)
		gui.Holder.TabController.Rotation=0;
		gui.Holder.MenuButtons:TweenPosition(UDim2.new(-0.35,0,0,0), "Out", "Quint", .3, true)
		tS:Create(gui.Holder.TabController, TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 1}):Play()
		gui.Holder.Main:TweenPosition(UDim2.new(0,0,-1,0), "Out", "Sine", .2, true)
		isclosed = true
	end
end)
gui.Holder.TabController.MouseButton1Up:Connect(function()
	if gui.Holder.TabController.BackgroundTransparency < 1 then
		tS:Create(gui.Holder.TabController, TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 1, Rotation=180}):Play()
		gui.Holder.MenuButtons:TweenPosition(UDim2.new(0,0,0,0), "Out", "Quint", .4, true)
	elseif gui.Holder.TabController.BackgroundTransparency > 0 then
		tS:Create(gui.Holder.TabController, TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 0, Rotation=0}):Play()
		gui.Holder.MenuButtons:TweenPosition(UDim2.new(-0.35,0,0,0), "Out", "Quint", .4, true)
	end
end)
for i,v in next, gui.Holder.MenuButtons:GetChildren() do
	if v:IsA("GuiObject") and v.ClassName ~= "UIListLayout" then
     	local function materializeb(buttons, color, transp, speed)
        local button = buttons
        local ripplespeed = speed or 1
		local transparency = transp or 0.8
		speed = speed or 1
		transp = transp or 0.8
		local parent = button;local circlecolor = color or parent.TextColor3
		button = button or gui;color = color or parent.TextColor3
		local mouse = game:GetService'Players'.LocalPlayer:GetMouse();local diagonal = math.sqrt((parent.Size.X.Offset) ^ 2 + (parent.Size.Y.Offset) ^ 2)
		parent.ClipsDescendants = true;parent.Active = true;parent.Selectable = true;parent.Visible = true;parent.AutoButtonColor = false
		parent.MouseButton1Down:Connect(function()
		function CreateInstance(cls,props)	inst = Instance.new(cls)	for i,v in pairs(props) do inst[i] = v end return inst end
		local circle = CreateInstance('ImageLabel', {Name = "CircleLabel",ZIndex=69, Parent = parent, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0,0,0,0), Size = UDim2.new(0,50,0,50), Visible = false, Image = "rbxasset://textures/whiteCircle.png", ImageColor3 = circlecolor})
	    local x = (mouse.X) - (parent.AbsolutePosition.X);local y = (mouse.Y) - (parent.AbsolutePosition.Y)
		parent.MouseLeave:Connect(function() game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play() wait(.2) circle:Destroy() end)
		parent.MouseButton1Up:Connect(function() wait(0.15)
 			game:GetService("TweenService"):Create(circle, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play()
			wait(.2)
			circle:Destroy()	
		end)
		circle.Position = UDim2.new(0,x,0,y);circle.Size = UDim2.new(0,5,0,5) -- edit this to make it bigger before animation
		circle.ImageTransparency = transparency;circle.Visible = true
		wait()
		circle:TweenSize(UDim2.new(0, diagonal * 2, 0, diagonal * 2),"Out","Quad",ripplespeed)
		end)
		end
	materializeb(v)
	end
end
--// tab switching - expensive
local menuButtons = gui.Holder.MenuButtons
local mainFrame = gui.Holder.Main

local tabData = {
	-- the first parameter is the button, the second parameter is the frame for that button
	{menuButtons.AudioBTN,mainFrame.AudioTab};
	{menuButtons.ChatBTN,mainFrame.ChatTab};
	{menuButtons.ScriptsBTN,mainFrame.ScriptsFrame};
	{menuButtons.ScriptSearchBTN,mainFrame.SearchTab};
	{menuButtons.GUIBTN,mainFrame.GuisFrame};
	{menuButtons.ZZCredits,mainFrame.CreditsTab};
	{menuButtons.CommandsBTN,mainFrame.CommandsTab};
	{menuButtons.AccountFinder, mainFrame.AccountFinder};
	{menuButtons.AHomeBTN, mainFrame.HomeTab}
}
for i,v in pairs(tabData) do
	v[1].MouseButton1Up:Connect(function()
		
		if v[2].Visible == true then
			return
		end
		
		for a,z in pairs(tabData) do
			if not (z[1]==v[1]) then
				z[2]:TweenPosition(UDim2.new(1, 0,0, 0),"Out","Quint",0.2, true)
				spawn(function()
					wait(0.1)
					z[2].Visible = false
				end)
			end
		end
		v[2].Position = UDim2.new(-1, 0,0, 0)
		v[2].Visible = true
		v[2]:TweenPosition(UDim2.new(0, 0,0, 0),"Out","Quint",0.2, true)
		tS:Create(gui.Holder.TabController, TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 0, Rotation=0}):Play()
		gui.Holder.MenuButtons:TweenPosition(UDim2.new(-0.35,0,0,0), "Out", "Quint", 0.4, true)
	end)
end

--// audio - expensive
local audioTab =  {}
local audioFrame = gui.Holder.Main.AudioTab
audioTab.resultClone = audioFrame.AudioResults.result:Clone()
audioFrame.AudioResults.result:Destroy();
audioFrame.AudioResults.UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	audioFrame.AudioResults.CanvasSize = UDim2.new(0,0,0,audioFrame.AudioResults.UIGridLayout.AbsoluteContentSize.Y)
end)
audioFrame.AudioQuery.FocusLost:Connect(function(e)
	if e then
	local query = audioFrame.AudioQuery.Text
	local results = httpService:Get("https://rprxy.xyz/proxy/api/searchmusic/"..query:lower(),true)
	
	for i,v in pairs(audioFrame.AudioResults:GetChildren()) do
		spawn(function()
			if v:IsA("ImageButton") then
				tS:Create(v, TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {ImageTransparency=1}):Play()
				tS:Create(v.TextLabel, TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {TextTransparency=1}):Play()
				wait(.15)
				v:Destroy()
				
			end
		end)
	end
	wait(.16)
	for i,v in pairs(results) do
		if not (v.Name:find("#")) then
			local new = audioTab.resultClone:Clone()
			new.ImageTransparency = 1
			new.TextLabel.TextTransparency = 1
			tS:Create(new, TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {ImageTransparency=0}):Play()
			tS:Create(new.TextLabel, TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {TextTransparency=0}):Play()
			new.TextLabel.Text = v.Name
			new.Parent = audioFrame.AudioResults
			new.Visible = true
			
			local audio = workspace:FindFirstChild("FathomAudio")
			if audio and audio.SoundId == "rbxassetid://"..v.AssetId and audio.Playing then
				local boldTween = tS:Create(new,TweenInfo.new(.35,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0),{BackgroundColor3 = Color3.fromRGB(18,18,18)})
				boldTween:Play()
			end
			new.MouseButton1Up:Connect(function()
				local audio = workspace:FindFirstChild("FathomAudio")
				if not (audio) then
					audio = Instance.new("Sound")
					audio.Parent = game:GetService("Workspace")
					audio.Name = "FathomAudio"				
				end
				if audio.SoundId == "rbxassetid://"..v.AssetId and audio.Playing then
					local boldTween = tS:Create(new,TweenInfo.new(.35,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0),{BackgroundColor3 = Color3.fromRGB(18,18,18)})
					boldTween:Play()
					audio:Stop()
				else
					for i,v in pairs(audioFrame.AudioResults:GetChildren()) do
						if v:IsA("ImageButton") then
							local boldTween = tS:Create(v,TweenInfo.new(.35,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0),{BackgroundColor3 = Color3.fromRGB(18,18,18)})
							boldTween:Play()
						end
					end
					local boldTween = tS:Create(new,TweenInfo.new(.35,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0),{BackgroundColor3=Color3.fromRGB(73,73,73)})
					boldTween:Play()
					
					audio.SoundId="rbxassetid://"..v.AssetId
					audio:Play()		
				end
			end)
		end
	end
	end
end)

--// chat bypass
local chatTab = mainFrame.ChatTab
chat = false
copyafterchat = false
function createcheckbox(parent,respone_function, oncolor,offcolor)
	local selectcolor = oncolor or Color3.fromRGB(0,0,0);local notselectedcolor = offcolor or Color3.new(1,1,1)
	local CheckBoxImage = CreateInstance('ImageButton',{Image='rbxassetid://1721163816',ZIndex=65,ImageColor3=selectcolor,ImageRectOffset=Vector2.new(0, 0),ImageRectSize=Vector2.new(0, 0),ImageTransparency=0,ScaleType=Enum.ScaleType.Stretch,SliceCenter=Rect.new(0, 0, 0, 0),AutoButtonColor=true,Modal=false,Selected=false,Style=Enum.ButtonStyle.Custom,Active=true,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0, -35, 0, 0),Rotation=0,Selectable=true,Size=UDim2.new(0, 26, 0, 26),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,Name='CheckBoxImage',Parent = parent})
	local BackgroundFrame = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,ZIndex=63,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=selectcolor,BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.150000006, 0, 0.150000006, 0),Rotation=0,Selectable=false,Size=UDim2.new(0.699999988, 0, 0.699999988, 0),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,Name = 'BackgroundFrame',Parent = CheckBoxImage})
	local CheckFrame = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,ZIndex=64,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=notselectedcolor,BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0, 4, 0, 5),Rotation=0,Selectable=false,Size=UDim2.new(0, 0, 0.600000024, 0),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,Name = 'CheckFrame',Parent = CheckBoxImage})
	local UncheckedFrame = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,ZIndex=65,Active=false,AnchorPoint=Vector2.new(0.5, 0.5),BackgroundColor3=notselectedcolor,BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.5, 0, 0.5, 0),Rotation=0,Selectable=false,Size=UDim2.new(0.600000024, 0, 0.600000024, 0),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,Name = 'UncheckedFrame',Parent = CheckBoxImage})
	CheckBoxImage.MouseButton1Down:Connect(function()
		if checked then
			CheckFrame:TweenSize(UDim2.new(0, 0,0.6, 0),"Out","Quad",0.1)
		else
			game:GetService("TweenService"):Create(UncheckedFrame, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
		end
	end)
	if parent.ClassName =="TextButton" or parent.ClassName == "ImageButton" then 
		parent.AutoButtonColor = false
		parent.MouseButton1Up:Connect(function()
			if checked then
				game:GetService("TweenService"):Create(UncheckedFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
				checked = false
				respone_function(checked)
			else
				CheckFrame:TweenSizeAndPosition(UDim2.new(0.7, 0,0.6, 0),UDim2.new(0, 4,0, 5),"Out","Quad",0.2)
				checked = true
				respone_function(checked)
			end
		end)
		parent.MouseButton1Down:Connect(function()
			if checked then
				CheckFrame:TweenSize(UDim2.new(0, 0,0.6, 0),"Out","Quad",0.1)
			else
				game:GetService("TweenService"):Create(UncheckedFrame, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
			end
		end)
	end
	CheckBoxImage.MouseButton1Up:Connect(function()
		if checked then
			game:GetService("TweenService"):Create(UncheckedFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
			checked = false
			respone_function(checked)
		else
			CheckFrame:TweenSizeAndPosition(UDim2.new(0.7, 0,0.6, 0),UDim2.new(0, 4,0, 5),"Out","Quad",0.2)
			checked = true
			respone_function(checked)
		end
	end)
	CheckBoxImage.MouseLeave:Connect(function()
		if checked and CheckFrame.Size == UDim2.new(0, 0, 1, 0) then
			CheckFrame:TweenSize(UDim2.new(1, 0, 1, 0),"Out","Quad",0.1)
		elseif checked == false and UncheckedFrame.BackgroundTransparency > 0 then
			game:GetService("TweenService"):Create(UncheckedFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
		end
	end)
end
createcheckbox(chatTab.SendToggle,function(arg) chat = arg end, Color3.fromRGB(255,255,255),Color3.fromRGB(28, 28, 28))
loadstring(httpService:Get("https://pastebin.com/raw/mr71rVvg"))()
chatTab.ChatQuery.FocusLost:Connect(function()
	local unfiltered = chatTab.ChatQuery.Text
	local doneFil = ""
	for i=1,unfiltered:len(),1 do
		if kanjiCharacters[unfiltered:sub(i,i):lower()] == nil then
			kanjiCharacters[unfiltered:sub(i,i):lower()] = unfiltered:sub(i,i):lower()
		end
		doneFil = doneFil..kanjiCharacters[unfiltered:sub(i,i):lower()].." "
	end
	chatTab.ChatQuery.Text = doneFil
	local event = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
	if event and chat then
		event.SayMessageRequest:FireServer(doneFil,"All")
	end
	if Synapse and copyafterchat then
		Synapse:Copy(chatTab.ChatQuery.Text)
	end
end)
createcheckbox(chatTab.CopyToggle, function(arg) copyafterchat = arg end, Color3.fromRGB(255,255,255),Color3.fromRGB(28, 28, 28))
if not Synapse then gui.Holder.Main.ChatTab.CopyToggle:Destroy() end
--// scripts
loadstring(httpService:Get("https://pastebin.com/raw/zy9VPDLr"))()
local function getAllScripts()
	local allOfIt = {}
	for i,v in pairs(fathomScripts) do
		table.insert(allOfIt,v)
	end
	local saves = saveService:getSave()	
	if saves and not (saves["scripts"] == nil) then
		for i,v in pairs(saves["scripts"]) do
			table.insert(allOfIt, v)
		end
	end
	
	return allOfIt
end

local scriptFrame = mainFrame.ScriptsFrame
local scriptsTab = {}
scriptFrame.MainScriptsFrame.scriptButton.TextScaled = true
scriptsTab.scriptButton = scriptFrame.MainScriptsFrame.scriptButton:clone()
scriptFrame.MainScriptsFrame.scriptButton:destroy()

if not(writefile and readfile) then
	scriptFrame.AddScript.Visible = false
end


local allScripts = getAllScripts()
for i,v in pairs(allScripts) do
	local new = scriptsTab.scriptButton:Clone()
	materializeb(new)
	new.Text = v[1]
	new.MouseButton1Up:Connect(function()
		spawn(function()
			loadstring(httpService:Get(v[2]))()
		end)
	end)
	new.Parent = scriptFrame.MainScriptsFrame
end
scriptFrame.MainScriptsFrame.UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scriptFrame.MainScriptsFrame.CanvasSize = UDim2.new(0,0,0,scriptFrame.MainScriptsFrame.UIGridLayout.AbsoluteContentSize.Y)
end)
scriptFrame.search:GetPropertyChangedSignal("Text"):Connect(function()
	local query = scriptFrame.search.Text
	for i,v in pairs(scriptFrame.MainScriptsFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	
	local allScripts = getAllScripts()
	for i,v in pairs(allScripts) do
		if v[1]:lower():find(query:lower()) then
			local new = scriptsTab.scriptButton:Clone()
			materializeb(new)
			new.Text = v[1]
			new.MouseButton1Up:Connect(function()
				spawn(function()
					loadstring(httpService:Get(v[2]))()
				end)
			end)
			new.Parent = scriptFrame.MainScriptsFrame
			scriptFrame.MainScriptsFrame.CanvasSize = UDim2.new(0,0,0,scriptFrame.MainScriptsFrame.UIGridLayout.AbsoluteContentSize.Y)
		end
	end
end)

--save
local saveFrame = scriptFrame.InsertScriptFrame
materializeb(saveFrame.InsertSRC)
saveFrame.InsertSRC.MouseButton1Up:Connect(function()
	local pasteId = saveFrame.PasteID.Text
	local name = saveFrame.ScriptName.Text

	local currentSave = saveService:getSave()
	if currentSave and currentSave["scripts"] then
		table.insert(currentSave["scripts"],{name,"https://www.pastebin.com/raw/"..pasteId})
	else
		currentSave["scripts"] = {{name,"https://www.pastebin.com/raw/"..pasteId}}
	end
	
	saveService:setSave(currentSave)
	
	local allScripts = getAllScripts()
	
	for i,v in pairs(scriptFrame.MainScriptsFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	
	for i,v in pairs(allScripts) do
		local new = scriptsTab.scriptButton:Clone()
		new.Text = v[1]
		new.MouseButton1Up:Connect(function()
			spawn(function()
				loadstring(httpService:Get(v[2]))()
			end)
		end)
		new.Parent = scriptFrame.MainScriptsFrame
	end

	
	
	saveFrame:TweenPosition(UDim2.new(0.026, 0,1, 0), "Out", "Quint", .4, true)
end)
--effect
buttoneffect(gui.Holder.Main.ScriptsFrame.AddScript, "Quint", .4, Color3.fromRGB(40, 40, 40),Color3.fromRGB(67, 67, 67))

--// guis
local guisFrame = mainFrame.GuisFrame
loadstring(httpService:Get("https://pastebin.com/raw/v1YRzcvf"))()
local function getAllGuis()
	loadstring(httpService:Get("https://pastebin.com/raw/v1YRzcvf"))()
	return fathomGuis
end

for i,v in pairs(getAllGuis()) do
	local new = scriptsTab.scriptButton:Clone()
	new.Text = v[1]
	new.MouseButton1Up:Connect(function()
		spawn(function()
			loadstring(httpService:Get(v[2]))()
		end)
	end)
	new.Parent = guisFrame.MainScriptsFrame
	materializeb(new)
end

guisFrame.search:GetPropertyChangedSignal("Text"):Connect(function()
	local query = guisFrame.search.Text
	
	for i,v in pairs(guisFrame.MainScriptsFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end	
	
	for i,v in pairs(fathomGuis) do
		if v[1]:lower():find(query:lower()) then
			local new = scriptsTab.scriptButton:Clone()
			new.Text = v[1]
			new.MouseButton1Up:Connect(function()
				spawn(function()
					loadstring(httpService:Get(v[2]))()
				end)
			end)
			new.MouseButton2Click:Connect(function()
			print'yeeeeeeeee'
			if writefile and readfile then
				loadstring(httpService:Get("https://pastebin.com/raw/Ts8TSAZN"))()
				notify("Confirm Delete Script?", true, function()
				
					local saves = saveService:getSave()	
					if saves and not (saves["scripts"] == nil) then -- pasted two lines to check if file is valid
					
								local file = game:GetService("HttpService"):JSONDecode(readfile("FathomHubSave.txt")) -- create a backup because the saveService:setSave() doesn't store backups when theres a change
								for i,v in next, file.scripts[1] do -- this will go to the scripts directory without having to use another iterator function
									if v[1] == new.Text then -- if the script name (name the user chosen) matches the textbutton name it will proceed
										--rawset(file.scripts[1], v, nil) -- table rawset(table file, Variant index (the other table), Variant value (the table data nil))
										table.remove(file.scripts[1], v) -- more efficient and won't return null or nil 
										saveService:setSave(file) -- finally save
										new:Destroy()
										break -- break to not accidentally delete a duplicate if the user made one or something -_-
									end -- end
								end -- end
					
					end
				
				end)
			end
		end)
			new.Parent = guisFrame.MainScriptsFrame
			materializeb(new)
		end
	end
end)
--// Commands management
--game.StarterGui.FathomHub.Tab.Holder.Main.CommandsTab.CommandsList.CanvasSize = UDim2.new(1, 0,0,game.StarterGui.FathomHub.Tab.Holder.Main.CommandsTab.CommandsList.UIListLayout.AbsoluteContentSize.Y ) 
gui.Holder.Main.CommandsTab.CommandsList.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	gui.Holder.Main.CommandsTab.CommandsList.CanvasSize = UDim2.new(1, 0,0,gui.Holder.Main.CommandsTab.CommandsList.UIListLayout.AbsoluteContentSize.Y)
end)
currentcommand = "none"

local command_button = gui.Holder.Main.CommandsTab.CommandsList.UntitledSection.TextButton:Clone()
gui.Holder.Main.CommandsTab.CommandsList.UntitledSection.TextButton:Destroy()
local Section = gui.Holder.Main.CommandsTab.CommandsList.UntitledSection:Clone()
gui.Holder.Main.CommandsTab.CommandsList.UntitledSection:Destroy()

function newcommand(parent,name,textsize,execute, args)
	local TextButton = command_button:Clone();
	materializeb(TextButton)
	TextButton.Parent = gui.Holder.Main.CommandsTab.CommandsList[parent];
	TextButton.Text = name; TextButton.TextSize = textsize or 29
	TextButton.MouseButton1Up:Connect(function()
		currentcommand = TextButton.Text
		if args ~= nil and TextButton.Text == currentcommand then
				gui.Holder.Main.CommandsTab.ArgPrompt.ArgInsert.FocusLost:Connect(function()
				
					if gui.Holder.Main.CommandsTab.ArgPrompt.ArgInsert.Text == "" then
						gui.Holder.Main.CommandsTab.ArgPrompt:TweenPosition(UDim2.new(0.059, 0,1, 0), "Out", "Quint", .3, true)
					else
						gui.Holder.Main.CommandsTab.ArgPrompt.ArgEx.Text = "no current args are specified"
						execute(gui.Holder.Main.CommandsTab.ArgPrompt.ArgInsert.Text)
						gui.Holder.Main.CommandsTab.ArgPrompt.ArgInsert.Text = ""
						gui.Holder.Main.CommandsTab.ArgPrompt:TweenPosition(UDim2.new(0.059, 0,1, 0), "Out", "Quint", .3, true)
						
					end
				
				end)
				gui.Holder.Main.CommandsTab.ArgPrompt.ArgEx.Text = "ARGS: "..args
				gui.Holder.Main.CommandsTab.ArgPrompt:TweenPosition(UDim2.new(0.059, 0,0.112, 0), "Out", "Quint", .3, true)
				gui.Holder.Main.CommandsTab.ArgPrompt.ArgInsert:CaptureFocus()
			else
				execute()
			end
			
	end)
end
function newsection(name, buttonsize)
	local untitledsection = Section:Clone()
	untitledsection.Parent = gui.Holder.Main.CommandsTab.CommandsList
	untitledsection.Name = name
	untitledsection.UIGridLayout.CellSize = buttonsize or UDim2.new(0, 100,0, 100)
	untitledsection.Size = UDim2.new(1,0,0,untitledsection.UIGridLayout.AbsoluteContentSize.Y)
	untitledsection.UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		untitledsection.Size = UDim2.new(1,0,0,untitledsection.UIGridLayout.AbsoluteContentSize.Y)
	end)
end

loadstring(httpService:Get("https://pastebin.com/raw/cWVTUCZP"))()
--// script search

local scriptSearch = mainFrame.SearchTab

function searchPastebin(query,engine,charNet,holder,responseFunc,errorFunc)
	local rawHttp = httpService:Get(engine.."site:pastebin.com ".. charNet .." "..query:lower())
	local toScan = rawHttp
	local results = {}
	
	if errorFunc == nil then
		function errorFunc() end
	end
	
	if toScan == nil then
		errorFunc(); return	
	end
	
	local recordHolder;
	if holder == nil then
		recordHolder = {}
	else
		recordHolder=holder
	end
	
	while wait() do
		local startPaste,endPaste = toScan:find("pastebin.com/")
		if startPaste then
			local id = toScan:sub(endPaste+1,endPaste+8)
			
			if recordHolder[id:lower()] == nil then
				recordHolder[id:lower()] = true
				local newResult = {"https://www.pastebin.com/raw/"..id}
				local sitePaste = httpService:Get("https://www.pastebin.com/"..id)
				if not (sitePaste == nil) then -- in case of a failed http request
					local _,titleStart = sitePaste:find("<title>")
					local titleEnd,_ = sitePaste:find("</title>")
					newResult[2] = sitePaste:sub(titleStart+1,titleEnd-16)				
					
					responseFunc(newResult)	
				end
			end
		else
			break
		end
		
		toScan = toScan:sub(endPaste+9)
	end
	return results
end

local searchEngines = {
	{"Google","https://www.google.com/search?q="};
	{"Yahoo","https://search.yahoo.com/search?p="};
	{"Bing","https://www.bing.com/search?q="};
	{"Ecosia","https://www.ecosia.org/search?q="};
}
local currentEngine = 1
local searchData = {}
searchData.button = scriptSearch.MenuButtons.result:Clone()
scriptSearch.MenuButtons.result:Destroy();

RecentClickedScript = "None"

scriptSearch.data.SearchQuery.FocusLost:Connect(function(e)
	if e then
		local query = scriptSearch.data.SearchQuery.Text:lower()
		for i,v in pairs(scriptSearch.MenuButtons:GetChildren()) do
			spawn(function()
				if v:IsA("TextButton") then
					tS:Create(v, TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {TextTransparency=1,BackgroundTransparency=1}):Play()
					wait(.15)
					v:Destroy()
					scriptSearch.MenuButtons.CanvasSize = UDim2.new(0,0,0, scriptSearch.MenuButtons.UIGridLayout.AbsoluteContentSize.Y)
				end
			end)
		end
	
		local function response(v) 
			local new = searchData.button:clone()
			scriptSearch.MenuButtons.CanvasSize = UDim2.new(0,0,0, scriptSearch.MenuButtons.UIGridLayout.AbsoluteContentSize.Y)
			new.BackgroundTransparency = 1
			new.TextTransparency = 1
			tS:Create(new, TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {TextTransparency=0,BackgroundTransparency=0}):Play()
			materializeb(new)
			new.Text = v[2]
			new.MouseButton1Up:Connect(function()
				spawn(function()
					loadstring(httpService:Get(v[1]))()
				end)
			end)
			new.MouseButton2Click:Connect(function()
				-- 30
				RecentClickedScript = string.sub(v[1], 30)
				notificationService:extendednotify("ABOUT THIS SCRIPT", {
					"Link: ".. v[1];
					"Name: ".. v[2];
					"This script was not made nor endorsed by Fathom Hub.";
				})
			end)
			new.Parent = scriptSearch.MenuButtons
		
		end
		--{0.293, 0},{-0.5, 0}
		
		local dataManager = {}
		scriptSearch.data.SearchQuery:TweenPosition(UDim2.new(0.293, 0,-1, 0),"Out","Quint",.2, true)

		searchPastebin(query,searchEngines[currentEngine][2],"roblox script",dataManager,response,function() notificationService:notify("There was an error with your search. You are most likely rate-limited. Use a different engine, or try again later.") end)
		searchPastebin(query,searchEngines[currentEngine][2],"roblox lua",dataManager,response)
		searchPastebin(query,searchEngines[currentEngine][2],"roblox",dataManager,response)
		
		scriptSearch.data.SearchQuery:TweenPosition(UDim2.new(0.293, 0,0.164, 0),"Out","Quint",.2,true)
	end
end)

createmenudropbox(gui.Holder.Main.SearchTab.data.Selector, true,{
	["Google"]= function()
		currentEngine =1
	end,
	["Yahoo"]=function()
		currentEngine=2
	end,
	["Bing"]=function()
		currentEngine=3
	end,
	["Ecosia"]=function()
		currentEngine=4
	end
})

--// account finder yeee
function GetDate()
	local date = {}
	local months = {
		{"January", 31};
		{"February", 28};
		{"March", 31};
		{"April", 30};
		{"May", 31};
		{"June", 30};
		{"July", 31};
		{"August", 31};
		{"September", 30};
		{"October", 31};
		{"November", 30};
		{"December", 31};
	}
	local t = tick()
	date.total = t
	date.seconds = math.floor(t % 60)
	date.minutes = math.floor((t / 60) % 60)
	date.hours = math.floor((t / 60 / 60) % 24)
	date.year = (1970 + math.floor(t / 60 / 60 / 24 / 365.25))
	date.yearShort = tostring(date.year):sub(-2)
	date.isLeapYear = ((date.year % 4) == 0)
	date.isAm = (date.hours < 12)
	date.hoursPm = (date.isAm and date.hours or (date.hours == 12 and 12 or (date.hours - 12)))
	if (date.hoursPm == 0) then date.hoursPm = 12 end
	if (date.isLeapYear) then
		months[2][2] = 29
	end
	do
		date.dayOfYear = math.floor((t / 60 / 60 / 24) % 365.25)
		local dayCount = 0
		for i,month in pairs(months) do
			dayCount = (dayCount + month[2])
			if (dayCount > date.dayOfYear) then
				date.monthWord = month[1]
				date.month = i
				date.day = (date.dayOfYear - (dayCount - month[2]) + 1)
				break
			end
		end
	end
	function date:format(str)
		str = str
			:gsub("#s", ("%.2i"):format(self.seconds))
			:gsub("#m", ("%.2i"):format(self.minutes))
			:gsub("#h", tostring(self.hours))
			:gsub("#H", tostring(self.hoursPm))
			:gsub("#Y", tostring(self.year))
			:gsub("#y", tostring(self.yearShort))
			:gsub("#a", (self.isAm and "AM" or "PM"))
			:gsub("#W", self.monthWord)
			:gsub("#M", tostring(self.month))
			:gsub("#d", tostring(self.day))
			:gsub("#D", tostring(self.dayOfYear))
			:gsub("#t", tostring(self.total))
		return str
	end
	return date
end
-- ^ essential function for getting date for naming save file
local function slidefunc(pos_object, responseexe)
pcall(function()
	local mouseDrag = false
	pos_object.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseDrag = true
			local linePos = game:GetService("Players").LocalPlayer:GetMouse().X - pos_object.AbsolutePosition.X
			if linePos >= 0 and linePos <= pos_object.AbsoluteSize.X then
				local movePos = linePos/pos_object.AbsoluteSize.X
				pos_object.Touch:TweenPosition(UDim2.new(movePos, 0, 0, 0), "Out", "Quad", .11, true)
				responseexe(movePos)
			elseif linePos < 0 then
				pos_object.Touch:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", .11, true)
				responseexe(0)
			else
				pos_object.Touch:TweenPosition(UDim2.new(1, 0, 0, 0), "Out", "Quad", .11, true)
				responseexe(1)
			end
		end
	end)
	pos_object.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			mouseDrag = false
		end
	end)
	game:GetService("Players").LocalPlayer:GetMouse().Move:connect(function(prop)
		if mouseDrag then
			local linePos = game:GetService("Players").LocalPlayer:GetMouse().X - pos_object.AbsolutePosition.X
			if linePos >= 0 and linePos <= pos_object.AbsoluteSize.X then
				local movePos = linePos/pos_object.AbsoluteSize.X
				pos_object.Touch:TweenPosition(UDim2.new(movePos, 0, 0, 0), "Out", "Quad", .11, true)
				responseexe(movePos)
			elseif linePos < 0 then
				pos_object.Touch:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", .11, true)
				responseexe(0)
			else
				pos_object.Touch:TweenPosition(UDim2.new(1, 0, 0, 0), "Out", "Quad", .11, true)
				responseexe(1)
			end
		end
	end)
end)
end
slidefunc(gui.Holder.Main.AccountFinder.Pos, function(arg)
	if string.match(tostring(arg*16+4), "%.") then
		gui.Holder.Main.AccountFinder.ULength.Value = tonumber(string.match(tostring(arg*16+4), "(%d-)%."))
		gui.Holder.Main.AccountFinder.Length.Text = "Name Length: "..tostring(gui.Holder.Main.AccountFinder.ULength.Value)
	else
		gui.Holder.Main.AccountFinder.ULength.Value = tonumber(arg*16+4)
		gui.Holder.Main.AccountFinder.Length.Text = "Name Length: "..tostring(arg*16+4)
	end
end)
gui.Holder.Main.AccountFinder.ULength:GetPropertyChangedSignal("Value"):Connect(function()
	if gui.Holder.Main.AccountFinder.ULength.Value < 4 or gui.Holder.Main.AccountFinder.ULength.Value > 20 then
		gui.Parent:Destroy()
		spawn(function()
			warnmsg = pcall(function()
				loadstring(httpService:Get("https://pastebin.com/raw/Ts8TSAZN"))()
				notificationService:notify("Action aborted")
			end)
		end)
		if not warnmsg then print'\nFATHOM HUB ANTI-TAMPER: REJECTED NON-SYSTEM OPERATION\nSTILL WHY?: VALUE UNDER 4 OR OVER 20' end
	end
end)
local msgtxt = gui.Holder.Main.AccountFinder.Log.Example:Clone()
gui.Holder.Main.AccountFinder.Log.Example:Destroy()
local accounts = {}
function newmsg(msg_type, text)
	if msg_type=="invalid" then
		local newtext = msgtxt:Clone()
		newtext.Parent = gui.Holder.Main.AccountFinder.Log
		newtext.Name = "invalid"
		newtext.Text = "FAILED: "..text
		gui.Holder.Main.AccountFinder.Log.CanvasSize = UDim2.new(0,0,0,gui.Holder.Main.AccountFinder.Log.UIListLayout.AbsoluteContentSize.Y)
		gui.Holder.Main.AccountFinder.Log.CanvasPosition = Vector2.new(0,gui.Holder.Main.AccountFinder.Log.CanvasSize.Y.Offset)
	elseif msg_type == "success" then
		local newtext = msgtxt:Clone()
		newtext.Parent = gui.Holder.Main.AccountFinder.Log
		newtext.Name = "success"
		newtext.Text = "SUCCESS: "..text
		gui.Holder.Main.AccountFinder.Log.CanvasSize = UDim2.new(0,0,0,gui.Holder.Main.AccountFinder.Log.UIListLayout.AbsoluteContentSize.Y)
		gui.Holder.Main.AccountFinder.Log.CanvasPosition = Vector2.new(0,gui.Holder.Main.AccountFinder.Log.CanvasSize.Y.Offset)
	elseif msg_type == "save" and writefile then
		accounts[#accounts+1] = text
	end
	
end

gui.Holder.Main.AccountFinder.ButtonHolder.FindToggle:GetPropertyChangedSignal("Text"):Connect(function()
	if writefile and gui.Holder.Main.AccountFinder.ButtonHolder.FindToggle.Text == "Start" and #accounts ~= 0 then
		gui.Holder.Main.AccountFinder.ButtonHolder.Save:TweenPosition(UDim2.new(0.668, 0,0, 0), "Out", "Quint", .3, true)
	end
	
end)
materializeb(gui.Holder.Main.AccountFinder.ButtonHolder.Clear)
materializeb(gui.Holder.Main.AccountFinder.ButtonHolder.FindToggle)
materializeb(gui.Holder.Main.AccountFinder.ButtonHolder.Save)
gui.Holder.Main.AccountFinder.ButtonHolder.Clear.MouseButton1Up:Connect(function()
	gui.Holder.Main.AccountFinder.ButtonHolder.FindToggle:TweenPosition(UDim2.new(0,0,1,0), "Out", "Quint", .3, true)
	gui.Holder.Main.AccountFinder.ButtonHolder.Save:TweenPosition(UDim2.new(0.668, 0,1, 0), "Out", "Quint", .3, true)
	gui.Holder.Main.AccountFinder.ButtonHolder.Clear:TweenPosition(UDim2.new(0.402, 0,1, 0), "Out", "Quint", .3, true)
	if #accounts ~= 0 then
		--// fastest way to do it ok?
		local count = #accounts
		for i=0, count do accounts[i]=nil end
	end
	for i,v in next, gui.Holder.Main.AccountFinder.Log:GetChildren() do
		if v:IsA("GuiObject") then
			v:Destroy()
			game:GetService("RunService").RenderStepped:wait()
		end
	end
	gui.Holder.Main.AccountFinder.ButtonHolder.FindToggle:TweenPosition(UDim2.new(0,0,0,0), "Out", "Quint", .3, true)
end)

																																																			--[[
___________                                   .__                              __       _________             __                    _____              .__                 __                        __  .__                             
\_   _____/__  _________   ____   ____   _____|__|__  __ ____   _____    _____|  | __  /   _____/__.__. _____/  |______  ___  ___ _/ ____\___________  |__| ____   _______/  |________ __ __   _____/  |_|__| ____   ____   ______       
 |    __)_\  \/  /\____ \_/ __ \ /    \ /  ___/  \  \/ // __ \  \__  \  /  ___/  |/ /  \_____  <   |  |/    \   __\__  \ \  \/  / \   __\/  _ \_  __ \ |  |/    \ /  ___/\   __\_  __ \  |  \_/ ___\   __\  |/  _ \ /    \ /  ___/       
 |        \>    < |  |_> >  ___/|   |  \\___ \|  |\   /\  ___/   / __ \_\___ \|    <   /        \___  |   |  \  |  / __ \_>    <   |  | (  <_> )  | \/ |  |   |  \\___ \  |  |  |  | \/  |  /\  \___|  | |  (  <_> )   |  \\___ \        
/_______  /__/\_ \|   __/ \___  >___|  /____  >__| \_/  \___  > (____  /____  >__|_ \ /_______  / ____|___|  /__| (____  /__/\_ \  |__|  \____/|__|    |__|___|  /____  > |__|  |__|  |____/  \___  >__| |__|\____/|___|  /____  >       
        \/      \/|__|        \/     \/     \/              \/       \/     \/     \/         \/\/         \/          \/      \/                              \/     \/                          \/                    \/     \/        
                .__                      __           .__                             __                                   _____                    __  .__                .__               __  .__                   __                
  ____   ____   |  |__   ______  _  __ _/  |_  ____   |__| ____   ______ ____________/  |_   ___.__. ____  __ _________  _/ ____\_ __  ____   _____/  |_|__| ____   ____   |__| ____       _/  |_|  |__ _____    ____ |  | __  ______    
 /  _ \ /    \  |  |  \ /  _ \ \/ \/ / \   __\/  _ \  |  |/    \ /  ___// __ \_  __ \   __\ <   |  |/  _ \|  |  \_  __ \ \   __\  |  \/    \_/ ___\   __\  |/  _ \ /    \  |  |/    \      \   __\  |  \\__  \  /    \|  |/ / /  ___/    
(  <_> )   |  \ |   Y  (  <_> )     /   |  | (  <_> ) |  |   |  \\___ \\  ___/|  | \/|  |    \___  (  <_> )  |  /|  | \/  |  | |  |  /   |  \  \___|  | |  (  <_> )   |  \ |  |   |  \      |  | |   Y  \/ __ \|   |  \    <  \___ \     
 \____/|___|  / |___|  /\____/ \/\_/    |__|  \____/  |__|___|  /____  >\___  >__|   |__|    / ____|\____/|____/ |__|     |__| |____/|___|  /\___  >__| |__|\____/|___|  / |__|___|  / /\   |__| |___|  (____  /___|  /__|_ \/____  > /\ 
																																																			            \/       \/                                       \/     \/     \/               \/                                           \/     \/                    \/          \/  )/             \/     \/     \/     \/     \/  \/ --]]
																																																		
gui.Holder.Main.AccountFinder.ButtonHolder.Save.MouseButton1Up:Connect(function()
	gui.Holder.Main.AccountFinder.ButtonHolder.Save:TweenPosition(UDim2.new(0.668, 0,1, 0), "Out", "Quint", .3, true)
	writefile("Fathom Account Output - "..GetDate()["month"].." - "..GetDate()["day"].." - "..GetDate()["year"], table.concat(accounts, "\n"))
	gui.Holder.Main.AccountFinder.ButtonHolder.Save:TweenPosition(UDim2.new(0.668, 0,0, 0), "Out", "Quint", .3, true)
end)	
local run = false		
local prevAttempts = {}
local characters = "abcdefg123hijk456lmno789p0"																																											
gui.Holder.Main.AccountFinder.ButtonHolder.FindToggle.MouseButton1Up:Connect(function()
	if run == false then
		run = true
		gui.Holder.Main.AccountFinder.ButtonHolder.FindToggle.Text = "STOP"
		--// ASK SYNTAX PLZ STOP
		-- buddy i was dming you and you went offline right after my first message
		spawn(function()
			while run and wait() do
				local query = ""
				for i = tonumber(gui.Holder.Main.AccountFinder.Length.Text:sub(14)),1,-1 do
					local num = math.random(1, characters:len())
					query = query..characters:sub(num,num)
				end
				
				if not(prevAttempts[query]) then prevAttempts[query]=true
				--	print(query)
					if httpService:Get("http://www.rprxy.xyz/UserCheck/DoesUsernameExist?username="..query):find("false") then					
						-- change rprxy.xyz to roblox.com on release
						newmsg("success", " "..query)
						newmsg("save", query)
					else
						newmsg("not_Valid", " "..query.." IS ALREADY TAKEN")
					end
				end
			end
		end)
	else
		run = false
		if writefile and #accounts > 0 then
			gui.Holder.Main.AccountFinder.ButtonHolder.Save:TweenPosition(UDim2.new(0.668, 0,0, 0), "Out", "Quint", .3, true)
		end
		if #gui.Holder.Main.AccountFinder.Log:GetChildren()-1 > 0 then
			gui.Holder.Main.AccountFinder.ButtonHolder.Clear:TweenPosition(UDim2.new(0.402, 0,0, 0), "Out", "Quint", .3, true)
		end
		gui.Holder.Main.AccountFinder.ButtonHolder.FindToggle.Text = "START"
	end
end)


--// Script viewereditor

scriptviewer = gui.Parent.ScriptViewer
local scriptviewerenabled = false

game:GetService("UserInputService").InputBegan:Connect(function(inputObject, gameProcessedEvent)
	if inputObject.KeyCode == Enum.KeyCode.F4 then
		if scriptviewerenabled == false then
			scriptviewer.Visible = true
			scriptviewer.Holder.Main:TweenPosition(UDim2.new(0, 0,0, 0), "Out", "Quad", .3, true)
			scriptviewerenabled = true
		else
			scriptviewer.Holder.Main:TweenPosition(UDim2.new(0, 0,-1, 0), "Out", "Quad", .3, true)
			wait(.3)
			scriptviewerenabled = false
			scriptviewer.Visible = false
		end
	end
end)

game:GetService("UserInputService").InputBegan:Connect(function(inputObject, gameProcessedEvent)
	if inputObject.KeyCode == Enum.KeyCode.F2 then
		if scriptviewer.Holder.Main.ScrollingFrame.Source_.Strings_.Visible == false then
			for i,v in next,  scriptviewer.Holder.Main.ScrollingFrame.Source_:GetChildren() do
				v.Visible = true
			end
		else
			for i,v in next,  scriptviewer.Holder.Main.ScrollingFrame.Source_:GetChildren() do
				v.Visible = false
			end
		end
	end
end)
scriptviewer.Holder.Main.MDetect.MouseEnter:Connect(function()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.ScrollingFrame, TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0), {ScrollBarThickness = 9}):Play()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.Ex, TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 0}):Play()
end)
scriptviewer.Holder.Main.MDetect.MouseLeave:Connect(function()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.ScrollingFrame, TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0), {ScrollBarThickness = 2}):Play()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.Ex, TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 1}):Play()
end)

scriptviewer.Holder.Main.MDetect2.MouseEnter:Connect(function()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.ScrollingFrame, TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0), {ScrollBarThickness = 9}):Play()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.Ex2, TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 0}):Play()
end)
scriptviewer.Holder.Main.MDetect2.MouseLeave:Connect(function()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.ScrollingFrame, TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0), {ScrollBarThickness = 2}):Play()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.Ex2, TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 1}):Play()
end)

loadstring(httpService:Get("https://pastebin.com/raw/ef1TzBJR"))()
Source_ = scriptviewer.Holder.Main.ScrollingFrame.Source_



local Highlight = function(string, keywords)
    local K = {}
    local S = string
    local Token =
    {
        ["="] = true,
        ["."] = true,
        [","] = true,
        ["("] = true,
        [")"] = true,
        ["["] = true,
        ["]"] = true,
        ["{"] = true,
        ["}"] = true,
        [":"] = true,
        ["*"] = true,
        ["/"] = true,
        ["+"] = true,
        ["-"] = true,
        ["%"] = true,
		[";"] = true,
		["~"] = true
    }
    for i, v in pairs(keywords) do
        K[v] = true
    end
    S = S:gsub(".", function(c)
        if Token[c] ~= nil then
            return "\32"
        else
            return c
        end
    end)
    S = S:gsub("%S+", function(c)
        if K[c] ~= nil then
            return c
        else
            return (" "):rep(#c)
        end
    end)
  
    return S
end
local strings = function(string)
    local highlight = ""
    local quote = false
    string:gsub(".", function(c)
        if quote == false and c == "\"" then
            quote = true
        elseif quote == true and c == "\"" then
            quote = false
        end
        if quote == false and c == "\"" then
            highlight = highlight .. "\""
        elseif c == "\n" then
            highlight = highlight .. "\n"
		elseif c == "\t" then
		    highlight = highlight .. "\t"
        elseif quote == true then
            highlight = highlight .. c
        elseif quote == false then
            highlight = highlight .. "\32"
        end
    end)
  
    return highlight
end
local hTokens = function(string)
    local Token =
    {
        ["="] = true,
        ["."] = true,
        [","] = true,
        ["("] = true,
        [")"] = true,
        ["["] = true,
        ["]"] = true,
        ["{"] = true,
        ["}"] = true,
        [":"] = true,
        ["*"] = true,
        ["/"] = true,
        ["+"] = true,
        ["-"] = true,
        ["%"] = true,
		[";"] = true,
		["~"] = true
    }
    local A = ""
    string:gsub(".", function(c)
        if Token[c] ~= nil then
            A = A .. c
        elseif c == "\n" then
            A = A .. "\n"
		elseif c == "\t" then
			A = A .. "\t"
        else
            A = A .. "\32"
        end
    end)
  
    return A
end

local highlight_source = function()
	Source_.Text = Source_.Text:gsub("\13", "")
	Source_.Text = Source_.Text:gsub("\t", "      ")
	local s = Source_.Text
	Source_.Keywords_.Text = Highlight(s, lua_keywords)
	Source_.Globals_.Text = Highlight(s, global_env)
	Source_.RemoteHighlight_.Text = Highlight(s, {"FireServer", "fireServer", "InvokeServer", "invokeServer"})
	Source_.Strings_.Text = strings(s)
	Source_.Tokens_.Text = hTokens(s)

end

Source_:GetPropertyChangedSignal("Text"):Connect(function()
	highlight_source()
	
	local lines = 1
	scriptviewer.Holder.Main.ScrollingFrame.Source_.Text:gsub("\n", function()
		lines = lines + 1
	end)
	lines = lines - 14
	local newsize = 0
	for i=1,lines do
		newsize = newsize + 14
	end
	
	pcall(function()
		scriptviewer.Holder.Main.ScrollingFrame.Source_.Size = UDim2.new(1,0,0,204)
		scriptviewer.Holder.Main.ScrollingFrame.Source_.Size = UDim2.new(1,0,0,scriptviewer.Holder.Main.ScrollingFrame.Source_.Size.Y.Offset +newsize)
		
		
		--scriptviewer.Holder.Main.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,scriptviewer.Holder.Main.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y+18)
		scriptviewer.Holder.Main.ScrollingFrame.CanvasSize = UDim2.new(0,800,0,Source_.Size.Y.Offset)
		scriptviewer.Holder.Main.ScrollingFrame.CanvasPosition = Vector2.new(0,scriptviewer.Holder.Main.ScrollingFrame.CanvasSize.Y.Offset)
		
	end)
end)
for i,v in next, scriptviewer.Holder.Main:GetChildren() do
	if v:IsA("TextButton") then
		materializeb(v)
	end
end
scriptviewer.Holder.Main.Execute.MouseButton1Up:Connect(function()
	loadstring(Source_.Text)()
end)


local copy
spawn(function()
if Clipboard ~= nil then
	copy = Clipboard.set
	return
elseif Synapse ~= nil then
	copy = function(str)
		Synapse:Copy(str)
	end
	return
elseif setclipboard ~= nil then	
	copy = setclipboard
	return
end
scriptviewer.Holder.Main.Copy.Visible = false
end)

scriptviewer.Holder.Main.Copy.MouseButton1Up:Connect(function()
	copy(scriptviewer.Holder.Main.ScrollingFrame.Source_.Text)
end)

scriptviewer.Holder.Main.Clear.MouseButton1Up:Connect(function()
	scriptviewer.Holder.Main.ScrollingFrame.Source_.Text = ""
end)
if readfile == nil then
	scriptviewer.Holder.Main.Open.Visible = false
end
if writefile == nil then
	scriptviewer.Holder.Main.SaveScript.Visible = false
end
scriptviewer.Holder.Main.Open.MouseButton1Up:Connect(function()
	render(function()
		Source_.Text = "-- Attempting to read given file name."
		local readed = ""
		local read = pcall(function()
			readfile(scriptviewer.Holder.Main.Parameter.Text)
		end)
		if not read then
			Source_.Text = "-- Fathom Script Reader\n-- File reading asynchronous failed\n-- Didn't find file specified or corrupted please specify extention [.txt, .lua, .html] if it was the cause."
		else
			Source_.Text = readed
		end
	end)
end)
scriptviewer.Holder.Main.SaveScript.MouseButton1Up:Connect(function()
	render(function()
		local save = pcall(function()
			writefile(scriptviewer.Holder.Main.Parameter.Text, Source_.Text)
		end)
		if not save then
			scriptviewer.Holder.Main.Parameter.Text = "Error Occurred"
		end
	end)
end)
scriptviewer.Holder.Main.OpenURL.MouseButton1Up:Connect(function()
	render(function()
		local onlineReadAsync = pcall(function()
			Source_.Text = httpService:Get("https://pastebin.com/raw/"..scriptviewer.Holder.Main.Parameter.Text)
		end)
		if not onlineReadAsync then
			Source_.Text = "-- Fathom Script Service\n-- URL Get asynchronous failed\n--Sometimes this is because you didn't provide a valid ID or IP banned"
		end
	end)
end)
scriptviewer.Holder.Main.OpenRCT.MouseButton1Up:Connect(function()
	render(function()
		if RecentClickedScript ~= "None" then
			Source_.Text = "loadstring(game:HttpGetAsync(\"https://pastebin.com/raw/"..RecentClickedScript.."\",0,true))()"
		else
			Source_.Text = "-- Fathom Open Service\n-- Passed Empty Variable"
		end
	end)
end)

local lbl = scriptviewer.Holder.Main.WaitBox.Load
local xDelta = 64
local yDelta = 64
local xIndex = 0
local yIndex = 0
local maxX = 5
local maxY = 15
spawn(function()
local running = true
repeat
	lbl.ImageRectOffset = Vector2.new(xIndex * xDelta, yIndex * yDelta)
	xIndex = xIndex + 1
	if xIndex == maxX then
		xIndex = 0
		yIndex = yIndex + 1
		if yIndex == maxY then
			yIndex = 0
		end
	end
	wait(.029)
until running == false
end)

function render(afunction)
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.WaitBox.Load, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 0}):Play()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.WaitBox.TextLabel, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {TextTransparency = 0}):Play()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.WaitBox, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 0}):Play()
	afunction()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.WaitBox.Load, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {ImageTransparency = 1}):Play()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.WaitBox.TextLabel, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {TextTransparency = 1}):Play()
	game:GetService("TweenService"):Create(scriptviewer.Holder.Main.WaitBox, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0), {BackgroundTransparency = 1}):Play()
end












--[[
	EXAMPLE OF SCRIPTS
	local scripts = {
		["Name"]="paste ID"	
	}
--]]

loadstring(game:HttpGetAsync("pasteID", 0, true))();
local bb = Instance.new("UIListLayout");
bb.Parent = mainframe or what_ever_u_choose;
bb.HorizontalAlignment = Enum.HorizontalAlignment.Center;
bb.Padding = Vector2.new(0.04, 0);
for i,v in next, scripts do
	local textbutton = Instance.new("TextButton");
	textbutton.Size = UDim2.new(0, 150, 0, 150);
	textbutton.Text = i;
	textbutton.Parent = mainframe or what_ever_u_choose;
	textbutton.MouseButton1Up:Connect(function()
		loadstring(game:HttpGetAsync("https://pastebin.com/raw/"..v, 0, true))();
	end);
end;






































