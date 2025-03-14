if not game.SinglePlayer() then return end

local Working, Stop = false, false
local Stop = false
local MacroTable, Loops = {}, {}
local Step, CurLoop = 0, 0
local Owner = Owner or LocalPlayer()

local ConFile  = CreateClientConVar("peak_concommac_file", "default", true, false, "Name of the currently selected file with Macro instructions")
local SuppressMessages  = CreateClientConVar("peak_concommac_messageoff", 0, true, false, "Turn off chat messages from Console Command Macro")
local SuppressSounds  = CreateClientConVar("peak_concommac_soundoff", 0, true, false, "Turn off sounds from Console Command Macro")

local Action = {
	function(var, step) -- Wait
		var = tonumber(var)
		if not var then var = 0 end

		local time = CurTime()

		while ( CurTime() - time < var ) and not Stop do
			step = coroutine.yield(step)
		end

		return step
	end,

	function(var, step) -- Concommand
		Owner:ConCommand( var )

		return step
	end,

	function(var, step) -- Loop start
		var = tonumber(var)
		if not var then var = 1 end

		CurLoop = CurLoop + 1
		Loops[CurLoop] = {
			Repeats = var - 1,
			Jump = step
		}
print("Setting loop " .. CurLoop .. ", set to repeat for " .. var)
		return step
	end,

	function(var, step) -- Loop end
		local Repeats = Loops[CurLoop].Repeats print("Loop end, repeats left: " .. Repeats)
		if Repeats > 0 then
			step = Loops[CurLoop].Jump
			Loops[CurLoop].Repeats = Repeats - 1
		else
			Loops[CurLoop] = nil print("Loop " .. CurLoop .. " done")
			if CurLoop > 0 then
				CurLoop = CurLoop - 1
			end
		end

		return step
	end
}

-- test
local DefaultMacro = {
	{
		Type = 1,
		Var = 1
	},

	{
		Type = 3,
		Var = 100
	},

	{
		Type = 2,
		Var = ""
	},

	{
		Type = 1,
		Var = 0.01
	},

	{
		Type = 2,
		Var = ""
	},

	{
		Type = 1,
		Var = 0.01
	},

	{
		Type = 4
	}
}

local function macro(step)
	while true do
		step = coroutine.yield(step) print("Cor enter, step: " .. step)
		if step and not Stop then
			if MacroTable[step] then
				local a = MacroTable[step]
				step = Action[a.Type](a.Var, step) + 1
				print("Step valid, step now: " .. step)
			else
				if not SuppressMessages:GetBool() then Owner:ChatPrint("Console Macro finished!") end
				if not SuppressSounds:GetBool() then surface.PlaySound("buttons/button1.wav") end
				Working = false
				Stop = false
				CurLoop = 0
				Loops = {}
			end
		else
			if not SuppressMessages:GetBool() then Owner:ChatPrint("Console Macro stopped!") end
			if not SuppressSounds:GetBool() then surface.PlaySound("buttons/button6.wav") end
			Working = false
			Stop = false
			CurLoop = 0
			Loops = {}
		end
	end
end

local cor = coroutine.create(macro)

local function MacroTick()
	if Working then
		local b, step = coroutine.resume(cor, Step)
		if not b then print (b, step) end
		if b and step then
			Step = step
		end
	end
end

hook.Add("Think", "PEAKConCommandMacro", MacroTick)

concommand.Add( "peak_mac_start", function()
	if not Owner or not IsValid(Owner) then Owner = LocalPlayer() end

	if not Working then
		if not SuppressMessages:GetBool() then Owner:ChatPrint("Console Macro starting!") end
		if not SuppressSounds:GetBool() then surface.PlaySound("buttons/blip1.wav") end
		Working = true
		Stop = false
		Step = 1
		print("start")
	else
		Stop = true
		print("manual stop")
	end
end )

-------- UI Related functions --------

local CYAN = Color(0, 230, 230)
local ORANGE = Color(230, 200, 0)
local WHITE = Color(230, 230, 230)
local MacroPanel

local CreateStep = {
	function( cpanel, tab, id ) -- Wait
		local base = vgui.Create("DPanel", cpanel)
		base:SetBackgroundColor(WHITE)
		cpanel:AddItem(base)

		base.text = vgui.Create("DLabel", base)
		base.text:SetDark(true)
		base.text:SetText("Step " .. id .. ": Wait (seconds)")

		base.entry = vgui.Create("DTextEntry", base)
		base.entry:SetNumeric(true)
		base.entry:SetValue(tab.Var)
		base.entry:SetUpdateOnType(true)

		base.entry.OnValueChange = function(self, val)
			val = tonumber(val)
			if val then
				tab.Var = val
			end
		end

		base.PerformLayout = function(self)
			self:SetHeight(48)

			self.text:SetPos(10, 5)
			self.text:SetWide(self:GetWide())

			self.entry:SetSize(self:GetWide() - 40, 15)
			self.entry:SetPos(5, 28)
		end

		return base
	end,
		
	function( cpanel, tab, id ) -- Concommand
		local base = vgui.Create("DPanel", cpanel)
		base:SetBackgroundColor(CYAN)
		cpanel:AddItem(base)

		base.text = vgui.Create("DLabel", base)
		base.text:SetDark(true)
		base.text:SetText("Step " .. id .. ": Console Command")

		base.entry = vgui.Create("DTextEntry", base)
		base.entry:SetValue(tab.Var)
		base.entry:SetUpdateOnType(true)

		base.entry.OnValueChange = function(self, val)
			val = tostring(val)
			if val then
				tab.Var = val
			end
		end

		base.PerformLayout = function(self)
			self:SetHeight(48)

			self.text:SetPos(10, 5)
			self.text:SetWide(self:GetWide())

			self.entry:SetSize(self:GetWide() - 40, 15)
			self.entry:SetPos(5, 28)
		end

		return base
	end,
		
	function( cpanel, tab, id ) -- Loop Start
		local base = vgui.Create("DPanel", cpanel)
		base:SetBackgroundColor(ORANGE)
		cpanel:AddItem(base)

		base.text = vgui.Create("DLabel", base)
		base.text:SetDark(true)
		base.text:SetText("Step " .. id .. ": Loop Start (Repeat amount)")

		base.entry = vgui.Create("DTextEntry", base)
		base.entry:SetNumeric(true)
		base.entry:SetValue(tab.Var)
		base.entry:SetUpdateOnType(true)

		base.entry.OnValueChange = function(self, val)
			val = tonumber(val)
			if val then
				val = math.floor(val)
				tab.Var = val
			end
		end

		base.PerformLayout = function(self)
			self:SetHeight(48)

			self.text:SetPos(10, 5)
			self.text:SetWide(self:GetWide())

			self.entry:SetSize(self:GetWide() - 40, 15)
			self.entry:SetPos(5, 28)
		end

		return base
	end,
		
	function( cpanel, tab, id ) -- Loop end
		local base = vgui.Create("DPanel", cpanel)
		base:SetBackgroundColor(ORANGE)
		cpanel:AddItem(base)

		base.text = vgui.Create("DLabel", base)
		base.text:SetDark(true)
		base.text:SetText("Step " .. id ..": Loop End")

		base.PerformLayout = function(self)
			self:SetHeight(28)

			self.text:SetPos(10, 5)
			self.text:SetWide(self:GetWide())
		end

		return base
	end
}

local RebuildMacroSteps

local function UIBuild(cpanel, tab, id)
	local panel = CreateStep[tab.Type](cpanel, tab, id)

	panel.buttonup = vgui.Create("DButton", panel)
	panel.buttonup:SetSize(20, 10)
	panel.buttonup:SetText("^")

	panel.buttonup.PerformLayout = function(butt)
		butt:SetPos(panel:GetWide() - 30, 5)
	end

	panel.buttonup.DoClick = function()
		if Working then return end

		local temp = MacroTable[id]

		MacroTable[id] = MacroTable[id - 1] 
		MacroTable[id - 1] = temp

		RebuildMacroSteps(cpanel)
	end

	panel.buttonup:SetVisible(false)



	panel.buttondown = vgui.Create("DButton", panel)
	panel.buttondown:SetSize(20, 10)
	panel.buttondown:SetText("v")

	panel.buttondown.PerformLayout = function(butt)
		butt:SetPos(panel:GetWide() - 30, panel:GetTall() - 15)
	end

	panel.buttondown.DoClick = function()
		if Working then return end

		local temp = MacroTable[id]

		MacroTable[id] = MacroTable[id + 1] 
		MacroTable[id + 1] = temp

		RebuildMacroSteps(cpanel)
	end

	panel.buttondown:SetVisible(false)



	panel.OnCursorEntered = function()
		if Working then return end

		if id - 1 > 0 then
			panel.buttonup:SetVisible(true)
		end

		if MacroTable[id + 1] then
			panel.buttondown:SetVisible(true)
		end
	end

	panel.buttonup.OnCursorEntered = panel.OnCursorEntered
	panel.buttondown.OnCursorEntered = panel.OnCursorEntered

	panel.OnCursorExited = function(panel)
		panel.buttonup:SetVisible(false)
		panel.buttondown:SetVisible(false)
	end

	return panel
end

RebuildMacroSteps = function(macropanel) -- Rebuilds steps without clearing the MacroTable
	if not IsValid(macropanel) then return end
	macropanel:Clear()
	macropanel.items = {}

	for id, tab in ipairs(MacroTable) do
		local panel = UIBuild(macropanel, tab, id)
		table.insert( macropanel.items, panel )
	end
end

local savepath = "cocomacro/"
local savefolder = "cocomacro"

do -- initialize the table


local var = ConFile:GetString()

if var == "default" then
	MacroTable = table.Copy(DefaultMacro)
else
	local dname = var .. ".txt"

	if not file.Exists(savepath .. dname, "DATA") then
		MacroTable = table.Copy(DefaultMacro)
	else
		local rdata = file.Read(savepath .. dname, "DATA")
		rdata = util.JSONToTable(rdata)

		MacroTable = rdata
	end
end


end

cvars.AddChangeCallback( "peak_concommac_file", function(name, old, new)
	if new == "default" then
		MacroTable = table.Copy(DefaultMacro)
	else
		local dname = new .. ".txt"

		if not file.Exists(savepath .. dname, "DATA") then
			return
		end

		local rdata = file.Read(savepath .. dname, "DATA")
		rdata = util.JSONToTable(rdata)

		MacroTable = rdata
	end

	if MacroPanel then
		RebuildMacroSteps(MacroPanel)
	end
end )

local function CreateSavePanel( cpanel )
	local base = vgui.Create( "DPanel" )
	base:SetTall(70)
	base:SetDrawBackground(false)
	cpanel:AddItem(base)

	base.box = vgui.Create("DComboBox", base)
	base.box:SetPos(0, 5)

	base.box:AddChoice("Default", "default")

	local files = file.Find(savepath .. "*.txt", "DATA")
	for k, file in ipairs(files) do
		file = string.sub(file, 1, -5)
		if string.lower(file) == "default" then continue end

		base.box:AddChoice(file, file)
	end

	base.box.OnSelect = function(self, id, val, data)
		if data == "default" then
			Owner:ConCommand("peak_concommac_file " .. data)
			return
		end

		local dname = data .. ".txt"

		if not file.Exists(savepath .. dname, "DATA") then
			self:RemoveChoice(id)
			notification.AddLegacy("ERROR: Macro does not exist!", NOTIFY_ERROR, 5)
			surface.PlaySound("buttons/button10.wav")
			return
		end

		Owner:ConCommand("peak_concommac_file " .. data)
	end

	base.butt = vgui.Create("DButton", base)
	base.butt:SetSize(20, 20)
	base.butt:SetText("Save")

	base.butt.DoClick = function(self)
		if not file.IsDir( savefolder, "DATA" ) then
			file.CreateDir( savefolder )
		end

		local json = util.TableToJSON( MacroTable )
		local num = 1
		while file.Exists( savepath .. "macro" .. num .. ".txt", "DATA" ) do
			num = num + 1
		end
		local name = "macro" .. num
		file.Write( savepath .. name .. ".txt", json )

		notification.AddLegacy("Macro saved!", NOTIFY_GENERIC, 5)
		surface.PlaySound("buttons/button14.wav")

		base.box:AddChoice(name, name)
	end

	base.supchat = vgui.Create("DCheckBoxLabel", base)
	base.supchat:SetDark(true)
	base.supchat:SetText("Suppress chat messages")
	base.supchat:SetConVar("peak_concommac_messageoff")
	base.supchat:SetPos(0, 30)

	base.supsnd = vgui.Create("DCheckBoxLabel", base)
	base.supsnd:SetDark(true)
	base.supsnd:SetText("Suppress sounds")
	base.supsnd:SetConVar("peak_concommac_soundoff")
	base.supsnd:SetPos(0, 50)

	base.PerformLayout = function()

		base.box:SetSize(base:GetWide() - 30, 20)

		base.butt:SetPos(base:GetWide() - 25, 5)

	end
end

local function MacroMenu( cpanel )
	local macrobase = vgui.Create("DPanelList", cpanel)
	macrobase:SetPaintBackgroundEnabled(false)
	macrobase:SetSpacing(6)
	cpanel:AddItem(macrobase)

	macrobase.items = {}

	for id, tab in ipairs(MacroTable) do
		local panel = UIBuild(macrobase, tab, id)
		table.insert( macrobase.items, panel )
	end

	macrobase.OldPerform = macrobase.PerformLayout

	macrobase.PerformLayout = function(self)
		self:OldPerform()
		self:SizeToChildren(false, true)
	end



	local buttonbase = vgui.Create("Panel", cpanel)
	cpanel:AddItem(buttonbase)

	buttonbase.addbutton = vgui.Create("DButton", buttonbase)
	buttonbase.addbutton:SetText("+")
	buttonbase.addbutton:SetSize(20, 20)

	buttonbase.addbutton.DoClick = function()
		local function ExpandMacro(typeid)
			if Working then return end

			local tab
			if typeid ~= 4 then
				tab = { Type = typeid, Var = "" }
			else
				tab = { Type = typeid }
			end

			table.insert( MacroTable, tab )
			table.insert( macrobase.items, UIBuild(macrobase, tab, #MacroTable) )
		end

		local dmenu = DermaMenu()
		dmenu:AddOption( "Add Wait", function() ExpandMacro(1) end )
		dmenu:AddOption( "Add Console Command", function() ExpandMacro(2) end )
		dmenu:AddOption( "Add Loop Start", function() ExpandMacro(3) end )
		dmenu:AddOption( "Add Loop End", function() ExpandMacro(4) end )
		dmenu:Open()
	end

	buttonbase.removebutton = vgui.Create("DButton", buttonbase)
	buttonbase.removebutton:SetText("-")
	buttonbase.removebutton:SetSize(20, 20)

	buttonbase.removebutton.DoClick = function()
		if Working then return end

		local id = #MacroTable
		if id < 1 then return end

		MacroTable[id] = nil

		macrobase.items[id]:Remove()
		macrobase.items[id] = nil
	end

	buttonbase.removebutton.DoRightClick = function()
		local dmenu = DermaMenu()
		dmenu:AddOption( "Delete every step", function()
			if Working then return end

			for id, panel in ipairs(macrobase.items) do
				panel:Remove()
			end

			macrobase.items = {}
			MacroTable = {}
		end )
		dmenu:Open()
	end

	buttonbase.PerformLayout = function(self)
		self:SetHeight(30)

		self.addbutton:SetPos(self:GetWide()/2 - 30, 10)

		self.removebutton:SetPos(self:GetWide()/2 + 10, 10)
	end

	return macrobase, buttonbase
end

local function MacroBuild( Panel )
	if not Owner or not IsValid(Owner) then Owner = LocalPlayer() end

	CreateSavePanel(Panel)

	local startbutton = vgui.Create( "DButton", Panel )
	startbutton:SetSize( 100, 20 )
	startbutton:SetText( "Start" )

	startbutton.DoClick = function()
		Owner:ConCommand( "peak_mac_start" )
	end
	Panel:AddItem(startbutton)

	MacroPanel = MacroMenu( Panel )
end

hook.Add("PopulateToolMenu", "peak_macroconcommand", function ()
	spawnmenu.AddToolMenuOption( "Utilities", "PEAK Incompetence", "peak_mcc", "Concommand Macro", "", "", MacroBuild )
end)
