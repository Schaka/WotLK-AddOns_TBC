local L = LibStub("AceLocale-3.0"):GetLocale("Gladius", true)

function Gladius:GetDRList()
   return {
       -- DRUID
       [33786] = "cycloneblind",           -- Cyclone
       [18658] = "sleep",                  -- Hibernate
       [26989] = "root",		    -- Entangling roots
       [8983] = "stun",                    -- Bash
       [9005] = "stun",                    -- Pounce
       [22570] = "disorient",              -- Maim

       -- HUNTER
       [14309] = "freezingtrap",           -- Freezing Trap
       [19386] = "sleep",                  -- Wyvern Sting
       [19503] = "scattershot",            -- Scatter Shot
       [19577] = "stun",                   -- Intimidation

       -- MAGE
       [12826] = "disorient",              -- Polymorph
       [31661] = "dragonsbreath",          -- Dragon's Breath
       [27088] = "root",                   -- Frost Nova
       [33395] = "root",                   -- Freeze (Water Elemental)

       -- PALADIN
       [10308] = "stun",                   -- Hammer of Justice
       [20066] = "repentance",             -- Repentance

       -- PRIEST
       [8122] = "fear",                    -- Phychic Scream
       [44047] = "root",                   -- Chastise
       [605] = "charm",                    -- Mind Control

       -- ROGUE
       [6770] = "disorient",               -- Sap
       [2094] = "cycloneblind",            -- Blind
       [1833] = "stun",                    -- Cheap Shot
       [8643] = "kidneyshot",              -- Kidney Shot
       [1776] = "disorient",               -- Gouge

       -- WARLOCK
       [5782] = "fear",                    -- Fear
       [27223] = "horror",                 -- Death Coil
       [30283] = "stun",                   -- Shadowfury
       [6358] = "fear",                    -- Seduction (Succubus)
       [5484] = "fear",                    -- Howl of Terror

       -- WARRIOR
       [12809] = "stun",                   -- Concussion Blow
       [25274] = "stun",                   -- Intercept Stun
       [5246] = "fear",                    -- Intimidating Shout

       -- TAUREN
       [20549] = "stun",                   -- War Stomp
   }
end