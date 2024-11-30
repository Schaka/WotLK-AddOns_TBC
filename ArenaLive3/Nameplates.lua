local addonName, L = ...;

local frames = {}
local Nameplate = ArenaLive:ConstructHandler("Nameplate", true, true);
Nameplate:RegisterEvent("UNIT_AURA", "UNIT_AURA");
Nameplate:RegisterEvent("PLAYER_TARGET_CHANGED", "UNIT_AURA");

local relevantUnits = {
	"target",
    "targettarget",
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
    "mouseover",
    "mouseovertarget",
}


local numKids, lastupdate, i = 0, 0, 0
local WorldFrame = WorldFrame

local function setupNameplate(frame)
	local healthbar, nameframe = frame:GetChildren()
	if healthbar then
		local threat, hpborder, cbshield, cbborder, cbicon, overlay, name, level, bossicon, raidicon, elite = frame:GetRegions()
		local health, castbar = healthbar:GetChildren()

        if not frame.ccIndicator then
            local indicator = CreateFrame("Frame", nil, frame)
            indicator:SetPoint('TOP', frame, 0, 32)
            indicator:SetSize(48, 48)
            indicator.enabled = true

            local cooldown = CreateFrame("Cooldown", nil, indicator)
            cooldown:SetAllPoints(indicator)
            cooldown:SetFrameStrata("BACKGROUND")
            cooldown:Hide() -- cooldown frames on nameplates bug on update

            local text = indicator:CreateFontString(nil, "OVERLAY", "ArenaLiveFont_CooldownText")
            text:SetAllPoints(indicator)
            cooldown.text = text

            local icon = indicator:CreateTexture(nil, "OVERLAY")
            icon:SetSize(48, 48)
            icon:SetAllPoints(indicator)


            ArenaLive:ConstructHandlerObject (indicator, "CCIndicator", icon, cooldown, "ArenaLiveUnitFrames3")

            frame.CCIndicator = indicator
            frame.addon = "ArenaLiveUnitFrames3"
        end

	end

end

local function updateNameplate(frame)
    
    local healthbar, nameframe = frame:GetChildren()

	if healthbar then
		local threat, hpborder, cbshield, cbborder, cbicon, overlay, name, level, bossicon, raidicon, elite = frame:GetRegions()
		local health, castbar = healthbar:GetChildren()

        local namePlateName = name:GetText()
        local CCIndicator = ArenaLive:GetHandler("CCIndicator")

        for k, unit in pairs(relevantUnits) do
            if UnitName(unit) == name:GetText() then

                if not frame.CCIndicator then
                    setupNameplate(frame)
                end

                local indicator = frame.CCIndicator
                frame.unit = unit
    
                -- FIXME: updating every 0.1 is not very performant, but otherwise appear and re-appearing nameplates won't show correct info
                CCIndicator:UpdateCache("UNIT_AURA", unit)
                --CCIndicator:Update(frame);
                return
            end
        end
        
        if frame.CCIndicator then
            CCIndicator:Reset(frame)
        end
    
	end

end

Nameplate:SetScript("OnUpdate", function(self, elapsed)
	lastupdate = lastupdate + elapsed

	if lastupdate > 0.1 then

		for i=1, WorldFrame:GetNumChildren() do
            local frame = select(i, WorldFrame:GetChildren())
            local region = frame:GetRegions()
    
            if frame:IsShown() and not frame:GetName() and region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" then
                local healthbar, nameframe = frame:GetChildren()
    
                if healthbar then
                    updateNameplate(frame)                    
                end   
    
            end
        end

		lastupdate = 0
	end

end)

function Nameplate:UNIT_AURA(event, unit)

    if event == "PLAYER_TARGET_CHANGED" then
        event = "UNIT_AURA"
        unit = "target"
    end    

    for i=1, WorldFrame:GetNumChildren() do
		local frame = select(i, WorldFrame:GetChildren())
        local region = frame:GetRegions()

		if frame:IsShown() and not frame:GetName() and region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" then
            local healthbar, nameframe = frame:GetChildren()
            local threat, hpborder, cbshield, cbborder, cbicon, overlay, name, level, bossicon, raidicon, elite = frame:GetRegions()

            if healthbar then

                if UnitName(unit) == name:GetText() and frame.CCIndicator then
                    local indicator = frame.CCIndicator
                    frame.unit = unit

                    local CCIndicator = ArenaLive:GetHandler("CCIndicator")
                    CCIndicator:UpdateCache("UNIT_AURA", unit)
                    CCIndicator:Update(frame);
                end    
            end   

        end
	end
end