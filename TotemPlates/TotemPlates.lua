local AddOn = "TotemPlates"

local numChildren = -1
local Table = {
   ["Nameplates"] = {},
   ["Totems"] = {
		["Disease Cleansing Totem"] = true,
		["Earth Elemental Totem"] = true,
		["Earthbind Totem"] = true,
		["Fire Elemental Totem"] = true,
		["Fire Nova Totem I"] = true,
		["Fire Nova Totem II"] = true,
		["Fire Nova Totem III"] = true,
		["Fire Nova Totem IV"] = true,
		["Fire Nova Totem V"] = true,
		["Fire Nova Totem VI"] = true,
		["Fire Nova Totem VII"] = true,
		["Fire Resistance Totem I"] = true,
		["Fire Resistance Totem II"] = true,
		["Fire Resistance Totem III"] = true,
		["Fire Resistance Totem IV"] = true,
		["Fire Resistance Totem  "] = true,
		["Flametongue Totem I"] = true,
		["Flametongue Totem II"] = true,
		["Flametongue Totem III"] = true,
		["Flametongue Totem IV"] = true,
		["Flametongue Totem V"] = true,
		["Frost Resistance Totem I"] = true,
		["Frost Resistance Totem II"] = true,
		["Frost Resistance Totem III"] = true,
		["Frost Resistance Totem IV"] = true,
		["Grace of Air Totem I"] = true,
		["Grace of Air Totem II"] = true,
		["Grace of Air Totem III"] = true,
		["Grounding Totem"] = true,
		["Healing Stream Totem"] = true,
		["Healing Stream Totem II"] = true,
		["Healing Stream Totem III"] = true,
		["Healing Stream Totem IV"] = true,
		["Healing Stream Totem V "] = true,
		["Healing Stream Totem VI"] = true,
		["Magma Totem"] = true,
		["Magma Totem II"] = true,
		["Magma Totem III"] = true,
		["Magma Totem IV"] = true,
		["Magma Totem V"] = true,
		["Mana Spring Totem"] = true,
		["Mana Spring Totem II"] = true,
		["Mana Spring Totem III"] = true,
		["Mana Spring Totem IV"] = true,
		["Mana Spring Totem V"] = true,
		["Mana Tide Totem"] = true,
		["Nature Resistance Totem"] = true,
		["Nature Resistance Totem II"] = true,
		["Nature Resistance Totem III"] = true,
		["Nature Resistance Totem IV"] = true,
		["Nature Resistance Totem V"] = true,
		["Nature Resistance Totem V"] = true,
		["Poison Cleansing Totem"] = true,
		["Searing Totem"] = true,
		["Searing Totem II"] = true,
		["Searing Totem III"] = true,
		["Searing Totem IV"] = true,
		["Searing Totem V"] = true,
		["Searing Totem VI"] = true,
		["Searing Totem VII"] = true,
		["Sentry Totem"] = true,
		["Stoneclaw Totem"] = true,
		["Stoneclaw Totem II"] = true,
		["Stoneclaw Totem III"] = true,
		["Stoneclaw Totem IV"] = true,
		["Stoneclaw Totem V"] = true,
		["Stoneclaw Totem VI"] = true,
		["Stoneclaw Totem VII"] = true,
		["Stoneskin Totem"] = true,
		["Stoneskin Totem II"] = true,
		["Stoneskin Totem III"] = true,
		["Stoneskin Totem IV"] = true,
		["Stoneskin Totem V"] = true,
		["Stoneskin Totem VI"] = true,
		["Stoneskin Totem VII"] = true,
		["Stoneskin Totem VIII"] = true,
		["Strength of Earth Totem"] = true,
		["Strength of Earth Totem II"] = true,
		["Strength of Earth Totem III"] = true,
		["Strength of Earth Totem IV"] = true,
		["Strength of Earth Totem V"] = true,
		["Strength of Earth Totem VI"] = true,
		["Totem of Wrath"] = true,
		["Totem of Wrath II"] = true,
		["Totem of Wrath III"] = true,
		["Totem of Wrath IV"] = true,
		["Tremor Totem"] = true,
		["Windfury Totem"] = true,
		["Windfury Totem II"] = true,
		["Windfury Totem III"] = true,
		["Windfury Totem IV"] = true,
		["Windfury Totem V"] = true,
		["Windwall Totem"] = true,
		["Windwall Totem II"] = true,
		["Windwall Totem III"] = true,
		["Windwall Totem IV"] = true,
		["Wrath of Air Totem"] = true,
	},
   xOfs = -10,
   yOfs = -40,
   Scale = 1,
}

local function UpdateObjects(hp)
   frame = hp:GetParent()
   local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()
   local name = oldname:GetText()

   overlay:SetAlpha(1)
   threat:Show()
   hpborder:Show()
   oldname:Show()
   level:Show()
   hp:SetAlpha(1)
   if frame.totem then frame.totem:Hide() end

   for totem in pairs(Table["Totems"]) do
      if ( name == totem and Table["Totems"][totem] == true ) then
         overlay:SetAlpha(0)
         threat:Hide()
         hpborder:Hide()
         oldname:Hide()
         level:Hide()
         hp:SetAlpha(0)
         if not frame.totem then
            frame.totem = frame:CreateTexture(nil, "BACKGROUND")
            frame.totem:ClearAllPoints()
            frame.totem:SetPoint("CENTER",frame,"CENTER",Table.xOfs,Table.yOfs)
         else
            frame.totem:Show()
         end   
         frame.totem:SetTexture("Interface\\AddOns\\" .. AddOn .. "\\Textures\\" .. totem)
         frame.totem:SetWidth(64 *Table.Scale)
         frame.totem:SetHeight(64 *Table.Scale)
         break
      elseif ( name == totem ) then
         overlay:SetAlpha(0)
         threat:Hide()
         hpborder:Hide()
         oldname:Hide()
         level:Hide()
         hp:SetAlpha(0)
         break
      end
   end
end

local function SkinObjects(frame)
   local HealthBar, CastBar = frame:GetChildren()
   local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()

   HealthBar:HookScript("OnShow", UpdateObjects)
   HealthBar:HookScript("OnSizeChanged", UpdateObjects)

   UpdateObjects(HealthBar)
   Table["Nameplates"][frame] = true
end

local select = select
local function HookFrames(...)
   for index = 1, select('#', ...) do
      local frame = select(index, ...)
      local region = frame:GetRegions()

      if ( not Table["Nameplates"][frame] and not frame:GetName() and region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" ) then
         SkinObjects(frame)                  
         frame.region = region
      end
   end
end

local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Frame:SetScript("OnUpdate", function(self, elapsed)
	if ( WorldFrame:GetNumChildren() ~= numChildren ) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())      
	end
end)
Frame:SetScript("OnEvent", function(self, event, name)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		if ( not _G[AddOn .. "_PlayerEnteredWorld"] ) then
			ChatFrame1:AddMessage("|cff00ccff" .. AddOn .. "|cffffffff Loaded")
			_G[AddOn .. "_PlayerEnteredWorld"] = true
		end   
	end
end)