local Nameplates = select(2, ...)
local ClassesPerName = {}

local frames = {}
local SML

local allNameplatesSameOpacity = true
local useClassIconsForTeam = true

local relevantUnits = {
	"mouseover",
	"target",
	"focus",
	"arena1",
	"arena2",
	"arena3",
	"arena4",
    "arena5",
	"party1",
	"party2",
	"party3",
	"party4",
	"party5",
	"raid1",
	"raid2",
	"raid3",
	"raid4",
	"raid5",
	"raid6",
    "raid7",
    "raid8",
    "raid9",
    "raid10",
    "raid11",
    "raid12",
    "raid13",
    "raid14",
    "raid15",
}

local function updateUnits()
	-- don't give a shit what triggered it, we update all relevant units quickly

	for k,unit in pairs(relevantUnits) do
		
		if ( UnitIsPlayer(unit) ) then

			local localizedClass, englishClass, classIndex = UnitClass(unit)
			local name = UnitName(unit)

			ClassesPerName[name] = {
				["englishClass"] = englishClass,
				["classIndex"] = classIndex,
				["isFriend"] = UnitIsFriend("player", unit)
			}

		end
	end
end

local function setupNameplates(frame)
	local healthbar = frame:GetChildren()

	if healthbar then
		local threat, hpborder, cbshield, cbborder, cbicon, overlay, name, level, bossicon, raidicon, elite = frame:GetRegions()
		local health, castbar = frame:GetChildren()

	end

    if useClassIconsForTeam then
        local icon = frame["ClassIcon"]
        if not icon then
            icon = frame:CreateTexture(nil, "OVERLAY")
            icon:SetPoint('TOP', 0, 32)
            icon:SetSize(64, 64)
            frame["ClassIcon"] = icon
        end
    end

end	

local function restoreNameplate(frame)
	local healthbar = frame:GetChildren()

	if healthbar then
		local threat, hpborder, cbshield, cbborder, cbicon, overlay, name, level, bossicon, raidicon, elite = frame:GetRegions()
		local health, castbar = frame:GetChildren()

		local icon = frame["ClassIcon"]
		if icon then
			health:Show()
			overlay:Show()
			level:Show()
			--bossicon:Show()
			hpborder:Show()
			name:Show()
			icon:Hide()
		end
	end
end	

local function updateNameplates(frame)
	local healthbar, nameframe = frame:GetChildren()
	local inInstance, instanceType = IsInInstance()

	--if InCombatLockdown() then return end

	if healthbar then
		local threat, hpborder, cbshield, cbborder, cbicon, overlay, name, level, bossicon, raidicon, elite = frame:GetRegions()
		local health, castbar = frame:GetChildren()

		local classInfo = ClassesPerName[name:GetText()]
		-- early return if we can't do anything to this nameplate
		if not classInfo then
			restoreNameplate(frame)
			return 
		end

		local class = classInfo["englishClass"]
		local isFriend = classInfo["isFriend"]

		if (instanceType == "pvp" or instanceType == "arena") and isFriend then
			
			local icon = frame["ClassIcon"]
            if not icon then
                return -- no icon created yet
            end

			local coords = CLASS_ICON_TCOORDS[class]
			if coords then
				icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
				icon:SetTexCoord(unpack(coords))
				icon:Show()
				
				health:Hide()
				overlay:Hide()
				level:Hide()
				--bossicon:Hide()
				hpborder:Hide()
				name:Hide()
			end
		else
			local icon = frame["ClassIcon"]
			if icon then 
				restoreNameplate(frame)
			end
			
			local classcolor = RAID_CLASS_COLORS[class]
			health:SetStatusBarColor(classcolor.r, classcolor.g, classcolor.b)

		end
	end	

end

local function updateNameplateAlpha(frame)
	-- dirty hack :(
	if (allNameplatesSameOpacity) then
	    frame:SetAlpha(1.0)
	end

	updateNameplates(frame)
end

-- REGIONS
-- 1 = Threat glow, is the mob attacking you, or almost not etc
-- 2 = Health bar/level border
-- 3 = Border for the casting bar
-- 4 = Spell icon for the casting bar
-- 5 = Glow around the health bar when hovering over
-- 6 = Name text
-- 7 = Level text
-- 8 = Skull icon if the mob/player is 10 or more levels higher then you
-- 9 = Raid icon when you're close enough to the mob/player to see the name plate
-- 10 = Elite icon
local function hookFrames(...)
	local self = Nameplates

	for i=1, select("#", ...) do
		local frame = select(i, ...)
		local region = frame:GetRegions()

		if frame:IsShown() and not frame:GetName() and region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" then
 			local healthbar, nameframe, castbar = frame:GetChildren()

			if healthbar then
				frames[frame] = true				
				
				-- dirty hack :(
				frame:HookScript("OnUpdate", updateNameplateAlpha)
				frame:HookScript("OnShow", setupNameplates)
					
			end
		end
	end
end

local numKids, lastupdate, i = 0, 0, 0
local WorldFrame, frame = WorldFrame, frame
local frame = CreateFrame("Frame")
frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
frame:RegisterEvent("UNIT_TARGET")
frame:RegisterEvent("ARENA_OPPONENT_UPDATE")
frame:RegisterEvent("RAID_ROSTER_UPDATE")
frame:RegisterEvent("PARTY_MEMBERS_CHANGED")

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

frame:SetScript("OnUpdate", function(self, elapsed)
	lastupdate = lastupdate + elapsed

	if lastupdate > 0.1 then

		local newNumKids = WorldFrame:GetNumChildren()

		if numKids ~= newNumKids then
			for i = numKids + 1, newNumKids do
				frame = select(i, WorldFrame:GetChildren())
				hookFrames(frame)
			end
			numKids = newNumKids
		end

		lastupdate = 0
	end

end)

frame:SetScript("OnEvent", function(self, event) 
	if event == "UPDATE_MOUSEOVER_UNIT" or event == "UNIT_TARGET" or event == "ARENA_OPPONENT_UPDATE" or event == "RAID_ROSTER_UPDATE" or event == "PARTY_MEMBERS_CHANGED" then
		updateUnits()
	end

	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
		-- only cache classes and friend status per zone
		for k, name in pairs(ClassesPerName) do
            name["IsFriend"] = false
        end
	end	
end)