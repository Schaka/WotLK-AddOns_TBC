local ADDON_NAME = "Icicle"
local VERSION = "v1.3.3-Beta"
Icicle = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local self, Icicle = Icicle, Icicle
local Icicledb
local testMode

local print = function(s)
    local str = s
    if s == nil then str = "nil" end
    if type(str) == "boolean" then
        if str then
            str = "true"
        else
            str = "false"
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cffFF7D0A[".. ADDON_NAME .."]|r: " .. str)
end

local Icicle_Font = {
    ["Interface\\AddOns\\Icicle\\FreeUniversal-Regular.ttf"] = "FreeUniversal-Regular",
    ["Interface\\AddOns\\Icicle\\Hooge0655.ttf"] = "Hooge0655",
}

local Icicle_Order = {
    ["none"] = "None",
    ["ascending"] = "Ascending",
    ["descending"] = "Descending",
}

---------------------------------------------------------------------------------------------

-- ICICLE

---------------------------------------------------------------------------------------------

function Icicle:OnInitialize()
    self.db2 = LibStub("AceDB-3.0"):New("Icicledb", dbDefaults, "Default");
    print(VERSION .." XiCoN-Edit for WoW 2.4.3 updated by |cff0070DEXiconQoo|r")
    print("available commands:\n/Icicle (opens UI)\n/Icicletest (displays test icons on all shown nameplates)\n/Iciclereset (resets all cooldowns)")
    --LibStub("AceConfig-3.0"):RegisterOptionsTable("Icicle", Icicle.Options, {"Icicle", "SS"})
    self:RegisterChatCommand("Icicle", "ShowConfig")
    self:RegisterChatCommand("Icicletest", "InitTest")
    self:RegisterChatCommand("Iciclereset", "Reset")
    self.db2.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
    self.db2.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
    self.db2.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
    Icicledb = self.db2.profile
    Icicle.options = {
        name = "Icicle",
        desc = "Icons above enemy nameplates showing cooldowns",
        type = 'group',
        icon = [[Interface\Icons\Spell_Nature_ForceOfNature]],
        args = {},
    }
    local bliz_options = CopyTable(Icicle.options)
    bliz_options.args.load = {
        name = "Load configuration",
        desc = "Load configuration options",
        type = 'execute',
        func = "ShowConfig",
        handler = Icicle,
    }
    self.Aloft = IsAddOnLoaded("Aloft")
    self.SoHighPlates = IsAddOnLoaded("SoHighPlates")
    self.ElvUI = IsAddOnLoaded("ElvUI")
    self.ShaguPlates = IsAddOnLoaded("ShaguPlates-tbc") or IsAddOnLoaded("ShaguPlates")

    LibStub("AceConfig-3.0"):RegisterOptionsTable("Icicle_bliz", bliz_options)
    AceConfigDialog:AddToBlizOptions("Icicle_bliz", "Icicle")
end
function Icicle:OnDisable()
end
local function initOptions()
    if Icicle.options.args.general then
        return
    end

    Icicle:OnOptionsCreate()

    for k, v in Icicle:IterateModules() do
        if type(v.OnOptionsCreate) == "function" then
            v:OnOptionsCreate()
        end
    end
    AceConfig:RegisterOptionsTable("Icicle", Icicle.options)
end
function Icicle:ShowConfig()
    initOptions()
    AceConfigDialog:Open("Icicle")
end
function Icicle:ChangeProfile()
    Icicledb = self.db2.profile
    for k, v in Icicle:IterateModules() do
        if type(v.ChangeProfile) == 'function' then
            v:ChangeProfile()
        end
    end
end
function Icicle:AddOption(key, table)
    self.options.args[key] = table
end
local function setOption(info, value)
    local name = info[#info]
    Icicledb[name] = value
end
local function getOption(info)
    local name = info[#info]
    return Icicledb[name]
end
GameTooltip:HookScript("OnTooltipSetUnit", function(tip)
    local name, server = tip:GetUnit()
    local Realm = GetRealmName()
    if (Icicle_sponsors[name]) then
        if (Icicle_sponsors[name]["Realm"] == Realm) then
            tip:AddLine(Icicle_sponsors[Icicle_sponsors[name].Type], 1, 0, 0)
        end ;
    end
end)
function Icicle:OnOptionsCreate()
    self:AddOption("profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db2))
    self.options.args.profiles.order = -1
    self:AddOption('General', {
        type = 'group',
        name = "General",
        desc = "General Options",
        order = 1,
        args = {
            enableArea = {
                type = 'group',
                inline = true,
                name = "General options",
                set = setOption,
                get = getOption,
                args = {
                    all = {
                        type = 'toggle',
                        name = "Enable Everything",
                        desc = "Enables Icicle for BGs, world and arena",
                        order = 1,
                    },
                    arena = {
                        type = 'toggle',
                        name = "Arena",
                        desc = "Enabled in the arena",
                        disabled = function()
                            return Icicledb.all
                        end,
                        order = 2,
                    },
                    battleground = {
                        type = 'toggle',
                        name = "Battleground",
                        desc = "Enable Battleground",
                        disabled = function()
                            return Icicledb.all
                        end,
                        order = 3,
                    },
                    field = {
                        type = 'toggle',
                        name = "World",
                        desc = "Enabled outside Battlegrounds and arenas",
                        disabled = function()
                            return Icicledb.all
                        end,
                        order = 4,
                    },
                    iconsizer = {
                        type = "range",
                        min = 10,
                        max = 50,
                        step = 1,
                        name = "Icon Size",
                        desc = "Size of the Icons",
                        order = 5,
                        width = full,
                    },
                    YOffsetter = {
                        type = "range",
                        min = -80,
                        max = 80,
                        step = 1,
                        name = "Y Offsets",
                        desc = "Verticle Range from the Namplate and Icon",
                        order = 6,
                    },
                    XOffsetter = {
                        type = "range",
                        min = -80,
                        max = 80,
                        step = 1,
                        name = "X Offsets",
                        desc = "Horizontal Range from the Namplate and Icon",
                        order = 7,
                    },
                    order = {
                        type = 'select',
                        name = 'Icon sort order',
                        desc = 'None(who comes first), Ascending or Descending by time left',
                        values = Icicle_Order,
                        order = 8,
                    },
                    fontSize = {
                        type = 'range',
                        name = "font size",
                        desc = "size of the cooldown text in pixels inside the cooldown icon",
                        order = 8,
                        min = 6,
                        max = 30,
                        step = 1,
                        get = function()
                            return Icicledb.fontSize
                        end,
                        set = function(info, value)
                            Icicledb.fontSize = value
                        end
                    },
                    textfont = {
                        type = 'select',
                        name = "Cooldown number font",
                        desc = "Text font of cooldown number",
                        values = Icicle_Font,
                        order = 8,
                    },
                },
            }
        }
    })
end
local IcicleReset = {
    [11958] = { "Deep Freeze", "Ice Block", "Icy Veins" },
    [14185] = { "Sprint", "Vanish", "Shadowstep", "Evasion" }, --with prep glyph "Kick", "Dismantle", "Smoke Bomb"
    [23989] = { "Deterrence", "Silencing Shot", "Scatter Shot", "Rapid Fire", "Kill Shot" },
}

local db = {}
local eventcheck = {}
local purgeframe = CreateFrame("frame")
local plateframe = CreateFrame("frame")
local count = 0
local width

local IcicleInterrupts = { 47528, 34490, 2139, 15487--[[Silence]], 1766, 5799--[[Wind Shear]], 72, 19647, 47476 } --pummel

local getname = function(namePlate)
    local name
    if Icicle.Aloft then
        if namePlate.aloftData then
            name = namePlate.aloftData.name
        end
    elseif Icicle.SoHighPlates then
        if namePlate.oldname or namePlate.name then
            name = (namePlate.oldname and namePlate.oldname:GetText()) or (namePlate.name and namePlate.name:GetText())
        end
    else
        if Icicle.ElvUI then
            if namePlate.UnitFrame then
                name = namePlate.UnitFrame.oldName:GetText()
            end
        end
        if not name then
			--local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = namePlate:GetRegions()
            local _, _, _, _, _, _, nameRegion1, nameRegion2 = namePlate:GetRegions()
            if strmatch(nameRegion1:GetText(), "%d") then
                name = nameRegion2:GetText()
            else
                name = nameRegion1:GetText()
            end
        end
    end
    return name
end

local addicons = function(name, f, spellID)
    --name returns ___, f returns table value
    local num = #db[name] --number = db number
    local size
    if not width then
        width = f:GetWidth()
    end
    if num * Icicledb.iconsizer + (num * 2 - 2) > width then
        size = (width - (num * 2 - 2)) / num
    else
        size = Icicledb.iconsizer
    end
    if Icicledb.order == "ascending" then
        table.sort(db[name], function(a,b) return a.endtime < b.endtime end)
    elseif Icicledb.order == "descending" then
        table.sort(db[name], function(a,b) return a.endtime > b.endtime end)
    end

    for i = 1, #db[name] do
        db[name][i]:ClearAllPoints()
        db[name][i]:SetWidth(size)
        db[name][i]:SetHeight(size)
        db[name][i].cooldown:SetFont(Icicledb.textfont, Icicledb.fontSize, "OUTLINE") --
        if i == 1 then
            db[name][i]:SetPoint("TOPLEFT", f, Icicledb.XOffsetter, size + Icicledb.YOffsetter)
        else
            db[name][i]:SetPoint("TOPLEFT", db[name][i - 1], size + 2, 0)
        end
    end
end

local hideicons = function(f)
    f.icicle = 0
    local name = getname(f)
    if name and name == f.nameStr then
        if db[name] then
            for i = 1, #db[name] do
                db[name][i]:Hide()
                db[name][i]:SetParent(nil)
            end
        end
    end
end

local sourcetable = function(Name, spellID, spellName, eventType, subtracttime)
    if not db[Name] then
        db[Name] = {}
    end
    local _, _, texture = GetSpellInfo(spellID)
    local duration = IcicleCds[spellID]
    local icon = CreateFrame("frame", nil, UIParent)
    --if spellID == 42292 or spellID == 59752 then texture = "Interface\\Icons\\inv_jewelry_trinketpvp_02" end
    icon.texture = icon:CreateTexture(nil, "BORDER")
    icon.texture:SetAllPoints(icon)
    icon.texture:SetTexture(texture)
    icon.cooldown = icon:CreateFontString(nil, "OVERLAY")--CreateFrame("Cooldown", nil, icon)
    icon.cooldown:SetFont(Icicledb.textfont, Icicledb.fontSize, "OUTLINE")

    icon.cooldown:SetTextColor(0.7, 1, 0)
    icon.cooldown:SetAllPoints(icon)
    icon.endtime = GetTime() + duration
    icon.name = spellName
    icon.unitName = Name
    for k, v in ipairs(IcicleInterrupts) do
        if v == spellID then
            --spellName
            local iconBorder = icon:CreateTexture(nil, "OVERLAY")
            iconBorder:SetTexture("Interface\\AddOns\\Icicle\\Border.tga")
            iconBorder:SetVertexColor(1, 0.35, 0)--(1, 0.6, 0.1)
            iconBorder:SetAllPoints(icon)
        end
    end
    local icontimer = function(icon)
        --if not Icicledb.fontSize then Icicledb.fontSize = ceil(Icicledb.iconsizer - Icicledb.iconsizer  / 2) end
        local itimer = ceil(icon.endtime - GetTime()) -- cooldown duration
        if itimer >= 60 then
            icon.cooldown:SetText(itimer)
            if itimer < 60 and itimer >= 90 then
                icon.cooldown:SetText("2m")
            else
                icon.cooldown:SetText(ceil(itimer / 60) .. "m") -- X minutes
            end
        elseif itimer < 60 and itimer >= 11 then
            --if it's less than 60s
            icon.cooldown:SetText(itimer)
        elseif itimer <= 10 and itimer >= 4 then
            icon.cooldown:SetTextColor(1, 0.7, 0)
            icon.cooldown:SetText(itimer)
        elseif itimer <= 3 and itimer >= 1 then
            icon.cooldown:SetTextColor(1, 0, 0)
            icon.cooldown:SetText(itimer)
        else
            icon.cooldown:SetText(" ")
            icon:SetScript("OnUpdate", nil)
            icon:Hide()
            if db[icon.unitName] then
                for i = 1, #db[icon.unitName] do
                    -- safe delete from db when timer runs out!
                    if db[icon.unitName][i] and icon and db[icon.unitName][i].name == icon.name then
                        tremove(db[icon.unitName], i)
                        count = count - 1
                    end
                end
            end
        end
    end

    --CooldownFrame_SetTimer(icon.cooldown, GetTime(), duration, 1) OmniCC
    if spellID == 14185 or spellID == 23989 or spellID == 11958 then
        --Preperation, Cold Snap, Readiness
        for k, v in ipairs(IcicleReset[spellID]) do
            for i = 1, #db[Name] do
                if db[Name][i] then
                    if db[Name][i].name == v then
                        if db[Name][i]:IsVisible() then
                            local f = db[Name][i]:GetParent()
                            if f.icicle and f.icicle ~= 0 then
                                f.icicle = 0
                            end
                        end
                        db[Name][i]:Hide()
                        db[Name][i]:SetParent(nil)
                        tremove(db[Name], i)
                        count = count - 1
                    end
                end
            end
        end
    else
        for i = 1, #db[Name] do
            if db[Name][i] then
                if db[Name][i].name == spellName then
                    if db[Name][i]:IsVisible() then
                        local f = db[Name][i]:GetParent()
                        if f.icicle then
                            f.icicle = 0
                        end
                    end
                    db[Name][i]:Hide()
                    db[Name][i]:SetParent(nil)
                    tremove(db[Name], i)
                    count = count - 1
                end
            end
        end
    end
    tinsert(db[Name], icon)
    icon:SetScript("OnUpdate", function()
        icontimer(icon)
    end)
end

local onpurge = 0
local uppurge = function(self, elapsed)
    onpurge = onpurge + elapsed
    if onpurge >= 1 then
        onpurge = 0
        if count == 0 then
            plateframe:SetScript("OnUpdate", nil)
            purgeframe:SetScript("OnUpdate", nil)
        end
        for k, v in pairs(db) do
            for i, c in ipairs(v) do
                if c.endtime < GetTime() then
                    if c:IsVisible() then
                        local f = c:GetParent()
                        if f.icicle then
                            f.icicle = 0
                        end
                    end
                    c:Hide()
                    c:SetParent(nil)
                    tremove(db[k], i)
                    count = count - 1
                end
            end
        end
    end
end

local onplate = 0

local getplate = function(frame, elapsed, spellID)
    onplate = onplate + elapsed
    if onplate > .1 then -- 100ms update, was 330ms
        onplate = 0
        local num = WorldFrame:GetNumChildren()
        for i = 1, num do
            local f = select(i, WorldFrame:GetChildren())
            if not f.icicle then
                f.icicle = 0
            end
            if f:GetNumRegions() > 2 and f:GetNumChildren() >= 1 then
                if f:IsVisible() then
                    local name = getname(f)
                    if name then
                        f.nameStr = name
                        Icicle:Test(name)
                        if db[name] ~= nil then
                            f.icicle = #db[name]
                            for j = 1, #db[name] do
                                db[name][j]:SetParent(f)
                                db[name][j]:Show()
                            end
                            addicons(name, f, spellID)
                            if not f:GetScript("OnHide") then
                                f:SetScript("OnHide", hideicons)
                                f.icicleHooked = true
                            elseif not f.icicleHooked then
                                f:HookScript("OnHide", hideicons)
                                f.icicleHooked = true
                            end
                        end
                    end
                end
            end
        end
        testMode = nil
    end
end

function Icicle:InitTest()
    print("Icicle - testmode initiated on all visible plates")
    if not plateframe:GetScript("OnUpdate") then
        plateframe:SetScript("OnUpdate", getplate)
        purgeframe:SetScript("OnUpdate", uppurge)
    end
    testMode = true
end

function Icicle:Test(name)
    if testMode then
        local function testCD(unitName, spell, id)
            if not eventcheck[unitName] then
                eventcheck[unitName] = {}
            end
            if not eventcheck[unitName][spell] or GetTime() >= eventcheck[unitName][spell] + 1 then
                count = count + 1
                sourcetable(unitName, id, spell)
                eventcheck[unitName][spell] = GetTime()
            end
            if not plateframe:GetScript("OnUpdate") then
                plateframe:SetScript("OnUpdate", getplate)
                purgeframe:SetScript("OnUpdate", uppurge)
            end
        end
        testCD(name, "Shadowfury", 30283) -- 20s
        testCD(name, "Intercept", 20252) -- 15s
        testCD(name, "Intervene", 3411) -- 30s
        testCD(name, "Pummel", 6552) -- 10s
    end
end

local IcicleEvent = {}
function IcicleEvent.COMBAT_LOG_EVENT_UNFILTERED(event, ...)
    --local timestamp,event,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,spellName = select ( 1 , ... );
    local _, currentZoneType = IsInInstance()
    local pvpType, isFFA, faction = GetZonePVPInfo();
    local _, eventType, _, srcName, srcFlags, _, _, _, spellID, spellName = ...
    if (not ((pvpType == "contested" and Icicledb.field) or (pvpType == "hostile" and Icicledb.field) or (pvpType == "friendly" and Icicledb.field) or (currentZoneType == "pvp" and Icicledb.battleground) or (currentZoneType == "arena" and Icicledb.arena) or Icicledb.all)) then
        return
    end

    local isHostilePlayer = bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER and     bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE

    if IcicleCds[spellID] and isHostilePlayer then
        local Name = strmatch(srcName, "[%P]+")
        if eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_MISSED" or eventType == "SPELL_SUMMON" or eventType == "SPELL_AURA_REMOVED" then
            if not eventcheck[Name] then
                eventcheck[Name] = {}
            end
            if not eventcheck[Name][spellName] or GetTime() >= eventcheck[Name][spellName] + 1 then
                count = count + 1
                sourcetable(Name, spellID, spellName)
                eventcheck[Name][spellName] = GetTime()
            end
            if not plateframe:GetScript("OnUpdate") then
                plateframe:SetScript("OnUpdate", getplate)
                purgeframe:SetScript("OnUpdate", uppurge)
            end
        end
    end
end

function IcicleEvent.PLAYER_ENTERING_WORLD(event, ...)
    db = {}
    eventcheck = {}
    count = 0
end

function Icicle:Reset()
    print("Icicle - reset all timers")
    for k, v in pairs(db) do
        for i = 1, #v do
            if v[i] then
                v[i].endtime = 0.05
            end
        end
    end
end

local Icicle = CreateFrame("frame")
Icicle:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
Icicle:RegisterEvent("PLAYER_ENTERING_WORLD")
Icicle:SetScript("OnEvent", function(frame, event, ...)
    IcicleEvent[event](IcicleEvent, ...)
end)