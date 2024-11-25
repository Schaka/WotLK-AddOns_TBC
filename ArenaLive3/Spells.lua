ArenaLive.spellDB = {
			["Trinket"] = { 42292, 120 }, -- SpellID and cooldown of the PvP-Trinket
			["Racials"] = {
				-- First Number is the SpellID, 2nd one is the CD and 3rd is the shared CD with the PvP-Trinket. Use 0 if they don't have a shared CD.
				["Human"] =  {
					["PRIEST"] = { 25437, 600, 0},
					["WARRIOR"] = {20600, 180, 0},
					["WARLOCK"] = {20600, 180, 0},
					["MAGE"] = {20600, 180, 0},
					["ROGUE"] = {20600, 180, 0},
					["PALADIN"] = {20600, 180, 0},
				},
				["Dwarf"] = { 20594, 120, 0 },
				["NightElf"] = {
					["PRIEST"] = { 2651, 180, 0},
					["DRUID"] = { 20580, 10, 0},
					["WARRIOR"] = { 20580, 10, 0},
					["HUNTER"] = { 20580, 10, 0},
					["ROGUE"] = { 20580, 10, 0},
				},
				["Gnome"] = { 20589, 90, 0 },
				["Draenei"] = { 28880, 180, 0},
				["Orc"] = { -- Since Orcs also have class-specific racials, we need to add all of them
					["WARRIOR"] = { 20572, 120, 0 },
					["HUNTER"] = { 20572, 120, 0 },
					["ROGUE"] = { 20572, 120, 0 },
					["SHAMAN"] = { 33697, 120, 0 },
					["MAGE"] = { 33702, 120, 0 },
					["WARLOCK"] = { 33702, 120, 0 },
				},
				["Scourge"] = { 7744, 120, 0 },
				["Tauren"] = { 20549, 120, 0 },
				["Troll"] = { 26297, 180, 0 },
				["BloodElf"] = {
					["PALADIN"] = { 28730, 120, 0 },
					["HUNTER"] = { 28730, 120, 0},
					["ROGUE"] = { 25046, 120, 0 },
					["PRIEST"] = { 28730, 120, 0 },
					["MAGE"] = { 28730, 120, 0 },
					["WARLOCK"] = { 28730, 120, 0 },
				},
			},
			["CooldownResets"] = {
				[11958] = {				-- Mage: Cold Snap
					[120] = true,			-- Cone of Cold
					[122] = true,			-- Frost Nova
					[45438] = true,			-- Ice Block
				},
				[14185] = {				-- Rogue: Preparation
					[2983] = true,
					[1856] = true,
					[5277] = true,
				},
			},			
			["CCIndicator"] = { -- This table is used to track those spells, that are shown on the Class Portrait's position.
				-- The order is [spellID] = Priority-Type.
				-- racials
				[7744] = "defCD",			-- Will of the Forsaken
							
				-- Druid
				[33786] = "defCD",			-- Cyclone (Made that one a def CD, because the enemy is immune to everything during cyclone)
				[102795] = "stun",			-- Bear Hug
				[22570] = "stun",			-- Maim
				[8983] = "stun",			-- Bash
				[27006] = "stun",			-- Pounce (stun)
				[18658] = "crowdControl",	-- Hibernate R3
				[339] = "root",				-- Entangling roots
				[9853] = "root",			-- Entangling roots max rank
				[45334] = "root",			-- Feral Charge (root)
				[16689] = "defCD", 			-- Nature's Grasp
				[29166] = "usefulBuffs", 	-- Innervate

				-- Hunter
				[5384] = "defCD",			-- Feign Death
				[19263] = "defCD",			-- Deterrence
				[19577] = "stun",			-- Intimidation (stun)			
				[90337] = "stun",			-- Bad Manner (Monkey Pet)
				[34490] = "silence",		-- Silencing Shot
				[3355] = "crowdControl",	-- Freezing Trap R1
				[14309] = "crowdControl",	-- Freezing Trap R3
				[19503] = "crowdControl",	-- Scatter Shot
				[19386] = "crowdControl",	-- Wyvern Sting
				[1513] = "crowdControl",	-- Scare Beast R1
				[14327] = "crowdControl",	-- Scare Beast R3
				[19185] = "root",			-- Entrapment (trap-roots)
				[34692] = "usefulBuffs",	-- The Beast Within (Hunter)
				
				-- Mage
				[45438] = "defCD",			-- Ice Block
				[12472] = "offCD",			-- Icy Veins
				[18469] = "silence",		-- Counterspell silence
				[118] = "crowdControl",		-- Standard Polymorph R1
				[28272] = "crowdControl",	-- Polymorph Pig
				[28271] = "crowdControl",	-- Polymorph Turtle
				[33043] = "crowdControl",	-- Dragon's Breath
				[122] = "root",				-- Frost Nova R1
				[33395] = "root",			-- Freeze (Pet Nova)


				-- Paladin
				[1020] = "defCD",			-- Divine Shield
				[31884] = "offCD",			-- Avenging Wrath
				[10308] = "stun",			-- Hammer of Justice
				[119072] = "stun",			-- Holy Wrath
				[31935] = "silence",		-- Avenger's Shield
				[10326] = "crowdControl",	-- Turn Evil
				[20066] = "crowdControl",	-- Repentance
				[10278] = "defCD", 			-- Blessing of Protection
				[1044] = "usefulBuffs", 	-- Blessing of Freedom
				[6940] = "usefulBuffs", 	-- Blessing of Sacrifice
				
				-- Priest
				[33206] = "defCD",			-- Pain Suppression
				[10060] = "offCD",			-- Power Infusion
				[15487] = "silence",		-- Silence
				[8122] = "crowdControl",	-- Psychic Scream
				[10912] = "crowdControl",	-- Mind Control
				[6346] = "usefulBuffs",		-- Fear Ward
				
				-- Rogue	
				[45182] = "defCD",			-- Cheating Death
				[26669] = "defCD",			-- Evasion
				[31224] = "defCD",			-- Cloak of Shadows
				[8643] = "stun", 			-- Kidney Shot
				[1833] = "stun",			-- Cheap Shot
				[1330] = "silence",			-- Garrote - Silence
				[2094] = "crowdControl", 	-- Blind
				[1776] = "crowdControl", 	-- Gouge
				[11297] = "crowdControl", 	-- Sap
				
				-- Shaman
				[16166] = "offCD",			-- Elemental Mastery
				[32182] = "usefulBuffs", 	-- Heroism
				[2825] = "usefulBuffs", 	-- Bloodlust
				[8178] = "defCD",			-- Grounding Totem
				
				-- Warlock
				[710] = "defCD",			-- Banish (It is marked as def CD for the same reason as Cyclone)
				[27223] = "stun",			-- Mortal Coil
				[30414] = "stun",			-- Shadowfury
				[19647] = "silence",		-- Spell lock (Pet-silence)
				[17928] = "crowdControl",	-- Howl of Terror
				[5782] = "crowdControl",	-- Fear
				[6358] = "crowdControl",	-- Seduce (Pet-Charm)
				[30405] = "usefulDebuffs",	-- Unstable Affliction		
				
				-- Warrior
				[871] = "defCD",			-- Shield Wall
				[1719] = "offCD",			-- Recklessness
				[7922] = "stun",			-- Charge Stun
				[5246] = "crowdControl",	-- Intimidating Shout
				[676] = "disarm",			-- Disarm
				[18499] = "disarm",			-- Berserker Rage
				[23920] = "usefulBuffs",	-- Spell Reflection
				[12292] = "usefulBuffs", 	-- Death Wish
				[3411] = "usefulBuffs", 	-- Intervene
				[25274] = "crowdControl", 	-- Intercept Stun
				[5530] = "crowdControl", 	-- Mace Stun Effect
				[12292] = "usefulBuffs", 	-- Death Wish
				
				-- Racials
				[20549] = "crowdControl", 	-- War Stomp
				[20594] = "usefulBuffs", 	-- Stoneform
			},
			["FilteredSpells"] = { --[[This list blocks spells that cause bugs in the casthistory.]]--
					[75] = "Auto Shot", -- For every autoshot a hunter casts, the cast history will create a button. So we filter it.
					[5374] = "Mutilate", -- The real Mutilate-Spell triggers these two spells. We don't need to show all three of them in the CastHistory, so we block them too.
					[27576] = "Mutilate Off-Hand",
					[836] = "LOGINEFFECT",
			},
			["DefensiveCooldowns"] = {
				["DRUID"] = {
					[22812] = 60,		-- Barkskin
				},
				["HUNTER"] = {
					[19263] = 180		-- Deterrence
				},
				["MAGE"] = {
					[45438] = 300,		-- Ice Block
				},
				["PALADIN"] = {
					[642] = 300,		-- Divine Shield
				},
				["PRIEST"] = {
					[33206] = 120,			-- Pain Suppression (with Setbonus)
				},
				["ROGUE"] = {
					[5277] = 120,			-- Evasion
				},
				["SHAMAN"] = {
					[30823] = 60,			-- Shamanistic Rage
				},
				["WARRIOR"] = {
				},
				["WARLOCK"] = {
				},
			},
			["ShownBuffs"] = { -- I've decided to just show certain Buffs on the Buff-frame. Here is the List.
			},
		["Dispels"] = {
		},
		["Interrupts"] = {
			-- TO DO: SPEC SPECIFIC SPELLS
			["DRUID"] = { 8983, 60, false }, 			-- Nature's Cure
			["HUNTER"] = { 34490, 20, false }, 			-- Silencing Shot
			["MAGE"] = { 2139, 24, false }, 			-- Counter Spell
			["PALADIN"] = { 10308, 45, false }, 		-- Cleanse
			["PRIEST"] = { 10890, 27, false }, 			-- Purify
			["ROGUE"] = { 38768, 10, false }, 			-- Kick
			["WARRIOR"] = { 6554, 10, false },			-- Pummel
			["SHAMAN"] = { 8042, 6, false },
			["WARLOCK"] = { 19647, 24, false },	
		},
		["SharedCooldowns"] = {
		},
		["DiminishingReturns"] =
		{						
			-- Roots:
			[339] = "root", 				-- Entangling Roots
			[19975] = "root", 				-- Entangling Roots: Nature's Grasp
			[53148] = "root",				-- Charge (Tenacity Pet)
			[4167] = "root",  				-- Web 
			[33395] =  "root",  			-- Freeze
			[122] = "root",  				-- Frost Nova
			
			-- Short Roots:
			[64803] = "shortRoot",			-- Entrapment (trap-roots)
			
			-- Stuns:
			[22570] = "stun", 				-- Maim
			[5211] = "stun", 				-- Mighty Bash
			[9005] = "stun", 				-- Pounce	
			
			[19577] = "stun",				-- Intimidation (stun)			
			
			[853] = "stun",					-- Hammer of Justice
			
			[1833] = "stun", 				-- Cheap Shot
			[408] = "stun", 				-- Kidney Shot
			
			[22703] = "stun",				-- Infernal Awakening
			[30283] = "stun", 				-- Shadowfury
			
			[132168] = "stun", 				-- Shockwave
			[107570] = "stun",				-- Storm Bolt
			
			[20549] = "stun", 				-- War Stomp
			
			-- Short Stuns:
			
			[77505] = "shortStun", 			-- Earthquake
			
			[7922] = "shortStun",			-- Charge Stun					
	
			-- Mesmerizes:
			[2637] = "mesmerize",			-- Hibernate
			
			[3355] = "mesmerize", 			-- Freezing Trap
			[19386] = "mesmerize", 			-- Wyvern Sting
			
			[118] = "mesmerize", 			-- Polymorph
			
			[115078] = "mesmerize", 		-- Paralysis
			
			[20066] = "mesmerize", 			-- Repentance
			
			[9484] = "mesmerize", 			-- Shackle Undead
			
			[1776] = "mesmerize", 			-- Gouge
			[6770] = "mesmerize", 			-- Sap
			
			[710] = "mesmerize",			-- Banish
			
			-- Short Mesmerizes:
			[99] = "shortMesmerize", 		-- Disorienting Roar
			
			[19503] = "shortMesmerize",		-- Scatter Shot
			
			[31661] = "shortMesmerize", 	-- Dragon's Breath
			
			[123407] = "shortMesmerize",	-- Glyph of Breath of Fire
			
			[88625] = "shortMesmerize",		-- Holy Word: Chastise
			
			-- Fears:
			[113056] = "fear",				-- Intimidating Roar (cower)
			[113004] = "fear",				-- Intimidating Roar (flee)
			
			[1513] = "fear", 				-- Scare Beast
			
			[105421] = "fear", 				-- Blinding Light
			[10326] = "fear", 				-- Turn Evil
			
			[8122] = "fear", 				-- Psychic Scream
			[113792] = "fear", 				-- Psychic Terror
			
			[2094] = "fear", 				-- Blind
			
			[118699] = "fear", 				-- Fear
			[5484] = "fear", 				-- Howl of Terror
			[115268] = "fear", 				-- Mesmerize
			[6358] = "fear", 				-- Seduction
			
			[5246] = "fear",				-- Intimidating Shout
			[20511] = "fear", 				-- Intimidating Shout
			[95199] = "fear", 				-- Intimidating Shout

			-- Horrors:
			[6789] = "horror", 				-- Mortal Coil
		
			-- Cyclone:
			[33786] = "cyclone", -- Cyclone
			
			-- Charms:
			[605] = "charm", -- Dominate Mind
			
		},
	};