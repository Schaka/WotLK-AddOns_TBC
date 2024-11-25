
-- BigDebuffs by Jordon 
-- Backported and general improvements by Konjunktur
-- Spell list and minor improvements by Apparent#
-- Adjustments for Endless TBC 3.3.5a by Schaka

BigDebuffs = LibStub("AceAddon-3.0"):NewAddon("BigDebuffs", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local Masque = LibStub("Masque", true)


-- Defaults
local defaults = {
	profile = {
		unitFrames = {
			enabled = true,
			cooldownCount = true,
			player = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
                cc = true,
                interrupts = false,
                immunities = false,
                immunities_spells = false,
                buffs_defensive = false,
                buffs_offensive = false,
                buffs_other = false,
                roots = true,
			},
			focus = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
                cc = true,
                interrupts = true,
                immunities = true,
                immunities_spells = true,
                buffs_defensive = true,
                buffs_offensive = true,
                buffs_other = true,
                roots = true,
			},
			target = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
                cc = true,
                interrupts = true,
                immunities = true,
                immunities_spells = true,
                buffs_defensive = true,
                buffs_offensive = true,
                buffs_other = true,
                roots = true,
			},
			pet = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
                cc = true,
                interrupts = true,
                immunities = true,
                immunities_spells = true,
                buffs_defensive = true,
                buffs_offensive = true,
                buffs_other = true,
                roots = true,
			},
			party = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
                cc = true,
                interrupts = true,
                immunities = true,
                immunities_spells = true,
                buffs_defensive = true,
                buffs_offensive = true,
                buffs_other = true,
                roots = true,
			},
			arena = {
				enabled = true,
				anchor = "auto",
				size = 50,
				cdMod = 9,
                cc = true,
                interrupts = true,
                immunities = true,
                immunities_spells = true,
                buffs_defensive = true,
                buffs_offensive = true,
                buffs_other = true,
                roots = true,
			},

		},
		priority = {
			immunities = 90,
			immunities_spells = 80,
			cc = 70,
			interrupts = 60,
			buffs_defensive = 50,
			buffs_offensive = 40,
			buffs_other = 30,
			roots = 20,
		},
		spells = {},
	}
}

BigDebuffs.Spells = {
	-- Druid
	[22842] = { type = "buffs_defensive", },  -- Frenzied Regeneration
	[17116] = { type = "buffs_defensive", }, -- Nature's Swiftness
	[22812] = { type = "buffs_defensive", },  -- Barkskin
	[29166] = { type = "buffs_offensive", },  -- Innervate
	[53312] = { type = "buffs_other", }, -- Nature's Grasp
	[33357] = { type = "buffs_other", },  -- Dash
	[768] = { type = "buffs_other", }, -- Cat Form
	[9634] = { type = "buffs_other", }, -- Dire Bear Form
	[783] = { type = "buffs_other", }, -- Travel Form
	[24858] = { type = "buffs_other", }, -- Moonkin Form
	[33891] = { type = "buffs_other", }, -- Tree of Life
	[22570] = { type = "cc" },  -- Maim
	[8983] = { type = "cc", },  -- Bash
	[2637] = {type = "cc"}, -- Hibernate
	[49803] = { type = "cc", },  -- Pounce
	[33786] = { type = "immunities" },  -- Cyclone
	[45334] = { type = "roots", },  -- Feral Charge Effect (Immobilize)
	[26989] = { type = "roots", },  -- Entangling Roots
	[19975] = { type = "roots", }, -- Entangling Roots (From Nature's Grasp)
	[19675] = { type = "interrupts", duration = 4, },  -- Feral Charge Effect (Interrupt)
	-- Hunter
	[3045] = { type = "buffs_offensive", }, -- Rapid Fire
	[34471] = { type = "immunities", },  -- The Beast Within
	[19263] = { type = "immunities", },  -- Deterrence
	[19574] = { type = "immunities", }, -- Bestial Wrath (Pet)
	[3034] = { type = "buffs_other", },  -- Viper Sting
	[24394] = { type = "cc", },  -- Intimidation (Stun)
	[49012] = { type = "cc", },  -- Wyvern Sting
	[19503] = { type = "cc", },  -- Scatter Shot
	[14309] = { type = "cc", },  -- Freezing Trap
	[14327] = { type = "cc", }, -- Scare Beast
	[34490] = { type = "cc", }, -- Silencing Shot
	[48999] = { type = "roots", }, -- Counterattack
	[19185] = { type = "roots", }, -- Entrapment
	-- Mage
	[43039] = { type = "buffs_other", },  -- Ice Barrier
	[12472] = { type = "buffs_offensive", },  -- Icy Veins
	[12042] = { type = "buffs_offensive", },  -- Arcane Power
	[12043] = { type = "buffs_offensive", },  -- Presence of Mind
	[12051] = { type = "buffs_offensive", },  -- Evocation
	[44544] = { type = "buffs_offensive", }, -- Fingers of Frost
	[66] = { type = "buffs_offensive", },  -- Invisibility
	[118] = { type = "cc", },  -- Polymorph
	[42950] = { type = "cc", },  -- Dragon's Breath
	[12355] = { type = "cc", }, -- Impact
	[18469] = { type = "cc", }, -- Improved Counterspell
	[45438] = { type = "immunities", },  -- Ice Block
	[12494] = { type = "roots", },  -- Frostbite
	[122] = { type = "roots", },  -- Frost Nova
	[2139] = { type = "interrupts", duration = 6, },  -- Counterspell (Mage)
	-- Paladin
	[1022] = { type = "buffs_defensive", },  -- Blessing of Protection
	[498] = { type = "buffs_defensive", },  -- Divine Protection
	[6940] = { type = "buffs_defensive", },  -- Blessing of Sacrifice
	[1044] = { type = "buffs_defensive", },  -- Blessing of Freedom
	[31884] = { type = "buffs_offensive", },  -- Avenging Wrath
	[20066] = { type = "cc", }, -- Repentance
	[10308] = { type = "cc", }, -- Hammer of Justice
	[10326] = { type = "cc", }, -- Turn Evil
	[48817] = { type = "cc", }, -- Holy Wrath
	[20170] = { type = "cc", }, -- Seal of Justice Stun
	[642] = { type = "immunities", },  -- Divine Shield
	-- Priest
	[20711] = { type = "buffs_defensive", },  -- Spirit of Redemption
	[14751] = { type = "buffs_defensive", },  -- Inner Focus
	[33206] = { type = "buffs_defensive", },  -- Pain Suppression
	[10060] = { type = "buffs_offensive", },  -- Power Infusion
	[6346] = { type = "buffs_other", },  -- Fear Ward
	[48066] = { type = "buffs_other", }, -- Power Word: Shield
	[10890] = { type = "cc", },  -- Psychic Scream
	[15487] = { type = "cc", },  -- Silence
	[605] = { type = "cc", },  -- Mind Control
	[10955] = { type = "cc", },  -- Shackle Undead
	-- Rogue
	[13750] = { type = "buffs_offensive", },  -- Adrenaline Rush
	[14177] = { type = "buffs_offensive", }, -- Cold Blood
	[11305] = { type = "buffs_other", },  -- Sprint
	[26669] = { type = "buffs_defensive", },  -- Evasion
	[1776] = { type = "cc", },  -- Gouge
	[2094] = { type = "cc", },  -- Blind
	[8643] = { type = "cc", },  -- Kidney Shot
	[51724] = { type = "cc", },  -- Sap
	[1330] = { type = "cc", },  -- Garrote - Silence
	[1833] = { type = "cc", },  -- Cheap Shot
	[18425] = { type = "cc", }, -- Silence (Improved Kick)
	[31224] = { type = "immunities_spells", },  -- Cloak of Shadows
	[1766] = { type = "interrupts", duration = 5, },  -- Kick
	-- Shaman
	[16166] = { type = "buffs_offensive", }, -- Elemental Mastery (Instant Cast)
	[2825] = { type = "buffs_offensive", },  -- Bloodlust
	[32182] = { type = "buffs_offensive", },  -- Heroism
	[16191] = { type = "buffs_offensive", }, -- Mana Tide Totem
	[30823] = { type = "buffs_defensive", }, -- Shamanistic Rage
	[16188] = { type = "buffs_defensive", }, -- Nature's Swiftness
	[8178] = { type = "immunities_spells", }, -- Grounding Totem Effect
	-- Warlock
	[18708] = { type = "buffs_other", },  -- Fel Domination
	[27273] = { type = "buffs_other", }, -- Sacrifice
	[30283] = { type = "cc", },  -- Shadowfury
	[31117] = { type = "cc", },  -- Unstable Affliction (Silence)
	[18647] = { type = "cc", },  -- Banish
	[27223] = { type = "cc", },  -- Death Coil
	[6358] = { type = "cc", },  -- Seduction
	[6215] = { type = "cc", },  -- Fear
	[17928] = { type = "cc", },  -- Howl of Terror
	[24259] = { type = "cc", }, -- Spell Lock (Silence)
	[47995] = { type = "cc", }, -- Intercept (Felguard)
	[19647] = { type = "interrupts", duration = 6, },  -- Spell Lock (Interrupt)
	-- Warrior
	[12975] = { type = "buffs_defensive", },  -- Last Stand
	[871] = { type = "buffs_defensive", },  -- Shield Wall
	[3411] = { type = "buffs_defensive", },  -- Intervene
	[2565] = { type = "buffs_defensive", }, -- Shield Block
	[20230] = { type = "buffs_defensive", }, -- Retaliation
	[1719] = { type = "buffs_offensive", },  -- Recklessness
	[12292] = { type = "buffs_offensive", }, -- Death Wish
	[18499] = { type = "buffs_other", },  -- Berserker Rage
	[2457] = { type = "buffs_other", }, -- Battle Stance
	[2458] = { type = "buffs_other", }, -- Berserker Stance
	[71] = { type = "buffs_other", }, -- Defensive Stance
	[12809] = { type = "cc", }, -- Concussion Blow
	[12798] = { type = "cc", }, -- Revenge Stun
	[676] = { type = "cc", },  -- Disarm
	[46968] = { type = "cc", },  -- Shockwave
	[5246] = { type = "cc", },  -- Intimidating Shout (Non - Target)
	[20511] = { type = "cc", }, -- Intimidating Shout (Target)
	[7922] = { type = "cc", }, -- Charge
	[20253] = { type = "cc", }, -- Intercept
	[18498] = { type = "cc", }, -- Silenced - Gag Order
	[23920] = { type = "immunities_spells", },  -- Spell Reflection
	[6552] = { type = "interrupts", duration = 4, },  -- Pummel
	[72] = { type = "interrupts", duration = 5, }, -- Shield Bash
	-- Misc
	[22734] = { type = "buffs_other", },  -- Drink (Arena/Lvl 70 Water)
	[20549] = { type = "cc", },  -- War Stomp
	[28730] = { type = "cc", }, -- Arcane Torrent (Mana)
	[25046] = { type = "cc", }, -- Arcane Torrent (Energy)
}

BigDebuffs.SpellsLocalized = {}

local units = {
	"player",
	"pet",
	"target",
	"focus",
	"party1",
	"party2",
	"party3",
	"party4",
	"arena1",
	"arena2",
	"arena3",
	"arena4",
	"arena5",
}

local UnitDebuff, UnitBuff = UnitDebuff, UnitBuff

local GetAnchor = {
	ShadowedUnitFrames = function(anchor)
		local frame = _G[anchor]
		if not frame then return end
		if frame.portrait and frame.portrait:IsShown() then
			return frame.portrait, frame
		else
			return frame, frame, true
		end
	end,
	ZPerl = function(anchor)
		local frame = _G[anchor]
		if not frame then return end
		if frame:IsShown() then
			return frame, frame
		else
			frame = frame:GetParent()
			return frame, frame, true
		end
	end,
}

local anchors = {
	["ElvUI"] = {
		noPortrait = true,
		units = {
			player = "ElvUF_Player",
			pet = "ElvUF_Pet",
			target = "ElvUF_Target",
			focus = "ElvUF_Focus",
			party1 = "ElvUF_PartyGroup1UnitButton1",
			party2 = "ElvUF_PartyGroup1UnitButton2",
			party3 = "ElvUF_PartyGroup1UnitButton3",
			party4 = "ElvUF_PartyGroup1UnitButton4",
		},
	},
	["bUnitFrames"] = {
		noPortrait = true,
		alignLeft = true,
		units = {
			player = "bplayerUnitFrame",
			pet = "bpetUnitFrame",
			target = "btargetUnitFrame",
			focus = "bfocusUnitFrame",
			arena1 = "barena1UnitFrame",
			arena2 = "barena2UnitFrame",
			arena3 = "barena3UnitFrame",
			arena4 = "barena4UnitFrame",
		},
	},
	["Shadowed Unit Frames"] = {
		func = GetAnchor.ShadowedUnitFrames,
		units = {
			player = "SUFUnitplayer",
			pet = "SUFUnitpet",
			target = "SUFUnittarget",
			focus = "SUFUnitfocus",
			party1 = "SUFHeaderpartyUnitButton1",
			party2 = "SUFHeaderpartyUnitButton2",
			party3 = "SUFHeaderpartyUnitButton3",
			party4 = "SUFHeaderpartyUnitButton4",
		},
	},
	["ZPerl"] = {
		func = GetAnchor.ZPerl,
		units = {
			player = "XPerl_PlayerportraitFrame",
			pet = "XPerl_Player_PetportraitFrame",
			target = "XPerl_TargetportraitFrame",
			focus = "XPerl_FocusportraitFrame",
			party1 = "XPerl_party1portraitFrame",
			party2 = "XPerl_party2portraitFrame",
			party3 = "XPerl_party3portraitFrame",
			party4 = "XPerl_party4portraitFrame",
		},
	},
	["Blizzard"] = {
		units = {
			player = "PlayerPortrait",
			pet = "PetPortrait",
			target = "TargetFramePortrait",
			focus = "FocusFramePortrait",
			party1 = "PartyMemberFrame1Portrait",
			party2 = "PartyMemberFrame2Portrait",
			party3 = "PartyMemberFrame3Portrait",
			party4 = "PartyMemberFrame4Portrait",
			arena1 = "ArenaEnemyFrame1ClassPortrait",
			arena2 = "ArenaEnemyFrame2ClassPortrait",
			arena3 = "ArenaEnemyFrame3ClassPortrait",
			arena4 = "ArenaEnemyFrame4ClassPortrait",
			arena5 = "ArenaEnemyFrame5ClassPortrait",
		},
	},
}

function BigDebuffs:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BigDebuffsDB", defaults, true)

	self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
	self.frames = {}
	self.UnitFrames = {}
	self:SetupOptions()
end

local function HideBigDebuffs(frame)
	if not frame.BigDebuffs then return end
	for i = 1, #frame.BigDebuffs do
		frame.BigDebuffs[i]:Hide()
	end
end

function BigDebuffs:Refresh()
	for unit, frame in pairs(self.UnitFrames) do
		frame:Hide()
		frame.current = nil
		frame.cooldown.noCooldownCount = not self.db.profile.unitFrames.cooldownCount
		self:AttachUnitFrame(unit)
		self:UNIT_AURA(nil, unit)
	end
end

local unitsToUpdate = {}

function BigDebuffs:PLAYER_REGEN_ENABLED()
	for unit, _ in pairs(unitsToUpdate) do
		self:AttachUnitFrame(unit)
	end
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	unitsToUpdate = {}
end

function BigDebuffs:AttachUnitFrame(unit)
	if InCombatLockdown() then 
		unitsToUpdate[unit] = true
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return 
	end

	local frame = self.UnitFrames[unit]
	local frameName = "BigDebuffs" .. unit .. "UnitFrame"

	if not frame then
		frame = CreateFrame("Button", frameName, UIParent, "BigDebuffsUnitFrameTemplate")
		frame.icon = _G[frameName.."Icon"]
		frame.cooldownContainer = CreateFrame("Button", frameName.."CooldownContainer", frame)
		self.UnitFrames[unit] = frame
		frame.icon:SetDrawLayer("BORDER")
		frame.cooldownContainer:SetPoint("CENTER")
		frame.cooldown:SetParent(frame.cooldownContainer)
		frame.cooldown:SetAllPoints()
		frame.cooldown:SetAlpha(0.9)
		
		frame:RegisterForDrag("LeftButton")
		frame:SetMovable(true)
		frame.unit = unit
        
        if Masque then
            if not frame.masqueGroup then
                local group = Masque:Group("BigDebuffs", unit:gsub('%d',''))
                frame.masqueGroup = group
                frame.masqueGroup:AddButton(frame,
                    {
                        Cooldown = frame.cooldown,
                        Gloss = frame.icon,
                        Icon = frame.icon,
                    },
                nil, true)
            end
        end
	end

	frame:EnableMouse(self.test)

	_G[frameName.."Name"]:SetText(self.test and not frame.anchor and unit)

	frame.anchor = nil
	frame.blizzard = nil

	local config = self.db.profile.unitFrames[unit:gsub("%d", "")]

	if config.anchor == "auto" then
		-- Find a frame to attach to
		for k,v in pairs(anchors) do
			local anchor, parent, noPortrait
			if v.units[unit] then
				if v.func then
					anchor, parent, noPortrait = v.func(v.units[unit])
				else
					anchor = _G[v.units[unit]]
				end

				if anchor then
					frame.anchor, frame.parent, frame.noPortrait = anchor, parent, noPortrait
					if v.noPortrait then frame.noPortrait = true end
					frame.alignLeft = v.alignLeft
					frame.blizzard = k == "Blizzard"
					if not frame.blizzard then break end
				end
			end		
		end
	end

	if frame.anchor then
		if frame.blizzard then
			-- Blizzard Frame
			frame:SetParent(frame.anchor:GetParent())
			frame:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel())
			frame.cooldownContainer:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel()-1)
			frame.cooldownContainer:SetSize(frame.anchor:GetWidth() - config.cdMod, frame.anchor:GetHeight() - config.cdMod)
			frame.anchor:SetDrawLayer("BACKGROUND")
		else
			frame:SetParent(frame.parent and frame.parent or frame.anchor)
			frame:SetFrameLevel(99)
			frame.cooldownContainer:SetSize(frame.anchor:GetWidth(), frame.anchor:GetHeight())
		end

		frame:ClearAllPoints()

		if frame.noPortrait then
			-- No portrait, so attach to the side
			if frame.alignLeft then
				frame:SetPoint("TOPRIGHT", frame.anchor, "TOPLEFT")
			else
				frame:SetPoint("TOPLEFT", frame.anchor, "TOPRIGHT")
			end
			local height = frame.anchor:GetHeight()
			frame:SetSize(height, height)
		else
			frame:SetAllPoints(frame.anchor)
		end
        if Masque then
            frame.masqueGroup:ReSkin()
        end
	else
		-- Manual
		frame:SetParent(UIParent)
		frame:ClearAllPoints()
		
		frame.cooldownContainer:SetSize(frame:GetWidth(), frame:GetHeight())
		
		frame:SetFrameLevel(frame:GetParent():GetFrameLevel()+1)
		frame.cooldownContainer:SetFrameLevel(frame:GetParent():GetFrameLevel())
		frame.cooldownContainer:SetSize(frame:GetWidth(), frame:GetHeight())

		if not self.db.profile.unitFrames[unit] then self.db.profile.unitFrames[unit] = {} end

		if self.db.profile.unitFrames[unit].position then
			frame:SetPoint(unpack(self.db.profile.unitFrames[unit].position))
		else
			-- No saved position, anchor to the blizzard position
			LoadAddOn("Blizzard_ArenaUI")
			local relativeFrame = _G[anchors.Blizzard.units[unit]] or UIParent
			frame:SetPoint("CENTER", relativeFrame, "CENTER")
		end
		
		frame:SetSize(config.size, config.size)
        if Masque then
            frame.masqueGroup:ReSkin()
        end
	end
    
end

function BigDebuffs:SaveUnitFramePosition(frame)
	self.db.profile.unitFrames[frame.unit].position = { frame:GetPoint() }
end

function BigDebuffs:Test()
	self.test = not self.test
	self:Refresh()
end

local TestDebuffs = {}

function BigDebuffs:InsertTestDebuff(spellID)
	local texture = select(3, GetSpellInfo(spellID))
	table.insert(TestDebuffs, {spellID, texture})
end

local function UnitDebuffTest(unit, index)
	local debuff = TestDebuffs[index]
	if not debuff then return end
    
    local duration = random(4, 50)
    
	return GetSpellInfo(debuff[1]), nil, debuff[2], 0, "Magic", duration, GetTime()+duration, nil, nil, nil, debuff[1]
end

function BigDebuffs:OnEnable()
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self.interrupts = {}

	-- Prevent OmniCC finish animations
	if OmniCC then
		self:RawHook(OmniCC, "TriggerEffect", function(object, cooldown)
			local name = cooldown:GetName()
			if name and name:find("BigDebuffs") then return end
			self.hooks[OmniCC].TriggerEffect(object, cooldown)
		end, true)
	end

    self:InsertTestDebuff(8643) -- Kidney Shot
    self:InsertTestDebuff(1766)  -- Kick
end

function BigDebuffs:PLAYER_ENTERING_WORLD()
	for i = 1, #units do
		self:AttachUnitFrame(units[i])
	end
	self.stances = {}

	-- create a copy so we can use spellnames as a fallback, this is especially important for multi rank
	-- this maintains localization support to an extent too
	for id, options in pairs(self.Spells) do
		if type(id) == "number" then
			self.Spells[GetSpellInfo(id)] = options;
		else
			self.Spells[id] = options;
		end	
	end
end

-- For unit frames
function BigDebuffs:GetAuraPriority(unit, name, id)
	if not unit or (not self.Spells[id] and not self.Spells[name]) then return end
	
	id = self.Spells[id] and id or name
	
	-- Make sure category is enabled
	if not self.db.profile.unitFrames[unit:gsub("%d", "")][self.Spells[id].type] then return end
    
	-- Check for user set
	if self.db.profile.spells[id] then
		if self.db.profile.spells[id].unitFrames and self.db.profile.spells[id].unitFrames == 0 then return end
		if self.db.profile.spells[id].priority then return self.db.profile.spells[id].priority end
	end
    
	if self.Spells[id].nounitFrames and (not self.db.profile.spells[id] or not self.db.profile.spells[id].unitFrames) then
		return
	end
    
	return self.db.profile.priority[self.Spells[id].type] or 0
end

function BigDebuffs:GetUnitFromGUID(guid)
	for _,unit in pairs(units) do
		if UnitGUID(unit) == guid then
			return unit
		end
	end
	return nil
end

function BigDebuffs:UNIT_SPELLCAST_FAILED(_,unit, _, _, spellid)
	local guid = UnitGUID(unit)
	if self.interrupts[guid] == nil then
		self.interrupts[guid] = {}
		BigDebuffs:CancelTimer(self.interrupts[guid].timer)
		self.interrupts[guid].timer = BigDebuffs:ScheduleTimer(self.ClearInterruptGUID, 30, self, guid)
	end
	self.interrupts[guid].failed = GetTime()
end

function BigDebuffs:COMBAT_LOG_EVENT_UNFILTERED(_, ...)
	local _, subEvent, sourceGUID, _, _, destGUID, destName, _, spellid, name = ...

    -- Stance logic
	if subEvent == "SPELL_CAST_SUCCESS" and self.Spells[spellid] then
		if spellid == 2457 or spellid == 2458 or spellid == 71 then
			self:UpdateStance(sourceGUID, spellid)
		end
	end

	if subEvent ~= "SPELL_CAST_SUCCESS" and subEvent ~= "SPELL_INTERRUPT" then
		return
	end
		
	-- UnitChannelingInfo and event orders are not the same in WotLK as later expansions, UnitChannelingInfo will always return
	-- nil @ the time of this event (independent of whether something was kicked or not).
	-- We have to track UNIT_SPELLCAST_FAILED for spell failure of the target at the (approx.) same time as we interrupted
	-- this "could" be wrong if the interrupt misses with a <0.01 sec failure window (which depending on server tickrate might
	-- not even be possible)
	if subEvent == "SPELL_CAST_SUCCESS" and not (self.interrupts[destGUID] and 
			self.interrupts[destGUID].failed and GetTime() - self.interrupts[destGUID].failed < 0.01) then
		return
	end
	
	local spelldata = self.Spells[name] and self.Spells[name] or self.Spells[spellid]
	if spelldata == nil or spelldata.type ~= "interrupts" then return end
	local duration = spelldata.duration
   	if not duration then return end
	
	self:UpdateInterrupt(nil, destGUID, spellid, duration)
end

function BigDebuffs:UpdateStance(guid, spellid)
	if self.stances[guid] == nil then
		self.stances[guid] = {}
	else
		self:CancelTimer(self.stances[guid].timer)
	end
	
	self.stances[guid].stance = spellid
	self.stances[guid].timer = self:ScheduleTimer(self.ClearStanceGUID, 180, self, guid)

	local unit = self:GetUnitFromGUID(guid)
	if unit then
		self:UNIT_AURA(nil, unit)
	end
end

function BigDebuffs:ClearStanceGUID(guid)
	local unit = self:GetUnitFromGUID(guid)
	if unit == nil then
		self.stances[guid] = nil
	else
		self.stances[guid].timer = BigDebuffs:ScheduleTimer(self.ClearStanceGUID, 180, self, guid)
	end
end

function BigDebuffs:UpdateInterrupt(unit, guid, spellid, duration)
	local t = GetTime()
	-- new interrupt
	if spellid and duration ~= nil then
		if self.interrupts[guid] == nil then self.interrupts[guid] = {} end
		BigDebuffs:CancelTimer(self.interrupts[guid].timer)
		self.interrupts[guid].timer = BigDebuffs:ScheduleTimer(self.ClearInterruptGUID, 30, self, guid)
		self.interrupts[guid][spellid] = {started = t, duration = duration}
	-- old interrupt expiring
	elseif spellid and duration == nil then
		if self.interrupts[guid] and self.interrupts[guid][spellid] and
				t > self.interrupts[guid][spellid].started + self.interrupts[guid][spellid].duration then
			self.interrupts[guid][spellid] = nil
		end
	end
	
	unit = unit and unit or self:GetUnitFromGUID(guid)
	
	if unit then	
		self:UNIT_AURA(nil, unit)
	end
	-- clears the interrupt after end of duration
	if duration then
		BigDebuffs:ScheduleTimer(self.UpdateInterrupt, duration+0.1, self, unit, guid, spellid)
	end
end

function BigDebuffs:ClearInterruptGUID(guid)
	self.interrupts[guid] = nil
end

function BigDebuffs:GetInterruptFor(unit)
	local guid = UnitGUID(unit)
	interrupts = self.interrupts[guid]
	if interrupts == nil then return end
	
	local name, spellid, icon, duration, endsAt
	
	-- iterate over all interrupt spellids to find the one of highest duration
	for ispellid, intdata in pairs(interrupts) do
		if type(ispellid) == "number" then
			local tmpstartedAt = intdata.started
			local dur = intdata.duration
			local tmpendsAt = tmpstartedAt + dur
			if GetTime() > tmpendsAt then
				self.interrupts[guid][ispellid] = nil
			elseif endsAt == nil or tmpendsAt > endsAt then
				endsAt = tmpendsAt
				duration = dur
				name, _, icon = GetSpellInfo(ispellid)
				spellid = ispellid
			end
		end
	end
	
	if name then
		return name, spellid, icon, duration, endsAt
	end
end

function BigDebuffs:UNIT_AURA(event, unit)
	if not self.db.profile.unitFrames[unit:gsub("%d", "")] or 
			not self.db.profile.unitFrames[unit:gsub("%d", "")].enabled then 
		return 
	end
	
	local frame = self.UnitFrames[unit]
	if not frame then return end
	
	local UnitDebuff = BigDebuffs.test and UnitDebuffTest or UnitDebuff
	
	local now = GetTime()
	local left, priority, duration, expires, icon, isAura, interrupt = 0, 0
	
	for i = 1, 40 do
		-- Check debuffs
		local n,_, ico, _,_, d, e, caster, _,_, id = UnitDebuff(unit, i)
		
		if id then
			if self.Spells[n] or self.Spells[id] then
				local p = self:GetAuraPriority(unit, n, id)
				if p and (p > priority or (p == prio and expires and e < expires)) then
					left = e - now
					duration = d
					isAura = true
					priority = p
					expires = e
					icon = ico
				end
			end
		else
			break
		end
	end
	
	for i = 1, 40 do
		-- Check buffs
		local n,_, ico, _,_, d, e, _,_,_, id = UnitBuff(unit, i)
		if id then
			if self.Spells[id] then
				local p = self:GetAuraPriority(unit, n, id)
				if p and p >= priority then
					if p and (p > priority or (p == prio and expires and e < expires)) then
						left = e - now
						duration = d
						isAura = true
						priority = p
						expires = e
						icon = ico
					end
				end
			end
		else
			break
		end
	end
	
	local n, id, ico, d, e = self:GetInterruptFor(unit)
	if n then
		local p = self:GetAuraPriority(unit, n, id)
		if p and (p > priority or (p == prio and expires and e < expires)) then
			left = e - now
			duration = d
			isAura = true
			priority = p
			expires = e
			icon = ico
		end
	end

	-- need to always look for a stance (if we only look for it once a player
	-- changes stance we will never get back to it again once other auras fade)
	local guid = UnitGUID(unit)
	if self.stances[guid] then 
		local stanceId = self.stances[guid].stance
		if stanceId and self.Spells[stanceId] then
			n, _, ico = GetSpellInfo(stanceId)
			local p = self:GetAuraPriority(unit, n, stanceId)
			if p and p >= priority then
				left = 0
				duration = 0
				isAura = true
				priority = p
				expires = 0
				icon = ico
			end
		end
	end
	
	if isAura then
		if frame.current ~= icon then
			if frame.blizzard then
				-- Blizzard Frame
				SetPortraitToTexture(frame.icon, icon)
				-- Adapt
				if frame.anchor and Adapt and Adapt.portraits[frame.anchor] then
					Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("BACKGROUND")
				end
			else
				frame.icon:SetTexture(icon)
			end
		end
		
		if duration > 1 then
			frame.cooldown:SetCooldown(expires - duration, duration)
			frame.cooldownContainer:Show()
		else 
			frame.cooldown:SetCooldown(0, 0)
			frame.cooldownContainer:Hide()
		end

		frame:Show()
		frame.current = icon
	else
		-- Adapt
		if frame.anchor and frame.blizzard and Adapt and Adapt.portraits[frame.anchor] then
			Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("LOW")
		else
			frame:Hide()
			frame.current = nil
		end
	end
end

function BigDebuffs:PLAYER_FOCUS_CHANGED()
	self:UNIT_AURA(nil, "focus")
end

function BigDebuffs:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA(nil, "target")
end

function BigDebuffs:UNIT_PET()
	self:UNIT_AURA(nil, "pet")
end

SLASH_BigDebuffs1 = "/bd"
SLASH_BigDebuffs2 = "/bigdebuffs"
SlashCmdList.BigDebuffs = function(msg)
	LibStub("AceConfigDialog-3.0"):Open("BigDebuffs")
end
