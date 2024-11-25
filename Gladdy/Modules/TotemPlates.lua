local select, pairs, tremove, tinsert, format, strsplit, tonumber, ipairs = select, pairs, tremove, tinsert, format, strsplit, tonumber, ipairs
local UnitName = UnitName
local Gladdy = LibStub("Gladdy")
local L = Gladdy.L
local GetSpellInfo, CreateFrame = GetSpellInfo, CreateFrame
local totemData, totemNameTotemData = Gladdy:GetTotemData()

local NAMEPLATE_NUM
local NAMEPLATE_NUM_PREVIOUS
local TARGET_CURRENT

---------------------------------------------------

-- Option Helpers

---------------------------------------------------

local function GetTotemColorDefaultOptions()
	local defaultDB = {}
	local options = {}
	local indexedList = {}
	for k,v in pairs(totemData) do
		tinsert(indexedList, {name = k, id = v.id, color = v.color, texture = v.texture})
	end
	table.sort(indexedList, function (a, b)
		return a.name < b.name
	end)
	for i=1,#indexedList do
		defaultDB["totem" .. indexedList[i].id] = {color = indexedList[i].color, enabled = true, alpha = 0.6, customText = ""}
		options["npTotemsHideDisabledTotems"] = {
			order = 1,
			name = L["Hide Disabled Totem Plates"],
			desc = L["Hide Disabled Totem Plates"],
			type = "toggle",
			width = "full",
			get = function() return Gladdy.dbi.profile.npTotemsHideDisabledTotems end,
			set = function(_, value)
				Gladdy.dbi.profile.npTotemsHideDisabledTotems = value
				Gladdy:UpdateFrame()
			end
		}
		options["totem" .. indexedList[i].id] = {
			order = i+1,
			name = select(1, GetSpellInfo(indexedList[i].id)),
			--inline = true,
			width  = "3.0",
			type = "group",
			icon = indexedList[i].texture,
			args = {
				headerTotemConfig = {
					type = "header",
					name = format("|T%s:20|t %s", indexedList[i].texture, select(1, GetSpellInfo(indexedList[i].id))),
					order = 1,
				},
				enabled = {
					order = 2,
					name = L["Enabled"],
					desc = "Enable " .. format("|T%s:20|t %s", indexedList[i].texture, select(1, GetSpellInfo(indexedList[i].id))),
					type = "toggle",
					width = "full",
					get = function() return Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].enabled end,
					set = function(_, value)
						Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].enabled = value
						Gladdy:UpdateFrame()
					end
				},
				color = {
					type = "color",
					name = L["Border color"],
					desc = L["Color of the border"],
					order = 3,
					hasAlpha = true,
					width = "full",
					get = function()
						return Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].color.r,
						Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].color.g,
						Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].color.b,
						Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].color.a
					end,
					set = function(_, r, g, b, a)
						Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].color.r,
						Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].color.g,
						Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].color.b,
						Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].color.a = r, g, b, a
						Gladdy:UpdateFrame()
					end,
				},
				alpha = {
					type = "range",
					name = L["Alpha"],
					order = 4,
					min = 0,
					max = 1,
					step = 0.1,
					width = "full",
					get = function()
						return Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].alpha
					end,
					set = function(_, value)
						Gladdy.dbi.profile.npTotemColors["totem" .. indexedList[i].id].alpha = value
						Gladdy:UpdateFrame()
					end
				},
				customText = {
					type = "input",
					name = L["Custom totem name"],
					order = 5,
					width = "full",
					get = function() return Gladdy.db.npTotemColors["totem" .. indexedList[i].id].customText end,
					set = function(_, value) Gladdy.db.npTotemColors["totem" .. indexedList[i].id].customText = value Gladdy:UpdateFrame() end
				},
			}
		}
	end
	return defaultDB, options, indexedList
end

---------------------------------------------------

-- Core

---------------------------------------------------

local TotemPlates = Gladdy:NewModule("Totem Plates", 2, {
	npTotems = true,
	npTotemsShowFriendly = true,
	npTotemsShowEnemy = true,
	npTotemPlatesBorderStyle = "Interface\\AddOns\\Gladdy\\Images\\Border_rounded_blp",
	npTotemPlatesSize = 40,
	npTotemPlatesWidthFactor = 1,
	npTremorFont = "DorisPP",
	npTremorFontSize = 10,
	npTremorFontXOffset = 0,
	npTremorFontYOffset = 0,
	npTotemPlatesAlpha = 0.6,
	npTotemPlatesAlphaAlways = false,
	npTotemPlatesAlphaAlwaysTargeted = false,
	npTotemColors = select(1, GetTotemColorDefaultOptions()),
	npTotemsHideDisabledTotems = false,
})

function TotemPlates.OnEvent(self, event, ...)
	local Func = TotemPlates[event]
	if ( Func ) then
		Func(self, ...)
	end
end

function TotemPlates:Initialize()
	self:UpdateFrameOnce()
	self:SetFrameStrata("BACKGROUND") -- Prevent icons from overlapping other frames.
end

local function NameplateScanValid(Frame)
	if ( Frame and not
		(Frame:GetName() or
		Frame:GetID() ~= 0 or
		Frame:GetObjectType() ~= "Frame" or
		Frame:GetNumChildren() == 0 or
		Frame:GetNumRegions() == 0)
	 ) then
		return true
	end
end

local function NameplateChildren()
	return WorldFrame:GetChildren()
end

local function NameplateScan(...)
	for i = 1, NAMEPLATE_NUM do
		local Frame = select(i, ...)
		if ( Frame:IsShown() and NameplateScanValid(Frame) and not Frame.gladdyTotemFrame ) then
			TotemPlates:CreateTotemFrame(Frame)
		end
	end
end

local function NameplateHandler()
	NAMEPLATE_NUM = WorldFrame:GetNumChildren()
	if ( NAMEPLATE_NUM ~= NAMEPLATE_NUM_PREVIOUS ) then
		NAMEPLATE_NUM_PREVIOUS = NAMEPLATE_NUM

		NameplateScan(NameplateChildren())
	end
end

---------------------------------------------------

-- Events

---------------------------------------------------

local function PLAYER_TARGET_NAMEPLATE_CHANGED(...)
	for i = 1, NAMEPLATE_NUM do
		local nameplate = select(i, ...)

		if ( NameplateScanValid(nameplate) and nameplate.gladdyTotemFrameActive ) then
			if ( nameplate:IsShown() and TotemPlates:NameplateTypeValid(nameplate) ) then
				TotemPlates:SetTotemAlpha(nameplate, nameplate.nametext:GetText())
			end
		end
	end
end

function TotemPlates:PLAYER_TARGET_CHANGED()
	TARGET_CURRENT = UnitName("target")

	if ( TARGET_CURRENT and NAMEPLATE_NUM ) then
		PLAYER_TARGET_NAMEPLATE_CHANGED(NameplateChildren())
	end
end

function TotemPlates:NAME_PLATE_UNIT_ADDED(nameplate)
	if ( Gladdy.db.npTotems ) then
		if ( not nameplate ) then
			nameplate = self -- OnShow
		end

		local nameplateText = nameplate.nametext:GetText()
		local totemData = totemNameTotemData[nameplateText]

		if ( totemData ) then
			if ( TotemPlates:NameplateTypeValid(nameplate) ) then
				local Totem = Gladdy.db.npTotemColors["totem" .. totemData.id]

				if ( Totem.enabled ) then
					local totemFrame = nameplate.gladdyTotemFrame
					totemFrame.totemIcon:SetTexture(totemData.texture)
					totemFrame.totemBorder:SetVertexColor(Totem.color.r, Totem.color.g, Totem.color.b, Totem.color.a)
					totemFrame.totemName:SetText(Totem.customText or "")

					TotemPlates:ToggleTotem(nameplate, true)
					TotemPlates:ToggleAddon(nameplate)
					nameplate.gladdyTotemFrameActive = totemData

					TotemPlates:SetTotemAlpha(nameplate, nameplateText)
				else
					-- If certain totem is disabled, then hide it and the plate depending on setting.
					if ( nameplate.gladdyTotemFrameActive ) then
						TotemPlates:ToggleTotem(nameplate)
					end

					TotemPlates:ToggleAddon(nameplate, not Gladdy.db.npTotemsHideDisabledTotems)
				end
			end
		end
	end
end

function TotemPlates:NAME_PLATE_UNIT_REMOVED(nameplate)
	if ( not nameplate ) then
		nameplate = self -- OnHide
	end

	if ( nameplate.gladdyTotemFrame ) then
		if ( nameplate.gladdyTotemFrameActive ) then
			TotemPlates:ToggleTotem(nameplate)
			nameplate.gladdyTotemFrameActive = nil
		end

		TotemPlates:ToggleAddon(nameplate, true)
	end
end

---------------------------------------------------

-- Gladdy Call

---------------------------------------------------

local function UpdateFrameOnceSettings(...)
	for i = 1, NAMEPLATE_NUM do
		local nameplate = select(i, ...)

		if ( NameplateScanValid(nameplate) and nameplate.gladdyTotemFrameActive ) then
			if ( TotemPlates:NameplateTypeValid(nameplate) ) then
				if ( nameplate:IsShown() ) then
					TotemPlates:NAME_PLATE_UNIT_ADDED(nameplate)
					TotemPlates:SetTotemAlpha(nameplate, nameplate.nametext:GetText())
				end

				local totemFrame = nameplate.gladdyTotemFrame
				totemFrame:SetSize(Gladdy.db.npTotemPlatesSize * Gladdy.db.npTotemPlatesWidthFactor, Gladdy.db.npTotemPlatesSize)
				totemFrame.totemName:SetFont(Gladdy:SMFetch("font", "npTremorFont"), Gladdy.db.npTremorFontSize, "OUTLINE")
				totemFrame.totemName:SetPoint("TOP", totemFrame, "BOTTOM", Gladdy.db.npTremorFontXOffset, Gladdy.db.npTremorFontYOffset)
				totemFrame.totemBorder:SetTexture(Gladdy.db.npTotemPlatesBorderStyle)
			else
				TotemPlates:NAME_PLATE_UNIT_REMOVED(nameplate)
			end
		end
	end
end

function TotemPlates:UpdateFrameOnce()
	if ( Gladdy.db.npTotems and Gladdy.db.npTotemsShowEnemy ) then
		SetCVar("nameplateShowEnemyTotems", 1)
	end

	if ( Gladdy.db.npTotems and Gladdy.db.npTotemsShowFriendly ) then
		SetCVar("nameplateShowFriendlyTotems", 1)
	end

	if ( Gladdy.db.npTotems ) then
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:SetScript("OnUpdate", NameplateHandler)
		self:SetScript("OnEvent", TotemPlates.OnEvent)
	else
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:SetScript("OnUpdate", nil)
		self:SetScript("OnEvent", nil)
	end

	-- Update Settings
	if ( NAMEPLATE_NUM and Gladdy.db.npTotems ) then
		UpdateFrameOnceSettings(NameplateChildren())
	end
end

---------------------------------------------------

-- TotemPlates Frame

---------------------------------------------------

function TotemPlates:CreateTotemFrame(nameplate)
	local threatglow, castbar, castbarborder, castbarinterrupt, castbaricon -- Unused
	nameplate.healthbar, castbar = nameplate:GetChildren()
	threatglow, nameplate.healthborder, castborder, castinterrupt, casticon, nameplate.highlighttexture, nameplate.nametext, nameplate.leveltext, nameplate.bossicon, nameplate.raidicon, nameplate.mobicon = nameplate:GetRegions()

	local Frame = CreateFrame("Frame")
	Frame:SetPoint("BOTTOM", nameplate, "TOP", 0, -40)
	Frame:SetSize(Gladdy.db.npTotemPlatesSize * Gladdy.db.npTotemPlatesWidthFactor, Gladdy.db.npTotemPlatesSize)
	Frame:SetParent(TotemPlates) -- This prevents parental alpha, since we have custom alpha settings.
	Frame:Hide()
	nameplate.gladdyTotemFrame = Frame

	-- Icon
	local Icon = Frame:CreateTexture(nil, "BACKGROUND")
	Icon:SetPoint("TOPLEFT", Frame, "TOPLEFT")
	Icon:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT")
	Frame.totemIcon = Icon

	-- Border
	local Border = Frame:CreateTexture(nil, "BORDER")
	Border:SetPoint("TOPLEFT", Frame, "TOPLEFT")
	Border:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT")
	Border:SetTexture(Gladdy.db.npTotemPlatesBorderStyle)
	Frame.totemBorder = Border

	-- Name
	local Name = Frame:CreateFontString(nil, "OVERLAY")
	Name:SetFont(Gladdy:SMFetch("font", "npTremorFont"), Gladdy.db.npTremorFontSize, "OUTLINE")
	Name:SetPoint("TOP", Frame, "BOTTOM", Gladdy.db.npTremorFontXOffset, Gladdy.db.npTremorFontYOffset)
	Frame.totemName = Name

	-- Highlight
	local Highlight = Frame:CreateTexture(nil, "OVERLAY")
	Highlight:SetTexture("Interface/TargetingFrame/UI-TargetingFrame-BarFill")
	Highlight:SetPoint("TOPLEFT", Frame, "TOPLEFT", Gladdy.db.npTotemPlatesSize/16, -Gladdy.db.npTotemPlatesSize/16)
	Highlight:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", -Gladdy.db.npTotemPlatesSize/16, Gladdy.db.npTotemPlatesSize/16)
	Highlight:SetBlendMode("ADD")
	Highlight:SetAlpha(0)
	Frame.selectionHighlight = Highlight

	-- Hooks
	nameplate:HookScript("OnHide", TotemPlates.NAME_PLATE_UNIT_REMOVED)
	nameplate:HookScript("OnShow", TotemPlates.NAME_PLATE_UNIT_ADDED)

	self:NAME_PLATE_UNIT_ADDED(nameplate)
end

---------------------------------------------------

-- Nameplate functions

---------------------------------------------------

function TotemPlates:NameplateTypeValid(nameplate)
	if ( nameplate.healthbar ) then
		local nameplateR, nameplateG, nameplateB = nameplate.healthbar:GetStatusBarColor()
		local friendly = (nameplateR == 0 and nameplateG > 0.9)

		if ( (Gladdy.db.npTotemsShowFriendly and friendly) or (Gladdy.db.npTotemsShowEnemy and not friendly) ) then
			return true
		end
	end
end

function TotemPlates:GetAddonFrame(nameplate)
	-- TODO
end

function TotemPlates:ToggleTotem(nameplate, show)
	if ( show ) then
		nameplate.gladdyTotemFrame:Show()

		if ( not nameplate.gladdyTotemFrameActive ) then
			nameplate:SetScript("OnUpdate", TotemPlates.OnUpdate)
		end
	else
		nameplate.gladdyTotemFrame:Hide()

		if ( nameplate.gladdyTotemFrameActive ) then
			nameplate:SetScript("OnUpdate", nil)
		end
	end
end

function TotemPlates:ToggleAddon(nameplate, show)
	-- TODO: Make this work with other addons.
	if ( show ) then
		nameplate.healthbar:Show()
		nameplate.healthborder:Show()
		nameplate.highlighttexture:SetAlpha(1)
		nameplate.raidicon:SetAlpha(1)
		nameplate.nametext:Show()
		nameplate.leveltext:Show()
	else
		nameplate.healthbar:Hide()
		nameplate.healthborder:Hide()
		nameplate.highlighttexture:SetAlpha(0)
		nameplate.mobicon:Hide()
		nameplate.bossicon:Hide()
		nameplate.raidicon:SetAlpha(0)
		nameplate.nametext:Hide()
		nameplate.leveltext:Hide()
	end
end

function TotemPlates.OnUpdate(self, elapsed)
	local nameplateName = self.nametext:GetText()

	if ( self.gladdyTotemFrameActive and (nameplateName == TARGET_CURRENT or UnitName("mouseover") == nameplateName or not TARGET_CURRENT) ) then
		self.gladdyTotemFrame.selectionHighlight:SetAlpha(.25)
	else
		self.gladdyTotemFrame.selectionHighlight:SetAlpha(0)
	end
end

function TotemPlates:SetTotemAlpha(nameplate, nameplateText)
	if ( TARGET_CURRENT ) then
		if ( TARGET_CURRENT == nameplateText ) then -- is target
			if ( Gladdy.db.npTotemPlatesAlphaAlwaysTargeted ) then
				nameplate.gladdyTotemFrame:SetAlpha(Gladdy.db.npTotemColors["totem" .. nameplate.gladdyTotemFrameActive.id].alpha)
			else
				nameplate.gladdyTotemFrame:SetAlpha(1)
			end
		else -- is not target
			nameplate.gladdyTotemFrame:SetAlpha(Gladdy.db.npTotemColors["totem" .. nameplate.gladdyTotemFrameActive.id].alpha)
		end
	else -- no target
		if ( Gladdy.db.npTotemPlatesAlphaAlways ) then
			nameplate.gladdyTotemFrame:SetAlpha(Gladdy.db.npTotemColors["totem" .. nameplate.gladdyTotemFrameActive.id].alpha)
		else
			nameplate.gladdyTotemFrame:SetAlpha(0.95)
		end
	end
end

---------------------------------------------------

-- Interface options

---------------------------------------------------

function TotemPlates:GetOptions()
	return {
		headerTotems = {
			type = "header",
			name = L["Totem Plates"],
			order = 2,
		},
		npTotems = Gladdy:option({
			type = "toggle",
			name = L["Enabled"],
			desc = L["Turns totem icons instead of nameplates on or off."],
			order = 3,
			width = 0.9,
		}),
		npTotemsShowFriendly = Gladdy:option({
			type = "toggle",
			name = L["Show friendly"],
			desc = L["Turns totem icons instead of nameplates on or off."],
			disabled = function() return not Gladdy.db.npTotems end,
			order = 4,
			width = 0.65,
		}),
		npTotemsShowEnemy = Gladdy:option({
			type = "toggle",
			name = L["Show enemy"],
			desc = L["Turns totem icons instead of nameplates on or off."],
			disabled = function() return not Gladdy.db.npTotems end,
			order = 5,
			width = 0.6,
		}),
		group = {
			type = "group",
			childGroups = "tree",
			name = L["Frame"],
			disabled = function() return not Gladdy.db.npTotems end,
			order = 4,
			args = {
				icon = {
					type = "group",
					name = L["Icon"],
					order = 1,
					args = {
						header = {
							type = "header",
							name = L["Icon"],
							order = 1,
						},
						npTotemPlatesSize = Gladdy:option({
							type = "range",
							name = L["Totem size"],
							desc = L["Size of totem icons"],
							order = 5,
							min = 20,
							max = 100,
							step = 1,
							width = "full",
						}),
						npTotemPlatesWidthFactor = Gladdy:option({
							type = "range",
							name = L["Icon Width Factor"],
							desc = L["Stretches the icon"],
							order = 6,
							min = 0.5,
							max = 2,
							step = 0.05,
							width = "full",
						}),
					},
				},
				font = {
					type = "group",
					name = L["Font"],
					order = 2,
					args = {
						header = {
							type = "header",
							name = L["Font"],
							order = 1,
						},
						npTremorFont = Gladdy:option({
							type = "select",
							name = L["Font"],
							desc = L["Font of the custom totem name"],
							order = 11,
							dialogControl = "LSM30_Font",
							values = AceGUIWidgetLSMlists.font,
						}),
						npTremorFontSize = Gladdy:option({
							type = "range",
							name = L["Size"],
							desc = L["Scale of the font"],
							order = 12,
							min = 1,
							max = 50,
							step = 0.1,
							width = "full",
						}),
						npTremorFontXOffset = Gladdy:option({
							type = "range",
							name = L["Horizontal offset"],
							desc = L["Scale of the font"],
							order = 13,
							min = -300,
							max = 300,
							step = 1,
							width = "full",
						}),
						npTremorFontYOffset = Gladdy:option({
							type = "range",
							name = L["Vertical offset"],
							desc = L["Scale of the font"],
							order = 14,
							min = -300,
							max = 300,
							step = 1,
							width = "full",
						}),
					},
				},
				alpha = {
					type = "group",
					name = L["Alpha"],
					order = 4,
					args = {
						header = {
							type = "header",
							name = L["Alpha"],
							order = 1,
						},
						npTotemPlatesAlphaAlways = Gladdy:option({
							type = "toggle",
							name = L["Apply alpha when no target"],
							desc = L["Always applies alpha, even when you don't have a target. Else it is 1."],
							width = "full",
							order = 21,
						}),
						npTotemPlatesAlphaAlwaysTargeted = Gladdy:option({
							type = "toggle",
							name = L["Apply alpha when targeted"],
							desc = L["Always applies alpha, even when you target the totem. Else it is 1."],
							width = "full",
							order = 22,
						}),
						npAllTotemAlphas = {
							type = "range",
							name = L["All totem border alphas (configurable per totem)"],
							min = 0,
							max = 1,
							step = 0.1,
							width = "full",
							order = 23,
							get = function()
								local alpha, i = nil, 1
								for _,v in pairs(Gladdy.dbi.profile.npTotemColors) do
									if i == 1 then
										alpha = v.alpha
										i = i + 1
									else
										if v.alpha ~= alpha then
											return ""
										end
									end
								end
								return alpha
							end,
							set = function(_, value)
								for _,v in pairs(Gladdy.dbi.profile.npTotemColors) do
									v.alpha = value
								end
								Gladdy:UpdateFrame()
							end,
						},
					},
				},
				border = {
					type = "group",
					name = L["Border"],
					order = 5,
					args = {
						header = {
							type = "header",
							name = L["Border"],
							order = 1,
						},
						npTotemPlatesBorderStyle = Gladdy:option({
							type = "select",
							name = L["Totem icon border style"],
							order = 41,
							values = Gladdy:GetIconStyles()
						}),
						npAllTotemColors = {
							type = "color",
							name = L["All totem border color"],
							order = 42,
							hasAlpha = true,
							get = function()
								local color
								local i = 1
								for _,v in pairs(Gladdy.dbi.profile.npTotemColors) do
									if i == 1 then
										color = v.color
										i = i + 1
									else
										if v.color.r ~= color.r or v.color.g ~= color.g or v.color.b ~= color.b or v.color.a ~= color.a then
											return 0, 0, 0, 0
										end
									end
								end
								return color.r, color.g, color.b, color.a
							end,
							set = function(_, r, g, b, a)
								for _,v in pairs(Gladdy.dbi.profile.npTotemColors) do
									v.color.r = r
									v.color.g = g
									v.color.b = b
									v.color.a = a
								end
								Gladdy:UpdateFrame()
							end,
						},
					},
				},
			},
		},
		npTotemColors = {
			order = 50,
			name = L["Customize Totems"],
			type = "group",
			childGroups = "tree",
			disabled = function() return not Gladdy.db.npTotems end,
			args = select(2, GetTotemColorDefaultOptions())
		},
	}
end