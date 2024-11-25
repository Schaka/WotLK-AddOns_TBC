local AddOn = "rais_ArenaCastBar"

local Table = {
	["Nameplates"] = {},
	["CastBar"] = {
		["Blizzard"] = {
			Width = 123,
			Height = 30.73,
		},
	},
	["CheckButtons"] = {
		["Test"] = {
			["PointX"] = 170,
			["PointY"] = -15,
		},
		["Blizz"] = {
			["PointX"] = 170,
			["PointY"] = -45,
		},
		["Arena 1-5"] = {
			["PointX"] = 300,
			["PointY"] = -15,
		},
		["Arena 1-5 Pet"] = {
			["PointX"] = 300,
			["PointY"] = -45,
		},
		["Player Pet"] = {
			["PointX"] = 300,
			["PointY"] = -75,
		},
		["Target"] = {
			["PointX"] = 300,
			["PointY"] = -105,
		},
		["Focus"] = {
			["PointX"] = 300,
			["PointY"] = -135,
		},
		["Icon"] = {
			["PointX"] = 300,
			["PointY"] = -165,
		},
		["Timer"] = {
			["PointX"] = 300,
			["PointY"] = -195,
		},
		["Spell"] = {
			["PointX"] = 300,
			["PointY"] = -225,
		},
	},
	["Sliders"] = {
		["PointX"] = {
			["PointX"] = -100,
			["PointY"] = -125,
			["MinValue"] = -200,
			["MaxValue"] = 200,
		},
		["PointY"] = {
			["PointX"] = 100,
			["PointY"] = -125,
			["MinValue"] = -50,
			["MaxValue"] = 50,
		},	
		["Width"] = {
			["PointX"] = 0,
			["PointY"] = -50,
			["MinValue"] = 30,
			["MaxValue"] = 180,
		},	
	},
	["DropDownMenus"] = {
		["Timer"] = {
			["PointX"] = 10,
			["PointY"] = 80,
			["Items"] = {
				"LEFT",
				"CENTER",
				"RIGHT",
			},
		},
		["Spell"] = {
			["PointX"] = 10,
			["PointY"] = 30,
			["Items"] = {
				"LEFT",
				"CENTER",
				"RIGHT",
			},
		},
		["PointX"] = {
			["PointX"] = 40,
			["PointY"] = -95,
			["Items"] = {
				"CastBar",
				"Timer",
				"Icon",
				"Spell",
			},
		},
		["PointY"] = {
			["PointX"] = 240,
			["PointY"] = -95,
			["Items"] = {
				"CastBar",
				"Timer",
				"Icon",
				"Spell",
			},
		},
		["CastTime"] = {
			["PointX"] = 10,
			["PointY"] = 130,
			["Items"] = {
				"LEFT",
				"TOTAL",
				"BOTH",
			},
		},
	},
	["EditBoxes"] = {
		["PointX"] = {
			["PointX"] = -100,
			["PointY"] = -150,
		},
		["PointY"] = {
			["PointX"] = 100,
			["PointY"] = -150,
		},
	},	
}
local Textures = {
	Font = "Interface\\AddOns\\" .. AddOn .. "\\Textures\\DorisPP.ttf",
	CastBar = "Interface\\AddOns\\" .. AddOn .. "\\Textures\\LiteStep.tga",
	BlizzCB = "Interface\\TargetingFrame\\UI-StatusBar",
	Interrupt = "Interface\\AddOns\\" .. AddOn .. "\\Textures\\Nameplate-Border.blp",
	NonInterrupt = "Interface\\Tooltips\\Nameplate-CastBar-Shield",
}
_G[AddOn .. "_SavedVariables"] = {
	["CastBar"] = {
		["Width"] = 97,
		["PointX"] = 15,
		["PointY"] = -5,
	},
	["Icon"] = {
		["PointX"] = -58,
		["PointY"] = 0,
	},	
	["Timer"] = {
		["Anchor"] = "RIGHT",
		["PointX"] = 52,
		["PointY"] = 0,
		["Format"] = "LEFT"
	},	
	["Spell"] = {
		["Anchor"] = "LEFT",
		["PointX"] = -53,
		["PointY"] = 0,
	},	
	["Enable"] = {
		["Test"] = false,
		["Blizz"] = true,
		["Arena 1-5"] = true,
		["Arena 1-5 Pet"] = true,
		["Player Pet"] = true,
		["Target"] = true,
		["Focus"] = true,
		["Icon"] = true,
		["Timer"] = true,
		["Spell"] = true,
	},
}

local numChildren = -1
local function HookFrames(...)
	for ID = 1,select('#', ...) do
		local frame = select(ID, ...)
		local region = frame:GetRegions()
		if ( not Table["Nameplates"][frame] and not frame:GetName() and region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" ) then
			Table["Nameplates"][frame] = true
			if ( not Table["CastBar"]["Blizzard"].Width ) then
				local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()
				Table["CastBar"]["Blizzard"].Width = cbborder:GetWidth()
			end
		end
	end
end
local function BlizzStyle_Toggle()
	local function Style_Update(unit)
		if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Blizz"] == true ) then
			_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:Hide();
			_G[AddOn .. "_Texture_" .. unit .. "CastBar_Background"]:Hide();
			_G[AddOn .. "_Texture_" .. unit .. "CastBar_IconBorder"]:Hide();
			_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:Hide();
			_G[AddOn .. "_Texture_" .. unit .. "CastBar_Border"]:Hide();

			_G[AddOn .. "_Texture_" .. unit .. "CastBar_BlizzBorder"]:Show();
			_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]:SetTexture(Textures.BlizzCB);
			_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]:SetHeight(8);
		else
			_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:Show();
			_G[AddOn .. "_Texture_" .. unit .. "CastBar_Background"]:Show();
			_G[AddOn .. "_Texture_" .. unit .. "CastBar_IconBorder"]:Show();
			_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:Show();
			_G[AddOn .. "_Texture_" .. unit .. "CastBar_Border"]:Show();

			_G[AddOn .. "_Texture_" .. unit .. "CastBar_BlizzBorder"]:Hide();
			_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]:SetTexture(Textures.CastBar);
			_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]:SetHeight(11);
		end
	end
	Style_Update("player")
	Style_Update("pet")
	for id = 1,5 do 
		Style_Update("arena" .. id)
		Style_Update("arena" .. id .. "pet")
	end
end

local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
local function Frame_RegisterEvents()
	Frame:RegisterEvent("UNIT_SPELLCAST_START")
	Frame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	Frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	Frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	Frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	Frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
	Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
Frame:SetScript("OnEvent",function(self,event,unitID,spell,...)
	local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = ...
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		local function InterfaceMenu_Create()
			local ArenaCastBar = CreateFrame("FRAME",nil)
			ArenaCastBar.name = "ArenaCastBar"
			InterfaceOptions_AddCategory(ArenaCastBar)
			
			local function ArenaCastBar_Create()
				local function FontStrings_Create()
					local function MenuTitle_Create(name)
						local FontString = ArenaCastBar:CreateFontString()
						FontString:SetFontObject(GameFontNormalLarge)
						FontString:SetPoint("TOPLEFT",ArenaCastBar,"TOPLEFT",10,-15)
						FontString:SetText(name)
					end
					MenuTitle_Create("ArenaCastBar")
				end
				local function CheckButtons_Create()
					local function Enable_Create(name)
						local Data = Table["CheckButtons"][name]
						local CheckButton = CreateFrame("CHECKBUTTON",nil,ArenaCastBar,"OptionsCheckButtonTemplate")
						CheckButton:SetPoint("TOPLEFT",ArenaCastBar,"TOPLEFT",Data["PointX"],Data["PointY"])
						CheckButton:SetHitRectInsets(0,-35,0,0)
						if ( _G[AddOn .. "_SavedVariables"]["Enable"][name] == true ) then
							CheckButton:SetChecked(true)
						end
						CheckButton:SetScript("OnClick", function() 
							if ( CheckButton:GetChecked() ) then 
								_G[AddOn .. "_SavedVariables"]["Enable"][name] = true
								if ( name == "Test" ) then
									_G[AddOn .. "_Frame_playerCastBar"]:Show()
								end
								if ( name == "Blizz" ) then
									BlizzStyle_Toggle()
								end
								if ( name == "Timer" ) then
									local function Timer_Show(unit)
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:Show()
									end
									Timer_Show("player")
									Timer_Show("pet")
									for id = 1,5 do 
										Timer_Show("arena" .. id)
										Timer_Show("arena" .. id .. "pet")
									end
								end
								if ( name == "Spell" ) then
									local function Spell_Show(unit)
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:Show()
									end
									Spell_Show("player")
									Spell_Show("pet")
									for id = 1,5 do 
										Spell_Show("arena" .. id)
										Spell_Show("arena" .. id .. "pet")
									end
								end
								if ( name == "Icon" ) then
									local function Icon_Show(unit)
										_G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]:Show()
										_G[AddOn .. "_Texture_" .. unit .. "CastBar_IconBorder"]:Show()
									end
									Icon_Show("player")
									Icon_Show("pet")
									for id = 1,5 do 
										Icon_Show("arena" .. id)
										Icon_Show("arena" .. id .. "pet")
									end
								end
							else
								_G[AddOn .. "_SavedVariables"]["Enable"][name] = false
								if ( name == "Test" ) then
									_G[AddOn .. "_Frame_playerCastBar"]:Hide()
								end
								if ( name == "Blizz" ) then
									BlizzStyle_Toggle()
								end
								if ( name == "Timer" ) then
									local function Timer_Hide(unit)
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:Hide()
									end
									Timer_Hide("player")
									Timer_Hide("pet")
									for id = 1,5 do 
										Timer_Hide("arena" .. id)
										Timer_Hide("arena" .. id .. "pet")
									end
								end
								if ( name == "Spell" ) then
									local function Spell_Hide(unit)
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:Hide()
									end
									Spell_Hide("player")
									Spell_Hide("pet")
									for id = 1,5 do 
										Spell_Hide("arena" .. id)
										Spell_Hide("arena" .. id .. "pet")
									end
								end
								if ( name == "Icon" ) then
									local function Icon_Hide(unit)
										_G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]:Hide()
										_G[AddOn .. "_Texture_" .. unit .. "CastBar_IconBorder"]:Hide()
									end
									Icon_Hide("player")
									Icon_Hide("pet")
									for id = 1,5 do 
										Icon_Hide("arena" .. id)
										Icon_Hide("arena" .. id .. "pet")
									end
								end
							end
						end)
						CheckButton:SetScript("OnEnter", function()
							GameTooltip:SetOwner(this,"ANCHOR_RIGHT")
							if ( name == "Test" ) then
								GameTooltip:SetText("Enable " .. name)
								GameTooltip:AddDoubleLine("|cffffffffShow player's casting under a random nameplate.")
							elseif ( name == "Blizz" ) then
								GameTooltip:SetText("Enable " .. name)
								GameTooltip:AddDoubleLine("|cffffffffToggle CastBars style.")
							else
								GameTooltip:SetText("Enable " .. name)
							end
							GameTooltip:Show() 
						end)
						local FontString = CheckButton:CreateFontString()
						FontString:SetFontObject(GameFontWhite)
						FontString:SetPoint("LEFT",CheckButton,"RIGHT")
						FontString:SetText(name)
					end
					Enable_Create("Test")
					Enable_Create("Blizz")
					Enable_Create("Arena 1-5")
					Enable_Create("Arena 1-5 Pet")
					Enable_Create("Player Pet")
					Enable_Create("Target")
					Enable_Create("Focus")
					Enable_Create("Icon")
					Enable_Create("Timer")
					Enable_Create("Spell")
					
				end
				local function Sliders_Create()
					local function Width_Create(name)
						local Slider = CreateFrame("SLIDER",AddOn .. "_Slider_" .. name,ArenaCastBar,"OptionsSliderTemplate")
						local Data = Table["Sliders"][name]
						Slider:SetPoint("CENTER",ArenaCastBar,"CENTER",Data["PointX"],Data["PointY"])
						Slider:SetOrientation("HORIZONTAL")
						Slider:SetMinMaxValues(Data["MinValue"],Data["MaxValue"])
						Slider:SetValueStep(1)
						_G[Slider:GetName().."Low"]:SetText(Data["MinValue"])
						_G[Slider:GetName().."High"]:SetText(Data["MaxValue"])
						_G[Slider:GetName().."Text"]:SetText(name)
						_G[Slider:GetName().."Text"]:SetFontObject(GameFontNormal)
						local SliderText = ArenaCastBar:CreateFontString()
						SliderText:SetFont("Fonts\\FRIZQT__.TTF",12)
						SliderText:SetPoint("CENTER",Slider,"CENTER",0,-15)
						Slider:SetScript("OnValueChanged",function()
							SliderText:SetText(Slider:GetValue())
							_G[AddOn .. "_SavedVariables"]["CastBar"]["Width"] = Slider:GetValue()
							if ( _G[AddOn .. "_PlayerEnteredWorld"] ) then
								for i = 1,5 do
									_G[AddOn .. "_Frame_arena" .. i .. "CastBar"]:SetWidth(Slider:GetValue())
									_G[AddOn .. "_Frame_arena" .. i .. "petCastBar"]:SetWidth(Slider:GetValue())
									_G[AddOn .. "_Texture_arena" .. i .. "CastBar_Border"]:SetWidth(Slider:GetValue() +5)
									_G[AddOn .. "_Texture_arena" .. i .. "petCastBar_Border"]:SetWidth(Slider:GetValue() +5)
								end
								_G[AddOn .. "_Frame_playerCastBar"]:SetWidth(Slider:GetValue())
								_G[AddOn .. "_Texture_playerCastBar_Border"]:SetWidth(Slider:GetValue() +5)

								_G[AddOn .. "_Frame_petCastBar"]:SetWidth(Slider:GetValue())
								_G[AddOn .. "_Texture_petCastBar_Border"]:SetWidth(Slider:GetValue() +5)
							end
						end)
						Slider:SetValue(_G[AddOn .. "_SavedVariables"]["CastBar"]["Width"])
					end
					local function Position_Create(name)
						local Slider = CreateFrame("SLIDER",AddOn .. "_Slider_" .. name,ArenaCastBar,"OptionsSliderTemplate")
						local Data = Table["Sliders"][name]
						Slider:SetPoint("CENTER",ArenaCastBar,"CENTER",Data["PointX"],Data["PointY"])
						Slider:SetOrientation("HORIZONTAL")
						Slider:SetMinMaxValues(Data["MinValue"],Data["MaxValue"])
						Slider:SetValueStep(1)
						_G[Slider:GetName().."Low"]:SetText(Data["MinValue"])
						_G[Slider:GetName().."High"]:SetText(Data["MaxValue"])
						_G[Slider:GetName().."Text"]:SetText(name)
						_G[Slider:GetName().."Text"]:SetFontObject(GameFontNormal)
						Slider:Disable()
						Slider:SetScript("OnValueChanged",function()
							_G[AddOn .. "_EditBox" .. name]:SetText(Slider:GetValue())
							local value = UIDropDownMenu_GetText(_G[AddOn .. "_DropDownMenu_" .. name]) 
							_G[AddOn .. "_SavedVariables"][value][name] = Slider:GetValue()
							if ( name == "PointX" ) then
								local function PointX_Change(unit)
									if ( value == "CastBar" ) then
										local anchor,relativeTo,anchorTo,pointX,pointY = _G[AddOn .. "_Frame_" .. unit .. "CastBar"]:GetPoint()
										_G[AddOn .. "_Frame_" .. unit .. "CastBar"]:ClearAllPoints()
										_G[AddOn .. "_Frame_" .. unit .. "CastBar"]:SetPoint(anchor,relativeTo,anchorTo,Slider:GetValue(),pointY)
									end
									if ( value == "Icon" ) then
										local anchor,relativeTo,anchorTo,pointX,pointY = _G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]:GetPoint()
										_G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]:ClearAllPoints()
										_G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]:SetPoint(anchor,relativeTo,anchorTo,Slider:GetValue(),pointY)
									end									
									if ( value == "Spell" ) then
										local anchor,relativeTo,anchorTo,pointX,pointY = _G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:GetPoint()
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:ClearAllPoints()
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:SetPoint(anchor,relativeTo,anchorTo,Slider:GetValue(),pointY)
									end									
									if ( value == "Timer" ) then
										local anchor,relativeTo,anchorTo,pointX,pointY = _G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:GetPoint()
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:ClearAllPoints()
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:SetPoint(anchor,relativeTo,anchorTo,Slider:GetValue(),pointY)
									end									
								end
								PointX_Change("player")
								PointX_Change("pet")
								for id = 1,5 do 
									PointX_Change("arena" .. id)
									PointX_Change("arena" .. id .. "pet")
								end
							end
							if ( name == "PointY" ) then
								local function PointY_Change(unit)
									if ( value == "CastBar" ) then
										local anchor,relativeTo,anchorTo,pointX,pointY = _G[AddOn .. "_Frame_" .. unit .. "CastBar"]:GetPoint()
										_G[AddOn .. "_Frame_" .. unit .. "CastBar"]:ClearAllPoints()
										_G[AddOn .. "_Frame_" .. unit .. "CastBar"]:SetPoint(anchor,relativeTo,anchorTo,pointX,Slider:GetValue())
									end
									if ( value == "Icon" ) then
										local anchor,relativeTo,anchorTo,pointX,pointY = _G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]:GetPoint()
										_G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]:ClearAllPoints()
										_G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]:SetPoint(anchor,relativeTo,anchorTo,pointX,Slider:GetValue())
									end									
									if ( value == "Spell" ) then
										local anchor,relativeTo,anchorTo,pointX,pointY = _G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:GetPoint()
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:ClearAllPoints()
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:SetPoint(anchor,relativeTo,anchorTo,pointX,Slider:GetValue())
									end									
									if ( value == "Timer" ) then
										local anchor,relativeTo,anchorTo,pointX,pointY = _G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:GetPoint()
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:ClearAllPoints()
										_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:SetPoint(anchor,relativeTo,anchorTo,pointX,Slider:GetValue())
									end									
								end
								PointY_Change("player")
								PointY_Change("pet")
								for id = 1,5 do 
									PointY_Change("arena" .. id)
									PointY_Change("arena" .. id .. "pet")
								end
							end							
						end)
					end
					Width_Create("Width")
					Position_Create("PointX")
					Position_Create("PointY")
				end				
				local function DropDownMenus_Create()
					local function Anchor_Create(name)
						local DropDownMenu = CreateFrame("FRAME",AddOn .. "_DropDownMenu_" .. name,ArenaCastBar,"UIDropDownMenuTemplate")
						local Data = Table["DropDownMenus"][name]
						DropDownMenu:SetPoint("LEFT",Data["PointX"],Data["PointY"])
						UIDropDownMenu_SetWidth(DropDownMenu,80)
						UIDropDownMenu_Initialize(DropDownMenu,function()
							for _,key in pairs(Data["Items"]) do
								info = {};
								info.text = key
								info.value = key
								info.func = DropDownMenu.SetValue
								UIDropDownMenu_AddButton(info)
							end
						end)
						function DropDownMenu:SetValue()
							_G[AddOn .. "_SavedVariables"][name]["Anchor"] = this.value
							local function Anchor_Change(unit)
								if ( name == "Timer" ) then
									local anchor,relativeTo,anchorTo,pointX,pointY = _G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:GetPoint()
									_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:ClearAllPoints()
									_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]:SetPoint(this.value,relativeTo,anchorTo,pointX,pointY)
								end
								if ( name == "Spell" ) then
									local anchor,relativeTo,anchorTo,pointX,pointY = _G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:GetPoint()
									_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:ClearAllPoints()
									_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:SetPoint(this.value,relativeTo,anchorTo,pointX,pointY)
								end
							end
							Anchor_Change("player")							
							Anchor_Change("pet")							
							for id = 1,5 do 
								Anchor_Change("arena" .. id)
								Anchor_Change("arena" .. id .. "pet")
							end
						UIDropDownMenu_SetSelectedValue(DropDownMenu,this.value)
						end
						UIDropDownMenu_SetSelectedValue(DropDownMenu,_G[AddOn .. "_SavedVariables"][name]["Anchor"])
						
						local FontString = ArenaCastBar:CreateFontString()
						FontString:SetFontObject(GameFontNormalSmall)
						FontString:SetPoint("BOTTOM",DropDownMenu,"TOP")
						FontString:SetText(name .. " Anchor")
					end
					local function Position_Create(name)
						local DropDownMenu = CreateFrame("FRAME",AddOn .. "_DropDownMenu_" .. name,ArenaCastBar,"UIDropDownMenuTemplate")
						local Data = Table["DropDownMenus"][name]
						DropDownMenu:SetPoint("LEFT",Data["PointX"],Data["PointY"])
						UIDropDownMenu_SetWidth(DropDownMenu,80)
						UIDropDownMenu_Initialize(DropDownMenu,function()
							for _,key in pairs(Data["Items"]) do
								info = {};
								info.text = key
								info.value = key
								info.func = DropDownMenu.SetValue
								UIDropDownMenu_AddButton(info)
							end
						end)
						function DropDownMenu:SetValue()
							UIDropDownMenu_SetSelectedValue(DropDownMenu,this.value)
							_G[AddOn .. "_Slider_" .. name]:Enable() 
							_G[AddOn .. "_EditBox" .. name]:EnableMouse(true)
							_G[AddOn .. "_Slider_" .. name]:SetValue(_G[AddOn .. "_SavedVariables"][this.value][name])
						end
					end
					local function CastTime_Create()
						local DropDownMenu = CreateFrame("FRAME",AddOn .. "_DropDownMenu_CastTime",ArenaCastBar,"UIDropDownMenuTemplate")
						local Data = Table["DropDownMenus"]["CastTime"]
						DropDownMenu:SetPoint("LEFT",Data["PointX"],Data["PointY"])
						UIDropDownMenu_SetWidth(DropDownMenu,80)
						UIDropDownMenu_Initialize(DropDownMenu,function()
							for _,key in pairs(Data["Items"]) do
								info = {};
								info.text = key
								info.value = key
								info.func = DropDownMenu.SetValue
								UIDropDownMenu_AddButton(info)
							end
						end)
						function DropDownMenu:SetValue()
							UIDropDownMenu_SetSelectedValue(DropDownMenu,this.value)
							_G[AddOn .. "_SavedVariables"]["Timer"]["Format"] = this.value
						end
						UIDropDownMenu_SetSelectedValue(DropDownMenu,_G[AddOn .. "_SavedVariables"]["Timer"]["Format"])
						
						local FontString = ArenaCastBar:CreateFontString()
						FontString:SetFontObject(GameFontNormalSmall)
						FontString:SetPoint("BOTTOM",DropDownMenu,"TOP")
						FontString:SetText("CastTime")
					end
					Anchor_Create("Timer")				 
					Anchor_Create("Spell")				 
					Position_Create("PointX")				 
					Position_Create("PointY")
					CastTime_Create()					
				end
				local function EditBoxes_Create()
					local function Position_Create(name)
						local EditBox = CreateFrame("EditBox",AddOn .. "_EditBox" .. name,ArenaCastBar,"InputBoxTemplate")
						local Data = Table["EditBoxes"][name]
						EditBox:SetPoint("CENTER",ArenaCastBar,"CENTER",Data["PointX"],Data["PointY"])
						EditBox:SetWidth(40)
						EditBox:SetHeight(15)
						EditBox:SetMaxLetters(3)
						EditBox:SetJustifyH("CENTER")
						EditBox:SetCursorPosition(0)
						EditBox:SetFontObject("GameFontHighlight")
						EditBox:SetAutoFocus(false)
						EditBox:EnableMouse(false)
						EditBox:SetScript("OnEnterPressed",function()
							if ( name == "PointX" ) then
								if ( EditBox:GetNumber() >= -200 and EditBox:GetNumber() <= 200 ) then
									local value = UIDropDownMenu_GetText(_G[AddOn .. "_DropDownMenu_" .. name]) 
									_G[AddOn .. "_SavedVariables"][value][name] = EditBox:GetNumber()
									_G[AddOn .. "_Slider_" .. name]:SetValue(_G[AddOn .. "_SavedVariables"][value][name])
								else
									EditBox:SetText("")
								end
							end
							if ( name == "PointY" ) then
								if ( EditBox:GetNumber() >= -50 and EditBox:GetNumber() <= 50 ) then
									local value = UIDropDownMenu_GetText(_G[AddOn .. "_DropDownMenu_" .. name]) 
									_G[AddOn .. "_SavedVariables"][value][name] = EditBox:GetNumber()
									_G[AddOn .. "_Slider_" .. name]:SetValue(_G[AddOn .. "_SavedVariables"][this.value][name])
								else
									EditBox:SetText("")
								end
							end
							EditBox:ClearFocus()
						end)
					end
					Position_Create("PointX")
					Position_Create("PointY")
				end
				FontStrings_Create()
				CheckButtons_Create()
				Sliders_Create()
				DropDownMenus_Create() 
				EditBoxes_Create()
				local function Author_Create()
					local Author = ArenaCastBar:CreateFontString()
					Author:SetFontObject(GameFontNormal)
					Author:SetPoint("BOTTOMLEFT",ArenaCastBar,"BOTTOMLEFT", 10, 10)
					Author:SetText("Author")
					local AuthorName = ArenaCastBar:CreateFontString()
					AuthorName:SetFontObject(GameFontWhite)
					AuthorName:SetPoint("BOTTOMLEFT",ArenaCastBar,"BOTTOMLEFT", 60, 10)
					AuthorName:SetText("raisnilt")
				end
				Author_Create()
			end
			ArenaCastBar_Create()
		end
		local function CastBars_Create()
			local function UnitCastBar_Create(unit)
				_G[AddOn .. "_Frame_" .. unit .. "CastBar"] = CreateFrame("Frame",nil);
				local CastBar = _G[AddOn .. "_Frame_" .. unit .. "CastBar"]
				CastBar:SetFrameStrata("BACKGROUND");
				CastBar:SetWidth(_G[AddOn .. "_SavedVariables"]["CastBar"]["Width"]);
				CastBar:SetHeight(11);
				CastBar:SetPoint("CENTER");
				if ( unit == "player" ) then
					if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Test"] == false ) then
						CastBar:Hide()
					end
				elseif ( unit == "pet" ) then
					if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Player Pet"] == false ) then
						CastBar:Hide()
					end
				elseif ( unit == "arena1" or unit == "arena2" or unit == "arena3" or unit == "arena4" or unit == "arena5" ) then
					if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Arena 1-5"] == false ) then
						CastBar:Hide()
					end
				elseif ( unit == "arena1pet" or unit == "arena2pet" or unit == "arena3pet" or unit == "arena4pet" or unit == "arena5pet" ) then
					if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Arena 1-5 Pet"] == false ) then
						CastBar:Hide()
					end
				end
				
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"] = CastBar:CreateTexture(nil,"ARTWORK");
				local Texture = _G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]
				Texture:SetHeight(11);
				Texture:SetTexture(Textures.CastBar);
				Texture:SetPoint("LEFT",CastBar,"LEFT");

				_G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"] = CastBar:CreateTexture(nil,"ARTWORK");
				local Icon = _G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]
				Icon:SetHeight(13);
				Icon:SetWidth(13);
				Icon:SetPoint("CENTER",AddOn .. "_Frame_" .. unit .. "CastBar","CENTER",
					_G[AddOn .. "_SavedVariables"]["Icon"]["PointX"],
					_G[AddOn .. "_SavedVariables"]["Icon"]["PointY"]);
				if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Icon"] ) then
					Icon:Show()
				else
					Icon:Hide()
				end
				
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_IconBorder"] = CastBar:CreateTexture(nil,"BACKGROUND");
				local IconBorder = _G[AddOn .. "_Texture_" .. unit .. "CastBar_IconBorder"]
				IconBorder:SetHeight(16);
				IconBorder:SetWidth(16);
				IconBorder:SetPoint("CENTER",Icon,"CENTER");
				if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Icon"] ) then
					IconBorder:Show()
				else
					IconBorder:Hide()
				end
								
				_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"] = CastBar:CreateFontString()
				local SpellName = _G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]
				SpellName:SetFont(Textures.Font,9,"OUTLINE")
				SpellName:SetPoint(_G[AddOn .. "_SavedVariables"]["Spell"]["Anchor"],
					AddOn .. "_Frame_" .. unit .. "CastBar","CENTER",
					_G[AddOn .. "_SavedVariables"]["Spell"]["PointX"],
					_G[AddOn .. "_SavedVariables"]["Spell"]["PointY"]);
				if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Spell"] ) then
					SpellName:Show()
				else
					SpellName:Hide()
				end
				
				_G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"] = CastBar:CreateFontString()
				local CastTime = _G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]
				CastTime:SetFont(Textures.Font,9,"OUTLINE")
				CastTime:SetPoint(_G[AddOn .. "_SavedVariables"]["Timer"]["Anchor"],
					AddOn .. "_Frame_" .. unit .. "CastBar","CENTER",
					_G[AddOn .. "_SavedVariables"]["Timer"]["PointX"],
					_G[AddOn .. "_SavedVariables"]["Timer"]["PointY"]);		
				if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Timer"] ) then
					CastTime:Show()
				else
					CastTime:Hide()
				end
				
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_Border"] = CastBar:CreateTexture(nil,"BACKGROUND");
				local Border =_G[AddOn .. "_Texture_" .. unit .. "CastBar_Border"]
				Border:SetPoint("CENTER",AddOn .. "_Frame_" .. unit .. "CastBar","CENTER");
				Border:SetWidth(_G[AddOn .. "_SavedVariables"]["CastBar"]["Width"] +5);
				Border:SetHeight(16);

				_G[AddOn .. "_Texture_" .. unit .. "CastBar_BlizzBorder"] = CastBar:CreateTexture(nil,"BORDER");
				local BlizzBorder =_G[AddOn .. "_Texture_" .. unit .. "CastBar_BlizzBorder"]
				BlizzBorder:SetPoint("CENTER",CastBar,"CENTER",-8,0);
				BlizzBorder:SetWidth(Table["CastBar"]["Blizzard"].Width);
				BlizzBorder:SetHeight(Table["CastBar"]["Blizzard"].Height);

				_G[AddOn .. "_Texture_" .. unit .. "CastBar_Background"] = CastBar:CreateTexture(nil,"BORDER");
				local Background =_G[AddOn .. "_Texture_" .. unit .. "CastBar_Background"]
				Background:SetTexture(1/10, 1/10, 1/10, 1);
				Background:SetAllPoints(AddOn .. "_Frame_" .. unit .. "CastBar");
			end
			UnitCastBar_Create("player")
			UnitCastBar_Create("pet")
			for id = 1,5 do 
				UnitCastBar_Create("arena" .. id)
				UnitCastBar_Create("arena" .. id .. "pet")
			end
		end
		if ( not _G[AddOn .. "_PlayerEnteredWorld"] ) then
			Frame_RegisterEvents()
			InterfaceMenu_Create()
			CastBars_Create()
			BlizzStyle_Toggle()
			ChatFrame1:AddMessage("|cff00ccff" .. AddOn .. "|cffffffff Loaded")
			_G[AddOn .. "_PlayerEnteredWorld"] = true
		end	
	end	
	local function Casting_Event(unit)
		if ( event == "UNIT_SPELLCAST_START" ) then
			if ( unitID == unit ) then 
				_G[AddOn .. "_" .. unit .. "_Fading"] = false
				local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit);
				_G[AddOn .. "_" .. unit .. "_Casting"] = true
				if ( string.len(name) > 12 ) then name = (string.sub(name,1,12) .. ".. ") end	
				_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:SetText(name)
				_G[AddOn .. "_Frame_" .. unit .. "CastBar"]:SetAlpha(1)
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]:SetTexture(texture)
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"].value = GetTime() - (startTime /1000);
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"].maxValue = (endTime - startTime) /1000;
				if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Blizz"] == true ) then
					_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]:SetVertexColor(1,0.7,0)
				else
					_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]:SetVertexColor(1,0.5,0)
				end
			end
		elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" ) then
			if ( unitID == unit ) then 
				_G[AddOn .. "_" .. unit .. "_Fading"] = false
				local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo(unit);	
				_G[AddOn .. "_" .. unit .. "_Channeling"] = true
				if ( string.len(name) > 12 ) then name = (string.sub(name,1,12) .. ".. ") end	
				_G[AddOn .. "_FontString_" .. unit .. "CastBar_SpellName"]:SetText(name)
				_G[AddOn .. "_Frame_" .. unit .. "CastBar"]:SetAlpha(1)
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_Icon"]:SetTexture(texture)
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"].value = (GetTime() - (startTime /1000));
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"].maxValue = (endTime -startTime) /1000;
				if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Blizz"] == true ) then
					_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]:SetVertexColor(1,0.7,0)
				else
					_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]:SetVertexColor(1,0.5,0)
				end
			end
		elseif ( event == "UNIT_SPELLCAST_DELAYED" ) then
			if ( unitID == unit ) then 
				local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(unit);
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"].value = (GetTime() - (startTime / 1000));
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"].maxValue = (endTime - startTime) / 1000;
			end
		elseif ( event == "UNIT_SPELLCAST_CHANNEL_UPDATE" ) then
			if ( unitID == unit ) then 
				local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(unit);
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"].value = (GetTime() - (startTime / 1000));
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"].maxValue = (endTime - startTime) / 1000;
			end
		elseif ( event == "UNIT_SPELLCAST_FAILED" ) then
			if ( _G[AddOn .. "_" .. unit .. "_Casting"] == true and unitID == unit ) then
				_G[AddOn .. "_" .. unit .. "_Casting"] = false
				_G[AddOn .. "_" .. unit .. "_Channeling"] = false
			end
		elseif ( event == "UNIT_SPELLCAST_SUCCEEDED" ) then
			if ( _G[AddOn .. "_" .. unit .. "_Casting"] and unitID == unit ) then
				_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]:SetVertexColor(0, 1, 0)
				_G[AddOn .. "_" .. unit .. "_Fading"] = true
				_G[AddOn .. "_" .. unit .. "_Casting"] = false
			end
		end
	end
	Casting_Event("player")
	Casting_Event("pet")
	for id = 1,5 do 
		Casting_Event("arena" .. id)
		Casting_Event("arena" .. id .. "pet")
	end
  	local function Spell_Interrupt()
		if ( event == "COMBAT_LOG_EVENT_UNFILTERED" ) then
			if ( eventType == "SPELL_INTERRUPT" ) then
				local function Units_Check(unit)
					if ( destGUID ==  UnitGUID(unit) ) then
						_G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]:SetVertexColor(1, 0, 0)
						_G[AddOn .. "_" .. unit .. "_Casting"] = false
						_G[AddOn .. "_" .. unit .. "_Channeling"] = false
						_G[AddOn .. "_" .. unit .. "_Fading"] = true
					end
				end
				Units_Check("player")
				Units_Check("pet")
				for id = 1,5 do
					Units_Check("arena" .. id)
					Units_Check("arena" .. id .. "pet")
				end	
			end	
		end	
	end	
	Spell_Interrupt()
end)
Frame:SetScript("OnUpdate", function(self, elapsed)
	local function WorldFrames_Check()
		if ( WorldFrame:GetNumChildren() ~= numChildren ) then
			numChildren = WorldFrame:GetNumChildren()
			HookFrames(WorldFrame:GetChildren())
		end
	end
	WorldFrames_Check()

	local function NamePlatesName_Check()
		local name1,name2,name3,name4,name5,petname1,petname2,petname3,petname4,petname5,petname,focusname,focushp,targetname,targethp
		local function FrameName_Check(frame)
			local hp = frame:GetChildren()
			local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()
			local name = oldname:GetText()
			if ( name == UnitName("focus") and hp:GetValue() == UnitHealth("focus") ) then
				focusname = name
				focushp = hp:GetValue()
			end
			if ( name == UnitName("target") and hp:GetValue() == UnitHealth("target") ) then
				targetname = name
				targethp = hp:GetValue()
			end
			if ( name == UnitName("pet") and hp:GetValue() == UnitHealth("pet") ) then
				petname = true
			end
			for id = 1,5 do
				if ( name == UnitName("arena" .. id) and hp:GetValue() == UnitHealth("arena" .. id) ) then
					_G["name" .. id] = true
				end
				if ( name == UnitName("arena" .. id .. "pet") and hp:GetValue() == UnitHealth("arena" .. id .. "pet") ) then
					_G["petname" .. id] = true
				end
			end
		end
		for frame in pairs(Table["Nameplates"]) do
			FrameName_Check(frame)
		end
		for id = 1,5 do
			if ( _G["name" .. id] and _G[AddOn .. "_SavedVariables"]["Enable"]["Arena 1-5"] == true ) then
				_G[AddOn .. "_Frame_arena" .. id .. "CastBar"]:Show()
			else
				_G[AddOn .. "_Frame_arena" .. id .. "CastBar"]:Hide()
			end
			_G["name" .. id] = false
			if ( _G["petname" .. id] and _G[AddOn .. "_SavedVariables"]["Enable"]["Arena 1-5 Pet"] == true ) then
				_G[AddOn .. "_Frame_arena" .. id .. "petCastBar"]:Show()
			else
				_G[AddOn .. "_Frame_arena" .. id .. "petCastBar"]:Hide()
			end
			_G["petname" .. id] = false
		end
		if ( petname and _G[AddOn .. "_SavedVariables"]["Enable"]["Player Pet"] == true ) then
			_G[AddOn .. "_Frame_petCastBar"]:Show()
		else
			_G[AddOn .. "_Frame_petCastBar"]:Hide()
		end
		petname = false
		if ( focusname ) then
			local unit
			if ( focusname == UnitName("pet") and focushp == UnitHealth("pet") ) then
				unit = "pet"
			end
			for id = 1,5 do
				if ( focusname == UnitName("arena" .. id) and focushp == UnitHealth("arena" .. id) ) then
					unit = "arena" .. id
				end
				if ( focusname == UnitName("arena" .. id .. "pet") and focushp == UnitHealth("arena" .. id .. "pet") ) then
					unit = "arena" .. id .. "pet"
				end
			end
			if ( unit ) then
				if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Focus"] == true ) then
					_G[AddOn .. "_Frame_" .. unit .. "CastBar"]:Show()
				else
					_G[AddOn .. "_Frame_" .. unit .. "CastBar"]:Hide()
				end
			end
		end
		focusname = false
		if ( targetname ) then
			local unit
			if ( targetname == UnitName("pet") and targethp == UnitHealth("pet") ) then
				unit = "pet"
			end
			for id = 1,5 do
				if ( targetname == UnitName("arena" .. id) and targethp == UnitHealth("arena" .. id) ) then
					unit = "arena" .. id
				end
				if ( targetname == UnitName("arena" .. id .. "pet") and targethp == UnitHealth("arena" .. id .. "pet") ) then
					unit = "arena" .. id .. "pet"
				end
			end
			if ( unit ) then
				if ( _G[AddOn .. "_SavedVariables"]["Enable"]["Target"] == true ) then
					_G[AddOn .. "_Frame_" .. unit .. "CastBar"]:Show()
				else
					_G[AddOn .. "_Frame_" .. unit .. "CastBar"]:Hide()
				end
			end
		end
		targetname = false
	end
	NamePlatesName_Check()

	local function Position_Update()
		local function NamePlate_Update(frame)
			local hp = frame:GetChildren()
			local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()
			local name = oldname:GetText()
			
			for id = 1,5 do
				if ( name == UnitName("arena" .. id) and hp:GetValue() == UnitHealth("arena" .. id) and frame:IsShown() ) then
					_G[AddOn .. "_Frame_arena" .. id .. "CastBar"]:SetPoint("TOP",hp,"BOTTOM",6,-4.5)
					_G[AddOn .. "_Frame_arena" .. id .. "CastBar"]:SetParent(frame)
				end
				if ( name == UnitName("arena" .. id .. "pet") and hp:GetValue() == UnitHealth("arena" .. id .. "pet") and frame:IsShown() ) then
					_G[AddOn .. "_Frame_arena" .. id .. "petCastBar"]:SetPoint("TOP",hp,"BOTTOM",6,-4.5)
					_G[AddOn .. "_Frame_arena" .. id .. "petCastBar"]:SetParent(frame)
				end
			end
			if ( not _G[AddOn .. "_Frame_playerCastBar"]:GetParent() ) then  
				_G[AddOn .. "_Frame_playerCastBar"]:SetPoint("TOP",hp,"BOTTOM",
					_G[AddOn .. "_SavedVariables"]["CastBar"]["PointX"],
					_G[AddOn .. "_SavedVariables"]["CastBar"]["PointY"]);
				_G[AddOn .. "_Frame_playerCastBar"]:SetParent(frame)
			elseif ( not _G[AddOn .. "_Frame_playerCastBar"]:GetParent():IsShown() and frame:IsShown() ) then  
				_G[AddOn .. "_Frame_playerCastBar"]:SetPoint("TOP",hp,"BOTTOM",
					_G[AddOn .. "_SavedVariables"]["CastBar"]["PointX"],
					_G[AddOn .. "_SavedVariables"]["CastBar"]["PointY"]);
				_G[AddOn .. "_Frame_playerCastBar"]:SetParent(frame)
			end
			if ( name == UnitName("pet") and hp:GetValue() == UnitHealth("pet") and frame:IsShown() ) then
				_G[AddOn .. "_Frame_petCastBar"]:SetPoint("TOP",hp,"BOTTOM",
					_G[AddOn .. "_SavedVariables"]["CastBar"]["PointX"],
					_G[AddOn .. "_SavedVariables"]["CastBar"]["PointY"]);
				_G[AddOn .. "_Frame_petCastBar"]:SetParent(frame)
			end
		end
		for frame in pairs(Table["Nameplates"]) do
			NamePlate_Update(frame)
		end
	end
	Position_Update()

	local function CastBars_Update()
		local function Casting_Update(unit)
			local Casting = _G[AddOn .. "_" .. unit .. "_Casting"]
			local Channeling = _G[AddOn .. "_" .. unit .. "_Channeling"]
			local CastBar = _G[AddOn .. "_Frame_" .. unit .. "CastBar"]
			local Texture = _G[AddOn .. "_Texture_" .. unit .. "CastBar_CastBar"]
			local Border = _G[AddOn .. "_Texture_" .. unit .. "CastBar_Border"]
			local BlizzBorder = _G[AddOn .. "_Texture_" .. unit .. "CastBar_BlizzBorder"]
			local IconBorder = _G[AddOn .. "_Texture_" .. unit .. "CastBar_IconBorder"]
			local Fading =  _G[AddOn .. "_" .. unit .. "_Fading"]
			local CastTime = _G[AddOn .. "_FontString_" .. unit .. "CastBar_CastTime"]
			local Width = _G[AddOn .. "_SavedVariables"]["CastBar"]["Width"]
			local Enabled

			
			if ( not Fading or not _G[AddOn .. "_" .. unit .. "CastBarAlpha"] ) then
				_G[AddOn .. "_" .. unit .. "CastBarAlpha"] = 0
			end
			if ( unit == "player" ) then
				Enabled = _G[AddOn .. "_SavedVariables"]["Enable"]["Test"]
			end
			if ( unit == "pet" ) then
				Enabled = _G[AddOn .. "_SavedVariables"]["Enable"]["Player Pet"]
			end
			for id = 1,5 do
				if ( unit == "arena" .. id ) then
					Enabled = _G[AddOn .. "_SavedVariables"]["Enable"]["Arena 1-5"]
				end			
				if ( unit == "arena" .. id .. "pet" ) then
					Enabled = _G[AddOn .. "_SavedVariables"]["Enable"]["Arena 1-5 Pet"]
				end			
			end
			if ( UnitHealth(unit) == UnitHealth("focus") and UnitName(unit) == UnitName("focus") ) then
				Enabled = _G[AddOn .. "_SavedVariables"]["Enable"]["Focus"]
			end

			if ( Channeling and not UnitChannelInfo(unit) ) then
				_G[AddOn .. "_" .. unit .. "_Fading"] = true
				_G[AddOn .. "_" .. unit .. "_Channeling"] = false
			elseif ( Casting and not Fading and UnitCastingInfo(unit) ) then
				local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit);	
				if ( endTime ) then
					local total = string.format("%.2f",(endTime-startTime)/1000)
					local left = string.format("%.1f",total - Texture.value/Texture.maxValue*total)
					if ( _G[AddOn .. "_SavedVariables"]["Timer"]["Format"] == "LEFT" ) then
						CastTime:SetText(left)
					elseif ( _G[AddOn .. "_SavedVariables"]["Timer"]["Format"] == "TOTAL" ) then
						CastTime:SetText(total)
					elseif ( _G[AddOn .. "_SavedVariables"]["Timer"]["Format"] == "BOTH" ) then
						CastTime:SetText(left .. " /" .. total)
					end	
				end	
				if ( not notInterruptible ) then
					Border:SetTexture(0,0,0,1)
					BlizzBorder:SetTexture(Textures.NonInterrupt)
					IconBorder:SetTexture(0,0,0,1)
				else
					Border:SetTexture(1,0,0,1)
					BlizzBorder:SetTexture(Textures.Interrupt)
					IconBorder:SetTexture(1,0,0,1)
				end
				Texture.value = Texture.value +elapsed
				if ( Texture.value >= Texture.maxValue ) then return end
				Texture:SetWidth(Width*Texture.value/Texture.maxValue)
			elseif ( Channeling and not Fading ) then
				local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo(unit);
				if ( endTime ) then
					local total = string.format("%.2f",(endTime-startTime)/1000)
					local left = string.format("%.1f",total - Texture.value/Texture.maxValue*total)
					if ( _G[AddOn .. "_SavedVariables"]["Timer"]["Format"] == "LEFT" ) then
						CastTime:SetText(left)
					elseif ( _G[AddOn .. "_SavedVariables"]["Timer"]["Format"] == "TOTAL" ) then
						CastTime:SetText(total)
					elseif ( _G[AddOn .. "_SavedVariables"]["Timer"]["Format"] == "BOTH" ) then
						CastTime:SetText(left .. " /" .. total)
					end	
				end	
				if ( not notInterruptible ) then
					Border:SetTexture(0,0,0,1)
					BlizzBorder:SetTexture(Textures.Interrupt)
					IconBorder:SetTexture(0,0,0,1)
				else
					Border:SetTexture(1,0,0,1)
					BlizzBorder:SetTexture(Textures.Interrupt)
					IconBorder:SetTexture(1,0,0,1)
				end
				Texture.value = Texture.value +elapsed
				if ( Texture.value >= Texture.maxValue ) then return end
				Texture:SetWidth(Width*(Texture.maxValue-Texture.value)/Texture.maxValue)
			elseif ( Fading ) then
				if ( Channeling or Casting or _G[AddOn .. "_" .. unit .. "CastBarAlpha"] >= 0.5 ) then
					_G[AddOn .. "_" .. unit .. "CastBarAlpha"] = 0
					_G[AddOn .. "_" .. unit .. "_Fading"] = false
					return
				end	
				_G[AddOn .. "_" .. unit .. "CastBarAlpha"] = _G[AddOn .. "_" .. unit .. "CastBarAlpha"] + elapsed
				CastBar:SetAlpha(1-(2*_G[AddOn .. "_" .. unit .. "CastBarAlpha"]))
			elseif ( CastBar ) then
				CastBar:SetAlpha(0)
			end
		end
		Casting_Update("player")
		Casting_Update("pet")
		for id = 1,5 do 
			Casting_Update("arena" .. id)
			Casting_Update("arena" .. id .. "pet")
		end
	end
	CastBars_Update() 
end)