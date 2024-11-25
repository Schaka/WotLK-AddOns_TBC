JukedRealm = GetRealmName()
JukedChar = UnitName("player");
CharIndex=JukedChar.." - "..JukedRealm
JukedDB=JukedDB or {}
JukedDB["CharsUse"]=JukedDB["CharsUse"] or {}
JukedDB["Default"]= JukedDB["Default"] or { scale = 1, scale2 = 1, hidden = true, hidden2 = true, smart = true, smartPrio=true, prio = false, cols=6, colsPrio=6, arenaOnly=false, bgOnly=false, lock = false,growUp=1,growLeft=1, noCD=false,prioOnly=false,}
JukedDB[CharIndex] = JukedDB[CharIndex] or JukedDB["Default"]--{ scale = 1,scale2=1 , hidden = false,hidden2=false, smart=false, smartPrio=false,prio = false, cols=6, colsPrio=6, arenaOnly=false, bgOnly=false, lock = false,growUp=1,growLeft=1, noCD=false,prioOnly=false,}
for k,v in pairs(JukedDB) do
	if not (type(JukedDB[k]) == "table" ) then 
		JukedDB[k]=nil
	elseif (k=="Position" and (JukedDB["Position"]["scale2"]==nil)) then 
		JukedDB[k]=nil
	end
end
if (JukedDB["CharsUse"][CharIndex]) then
	CharIndex=JukedDB["CharsUse"][CharIndex]
else
	JukedDB["CharsUse"][CharIndex]=CharIndex
end

local abilities = {}
local order
local arena=false
local bg=false
local band = bit.band
local spell_table=spell_table

if spell_table==nil then ChatFrame1:AddMessage("NOT LOADED",0,1,0) end
for k,spell in ipairs(spell_table) do
	local name,_,spellicon = GetSpellInfo(spell.spellID)	
	abilities[name] = { icon = spellicon, duration = spell.time }
end

local frame
local bar
local bar2
local x = 15+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft-1)/2))
local x2 = 15+((JukedDB[CharIndex].colsPrio/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].colsPrio/2-1)*-30*((JukedDB[CharIndex].growLeft-1)/2))
local y2 = 0
local count2 = 0
local count=0
local y=0
local totalIcons=0
local GetTime = GetTime
local ipairs = ipairs
local pairs = pairs
local select = select
local floor = floor
local band = bit.band
local GetSpellInfo = GetSpellInfo
local GROUP_UNITS = bit.bor(0x00000010, 0x00000400)
local activetimers = {}
local size = 0

local function getsize()
	size = 0
	for k in pairs(activetimers) do
		size = size + 1
	end
end

local function isInBG()
	local a,type = IsInInstance()
	if (type == "pvp") then
		return true
	end
	return false
end

local function isInArena()
	local _,type = IsInInstance()
	if (type == "arena") then
		return true
	end
	return false
	
end
local function isPrio(ability)
	for k,v in ipairs(spell_table) do
		if select(1, GetSpellInfo(v.spellID))==ability then--find ability in table
			return v.prio--return prio status for ability
		end
	end
	return false
end

local function getTotalPrio(from)
	local ret=0
	if JukedDB[CharIndex].prio or from then
		for _,v in ipairs(spell_table) do
			if v.prio then
				ret=ret+1
			end
		end
	end
	return ret
end

local function getTotalMain()
	local ret=0
	if JukedDB[CharIndex].prio then
		for _,v in ipairs(spell_table) do
			if not v.prio then
				ret=ret+1
			end
		end
		return ret
	end
	return #(spell_table)
end

local function Juked_AddIcons()

	for _,ability in ipairs(spell_table) do--for all spells in spell table
		local name,_,_ = GetSpellInfo(ability.spellID)
		local btn = CreateFrame("Frame",nil,bar)
		btn:SetWidth(30)--create the frame and set the dimensions
		btn:SetHeight(30)
		
		if JukedDB[CharIndex].prio and isPrio(name) then
			btn:SetPoint("CENTER",bar,"CENTER",x2,y2)
		else
			btn:SetPoint("CENTER",bar,"CENTER",x,y)
		end
			
		btn:SetFrameStrata("LOW")
		local cd = CreateFrame("Cooldown",nil,btn)
		cd.noomnicc = not JukedDB[CharIndex].noCD
		cd.noOCC = not JukedDB[CharIndex].noCD
		cd.noCooldownCount = not JukedDB[CharIndex].noCD
		
		cd:SetAllPoints(true)
		cd:SetFrameStrata("LOW")
		cd:Hide()
		
		local texture = btn:CreateTexture(nil,"BACKGROUND")
		texture:SetAllPoints(true)
		texture:SetTexture(abilities[name].icon)
		texture:SetTexCoord(0.07,0.9,0.07,0.90)
	
		local text = cd:CreateFontString(nil,"ARTWORK")
		text:SetFont(STANDARD_TEXT_FONT,18,"OUTLINE")
		text:SetTextColor(1,1,0,1)
		text:SetPoint("LEFT",btn,"LEFT",1,0)
		
		btn.texture = texture
		btn.text = text
		btn.duration = abilities[name].duration
		btn.cd = cd
		
		if JukedDB[CharIndex].prio and isPrio(name) then
			bar2[name] = btn
			if (JukedDB[CharIndex].prioOnly and not isPrio(name)) then bar2[name]:Hide() end
			x2 = x2 + 30 * JukedDB[CharIndex].growLeft
			count2 = count2 + 1
			totalIcons = totalIcons + 1
			if count2 >= JukedDB[CharIndex].colsPrio and JukedDB[CharIndex].colsPrio > 0 then
				y2 = y2 - 30 * JukedDB[CharIndex].growUp
				x2 = 15+((JukedDB[CharIndex].colsPrio/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].colsPrio/2-1)*-30*((JukedDB[CharIndex].growLeft-1)/2))
				count2=0
			end
		else
			bar[name] = btn
			if (JukedDB[CharIndex].prioOnly and not isPrio(name)) then bar[name]:Hide() end
			x = x + 30 * JukedDB[CharIndex].growLeft
			count = count + 1
			totalIcons = totalIcons + 1
			if count >= JukedDB[CharIndex].cols and JukedDB[CharIndex].cols > 0 then
				y = y - 30 * JukedDB[CharIndex].growUp
				x = 15+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft-1)/2))
				count=0
			end
		end
	end
	x = 15+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft-1)/2))
	count=0
	y=0
	active=0
	x2 = 15+((JukedDB[CharIndex].colsPrio/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].colsPrio/2-1)*-30*((JukedDB[CharIndex].growLeft-1)/2))
	count2=0
	y2=0
end

local function Juked_AddIcon(ability)
	if (JukedDB[CharIndex].prioOnly and not isPrio(ability)) then return end
	if JukedDB[CharIndex].prio and isPrio(ability) then
		if not bar2[ability]:IsVisible() then
			bar2[ability]:SetPoint("CENTER",bar2,x2,y2)
			bar2[ability]:Show()
			x2 = x2 + 30 * JukedDB[CharIndex].growLeft
			count2 = count2 + 1
			if count2 >= JukedDB[CharIndex].colsPrio and JukedDB[CharIndex].colsPrio > 0 then
				y2 = y2 - 30 * JukedDB[CharIndex].growUp
				x2 = 15+((JukedDB[CharIndex].colsPrio/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].colsPrio/2-1)*-30*((JukedDB[CharIndex].growLeft-1)/2))
				count2=0
			end
		end
	else
		if not bar[ability]:IsVisible() then
			bar[ability]:SetPoint("CENTER",bar,x,y)
			bar[ability]:Show()
			x = x + 30 * JukedDB[CharIndex].growLeft
			count = count + 1
			if count >= JukedDB[CharIndex].cols and JukedDB[CharIndex].cols > 0 then
				y = y - 30 * JukedDB[CharIndex].growUp
				x = 15+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft-1)/2))
				count=0
			end
		end
	end
		local main=getTotalMain()
	if JukedDB[CharIndex].cols == 0 then
		bar:SetWidth(30*main)
	else
		bar:SetWidth(30*JukedDB[CharIndex].cols)
	end
	local numprio=getTotalPrio()
	if JukedDB[CharIndex].prio then
		if JukedDB[CharIndex].colsPrio == 0 then
			bar2:SetWidth(30*numprio)
		else
			bar2:SetWidth(30*JukedDB[CharIndex].colsPrio)
		end
	end
end


local function Juked_SavePosition()
	local point, _, relativePoint, xOfs, yOfs = bar:GetPoint()
	if not JukedDB[CharIndex].Position then 
		JukedDB[CharIndex].Position = {}
	end
	--first bar
	JukedDB[CharIndex].Position.point = point
	JukedDB[CharIndex].Position.relativePoint = relativePoint
	JukedDB[CharIndex].Position.xOfs = xOfs
	JukedDB[CharIndex].Position.yOfs = yOfs
	--second bar
	local point, _, relativePoint, xOfs, yOfs = bar2:GetPoint()
	JukedDB[CharIndex].Position.point2 = point
	JukedDB[CharIndex].Position.relativePoint2 = relativePoint
	JukedDB[CharIndex].Position.xOfs2 = xOfs
	JukedDB[CharIndex].Position.yOfs2 = yOfs
end

local function Juked_LoadPosition()
	if JukedDB[CharIndex].Position then
		bar:SetPoint(JukedDB[CharIndex].Position.point,UIParent,JukedDB[CharIndex].Position.relativePoint,JukedDB[CharIndex].Position.xOfs,JukedDB[CharIndex].Position.yOfs)
	else
		bar:SetPoint("CENTER", UIParent, "CENTER")
	end
	if JukedDB[CharIndex].Position and JukedDB[CharIndex].Position.point2 then
		bar2:SetPoint(JukedDB[CharIndex].Position.point2,UIParent,JukedDB[CharIndex].Position.relativePoint2,JukedDB[CharIndex].Position.xOfs2,JukedDB[CharIndex].Position.yOfs2)
	else
		bar2:SetPoint("CENTER", UIParent, "CENTER")
	end
end

local function Juked_Repos()
	if (JukedDB[CharIndex].bgOnly and not bg and JukedDB[CharIndex].arenaOnly and not arena) or (not JukedDB[CharIndex].bgOnly and JukedDB[CharIndex].arenaOnly and not arena) or (not JukedDB[CharIndex].arenaOnly and JukedDB[CharIndex].bgOnly and not bg) then return end
	if not JukedDB[CharIndex].smart then
		x = 15+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft-1)/2))
		count=0
		y=0
		for _,v in ipairs(spell_table) do
		local name, _, _ = GetSpellInfo(v.spellID)
			if not (JukedDB[CharIndex].prio and isPrio(name)) then
				local name,_,_ = GetSpellInfo(v.spellID)
				bar[name]:Hide()
				Juked_AddIcon(name)
				if JukedDB[CharIndex].hidden and not activetimers[name] then
					bar[name]:Hide()
				end
			end
		end
	else 
		if JukedDB[CharIndex].hidden then
			x = 15+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft-1)/2))
			count=0
			y=0
		end
		for _,v in ipairs(spell_table) do
		local name, _, _ = GetSpellInfo(v.spellID)
			if not(isPrio(name) and JukedDB[CharIndex].prio) then
				bar[name]:Hide()
				if activetimers[name] then
					Juked_AddIcon(name)
				else 
					if JukedDB[CharIndex].hidden then
						bar[name]:Hide()
					end
				end
			end
		end
	end
	if JukedDB[CharIndex].prio then
		if not JukedDB[CharIndex].smartPrio then
			x2 = 15+((JukedDB[CharIndex].colsPrio/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].colsPrio/2-1)*-30*((JukedDB[CharIndex].growLeft-1)/2))
			count2 = 0
			y2 = 0
			for _,v in ipairs(spell_table) do
			local name, _, _ = GetSpellInfo(v.spellID)
				if JukedDB[CharIndex].prio and isPrio(name) then
					bar2[name]:Hide()
					Juked_AddIcon(name)
					if JukedDB[CharIndex].hidden2 and not activetimers[name] then
						bar2[k]:Hide()
					end
				end
			end
		else
			if JukedDB[CharIndex].hidden2 then
				x2 = 15+((JukedDB[CharIndex].colsPrio/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].colsPrio/2-1)*-30*((JukedDB[CharIndex].growLeft-1)/2))
				count2 = 0
				y2 = 0
			end
			for _,v in ipairs(spell_table) do
			local name, _, _ = GetSpellInfo(v.spellID)
				if JukedDB[CharIndex].prio and isPrio(name) and JukedDB[CharIndex].hidden2 then
					bar2[k]:Hide()
					if activetimers[name] then
						Juked_AddIcon(name)
					else
						if JukedDB[CharIndex].hidden2 then
							bar2[name]:Hide()
						end
					end
				end
			end
		end
	end
end

local function Juked_UpdateBar()
	bar:SetScale(JukedDB[CharIndex].scale)
	bar2:SetScale(JukedDB[CharIndex].scale2)
	
	local main=getTotalMain()
	local numprio=getTotalPrio()
	if JukedDB[CharIndex].cols == 0 then
		bar:SetWidth(30*main)
	else
		bar:SetWidth(30*JukedDB[CharIndex].cols)
	end
	if JukedDB[CharIndex].prio then
		if JukedDB[CharIndex].colsPrio == 0 then
			bar2:SetWidth(30*numprio)
		else
			bar2:SetWidth(30*JukedDB[CharIndex].colsPrio)
		end
		bar2:Show()
	end
	if not JukedDB[CharIndex].prio then--if prio was disabled
		for _,v in ipairs(spell_table) do 
		local name, _, _ = GetSpellInfo(v.spellID)
			if isPrio(name) and bar2[name] then--if spell is prio and on currently on bar2
				bar[name]=bar2[name] --move the spell back to bar1
			end
		end
		bar2:Hide()--hide bar2
	elseif JukedDB[CharIndex].prio and table.getn(bar2) == 0 then--if prio is on and bar2 is empty
		for _,v in ipairs(spell_table) do
		local name, _, _ = GetSpellInfo(v.spellID)
			if JukedDB[CharIndex].prio and isPrio(name) then--if spell is prio and prio is on
				if bar[name] and not bar2[name] then
					bar2[name]=bar[name]--put spell on bar2
				end
			end
		end
	end
	--if bgonly mode is on, and not in a bg, or arenaonly and not in arena, or bgonly and arenaonly modes and not in bg or arena
	if (JukedDB[CharIndex].bgOnly and not bg and JukedDB[CharIndex].arenaOnly and not arena) or (not JukedDB[CharIndex].bgOnly and JukedDB[CharIndex].arenaOnly and not arena) or (not JukedDB[CharIndex].arenaOnly and JukedDB[CharIndex].bgOnly and not bg) then 
		for _,v in ipairs(spell_table) do
		local name, _, _ = GetSpellInfo(v.spellID)
			if JukedDB[CharIndex].prio and isPrio(name) then
				bar2[name]:Hide()--hide spells on prio and main bar
			else
				bar[name]:Hide()
			end
		end
		return
	end
	if JukedDB[CharIndex].hidden or JukedDB[CharIndex].hidden2 or JukedDB[CharIndex].smart or JukedDB[CharIndex].smartPrio then
		if JukedDB[CharIndex].smart or JukedDB[CharIndex].smartPrio then
			x = 15+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].cols/2)*-30*((JukedDB[CharIndex].growLeft-1)/2))
			count=0
			y=0
			x2 = 15+((JukedDB[CharIndex].colsPrio/2)*-30*((JukedDB[CharIndex].growLeft+1)/2))+((JukedDB[CharIndex].colsPrio/2-1)*-30*((JukedDB[CharIndex].growLeft-1)/2))
			y2 = 0
			count2 = 0
		end
		for _,v in ipairs(spell_table) do
		local name, _, _ = GetSpellInfo(v.spellID)
			if JukedDB[CharIndex].prio and isPrio(name) then
				if JukedDB[CharIndex].hidden2 or JukedDB[CharIndex].smartPrio then
					bar2[name]:Hide()--hide spells on bar2
				else
					bar2[name]:Show()
				end
				bar2[name].cd.noomnicc = not JukedDB[CharIndex].noCD
				bar2[name].cd.noOCC = not JukedDB[CharIndex].noCD--set correct flags to enable/disable omniCC 
				bar2[name].cd.noCooldownCount = not JukedDB[CharIndex].noCD
				bar2[name]:SetParent(bar2)
			else	
				if JukedDB[CharIndex].hidden or JukedDB[CharIndex].smart then
					bar[name]:Hide()--hide spells on main bar
				else
					bar[name]:Show()
				end
				bar[name].cd.noomnicc = not JukedDB[CharIndex].noCD
				bar[name].cd.noOCC = not JukedDB[CharIndex].noCD--set correct flags to enable/disable omniCC 
				bar[name].cd.noCooldownCount = not JukedDB[CharIndex].noCD
				bar[name]:SetParent(bar)
			end
		end
	else--if not hidden or smart
		for _,v in ipairs(spell_table) do
		local name, _, _ = GetSpellInfo(v.spellID)
			if JukedDB[CharIndex].prio and isPrio(name) then
				bar2[name]:Show() --show spell
				bar2[name].cd.noomnicc = not JukedDB[CharIndex].noCD
				bar2[name].cd.noOCC = not JukedDB[CharIndex].noCD--set correct flags to enable/disable omniCC 
				bar2[name].cd.noCooldownCount = not JukedDB[CharIndex].noCD
				bar2[name]:SetParent(bar2)
			else
				bar[name]:Show() 
				bar[name].cd.noomnicc = not JukedDB[CharIndex].noCD
				bar[name].cd.noOCC = not JukedDB[CharIndex].noCD
				bar[name].cd.noCooldownCount = not JukedDB[CharIndex].noCD
				bar[name]:SetParent(bar)
			end
		end
	end
	if JukedDB[CharIndex].prioOnly then--if prio only
		for _,v in ipairs(spell_table) do
		local name, _, _ = GetSpellInfo(v.spellID)
			if not isPrio(name) then--hide non-prio spells
				bar[name]:Hide()
			end
		end
	end
	if JukedDB[CharIndex].lock then--if bar is locked, disable mouse
		bar:EnableMouse(false)
	else--else, enable mouse
		bar:EnableMouse(true)
	end
	if JukedDB[CharIndex].lockPrio then
		bar2:EnableMouse(false)
	else
		bar2:EnableMouse(true)
	end
end

local function Juked_CreateBar()
	bar = CreateFrame("Frame", "jukedMainBar", UIParent)
	bar:SetMovable(true)
	bar:SetWidth(120)
	bar:SetHeight(30)
	bar:SetClampedToScreen(true) 
	bar:SetScript("OnMouseDown",function(self,button) if button == "LeftButton" then self:StartMoving() end end)
	bar:SetScript("OnMouseUp",function(self,button) if button == "LeftButton" then self:StopMovingOrSizing() Juked_SavePosition() end end)
	bar:Show()

	bar2 = CreateFrame("Frame", "jukedPrioBar", UIParent)
	bar2:SetMovable(true)
	bar2:SetWidth(120)
	bar2:SetHeight(30)
	bar2:SetClampedToScreen(true) 
	bar2:SetScript("OnMouseDown",function(self,button) if button == "LeftButton" then self:StartMoving() end end)
	bar2:SetScript("OnMouseUp",function(self,button) if button == "LeftButton" then self:StopMovingOrSizing() Juked_SavePosition() end end)
	bar2:Show()
	
	Juked_AddIcons()
	Juked_UpdateBar()
	Juked_LoadPosition()
end

local function Juked_UpdateText(text,cooldown)
if  JukedDB[CharIndex].noCD then return end
	if cooldown < 100 then 
		if cooldown <= 0.5 then
			text:SetText("")
		elseif cooldown < 10 then
			text:SetFormattedText(" %d",cooldown)
		else
			text:SetFormattedText("%d",cooldown)
		end
	else
		local m=floor((cooldown+30)/60)
		text:SetFormattedText("%dm",m)
	end
	if cooldown < 6 then 
		text:SetTextColor(1,0,0,1)
	else 
		text:SetTextColor(1,1,0,1) 
	end
end

local function Juked_StopAbility(ref,ability)
	if (JukedDB[CharIndex].hidden2 and isPrio(ability)) or (JukedDB[CharIndex].hidden and not isPrio(ability)) then
		if ref then
			ref:Hide()
		else
			if isPrio(ability) and JukedDB[CharIndex].prio then
				ref=bar2[ability]
			else
				ref=bar[ability]	
			end
		end
	end
	if activetimers[ability] then activetimers[ability] = nil end
	if ref then
		ref.text:SetText("")
		ref.cd:Hide()
	end
	if (JukedDB[CharIndex].hidden or JukedDB[CharIndex].hidden2) and (JukedDB[CharIndex].smart or JukedDB[CharIndex].smartPrio) then Juked_Repos() end
end

local time = 0
local function Juked_OnUpdate(self, elapsed)
	time = time + elapsed
	if time > 0.25 then
		getsize()
		for ability,ref in pairs(activetimers) do
			ref.cooldown = ref.start + ref.duration - GetTime()
			if ref.cooldown <= 0 then
				Juked_StopAbility(ref,ability)
			else 
				Juked_UpdateText(ref.text,floor(ref.cooldown+0.5))
			end
		end
		if size == 0 then frame:SetScript("OnUpdate",nil) end
		time = time - 0.25
	end
end

local function Juked_StartTimer(ref,ability)
	if (JukedDB[CharIndex].bgOnly and not bg and JukedDB[CharIndex].arenaOnly and not arena) or (not JukedDB[CharIndex].bgOnly and JukedDB[CharIndex].arenaOnly and not arena) or (not JukedDB[CharIndex].arenaOnly and JukedDB[CharIndex].bgOnly and not bg) then return end
	if JukedDB[CharIndex].hidden or JukedDB[CharIndex].hidden2 or JukedDB[CharIndex].smart or JukedDB[CharIndex].smartPrio then
		ref:Show()
	end
	local duration
	activetimers[ability] = ref
	ref.cd:Show()
	ref.cd:SetCooldown(GetTime()-0.40,ref.duration)
	ref.start = GetTime()
	Juked_UpdateText(ref.text,ref.duration)
	frame:SetScript("OnUpdate",Juked_OnUpdate)
end

local function Juked_COMBAT_LOG_EVENT_UNFILTERED(...)
	-- local timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, spellSchool, auraType
	local ability, useSecondDuration
	return function(timestamp, event, sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,id,spellName)
	if (band(sourceFlags, 0x00000040) == 0x00000040) and (event == "SPELL_CAST_SUCCESS" or eventtype == "SPELL_AURA_APPLIED") then 
			spellID = id
		else
			return
	end
		if (JukedDB[CharIndex].prioOnly and not isPrio(spellID)) then return end
		if (JukedDB[CharIndex].bgOnly and not bg and JukedDB[CharIndex].arenaOnly and not arena) or (not JukedDB[CharIndex].bgOnly and JukedDB[CharIndex].arenaOnly and not arena) or (not JukedDB[CharIndex].arenaOnly and JukedDB[CharIndex].bgOnly and not bg) then return end
		local cold_snap={31687,122,45438}
		local prep={26888,36554,26669, 11305}
		local readiness={19263,19503,34490}
		
		--local name,_,_ = GetSpellInfo(spellID)
		if spellID == 11958 then --cold snap 82676 Ring of Frost -- 44572 Deep Freeze -- 45438 Ice Block
			if JukedDB[CharIndex].prio and isPrio(ability) then
				for _,abil in ipairs(cold_snap) do
				local name = select(1, GetSpellInfo(abil))
					if activetimers[name] then
						Juked_StopAbility(bar2[name],name)
					end
				end
			else
				for _,abil in ipairs(cold_snap) do
				local name = select(1, GetSpellInfo(abil))
					if activetimers[name] then
						Juked_StopAbility(bar[name],name)
					end
				end
			end
		elseif spellID == 14185 then --prep
			if JukedDB[CharIndex].prio and isPrio(ability) then
				for _,abil in ipairs(prep) do
				local name = select(1, GetSpellInfo(abil))
					if activetimers[name] then
						Juked_StopAbility(bar2[name],name)
					end
				end
			else
				for _,abil in ipairs(prep) do
				local name = select(1, GetSpellInfo(abil))
					if activetimers[name] then
						Juked_StopAbility(bar[name],name)
					end
				end
			end
			--[[ 1766  Kick 1856  Vanish 36554 Shadowstep 76577 Smoke Bomb 51722 Dismantle
				Non tracked: Sprint, Smoke Bomb]]
		elseif spellID == 23989 then --readiness
			if JukedDB[CharIndex].prio and isPrio(ability) then
				for _,abil in ipairs(readiness) do
				local name = select(1, GetSpellInfo(abil))
					if activetimers[name] then
						Juked_StopAbility(bar2[name],name)
					end
				end
			else
				for _,abil in ipairs(readiness) do
				local name = select(1, GetSpellInfo(abil))
					if activetimers[name] then
						Juked_StopAbility(bar[name],name)
					end
				end
			end
		end
		useSecondDuration = false

		if abilities[spellName] then	
			if useSecondDuration and spellID == 16979 then
				if JukedDB[CharIndex].prio and isPrio(spellName) then
					bar2[spellName].duration=30
				else
					bar[spellName].duration=30
				end
			elseif spellID == 16979 then
				if JukedDB[CharIndex].prio and isPrio(spellName) then
					bar2[spellName].duration=15
				else
					bar[spellName].duration=15
				end
			end
			-- trigger CD after all exceptions have been handled
			if JukedDB[CharIndex].prio and isPrio(spellName) then
				if JukedDB[CharIndex].smartPrio then Juked_AddIcon(spellName) end
				Juked_StartTimer(bar2[spellName],spellName)
			else
				if JukedDB[CharIndex].smart then Juked_AddIcon(spellName) end
				Juked_StartTimer(bar[spellName],spellName)
			end
		end
	end	
end

Juked_COMBAT_LOG_EVENT_UNFILTERED = Juked_COMBAT_LOG_EVENT_UNFILTERED()


local function Juked_ResetAllTimers()
	for _,ability in ipairs(spell_table) do
		local name, _, _ = GetSpellInfo(ability.spellID)
		if JukedDB[CharIndex].prio and isPrio(name) then
			Juked_StopAbility(bar2[name],name)
		else
			Juked_StopAbility(bar[name],name)
		end
	end
	if not (JukedDB[CharIndex].smart or JukedDB[CharIndex].smartPrio) and not ((JukedDB[CharIndex].smart or JukedDB[CharIndex].smartPrio) and (JukedDB[CharIndex].hidden or JukedDB[CharIndex].hidden2)) then
		Juked_Repos()
	end

end

local function Juked_Reset()
	JukedDB[CharIndex] = JukedDB[CharIndex] or { scale = 1,scale2=1, hidden = false,hidden2=false, smart=false,smartPrio=false,prio = false, cols=6, colsPrio=6, arenaOnly=false, bgOnly=false, lock = false,lockPrio=false,growUp=1,growLeft=-1 ,noCD=false,prioOnly=false}
	Juked_ResetAllTimers()
	Juked_UpdateBar()
	Juked_LoadPosition()
end

local function Juked_PLAYER_ENTERING_WORLD(self)
	arena=isInArena()
	bg=isInBG()
	Juked_Reset()
end

local function Juked_Test()
	if (JukedDB[CharIndex].smart or JukedDB[CharIndex].smartPrio) and (JukedDB[CharIndex].hidden or JukedDB[CharIndex].hidden2) then 
		Juked_Repos()
	end
	if JukedDB[CharIndex].prioOnly then 
		for _,ability in ipairs(spell_table) do
			local name, _, _ = GetSpellInfo(ability.spellID)
			if isPrio(name) then
				if JukedDB[CharIndex].smartPrio then Juked_AddIcon(name) end
				if JukedDB[CharIndex].prio then
					Juked_StartTimer(bar2[name],name)
				else
					Juked_StartTimer(bar[name],name)
				end
			end
		end
	else
		for _,ability in ipairs(spell_table) do
		local name, _, _ = GetSpellInfo(ability.spellID)
			if JukedDB[CharIndex].prio and isPrio(name) then
				if JukedDB[CharIndex].smartPrio then Juked_AddIcon(name) end
				Juked_StartTimer(bar2[name],bane)
			else
			if JukedDB[CharIndex].smart then Juked_AddIcon(name) end
				Juked_StartTimer(bar[name],name)
			end
		end
	end
end


local cmdfuncs = {
	status = function() 
		ChatFrame1:AddMessage("Scale - Main Bar(1) = "..JukedDB[CharIndex].scale.."  Prio Bar(2) = "..JukedDB[CharIndex].scale2,0,1,1)
		local cd="Disabled"
		if (JukedDB[CharIndex].hidden) then cd="Enabled"; end
		ChatFrame1:AddMessage("Hidden(1) - "..cd,0,1,1)
		cd="Disabled"
		if (JukedDB[CharIndex].hidden2) then cd="Enabled"; end
		ChatFrame1:AddMessage("Hidden(2) - "..cd,0,1,1)
		cd="Disabled"
		if (JukedDB[CharIndex].smart) then cd="Enabled"; end
		ChatFrame1:AddMessage("Smart(1) - "..cd,0,1,1)
		cd="Disabled"
		if (JukedDB[CharIndex].smartPrio) then cd="Enabled"; end
		ChatFrame1:AddMessage("Smart(2) - "..cd,0,1,1)
		cd="unlocked"
		if (JukedDB[CharIndex].lock) then cd="locked"; end
		ChatFrame1:AddMessage("Locked(1) - "..cd,0,1,1)
		cd="unlocked"
		if (JukedDB[CharIndex].lockPrio) then cd="locked"; end
		ChatFrame1:AddMessage("Locked(2) - "..cd,0,1,1)
		cd="Disabled"
		if (JukedDB[CharIndex].prio) then cd="Enabled"; end
		ChatFrame1:AddMessage("Prio - "..cd,0,1,1)
		cd="Disabled"
		if (JukedDB[CharIndex].arenaOnly) then cd="Enabled"; end
		ChatFrame1:AddMessage("ArenaOnly - "..cd,0,1,1)
		cd="Disabled"
		if (JukedDB[CharIndex].bgOnly) then cd="Enabled"; end
		ChatFrame1:AddMessage("BGOnly - "..cd,0,1,1)
		cd="growing down"
		if (JukedDB[CharIndex].growUp==-1) then cd="growing up"; end
		ChatFrame1:AddMessage("Cooldowns are "..cd.." from the anchor",0,1,1)
		cd="Disabled"
		cd="growing right"
		if (JukedDB[CharIndex].growLeft==-1) then cd="growing left"; end
		ChatFrame1:AddMessage("Cooldowns are "..cd.." from the anchor",0,1,1)
		cd="Disabled"
		if (not JukedDB[CharIndex].noCD) then cd="Enabled"; end
		ChatFrame1:AddMessage("Juked cooldown display is "..cd,0,1,1)
		cd="all spell cooldowns"
		if (JukedDB[CharIndex].prioOnly) then cd="ONLY priority cooldowns"; end
		ChatFrame1:AddMessage("Displaying "..cd.."(PrioOnly mode="..tostring(JukedDB[CharIndex].prioOnly)..")",0,1,1)
		ChatFrame1:AddMessage("Columns per row:  Main Bar(1) = "..JukedDB[CharIndex].cols.."  Prio Bar(2) = "..JukedDB[CharIndex].colsPrio,0,1,1)
	end,
	scale = function(id,v,from) 
		if not id or not v then 
			ChatFrame1:AddMessage("USAGE: scale <bar ID> <number>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			ChatFrame1:AddMessage("Current settings: Main Bar(1) = "..JukedDB[CharIndex].scale.."  Prio Bar(2) = "..JukedDB[CharIndex].scale2,0,1,0)
			return
		end
		if ((id == 1 or id == 2) and v >= 0) then 
			if id==1 then
				JukedDB[CharIndex].scale = v
			elseif id == 2 then
				JukedDB[CharIndex].scale2=v
			end
			if not from then
				ChatFrame1:AddMessage("Scale for bar"..id.." set to"..v,0,1,0)
			end
			Juked_UpdateBar()
			return
		end
		if not from then
			ChatFrame1:AddMessage("USAGE: scale <bar ID> <number>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			ChatFrame1:AddMessage("Current settings: Main Bar(1) = "..JukedDB[CharIndex].scale.."  Prio Bar(2) = "..JukedDB[CharIndex].scale2,0,1,0)
		end
	end,
	hidden = function(id,from) 
		if not id then 
			ChatFrame1:AddMessage("USAGE: hidden <bar ID>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			return
		end
		if ((id == 1 or id == 2)) then 
			local cd="Disabled"
			if id == 1 then
				JukedDB[CharIndex].hidden = not JukedDB[CharIndex].hidden
				if (JukedDB[CharIndex].hidden) then cd="Enabled"; end
			elseif id == 2 then
				JukedDB[CharIndex].hidden2 = not JukedDB[CharIndex].hidden2
				if (JukedDB[CharIndex].hidden2) then cd="Enabled"; end
			end
			if not from then
				ChatFrame1:AddMessage("Juked hidden("..id..") mode is now "..cd,0,1,1)
				ChatFrame1:AddMessage("Enabled = Spells are hidden when not on cooldown",0,1,0)
				ChatFrame1:AddMessage("Disabled = Spells are always visible",0,1,0)
				ChatFrame1:AddMessage("Note: If Smart & Hidden mode are enabled, the cooldowns realign to the anchor when off cooldown",0,1,0)
			end
			Juked_UpdateBar() 
			Juked_Repos() 
		end
	end,
	smart = function(id,from) 
		if not id then 
			ChatFrame1:AddMessage("USAGE: smart <bar ID>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			return
		end
		local cd="Disabled"
		if ((id == 1 or id == 2)) then 
			if id == 1 then
				JukedDB[CharIndex].smart = not JukedDB[CharIndex].smart
				if (JukedDB[CharIndex].smart) then cd="Enabled"; end
			elseif id == 2 then
				JukedDB[CharIndex].smartPrio = not JukedDB[CharIndex].smartPrio
				if (JukedDB[CharIndex].smartPrio) then cd="Enabled"; end
			end
		end
		if not from then
			ChatFrame1:AddMessage("Juked smart mode is now "..cd,0,1,1)
			ChatFrame1:AddMessage("Enabled = Spells are only displayed once used and in the order they're used",0,1,0)
			ChatFrame1:AddMessage("Disabled = Spells are always displayed in the same order",0,1,0)
			ChatFrame1:AddMessage("Note: If Smart & Hidden mode are enabled, the cooldowns realign to the anchor when off cooldown",0,1,0)
		end
		Juked_Reset() 
	end,
	lock = function(id,from) 
		if not id then 
			ChatFrame1:AddMessage("USAGE: lock <bar ID>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			return
		end
		if ((id == 1 or id == 2)) then 
			local cd="unlocked"
			if id == 1 then
				JukedDB[CharIndex].lock = not JukedDB[CharIndex].lock
				if (JukedDB[CharIndex].hidden) then cd="locked"; end
			elseif id == 2 then
				JukedDB[CharIndex].lockPrio = not JukedDB[CharIndex].lockPrio
				if (JukedDB[CharIndex].lockPrio) then cd="locked"; end
			end
			if not from then ChatFrame1:AddMessage("Juked bar"..id.." is now "..cd,0,1,1) end
		end
		if not from then
			ChatFrame1:AddMessage("Locked = Bars can't be moved",0,1,0)
			ChatFrame1:AddMessage("Unlocked = Bars can be moved",0,1,0)
		end
		Juked_UpdateBar()
	end,
	prio = function(from) 
		JukedDB[CharIndex].prio = not JukedDB[CharIndex].prio
		if not from then
			local cd="Disabled"
			if (JukedDB[CharIndex].prio) then cd="Enabled"; end
			ChatFrame1:AddMessage("Juked Prio bar is now "..cd,0,1,1)
			ChatFrame1:AddMessage("Enabled = A second bar is created, displaying priority spells",0,1,0)
			ChatFrame1:AddMessage("Disabled = Juked displays all spells on the main bar",0,1,0)
		end
		local temp1=JukedDB[CharIndex].smart
		local temp2=JukedDB[CharIndex].smartPrio

		Juked_UpdateBar()
		JukedDB[CharIndex].smartPrio=false
		JukedDB[CharIndex].smart=false
		Juked_Repos() 
		JukedDB[CharIndex].smart=temp1
		JukedDB[CharIndex].smartPrio=temp2
		Juked_UpdateBar()
	end,
	arenaonly = function(from) 
		JukedDB[CharIndex].arenaOnly = not JukedDB[CharIndex].arenaOnly
		if not from then 
			local cd="Disabled"
			if (JukedDB[CharIndex].arenaOnly) then cd="Enabled"; end
			ChatFrame1:AddMessage("Juked Arena Only mode is now "..cd,0,1,1)
			ChatFrame1:AddMessage("Enabled = Juked is displayed ONLY in Arenas",0,1,0)
			ChatFrame1:AddMessage("Disabled = Juked is displayed outside of Arenas",0,1,0)
			ChatFrame1:AddMessage("Note: If BGOnly & ArenaOnly are enabled, it will work in Arenas and BGs",0,1,0)
		end
		Juked_Reset() 
	end,
	bgonly = function(from) 
		JukedDB[CharIndex].bgOnly = not JukedDB[CharIndex].bgOnly
		if not from then 
			local cd="Disabled"
			if (JukedDB[CharIndex].bgOnly) then cd="Enabled"; end
			ChatFrame1:AddMessage("Juked BG Only mode is now "..cd,0,1,1)
			ChatFrame1:AddMessage("Enabled = Juked is displayed ONLY in Battlegrounds",0,1,0)
			ChatFrame1:AddMessage("Disabled = Juked is displayed outside of Battlegrounds",0,1,0)
			ChatFrame1:AddMessage("Note: If BGOnly & ArenaOnly are enabled, it will work in Arenas and BGs",0,1,0)
		end
		Juked_Reset() 
	end,
	growup=function(from) 		
		JukedDB[CharIndex].growUp=JukedDB[CharIndex].growUp*-1
		if not from then 
			local text="growing down"
			if (JukedDB[CharIndex].growUp==-1) then text="growing up"; end
			ChatFrame1:AddMessage("Juked cooldowns are "..text.." from the anchor",0,1,1)
		end
		Juked_Repos()
		end,
	growleft=function(from) 		
		JukedDB[CharIndex].growLeft=JukedDB[CharIndex].growLeft*-1
		if not from then 
			local text="growing right"
			if (JukedDB[CharIndex].growLeft==-1) then text="growing left"; end
			ChatFrame1:AddMessage("Juked cooldows are "..text.." from the anchor",0,1,1)
		end
		Juked_Repos()
		end,
	nocd=function(from) 
		JukedDB[CharIndex].noCD = not JukedDB[CharIndex].noCD
		if not from then 
			local cd="Disabled"
			if (not JukedDB[CharIndex].noCD) then cd="Enabled"; end
			ChatFrame1:AddMessage("Juked cooldown display is now "..cd,0,1,1)
			ChatFrame1:AddMessage("Enabled = Juked displays text",0,1,0)
			ChatFrame1:AddMessage("Disabled = Juked displays no text, OmniCC can be used",0,1,0)
		end
		Juked_Reset()
	end,
	prioonly=function(from)
		JukedDB[CharIndex].prioOnly=not JukedDB[CharIndex].prioOnly
		if not from then
			local cd="all spell cooldowns"
			if (JukedDB[CharIndex].prioOnly) then cd="ONLY priority cooldowns"; end
			ChatFrame1:AddMessage("Juked is now displaying "..cd,0,1,1)
		end
		Juked_Reset()  
	end,
	opts=function()
		InterfaceOptionsFrame_OpenToFrame(Juked.mainpanel);
	end,
	gui=function()
		InterfaceOptionsFrame_OpenToFrame(Juked.mainpanel);
	end,
	config=function()
		InterfaceOptionsFrame_OpenToFrame(Juked.mainpanel);
	end,
	cols = function(id,v,from) 
		if not id or not v then 
			ChatFrame1:AddMessage("USAGE: cols <bar ID> <number>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			ChatFrame1:AddMessage("Current settings: Main Bar(1) = "..JukedDB[CharIndex].cols.."  Prio Bar(2) = "..JukedDB[CharIndex].colsPrio,0,1,0)
			return
		end
		if ((id == 1 or id == 2) and v >= 0) then 
			if id==1 then
				if (v==0) then
					JukedDB[CharIndex].cols = getTotalMain()
				else
					JukedDB[CharIndex].cols = v
				end
			elseif id==2 then
				if (v==0) then
					JukedDB[CharIndex].colsPrio = getTotalPrio()
				else
					JukedDB[CharIndex].colsPrio = v
				end
			end
			if not from then
				ChatFrame1:AddMessage("Cols for bar"..id.." set to "..v,0,1,0)
			end
			Juked_Repos()
			return	
		end
		if not from then
			ChatFrame1:AddMessage("USAGE: /juked cols <bar ID> <number>",0,1,0)
			ChatFrame1:AddMessage("Bar IDs: Main bar = 1   Prio Bar = 2",0,1,0)
			ChatFrame1:AddMessage("Current settings: Main Bar(1) = "..JukedDB[CharIndex].cols.."  Prio Bar(2) = "..JukedDB[CharIndex].colsPrio,0,1,0)
			ChatFrame1:AddMessage("Example: set main bar cols to 6: /juked cols 1 6",0,1,0)
		end
	end,
	reset = function() Juked_Reset() end,
	test = function() Juked_Test() end,
}

local cmdtbl = {}
function Juked_Command(cmd)
	for k in ipairs(cmdtbl) do
		cmdtbl[k] = nil
	end
	for v in gmatch(cmd, "[%d|%a|.]+") do
		tinsert(cmdtbl, v)
	end
  local cb = cmdfuncs[cmdtbl[1]] 
  if cb then
  	local s = tonumber(cmdtbl[2])
  	local ss = tonumber(cmdtbl[3])
  	cb(s,ss)
  else
	ChatFrame1:AddMessage("Juked Help",0,1,0)
	ChatFrame1:AddMessage("config - Display current value of options",0,1,0)
	ChatFrame1:AddMessage("scale <bar ID> <number> - Sets the scale factor for the given bar",0,1,0)
  	ChatFrame1:AddMessage("hidden <bar ID> (toggle) - Hides spell icons when off cooldown",0,1,0)
	ChatFrame1:AddMessage("smart <bar ID>(toggle) - Only show CD when used",0,1,0)
  	ChatFrame1:AddMessage("lock <bar ID>(toggle) - Locks the bars in place",0,1,0)
	ChatFrame1:AddMessage("growup (toggle) - The icons grow upwards from the anchor if enabled",0,1,0)
	ChatFrame1:AddMessage("growleft (toggle) - The icons grow left from the anchor if enabled",0,1,0)
	ChatFrame1:AddMessage("prio (toggle) - Displays second anchor with priority spells",0,1,0)
	ChatFrame1:AddMessage("arenaonly (toggle) - Only display cooldowns if in an arena",0,1,0)
	ChatFrame1:AddMessage("bgonly (toggle) - Only display cooldowns if in a battleground",0,1,0)
	ChatFrame1:AddMessage("prioonly (toggle) - Only displays priority cooldowns",0,1,0)
	ChatFrame1:AddMessage("nocd (toggle) - Disables the Juked cooldown text and allows omniCC",0,1,0)
	ChatFrame1:AddMessage("cols <bar ID> <num> (0 = 1 row) - Set number of spells per row for the given bar",0,1,0)
  	ChatFrame1:AddMessage("test - Activates all cooldowns to test Juked",0,1,0)
  	ChatFrame1:AddMessage("reset - Resets all cooldowns",0,1,0)
  end
end

local function Juked_OnLoad(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	if not JukedDB then
		JukedDB={}
	end
	JukedDB["Default"]= JukedDB["Default"] or { scale = 1, scale2 = 1, hidden = true, hidden2 = true, smart = true, smartPrio=true, prio = false, cols=6, colsPrio=6, arenaOnly=false, bgOnly=false, lock = false,growUp=1,growLeft=1, noCD=false,prioOnly=false,}
	JukedDB["CharsUse"]=JukedDB["CharsUse"] or {}
	
	if (JukedDB["CharsUse"][CharIndex]) then
		if (JukedDB[JukedDB["CharsUse"][CharIndex]]) then
			CharIndex=JukedDB["CharsUse"][CharIndex]
		else
			JukedDB["CharsUse"][CharIndex]=CharIndex
			if not JukedDB[CharIndex] then
				JukedDB[CharIndex]=JukedDB["Default"]
			end
		end	
	else
		JukedDB["CharsUse"][CharIndex]=CharIndex
		if not JukedDB[CharIndex] then
			JukedDB[CharIndex]=JukedDB["Default"]
		end
	end
	for k,v in pairs(JukedDB) do
		if not (type(JukedDB[k]) == "table" ) then 
			JukedDB[k]=nil
		elseif (k=="Position" and (JukedDB["Position"]["scale2"]==nil)) then 
			JukedDB[k]=nil
		end
	end
	
	Juked_CreateBar()
	Juked_SavePosition()
	
	SlashCmdList["Juked"] = Juked_Command
	SLASH_Juked1 = "/juked"
	SLASH_Juked2 = "/jd"
	SLASH_Juked3 = "/ib"
	ChatFrame1:AddMessage("Juked by Robrman, inspired by Kollektiv's InterruptBar. Type /juked or /jd for options.",0,1,0)
end

local eventhandler = {
	["VARIABLES_LOADED"] = function(self) Juked_OnLoad(self) end,
	["PLAYER_ENTERING_WORLD"] = function(self) Juked_PLAYER_ENTERING_WORLD(self) end,
	["COMBAT_LOG_EVENT_UNFILTERED"] = function(self,...) Juked_COMBAT_LOG_EVENT_UNFILTERED(...) end,
}

local function Juked_OnEvent(self,event,...)
	eventhandler[event](self,...)
end

frame = CreateFrame("Frame","jukedMainFrame",UIParent)
frame:SetScript("OnEvent",Juked_OnEvent)
frame:RegisterEvent("VARIABLES_LOADED")

Juked = {};
Juked.mainpanel = CreateFrame( "Frame", "JukedMainPanel", UIParent );
Juked.mainpanel.name = "Juked";
local title = Juked.mainpanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 20, -10)
title:SetText("Juked")
local subtitle = Juked.mainpanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetPoint("RIGHT", Juked.mainpanel, -32, 0)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("General options for Juked")

local buttonPositionY = -60;
local buttonPositionX = 20;

local t = {"prio","prioOnly","arenaOnly","bgOnly","nocd","growLeft","growUp"};
local general_cmd_table={cmdfuncs["prio"],cmdfuncs["prioonly"],cmdfuncs["arenaonly"],cmdfuncs["bgonly"],cmdfuncs["nocd"],cmdfuncs["growleft"],cmdfuncs["growup"]};
local t2 = {"Show Priority bar","Priority Bar Only", "Display Only in Arenas","Display Only in Battlegrounds","Hide Juked cooldown time","Grow icons left from the anchor","Grow icons up from the anchor"};
for i,v in ipairs (t) do
	local Juked_IconOptions_CheckButton = CreateFrame("CheckButton", "JUKED_Button_"..v, Juked.mainpanel, "OptionsCheckButtonTemplate");
	Juked_IconOptions_CheckButton:SetPoint("TOPLEFT",buttonPositionX,buttonPositionY);
	getglobal(Juked_IconOptions_CheckButton:GetName().."Text"):SetText(t2[i]);

	local function Juked_IconOptions_CheckButton_OnClick()
			general_cmd_table[i](1,"gui")
	end

	local function Juked_IconOptions_CheckButton_OnShow()
		if (v == "growLeft" or v == "growUp") then
			Juked_IconOptions_CheckButton:SetChecked(JukedDB[CharIndex][v]==-1);
		else
			Juked_IconOptions_CheckButton:SetChecked(JukedDB[CharIndex][v]);
		end
	end

	Juked_IconOptions_CheckButton:RegisterForClicks("AnyUp");
	Juked_IconOptions_CheckButton:SetScript("OnClick", Juked_IconOptions_CheckButton_OnClick);
	Juked_IconOptions_CheckButton:SetScript("OnShow", Juked_IconOptions_CheckButton_OnShow);
	buttonPositionY = buttonPositionY - 30;
end

-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(Juked.mainpanel);
-- Make a child panel
Juked.mainbarpanel = CreateFrame( "Frame", "MainBarPanel", Juked.mainpanel);
Juked.mainbarpanel.name = "Main Bar";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
Juked.mainbarpanel.parent = Juked.mainpanel.name;
			
local title = Juked.mainbarpanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 20, -10)
title:SetText("Main Bar Options")

local subtitle = Juked.mainbarpanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetPoint("RIGHT", Juked.mainbarpanel, -32, 0)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Options for Juked Main Bar")	

buttonPositionY = -60;
buttonPositionX = 20;

-- Main bar options
local t = {"hidden","smart","lock"};
local bar_cmd_table={cmdfuncs["hidden"],cmdfuncs["smart"],cmdfuncs["lock"]};
local t2 = {"Hide Icons","Smart", "Lock frame"};
for i,v in ipairs (t) do
	local Juked_IconOptions_CheckButton = CreateFrame("CheckButton", "JUKED_Button_"..v, Juked.mainbarpanel, "OptionsCheckButtonTemplate");
	Juked_IconOptions_CheckButton:SetPoint("TOPLEFT",buttonPositionX,buttonPositionY);
	getglobal(Juked_IconOptions_CheckButton:GetName().."Text"):SetText(t2[i]);

	local function Juked_IconOptions_CheckButton_OnClick()
			bar_cmd_table[i](1,"gui")
	end

	local function Juked_IconOptions_CheckButton_OnShow()
		Juked_IconOptions_CheckButton:SetChecked(JukedDB[CharIndex][v]);
	end

	Juked_IconOptions_CheckButton:RegisterForClicks("AnyUp");
	Juked_IconOptions_CheckButton:SetScript("OnClick", Juked_IconOptions_CheckButton_OnClick);
	Juked_IconOptions_CheckButton:SetScript("OnShow", Juked_IconOptions_CheckButton_OnShow);
	buttonPositionY = buttonPositionY - 30;
end
local tsliders = {"cols","scale"};
local slider_table={cmdfuncs["cols"],cmdfuncs["scale"]};
local slidert2 = {"Number of cols","Scale (default 1.0)" };
buttonPositionY = buttonPositionY - 30;
for i,v in ipairs (tsliders) do
	local Juked_IconOptions_Slider = CreateFrame("Slider", "Juked_Slider_"..v, Juked.mainbarpanel, "OptionsSliderTemplate");
	Juked_IconOptions_Slider:SetPoint("TOPLEFT",buttonPositionX,buttonPositionY);
	getglobal(Juked_IconOptions_Slider:GetName() .. 'Low'):SetText('-');
	getglobal(Juked_IconOptions_Slider:GetName() .. 'High'):SetText('+');
	getglobal(Juked_IconOptions_Slider:GetName() .. 'Text'):SetText(slidert2[i].."\nValue: "..JukedDB[CharIndex][v]);

	if (v == "cols") then
		Juked_IconOptions_Slider:SetMinMaxValues(0,#(spell_table));
		Juked_IconOptions_Slider:SetValueStep(1.0);
	elseif (v == "scale") then
		Juked_IconOptions_Slider:SetMinMaxValues(0.1,2.0);
		Juked_IconOptions_Slider:SetValueStep(0.1);
	end
	
	local function Juked_IconOptions_Slider_OnShow()
		Juked_IconOptions_Slider:SetValue(JukedDB[CharIndex][v]);
	end

	local function Juked_IconOptions_Slider_OnValueChanged()
		slider_table[i](1,Juked_IconOptions_Slider:GetValue(),"gui");
		getglobal(Juked_IconOptions_Slider:GetName() .. 'Text'):SetText(slidert2[i].."\nValue: "..JukedDB[CharIndex][v]);
	end

	Juked_IconOptions_Slider:SetScript("OnValueChanged", Juked_IconOptions_Slider_OnValueChanged);
	Juked_IconOptions_Slider:SetScript("OnShow", Juked_IconOptions_Slider_OnShow);
	buttonPositionY = buttonPositionY - 60;
end

InterfaceOptions_AddCategory(Juked.mainbarpanel);
-- Make a child panel
Juked.priobarpanel = CreateFrame( "Frame", "PrioBarPanel", Juked.mainpanel);
Juked.priobarpanel.name = "Prio Bar";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
Juked.priobarpanel.parent = Juked.mainpanel.name;

local title = Juked.priobarpanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 20, -10)
title:SetText("Prio Bar Options")

local subtitle = Juked.priobarpanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetPoint("RIGHT", Juked.priobarpanel, -32, 0)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Options for Juked Prio Bar")	

buttonPositionY = -60;
buttonPositionX = 20;
local priot = {"hidden2","smartPrio","lockPrio"};
for i,v in ipairs (priot) do
	local Juked_IconOptions_CheckButton = CreateFrame("CheckButton", "JUKED_Button_"..v, Juked.priobarpanel, "OptionsCheckButtonTemplate");
	Juked_IconOptions_CheckButton:SetPoint("TOPLEFT",buttonPositionX,buttonPositionY);
	getglobal(Juked_IconOptions_CheckButton:GetName().."Text"):SetText(t2[i]);

	local function Juked_IconOptions_CheckButton_OnClick()
			bar_cmd_table[i](2,"gui")
	end

	local function Juked_IconOptions_CheckButton_OnShow()
		Juked_IconOptions_CheckButton:SetChecked(JukedDB[CharIndex][v]);
	end

	Juked_IconOptions_CheckButton:RegisterForClicks("AnyUp");
	Juked_IconOptions_CheckButton:SetScript("OnClick", Juked_IconOptions_CheckButton_OnClick);
	Juked_IconOptions_CheckButton:SetScript("OnShow", Juked_IconOptions_CheckButton_OnShow);

	buttonPositionY = buttonPositionY - 30;
end
tsliders = {"colsPrio","scale2"};
buttonPositionY = buttonPositionY - 30;
for i,v in ipairs (tsliders) do
	local Juked_IconOptions_Slider = CreateFrame("Slider", "Juked_Slider_"..v, Juked.priobarpanel, "OptionsSliderTemplate");
	Juked_IconOptions_Slider:SetPoint("TOPLEFT",buttonPositionX,buttonPositionY);

	getglobal(Juked_IconOptions_Slider:GetName() .. 'Low'):SetText('-');
	getglobal(Juked_IconOptions_Slider:GetName() .. 'High'):SetText('+');
	getglobal(Juked_IconOptions_Slider:GetName() .. 'Text'):SetText(slidert2[i].."\nValue: "..JukedDB[CharIndex][v]);
	
	if (v == "colsPrio") then
		local val = getTotalPrio("gui");
		Juked_IconOptions_Slider:SetMinMaxValues(0,val+1);
		Juked_IconOptions_Slider:SetValueStep(1.0);
	elseif (v == "scale2") then
		
		Juked_IconOptions_Slider:SetMinMaxValues(0.1,2.0);
		Juked_IconOptions_Slider:SetValueStep(0.1);
	end
	
	local function Juked_IconOptions_Slider_OnShow()
		Juked_IconOptions_Slider:SetValue(JukedDB[CharIndex][v]);
	end

	local function Juked_IconOptions_Slider_OnValueChanged()
		slider_table[i](2,Juked_IconOptions_Slider:GetValue(),"gui");
		getglobal(Juked_IconOptions_Slider:GetName() .. 'Text'):SetText(slidert2[i].."\nValue: "..JukedDB[CharIndex][v]);
	end

	Juked_IconOptions_Slider:SetScript("OnValueChanged", Juked_IconOptions_Slider_OnValueChanged);
	Juked_IconOptions_Slider:SetScript("OnShow", Juked_IconOptions_Slider_OnShow);

	buttonPositionY = buttonPositionY - 60;
end
InterfaceOptions_AddCategory(Juked.priobarpanel);


-- Make a child panel
Juked.profilepanel = CreateFrame( "Frame", "ProfilePanel", Juked.mainpanel);
Juked.profilepanel.name = "Profiles";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
Juked.profilepanel.parent = Juked.mainpanel.name;

local title = Juked.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 20, -10)
title:SetText("Prio Bar Options")

local subtitle = Juked.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
subtitle:SetPoint("RIGHT", Juked.profilepanel, -32, 0)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Juked Profile Options")	

buttonPositionY = -60;
buttonPositionX = 20;
local UsingProfileLabel = Juked.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
UsingProfileLabel:SetHeight(32)
UsingProfileLabel:SetPoint("TOPLEFT", buttonPositionX,buttonPositionY)
UsingProfileLabel:SetNonSpaceWrap(true)
UsingProfileLabel:SetJustifyH("LEFT")
UsingProfileLabel:SetJustifyV("TOP")
UsingProfileLabel:SetText("Currently using: "..CharIndex)	


buttonPositionY=-100
local Juked_Options_EditBox = CreateFrame("EditBox", "Juked_NewProfile_NewID", Juked.profilepanel, "InputBoxTemplate");
Juked_Options_EditBox:SetPoint("TOPLEFT", buttonPositionX+5,buttonPositionY);
Juked_Options_EditBox:SetWidth(125);
Juked_Options_EditBox:SetHeight(32);
Juked_Options_EditBox:EnableMouse(true);
Juked_Options_EditBox:SetAutoFocus(false);
Juked_Options_EditBox_Text = Juked_Options_EditBox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall');
Juked_Options_EditBox_Text:SetPoint("TOPLEFT", -3, 10);
Juked_Options_EditBox_Text:SetText("New Profile Name");


-- New Profile Save Button
local Juked_CreateProfile_SaveButton = CreateFrame("Button", "Juked_ProfileSaveButton",Juked.profilepanel, "OptionsButtonTemplate");
Juked_CreateProfile_SaveButton:SetPoint("TOPLEFT",buttonPositionX+130,buttonPositionY-5);
Juked_CreateProfile_SaveButton:SetWidth(50);
Juked_CreateProfile_SaveButton:SetHeight(21);
Juked_CreateProfile_SaveButton:SetText("Save");

local function CreateNewProfile()
	JukedDB[Juked_Options_EditBox:GetText()]=JukedDB[Juked_Options_EditBox:GetText()] or { scale = 1,scale2=1 , hidden = false,hidden2=false, smart=false, smartPrio=false,prio = false, cols=6, colsPrio=6, arenaOnly=false, bgOnly=false, lock = false,growUp=1,growLeft=1, noCD=false,prioOnly=false,}
	Juked_Options_EditBox:SetText("")
end
Juked_CreateProfile_SaveButton:SetScript("OnClick", CreateNewProfile)


buttonPositionX = buttonPositionX+195
buttonPositionY = -100
local subtitle = Juked.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", buttonPositionX+10,buttonPositionY+15)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Use Profile...")
if not DropDownMenuUse then
   CreateFrame("Button", "DropDownMenuUse", Juked.profilepanel, "UIDropDownMenuTemplate")
end
 
DropDownMenuUse:ClearAllPoints()
DropDownMenuUse:SetPoint("TOPLEFT", buttonPositionX-10, buttonPositionY)
DropDownMenuUse:Show()
 
local items = {}

local function OnClick(self)
   UIDropDownMenu_SetSelectedID(DropDownMenuUse, self:GetID())
   JukedDB["CharsUse"][JukedChar.." - "..JukedRealm]=self:GetText()
   CharIndex=self:GetText()
   UsingProfileLabel:SetText("Currently using: "..CharIndex)
   Juked_Reset()
end
 
local function initialize(self, level)
items = {};
 	for k,v in pairs(JukedDB) do
		if (type(JukedDB[k]) == "table" and not(k =="CharsUse")) then table.insert(items,k) end
	end
   local info = UIDropDownMenu_CreateInfo()
   for k,v in pairs(items) do
      info = UIDropDownMenu_CreateInfo()
      info.text = v
      info.value = v
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end

UIDropDownMenu_Initialize(DropDownMenuUse, initialize)
UIDropDownMenu_SetWidth(DropDownMenuUse, 160);
UIDropDownMenu_SetButtonWidth(DropDownMenuUse, 180)
UIDropDownMenu_SetSelectedID(DropDownMenuUse, 1)
UIDropDownMenu_JustifyText(DropDownMenuUse, "LEFT")

buttonPositionX = 5
buttonPositionY = buttonPositionY -60

local subtitle = Juked.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", buttonPositionX+20,buttonPositionY+15)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Copy From...")

if not DropDownMenuCopy then
   CreateFrame("Button", "DropDownMenuCopy", Juked.profilepanel, "UIDropDownMenuTemplate")
end

DropDownMenuCopy:ClearAllPoints()
DropDownMenuCopy:SetPoint("TOPLEFT", buttonPositionX, buttonPositionY)
DropDownMenuCopy:Show()
 
local function OnClick(self)
   UIDropDownMenu_SetSelectedID(DropDownMenuCopy, self:GetID())
   JukedDB[JukedChar.." - "..JukedRealm]=JukedDB[self:GetText()]
   CharIndex=JukedChar.." - "..JukedRealm
   UsingProfileLabel:SetText("Currently using: "..CharIndex)
   Juked_Reset()
end
 
local function initialize(self, level)
items = {};
 	for k,v in pairs(JukedDB) do
		if (type(JukedDB[k]) == "table" and not(k =="CharsUse")) then table.insert(items,k) end
	end
   local info = UIDropDownMenu_CreateInfo()
   for k,v in pairs(items) do
      info = UIDropDownMenu_CreateInfo()
      info.text = v
      info.value = v
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end
 
UIDropDownMenu_Initialize(DropDownMenuCopy, initialize)
UIDropDownMenu_SetWidth(DropDownMenuCopy, 160);
UIDropDownMenu_SetButtonWidth(DropDownMenuCopy, 180)
UIDropDownMenu_SetSelectedID(DropDownMenuCopy, 1)
UIDropDownMenu_JustifyText(DropDownMenuCopy, "LEFT")

buttonPositionX = buttonPositionX+220

local subtitle = Juked.profilepanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
subtitle:SetHeight(32)
subtitle:SetPoint("TOPLEFT", buttonPositionX,buttonPositionY+15)
subtitle:SetNonSpaceWrap(true)
subtitle:SetJustifyH("LEFT")
subtitle:SetJustifyV("TOP")
subtitle:SetText("Delete Profile")

if not DropDownMenuDel then
   CreateFrame("Button", "DropDownMenuDel", Juked.profilepanel, "UIDropDownMenuTemplate")
end

DropDownMenuDel:ClearAllPoints()
DropDownMenuDel:SetPoint("TOPLEFT", buttonPositionX-20, buttonPositionY)
DropDownMenuDel:Show()
 
local function OnClick(self)
	JukedDB[self:GetText()]=nil
	if (CharIndex == self:GetText()) then
		if ((JukedChar.." - "..JukedRealm)==self:GetText()) then
			JukedDB["CharsUse"][JukedChar.." - "..JukedRealm]="Default"
			CharIndex="Default"
		else
			CharIndex=JukedChar.." - "..JukedRealm
			if not JukedDB[CharIndex] then
				JukedDB[CharIndex] = JukedDB["Default"]
			end
			JukedDB["CharsUse"][CharIndex]=CharIndex
		end
		UsingProfileLabel:SetText("Currently using: "..CharIndex)	
	end
	items = {};
 	for k,v in pairs(JukedDB) do
		if (type(JukedDB[k]) == "table" and not(k =="CharsUse")and not (k == "Default")) then table.insert(items,k) end
	end
	Juked_Reset()
end
 
local function initialize(self, level)
items = {};
 	for k,v in pairs(JukedDB) do
		if (type(JukedDB[k]) == "table" and not(k =="CharsUse")and not (k == "Default")) then table.insert(items,k) end
	end
	local info = UIDropDownMenu_CreateInfo()
	for k,v in pairs(items) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = v
		info.func = OnClick
		UIDropDownMenu_AddButton(info, level)
	end
end
	
UIDropDownMenu_Initialize(DropDownMenuDel, initialize)
UIDropDownMenu_SetWidth(DropDownMenuDel, 160);
UIDropDownMenu_SetButtonWidth(DropDownMenuDel, 180)
UIDropDownMenu_SetSelectedID(DropDownMenuDel, 1)
UIDropDownMenu_JustifyText(DropDownMenuDel, "LEFT")
-- Add the child to the Interface Options
InterfaceOptions_AddCategory(Juked.profilepanel);
