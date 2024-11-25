local MAJOR, MINOR = "DRList-1.0", 50 -- Don't forget to change this in DRList-1.0.lua aswell!
local Lib = LibStub(MAJOR)
if Lib.spellListVersion and Lib.spellListVersion >= MINOR then
    return
end

Lib.spellListVersion = MINOR

if Lib.gameExpansion == "wotlk" then

    -- SpellID list for Wrath of the Lich King.
    -- spellID for every rank is used over spell name to avoid name collisions, and faster lookups
    Lib.spellList = {
        [2637]  = "incapacitate", -- Hibernate (Rank 1)
        [18657] = "incapacitate", -- Hibernate (Rank 2)
        [18658] = "incapacitate", -- Hibernate (Rank 3)
        [22570] = "incapacitate", -- Maim
        [3355]  = "incapacitate", -- Freezing Trap Effect (Rank 1)
        [14308] = "incapacitate", -- Freezing Trap Effect (Rank 2)
        [14309] = "incapacitate", -- Freezing Trap Effect (Rank 3)
        [19386] = "incapacitate", -- Wyvern Sting (Rank 1)
        [24132] = "incapacitate", -- Wyvern Sting (Rank 2)
        [24133] = "incapacitate", -- Wyvern Sting (Rank 3)
        [27068] = "incapacitate", -- Wyvern Sting (Rank 4)
        [118]   = "incapacitate", -- Polymorph (Rank 1)
        [12824] = "incapacitate", -- Polymorph (Rank 2)
        [12825] = "incapacitate", -- Polymorph (Rank 3)
        [12826] = "incapacitate", -- Polymorph (Rank 4)
        [28271] = "incapacitate", -- Polymorph: Turtle
        [28272] = "incapacitate", -- Polymorph: Pig
        [20066] = "incapacitate", -- Repentance
        [6770]  = "incapacitate", -- Sap (Rank 1)
        [2070]  = "incapacitate", -- Sap (Rank 2)
        [11297] = "incapacitate", -- Sap (Rank 3)
        [1776]  = "incapacitate", -- Gouge (Rank 1)
        [1777]  = "incapacitate", -- Gouge (Rank 2)
        [8629]  = "incapacitate", -- Gouge (Rank 3)
        [11285] = "incapacitate", -- Gouge (Rank 4)
        [11286] = "incapacitate", -- Gouge (Rank 5)
        [38764] = "incapacitate", -- Gouge (Rank 6)
        [710]   = "incapacitate", -- Banish (Rank 1)
        [18647] = "incapacitate", -- Banish (Rank 2)
        [13327] = "incapacitate", -- Reckless Charge (Rocket Helmet)
        [4064]  = "incapacitate", -- Rough Copper Bomb
        [4065]  = "incapacitate", -- Large Copper Bomb
        [4066]  = "incapacitate", -- Small Bronze Bomb
        [4067]  = "incapacitate", -- Big Bronze Bomb
        [4068]  = "incapacitate", -- Iron Grenade
        [12421] = "incapacitate", -- Mithril Frag Bomb
        [4069]  = "incapacitate", -- Big Iron Bomb
        [12562] = "incapacitate", -- The Big One
        [12543] = "incapacitate", -- Hi-Explosive Bomb
        [19769] = "incapacitate", -- Thorium Grenade
        [19784] = "incapacitate", -- Dark Iron Bomb
        [30216] = "incapacitate", -- Fel Iron Bomb
        [30461] = "incapacitate", -- The Bigger One
        [30217] = "incapacitate", -- Adamantite Grenade

        [33786] = "disorient", -- Cyclone
        [2094]  = "disorient", -- Blind

        [5211]  = "stun", -- Bash (Rank 1)
        [6798]  = "stun", -- Bash (Rank 2)
        [8983]  = "stun", -- Bash (Rank 3)
        [9005]  = "stun", -- Pounce (Rank 1)
        [9823]  = "stun", -- Pounce (Rank 2)
        [9827]  = "stun", -- Pounce (Rank 3)
        [27006] = "stun", -- Pounce (Rank 4)
        [24394] = "stun", -- Intimidation
        [853]   = "stun", -- Hammer of Justice (Rank 1)
        [5588]  = "stun", -- Hammer of Justice (Rank 2)
        [5589]  = "stun", -- Hammer of Justice (Rank 3)
        [10308] = "stun", -- Hammer of Justice (Rank 4)
        [1833]  = "stun", -- Cheap Shot
        [30283] = "stun", -- Shadowfury (Rank 1)
        [30413] = "stun", -- Shadowfury (Rank 2)
        [30414] = "stun", -- Shadowfury (Rank 3)
        [12809] = "stun", -- Concussion Blow
        [7922]  = "stun", -- Charge Stun
        [20253] = "stun", -- Intercept Stun (Rank 1)
        [20614] = "stun", -- Intercept Stun (Rank 2)
        [20615] = "stun", -- Intercept Stun (Rank 3)
        [25273] = "stun", -- Intercept Stun (Rank 4)
        [25274] = "stun", -- Intercept Stun (Rank 5)
        [20549] = "stun", -- War Stomp (Racial)
        [13237] = "stun", -- Goblin Mortar
        [835]   = "stun", -- Tidal Charm

        [16922]   = "random_stun",  -- Celestial Focus (Starfire Stun)
        [19410]   = "random_stun",  -- Improved Concussive Shot
        [12355]   = "random_stun",  -- Impact
        [20170]   = "random_stun",  -- Seal of Justice Stun
        [15269]   = "random_stun",  -- Blackout
        [18093]   = "random_stun",  -- Pyroclasm
        [39796]   = "random_stun",  -- Stoneclaw Stun
        [12798]   = "random_stun",  -- Revenge Stun
        [5530]    = "random_stun",  -- Mace Stun Effect (Mace Specialization)
        [15283]   = "random_stun",  -- Stunning Blow (Weapon Proc)
        [56]      = "random_stun",  -- Stun (Weapon Proc)
        [34510]   = "random_stun",  -- Stormherald/Deep Thunder (Weapon Proc)

        [10326] = "fear", -- Turn Evil (Might be PvE only until wotlk, adding just incase)
        [8122]  = "fear", -- Psychic Scream (Rank 1)
        [8124]  = "fear", -- Psychic Scream (Rank 2)
        [10888] = "fear", -- Psychic Scream (Rank 3)
        [10890] = "fear", -- Psychic Scream (Rank 4)
        [5782]  = "fear", -- Fear (Rank 1)
        [6213]  = "fear", -- Fear (Rank 2)
        [6215]  = "fear", -- Fear (Rank 3)
        [6358]  = "fear", -- Seduction (Succubus)
        [5484]  = "fear", -- Howl of Terror (Rank 1)
        [17928] = "fear", -- Howl of Terror (Rank 2)
        [1513]  = "fear", -- Scare Beast (Rank 1)
        [14326] = "fear", -- Scare Beast (Rank 2)
        [14327] = "fear", -- Scare Beast (Rank 3)
        [5246]  = "fear", -- Intimidating Shout
        [5134]  = "fear", -- Flash Bomb Fear (Item)

        [339]   = "root", -- Entangling Roots (Rank 1)
        [1062]  = "root", -- Entangling Roots (Rank 2)
        [5195]  = "root", -- Entangling Roots (Rank 3)
        [5196]  = "root", -- Entangling Roots (Rank 4)
        [9852]  = "root", -- Entangling Roots (Rank 5)
        [9853]  = "root", -- Entangling Roots (Rank 6)
        [26989] = "root", -- Entangling Roots (Rank 7)
        [19975] = "root", -- Nature's Grasp (Rank 1)
        [19974] = "root", -- Nature's Grasp (Rank 2)
        [19973] = "root", -- Nature's Grasp (Rank 3)
        [19972] = "root", -- Nature's Grasp (Rank 4)
        [19971] = "root", -- Nature's Grasp (Rank 5)
        [19970] = "root", -- Nature's Grasp (Rank 6)
        [27010] = "root", -- Nature's Grasp (Rank 7)
        [122]   = "root", -- Frost Nova (Rank 1)
        [865]   = "root", -- Frost Nova (Rank 2)
        [6131]  = "root", -- Frost Nova (Rank 3)
        [10230] = "root", -- Frost Nova (Rank 4)
        [27088] = "root", -- Frost Nova (Rank 5)
        [33395] = "root", -- Freeze (Water Elemental)
        [39965] = "root", -- Frost Grenade (Item)

        [605]   = "mind_control", -- Mind Control (Rank 1)
        [10911] = "mind_control", -- Mind Control (Rank 2)
        [10912] = "mind_control", -- Mind Control (Rank 3)
        [13181] = "mind_control", -- Gnomish Mind Control Cap

        [14251] = "disarm", -- Riposte
        [34097] = "disarm", -- Riposte 2 (TODO: Check which ID is the correct one)
        [676]   = "disarm", -- Disarm

        [12494] = "random_root",         -- Frostbite
        [23694] = "random_root",         -- Improved Hamstring
        [19229] = "random_root",         -- Improved Wing Clip
        [19185] = "random_root",         -- Entrapment

        [19503] = "scatter",        -- Scatter Shot
        [31661] = "scatter",        -- Dragon's Breath (Rank 1)
        [33041] = "scatter",        -- Dragon's Breath (Rank 2)
        [33042] = "scatter",        -- Dragon's Breath (Rank 3)
        [33043] = "scatter",        -- Dragon's Breath (Rank 4)

        -- Spells that DR with itself only
        [408]   = "kidney_shot",         -- Kidney Shot (Rank 1)
        [8643]  = "kidney_shot",         -- Kidney Shot (Rank 2)
        [43523] = "unstable_affliction", -- Unstable Affliction 1
        [31117] = "unstable_affliction", -- Unstable Affliction 2
        [6789]  = "death_coil",          -- Death Coil (Rank 1)
        [17925] = "death_coil",          -- Death Coil (Rank 2)
        [17926] = "death_coil",          -- Death Coil (Rank 3)
        [27223] = "death_coil",          -- Death Coil (Rank 4)
        [44041] = "chastise",            -- Chastise (Rank 1)
        [44043] = "chastise",            -- Chastise (Rank 2)
        [44044] = "chastise",            -- Chastise (Rank 3)
        [44045] = "chastise",            -- Chastise (Rank 4)
        [44046] = "chastise",            -- Chastise (Rank 5)
        [44047] = "chastise",            -- Chastise (Rank 6)
        [19306] = "counterattack",       -- Counterattack (Rank 1)
        [20909] = "counterattack",       -- Counterattack (Rank 2)
        [20910] = "counterattack",       -- Counterattack (Rank 3)
        [27067] = "counterattack",       -- Counterattack (Rank 4)
    }

else
    print("DRList-1.0: Unsupported game expansion loaded.") -- luacheck: ignore
end

-- Alias for DRData-1.0
Lib.spells = Lib.spellList
