OmniBarAddonName, OmniBarAddonFrame = "OmniBar", CreateFrame("Frame", "OmniBarFrame")
WOW_PROJECT_TBC = "TBC"
WOW_PROJECT_ID = "TBC"

if WOW_PROJECT_ID ~= WOW_PROJECT_TBC then return end

OmniBarAddonFrame.Resets = {
    --[[ Cold Snap
        - Frost Nova
        - Frost Ward
        - Cone of Cold
        - Ice Barrier
        - Ice Block
        - Icy Veins
        - Summon Water Elemental
      ]]
    [11958] = {122,6143,120,11426,45438,12472,31687},

    --[[ Preparation
        - Evasion
        - Sprint
		- Vanish
		- Cold Blood
		- Shadowstep
		- Premeditation (not trackable)
      ]]
    [14185] = { 26669, 2983, 26889, 14177, 36554, 14183},

    --[[ Readiness
        - Bestial Wrath
        - Intimidation
        - Scare Beast
        - Flare
        - Rapid Fire
        - Scatter Shot
        - Silencing Shot
        - Tranquilizing Shot
        - Deterrence
        - Explosive Trap
        - Freezing Trap
        - Frost Trap
        - Immolation Trap
        - Snake Trap
        - Wyvern Sting
      ]]
    [23989] = {19574,19577,14327,1543,3045,19503,34490,19801,19263,13813,1499,13809,13795,34600,19386,},
}

OmniBarAddonFrame.Cooldowns = {

    -- Trinket
    [42292] = {default = false, duration=120, class="DRUID"},
    [42292] = {default = false, duration=120, class="HUNTER"},
    [42292] = {default = false, duration=120, class="MAGE"},
    [42292] = {default = false, duration=120, class="PALADIN"},
    [42292] = {default = false, duration=120, class="PRIEST"},
    [42292] = {default = false, duration=120, class="ROGUE"},
    [42292] = {default = false, duration=120, class="SHAMAN"},
    [42292] = {default = false, duration=120, class="WARLOCK"},
    [42292] = {default = false, duration=120, class="WARRIOR"},

    -- Interrupts
    [16979] = { default = true, duration = 15, class = "DRUID" }, -- Feral Charge (Druid)
    [2139] = { default = true, duration = 24, class = "MAGE" }, -- Counterspell (Mage)
    [1766] = { default = true, duration = 10, class = "ROGUE" }, -- Kick (Rogue)
        [1767] = { parent = 1766 },
        [1768] = { parent = 1766 },
        [1769] = { parent = 1766 },
        [38768] = { parent = 1766 },
    [6552] = { default = true, duration = 10, class = "WARRIOR" }, -- Pummel (Warrior)
        [6554] = { parent = 6552 },
    [72] = { default = true, duration = 12, class = "WARRIOR" }, -- Shield Bash (Warrior)
        [1671] = { parent = 72 },
        [1672] = { parent = 72 },
        [29704] = { parent = 72 },
    [8042] = { default = true, duration = 5, class = "SHAMAN" }, -- Earth Shock (Shaman)
        [8044] = { parent = 8042 },
        [8045] = { parent = 8042 },
        [8046] = { parent = 8042 },
        [10412] = { parent = 8042 },
        [10413] = { parent = 8042 },
        [10414] = { parent = 8042 },
        [25454] = { parent = 8042 },
        -- Flame Shock (shares CD)
        [8050] = { parent = 8042 },
        [8052] = { parent = 8042 },
        [8053] = { parent = 8042 },
        [10447] = { parent = 8042 },
        [10448] = { parent = 8042 },
        [29228] = { parent = 8042 },
        [25457] = { parent = 8042 },
        -- Frost Shock (shares CD)
        [8056] = { parent = 8042 },
        [8058] = { parent = 8042 },
        [10472] = { parent = 8042 },
        [10473] = { parent = 8042 },
        [25464] = { parent = 8042 },
    [19244] = {default = true, class = "WARLOCK", duration = 24 }, -- Spell Lock
        [19647] = { parent = 19244 },
    [34490] = {default = true, class = "HUNTER", duration = 20}, -- Silencing Shot
    [15487] = { duration = 45, class = "PRIEST" }, -- Silence

    -- Priest
    [25441] = {class = "PRIEST", duration = 180}, --Feedback
    --Dwarf, Human
    [13908] = {class = "PRIEST", duration = 120}, --Desperate Prayer r1
        [19236] = {parent = 13908}, --Desperate Prayer r2
        [19238] = {parent = 13908}, --Desperate Prayer r3
        [19240] = {parent = 13908}, --Desperate Prayer r4
        [19241] = {parent = 13908}, --Desperate Prayer r5
        [19242] = {parent = 13908}, --Desperate Prayer r6
        [19243] = {parent = 13908}, --Desperate Prayer r7
        [25437] = {parent = 13908}, --Desperate Prayer r8
    --Undead
    [2944] = {class = "PRIEST", duration = 180}, --Devouring Plague r1
        [19276] = {parent = 2944}, --Devouring Plague r2
        [19277] = {parent = 2944}, --Devouring Plague r3
        [19278] = {parent = 2944}, --Devouring Plague r4
        [19279] = {parent = 2944}, --Devouring Plague r5
        [19280] = {parent = 2944}, --Devouring Plague r6
        [25467] = {parent = 2944}, --Devouring Plague r7
    --Discipline
    [6346] = {class = "PRIEST", duration = 180}, --Fear Ward
    [14751] = {class = "PRIEST", duration = 180}, --Inner Focus
    [33206] = {class = "PRIEST", duration = 120}, --Pain Supression
    [10060] = {class = "PRIEST", duration = 180}, --Power infusion
    --Shadow
    --I think fade is unnecessary even in pve
    [34433] = {class = "PRIEST", duration = 300}, --Shadowfiend
    [8122] = { class = "PRIEST", duration = 26 }, -- Psychic Scream
        [8124] = { parent = 8122 },
        [10888] = { parent = 8122 },
        [10890] = { parent = 8122 },
    [32379] = { class = "PRIEST", duration = 12 }, -- Shadow Word: Death
        [32996] = { parent = 32379 },

    -- Warlock
    [5484] = { class = "WARLOCK", duration = 40 }, -- Howl of Terror
        [17928] = { parent = 5484 },
    [6789] = { class = "WARLOCK", duration = 120 }, -- Death Coil
        [17925] = { parent = 6789 },
        [17926] = { parent = 6789 },
        [27223] = { parent = 6789 },
    [6229] = { class = "WARLOCK", duration = 30 }, -- Shadow Ward
        [11739] = { parent = 6229 },
        [11740] = { parent = 6229 },
        [28610] = { parent = 6229 },
    [18288] = { class ="WARLOCK", duration = 180 },  -- Amplify Curse
    [27277] = { class ="WARLOCK", duration = 8 },  -- Devour Magic
        [19505] = { parent = 27277 },
        [19731] = { parent = 27277 },
        [19734] = { parent = 27277 },
        [19736] = { parent = 27277 },
        [27276] = { parent = 27277 },
    [23469] = {class ="WARLOCK", duration = 120}, --Healthstone
        [23471] = { parent = 23469 },
        [23473] = { parent = 23469 },
        [23475] = { parent = 23469 },
        [23477] = { parent = 23469 },
        [27237] = { parent = 23469 },
    [18708] = {class ="WARLOCK", duration = 900}, --Fel Domination
    [30283] = {class ="WARLOCK", duration = 20}, --Shadowfury
        [30413] = { parent = 30283 },
        [30414] = { parent = 30283 },

    -- Shaman
    --Elemental
    [2484] = {class = "SHAMAN", duration = 15}, --Earthbind Totem
    [16166] = {class = "SHAMAN", duration = 180}, --Elemental Mastery
    [2894] = {class = "SHAMAN", duration = 1200}, --Fire Elemental Totem
    --Enhancement
    [2825] = {class = "SHAMAN", duration = 600}, --Bloodlust
    [32182] = {class = "SHAMAN", duration = 600}, --Heroism
    [2062] = {class = "SHAMAN", duration = 1200}, --Earth Elemental Totem
    [8177] = { class = "SHAMAN", duration = 13 }, -- Grounding Totem
    [30823] = {class = "SHAMAN", duration = 120}, --Shamanistic Rage
    --Restoration
    [16190] = {class = "SHAMAN", duration = 300}, --Mana Tide Totem
    [16188] = {class = "SHAMAN", duration = 180}, --Nature's Swiftness

    -- Paladin

    [1022] = { class = "PALADIN", duration = 180 },-- Blessing of Protection
        [5599] = { parent = 1022 },
        [10278] = { parent = 1022 },
    [642] = { class = "PALADIN", duration = 300 }, -- Divine Shield
        [1020] = { parent = 642 },
    [853] = { class = "PALADIN", duration = 45 }, -- Hammer of Justice
        [5588] = { parent = 853 },
        [5589] = { parent = 853 },
        [10308] = { parent = 853 },
    [1044] = { class = "PALADIN", duration = 25 }, -- Blessing of Freedom
    [20066] = { class = "PALADIN", duration = 60 }, -- Repentance
    [27148] = {class = "PALADIN", duration = 30}, -- Blessing of Sacrifice
        [6940] = { parent = 27148 },
        [20729] = { parent = 27148 },
        [27147] = { parent = 27148 },
    [10326] = {class = "PALADIN", duration = 30}, --Turn Evil
    [2878] = {class = "PALADIN", duration = 30}, --Turn Undead r1
        [5627] = { parent = 2878 },
    [498] = {class = "PALADIN", duration = 300}, --Divine Protection
        [5573] = { parent = 498 },
    [31884] = {class = "PALADIN", duration = 180}, --Avenging Wrath

    -- Hunter
    [27018] = {class = "HUNTER", duration = 15}, -- Viper sting
        [3034] = { parent = 27018 },
        [14279] = { parent = 27018 },
        [14280] = { parent = 27018 },
        [49008] = { parent = 27018 },
    [14327] = {class = "HUNTER", duration = 30}, -- Scare Beast
        [14326] = { parent = 14327 },
        [1513] = { parent = 14327 },
    [3045] = { class = "HUNTER", duration = 180 }, -- Rapid Fire
    [19263] = { class = "HUNTER", duration = 300 }, -- Deterrence
    [19574] = { class = "HUNTER", duration = 120 }, -- Bestial Wrath
    [1499] = { class = "HUNTER", duration = 15 }, -- Freezing Trap
        [14310] = { parent = 1499 },
        [14311] = { parent = 1499 },
    [19386] = { class = "HUNTER", duration = 120 }, -- Wyvern Sting
        [24132] = { parent = 19386 },
        [24133] = { parent = 19386 },
        [27068] = { parent = 19386 },
    [19503] = { class = "HUNTER", duration = 30 }, -- Scatter Shot
    [25999] = { class = "HUNTER", duration = 25 }, -- Boar Charge
    [19263] = {class = "HUNTER", duration = 300}, --Deterrence
    [13813] = {class = "HUNTER", duration = 30}, --Explosive Trap
        [14316] = { parent = 13813},
        [14317] = { parent = 13813},
        [27025] = { parent = 13813},
    [1499] = {class = "HUNTER", duration = 30}, --Freezing Trap
        [14310] = { parent = 1499},
        [14311] = { parent = 1499},
    [13809] = {class = "HUNTER", duration = 30}, --Frost Trap
    [13795] = {class = "HUNTER", duration = 30}, --Immolation Trap
        [14302] = { parent = 13795},
        [14303] = { parent = 13795},
        [14304] = { parent = 13795},
        [14305] = { parent = 13795},
        [27023] = { parent = 13795},
    [34600] = {class = "HUNTER", duration = 30}, --Snake Trap
    [23989] = {class = "HUNTER", duration = 180}, --Readiness

    -- Druid

    [22812] = { class = "DRUID", duration = 60 }, -- Barkskin
    [16689] = { class = "DRUID", duration = 60 }, -- Nature's Grasp
        [16810] = { parent = 16689 },
        [16811] = { parent = 16689 },
        [16812] = { parent = 16689 },
        [16813] = { parent = 16689 },
        [17329] = { parent = 16689 },
        [27009] = { parent = 16689 },
    [29166] = { class = "DRUID", duration = 360 }, -- Innervate
    [18562] = { class = "DRUID", duration = 13 }, -- Swiftmend
    [17116] = {class = "DRUID", duration = 180}, --Nature's Swiftness
    [22570] = { class = "DRUID", duration = 10 }, -- Maim
        [49802] = { parent = 22570 },
    [5211] = { class = "DRUID", duration = 60 }, -- Bash
        [6798] = { parent = 5211 },
        [8983] = { parent = 5211 },
    [1850] = { class = "DRUID", duration = 300 }, -- Dash
        [9821] = { parent = 1850 },
        [33357] = { parent = 1850 },
    [740] = {class = "DRUID", duration = 600}, --Tranquility
        [8918] = { parent = 740 },
        [9862] = { parent = 740 },
        [9863] = { parent = 740 },
        [26983] = { parent = 740 },

    -- Mage

    [12043] = {class = "MAGE", duration = 180}, --Presence of Mind
    [66] = {class = "MAGE", duration = 300}, --Invisibility
    [12051] = {class = "MAGE", duration = 480}, --Evocation
    [12042] = {class = "MAGE", duration = 180}, --Arcane Power
    [1953] = {class = "MAGE", duration = 15}, --Blink
    [5405] = {class = "MAGE", duration = 120}, --Mana Gem r1
        [10052] = { parent = 5405 },
        [10057] = { parent = 5405 },
        [10058] = { parent = 5405 },
        [27103] = { parent = 5405 },
    [11426] = { class = "MAGE", duration = 24 }, -- Ice Barrier
        [13031] = { parent = 11426 },
        [13032] = { parent = 11426 },
        [13033] = { parent = 11426 },
        [27134] = { parent = 11426 },
        [33405] = { parent = 11426 },
    [543] = { class = "MAGE", duration = 30 }, -- Fire Ward
        [8457] = { parent = 543 },
        [8458] = { parent = 543 },
        [10223] = { parent = 543 },
        [10225] = { parent = 543 },
        [27128] = { parent = 543 },
    [6143] = { class = "MAGE", duration = 30 }, -- Frost Ward
        [8461] = { parent = 6143 },
        [8462] = { parent = 6143 },
        [10177] = { parent = 6143 },
        [28609] = { parent = 6143 },
        [32796] = { parent = 6143 },
    [122] = { class = "MAGE", duration = 21 }, -- Frost Nova
        [865] = { parent = 122 },
        [6131] = { parent = 122 },
        [10230] = { parent = 122 },
        [27088] = { parent = 122 },
    [12042] = { class = "MAGE", duration = 180 }, -- Arcane Power
    [45438] = { class = "MAGE", duration = 240 }, -- Ice Block
    [12051] = { class = "MAGE", duration = 420 }, -- Evocation
    [11958] = { class = "MAGE", duration = 480 }, -- Cold Snap
    [31687] = {class = "MAGE", duration = 180}, --Summon Water Elemental
    [12472] = {class = "MAGE", duration = 180}, --Icy Veins
    [28682] = {class = "MAGE", duration = 180}, --Combustion
    [11113] = {class = "MAGE", duration = 30}, --Blast Wave
        [13018] = { parent = 11113 },
        [13019] = { parent = 11113 },
        [13020] = { parent = 11113 },
        [13021] = { parent = 11113 },
        [27133] = { parent = 11113 },
        [33933] = { parent = 11113 },
    [31661] = {class = "MAGE", duration = 20}, --Dragon's Breath
        [33041] = { parent = 31661 },
        [33042] = { parent = 31661 },
        [33043] = { parent = 31661 },
    [120] = {class = "MAGE", duration = 8}, --Cone of Cold
        [8492] = { parent = 120 },
        [10159] = { parent = 120 },
        [10160] = { parent = 120 },
        [10161] = { parent = 120 },
        [27087] = { parent = 120 },

    -- Rogue

    [14177] = {class = "ROGUE", duration = 180}, --Cold Blood
    [13750] = { class = "ROGUE", duration = 300 }, -- Adrenaline Rush
    [13877] = { class = "ROGUE", duration = 120 }, -- Blade Flurry
    [408] = { class = "ROGUE", duration = 20 }, -- Kidney Shot
        [8643] = { parent = 408 },
    [2094] = { class = "ROGUE", duration = 90 }, -- Blind
    [2983] = { class = "ROGUE", duration = 210 }, -- Sprint
        [8696] = { parent = 2983 },
        [11305] = { parent = 2983 },
    [26669] = { class = "ROGUE", duration = 210 }, -- Evasion
        [5277] = { parent = 26669 },
    [1776] = { class = "ROGUE", duration = 9 }, -- Gouge
        [1777] = { parent = 1776 },
        [8629] = { parent = 1776 },
        [11285] = { parent = 1776 },
        [11286] = { parent = 1776 },
        [38764] = { parent = 1776 },
    [14278] = { class = "ROGUE", duration = 20 }, -- Ghostly Strike
    [14183] = { class = "ROGUE", duration = 120 }, -- Premeditation
    [14185] = { class = "ROGUE", duration = 600 }, -- Preparation
    [36554] = { class = "ROGUE", duration = 30 }, -- Shadowstep
    [31224] = { class = "ROGUE", duration = 60 }, -- Cloak of Shadows
    [45182] = { class = "ROGUE", duration = 60 }, -- Cheat Death
    [26889] = { class = "ROGUE", duration = 60 }, -- Vanish
        [1857] = { parent = 26889 },
        [1856] = { parent = 26889 },

    -- Warrior

    [20230] = { class = "WARRIOR", duration = 1800 }, -- Retaliation
    [1719] = { class = "WARRIOR", duration = 1800 }, -- Recklessness
    [871] = { class = "WARRIOR", duration = 1800 }, -- Shield Wall
    [12328] = { class = "WARRIOR", duration = 180 }, -- Death Wish
    [18499] = { class = "WARRIOR", duration = 30 }, -- Berserker Rage
    [12809] = { class = "WARRIOR", duration = 45 }, -- Concussion Blow
    [23920] = { class = "WARRIOR", duration = 10 }, -- Spell Reflection
    [676] = { class = "WARRIOR", duration = 60 }, -- Disarm
    [3411] = { class = "WARRIOR", duration = 30 }, -- Intervene
    [5246] = { class = "WARRIOR", duration = 180 }, -- Intimidating Shout
    [100] = { class = "WARRIOR", duration = 15 }, -- Charge
        [6178] = { parent = 100 },
        [11578] = { parent = 100 },
    [20252] = { class = "WARRIOR", duration = 30 }, -- Intercept
        [20616] = { parent = 20252 },
        [20617] = { parent = 20252 },
        [25272] = { parent = 20252 },
        [47996] = { parent = 20252 },
        [25275] = { parent = 20252 },

}
