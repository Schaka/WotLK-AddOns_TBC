--[[
    ArenaLive [Core] is an unit frame framework for World of Warcraft.
    Copyright (C) 2014  Harald Böhm <harald@boehm.agency>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
	ADDITIONAL PERMISSION UNDER GNU GPL VERSION 3 SECTION 7:
	As a special exception, the copyright holder of this add-on gives you
	permission to link this add-on with independent proprietary software,
	regardless of the license terms of the independent proprietary software.
]]

-- ArenaLive addon Name and localisation table:
local addonName, L = ...;

--[[
**************************************************
******* GENERAL HANDLER SET UP STARTS HERE *******
**************************************************
]]--
-- Create new Handler and register for aura event:
local CCIndicator = ArenaLive:ConstructHandler("CCIndicator", true);
CCIndicator.canToggle = true;
CCIndicator:RegisterEvent("UNIT_AURA", "UpdateCache");
CCIndicator:RegisterEvent("PLAYER_TARGET_CHANGED", "UpdateCache");
CCIndicator:RegisterEvent("PLAYER_FOCUS_CHANGED", "UpdateCache");

-- Create CC cache. This will be sorted by unitID and inside the unitID table by spellID:
local unitCCCache = {};

-- Variables for max buffs and debuffs:
local MAX_BUFFS = 40;
local MAX_DEBUFFS = 40;

-- localized spellname table
local locSpells = {};
for spellID,type in pairs(ArenaLive.spellDB["CCIndicator"]) do
	local name = GetSpellInfo(spellID)
	if name then
		locSpells[name] = type
	end
end



--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
function CCIndicator:ConstructObject (indicator, texture, cooldown, addonName)
	
	-- Add references:
	indicator.texture = texture;
	indicator.cooldown = cooldown;
	
	local width, height = indicator:GetSize();
	local parent = indicator:GetParent();
	if ( width == 0 and height == 0 and parent ) then
		-- BUGFIX: If size and height is 0, try to use parent's size, because it seems like SetAllPoints doesn't work for LUA created frames somehow:
		width, height = parent:GetSize();
		indicator:SetSize(width, height);
	end
	
	-- Set up cooldown (without frameType, as I want to store cooldown options per addon and not per frame type):
	ArenaLive:ConstructHandlerObject(cooldown, "Cooldown", addonName, indicator);
	
end

function CCIndicator:OnEnable (unitFrame)
	CCIndicator:Update(unitFrame);
end

function CCIndicator:OnDisable (unitFrame)
	CCIndicator:Reset(unitFrame);
end

function CCIndicator:Update (unitFrame)
	
	local unit = unitFrame.unit;
	local indicator = unitFrame[self.name];
	
	if ( not unit or not indicator.enabled ) then
		return;
	end

	local database = ArenaLive:GetDBComponent(unitFrame.addon, self.name);
	-- Update according to cache entries:
	if ( unitCCCache[unit] ) then
		local priority, expires, highestName, highestPriority, highestExpires;
		
		-- Iterate through all cached CCs in order to find the most important one:
		for spellName, infoTable in pairs(unitCCCache[unit]) do
			priority = database.Priorities[infoTable["priorityType"]];
			expires = unitCCCache[unit][spellName]["expires"];

			if not priority then
				print(spellName .. "  " .. unit)
			end

			if ( priority > 0 ) then
				if ( expires > 0 and GetTime() > expires  ) then
					-- Important spell has run out already. Remove entry from cache:
					table.wipe(unitCCCache[unit][spellName]);
					unitCCCache[unit][spellName] = nil;
				elseif ( not highestPriority or priority > highestPriority or ( priority == highestPriority and ( ( highestExpires > 0 and expires > highestExpires ) or expires == 0 ) ) ) then
					highestExpires = expires;
					highestName = spellName;
					highestPriority = priority;
				end
			end
		end
		
		if (highestName) then
			indicator.texture:SetTexture(unitCCCache[unit][highestName]["texture"]);
			
			if ( highestExpires > 0 ) then
				local duration = unitCCCache[unit][highestName]["duration"];
				local startTime = highestExpires - duration;
				indicator.cooldown:Set(startTime, duration);
			else
				-- These are buffs/debuffs without a duration, e.g. Solar Beam, Smoke Bomb and Grounding Totem
				indicator.cooldown:Reset();
			end
			
			indicator:Show();
		else
			CCIndicator:Reset(unitFrame);
		end
		
	else
		CCIndicator:Reset(unitFrame);
	end
end

function CCIndicator:Reset(unitFrame)
	local indicator = unitFrame[self.name];
	indicator.texture:SetTexture();
	indicator.cooldown:Reset();
	indicator:Hide();
end

function CCIndicator:UpdateCache (event, unit)
	
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		unit = "target";
	elseif ( event == "PLAYER_FOCUS_CHANGED" ) then
		unit = "focus";
	end

	-- Reset table if there is one:
	if ( unitCCCache[unit] ) then
		table.wipe(unitCCCache[unit]);
	end
	
	local spellName, texture, duration, expires, spellID, priorityType;
	
	-- Check Buffs:
	for i = 1, MAX_BUFFS, 1 do
		spellName, _, texture, _, _, duration, expires, _, _, _ = UnitBuff(unit, i);
		if ( not expires ) then -- spellID == 8178
			-- Grounding Totem:
			expires = 0;
		end
		
		if ( spellName ) then
			priorityType = locSpells[spellName];
			-- Found an important buff, store it in the cache:
			if ( priorityType ) then
			
				-- No cc was tracked for this unit until now. Create table for the new unit:
				if ( not unitCCCache[unit] ) then
					unitCCCache[unit] = {};
				end
				
				-- Update the cache if necessary:
				if ( not unitCCCache[unit][spellName] or ( unitCCCache[unit][spellName] and expires > unitCCCache[unit][spellName]["expires"] ) ) then
					
					if ( not unitCCCache[spellName] ) then
						unitCCCache[unit][spellName] = {};
					end

					unitCCCache[unit][spellName]["texture"] = texture;
					unitCCCache[unit][spellName]["duration"] = duration;
					unitCCCache[unit][spellName]["expires"] = expires;
					unitCCCache[unit][spellName]["priorityType"] = priorityType;
				end
			end
		else
			break;
		end
	end

	-- Check Debuffs:
	for i = 1, MAX_DEBUFFS, 1 do
		spellName, _, texture, _, _, duration, expires, _, _, _ = UnitDebuff(unit, i);
		if ( not expires ) then -- spellID == 81261 or spellID == 88611
			-- Solar Beam and Smoke Bomb:
			expires = 0;
		end
		
		if ( spellName ) then
			priorityType = locSpells[spellName];
			
			-- Found an important buff, store it in the cache:
			if ( priorityType ) then
				
				-- No cc was tracked for this unit until now. Create table for the new unit:
				if ( not unitCCCache[unit] ) then
					unitCCCache[unit] = {};
				end
				
				-- Update the cache if necessary:
				if ( not unitCCCache[unit][spellName] or ( unitCCCache[unit][spellName] and expires > unitCCCache[unit][spellName]["expires"] ) ) then
					
					if ( not unitCCCache[spellName] ) then
						unitCCCache[unit][spellName] = {};
					end
				
					unitCCCache[unit][spellName]["texture"] = texture;
					unitCCCache[unit][spellName]["duration"] = duration;
					unitCCCache[unit][spellName]["expires"] = expires;
					unitCCCache[unit][spellName]["priorityType"] = priorityType;
				end
			end
		else
			break;
		end
	end
	
	-- Inform all affected cc indicators that something has changed:
	if ( ArenaLive:IsUnitInUnitFrameCache(unit) ) then
		for id in ArenaLive:GetAffectedUnitFramesByUnit(unit) do
			local unitFrame = ArenaLive:GetUnitFrameByID(id);
			if ( unitFrame[self.name] ) then
				CCIndicator:Update(unitFrame);
			end
		end
	end
end


--[[
****************************************
**** OPTION FRAME SETUP STARTS HERE ****
****************************************
]]--
CCIndicator.optionSets = {
	["Enable"] = {
		["type"] = "CheckButton",
		["title"] = L["Enable"],
		["tooltip"] = L["Enables the Crowd Control Indicator."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Enabled; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Enabled = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue) for id, unitFrame in ArenaLive:GetAllUnitFrames() do if ( unitFrame.addon == frame.addon and unitFrame.group == frame.group and unitFrame[CCIndicator.name] ) then unitFrame:ToggleHandler(CCIndicator.name); end end end,
	},
	["DefCD"] = {
		["type"] = "Slider",
		["title"] = L["Defensive Cooldowns"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.defCD; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.defCD = newValue; end,
	},
	["OffCD"] = {
		["type"] = "Slider",
		["title"] = L["Offensive Cooldowns"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.offCD; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.offCD = newValue; end,
	},
	["Stun"] = {
		["type"] = "Slider",
		["title"] = L["Stuns"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.stun; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.stun = newValue; end,
	},
	["Silence"] = {
		["type"] = "Slider",
		["title"] = L["Silences"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.silence; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.silence = newValue; end,
	},
	["CrowdControl"] = {
		["type"] = "Slider",
		["title"] = L["Crowd Control"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.crowdControl; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.crowdControl = newValue; end,
	},
	["Root"] = {
		["type"] = "Slider",
		["title"] = L["Roots"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.root; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.root = newValue; end,
	},
	["Disarm"] = {
		["type"] = "Slider",
		["title"] = L["Disarms"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.disarm; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.disarm = newValue; end,
	},
	["UsefulBuff"] = {
		["type"] = "Slider",
		["title"] = L["Useful Buffs"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.usefulBuffs; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.usefulBuffs = newValue; end,
	},
	["UsefulDebuff"] = {
		["type"] = "Slider",
		["title"] = L["Useful Debuffs"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.usefulDebuffs; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.usefulDebuffs = newValue; end,
	},
};
