local GetSpellInfo = GetSpellInfo

local Gladdy = LibStub("Gladdy")
local L = Gladdy.L
local AURA_TYPE_DEBUFF, AURA_TYPE_BUFF = AURA_TYPE_DEBUFF, AURA_TYPE_BUFF

function Gladdy:GetSpecBuffs()
    return {
        -- DRUID
        [GetSpellInfo(45283)] = L["Restoration"], -- Natural Perfection
        [GetSpellInfo(16880)] = L["Restoration"], -- Nature's Grace; Dreamstate spec in TBC equals Restoration
        [GetSpellInfo(24858)] = L["Restoration"], -- Moonkin Form; Dreamstate spec in TBC equals Restoration
        [GetSpellInfo(17007)] = L["Feral"], -- Leader of the Pack
        [GetSpellInfo(16188)] = L["Restoration"], -- Nature's Swiftness

        -- HUNTER
        [GetSpellInfo(34692)] = L["Beast Mastery"], -- The Beast Within
        [GetSpellInfo(20895)] = L["Beast Mastery"], -- Spirit Bond
        [GetSpellInfo(34455)] = L["Beast Mastery"], -- Ferocious Inspiration
        [GetSpellInfo(27066)] = L["Marksmanship"], -- Trueshot Aura

        -- MAGE
        [GetSpellInfo(33405)] = L["Frost"], -- Ice Barrier
        [GetSpellInfo(11129)] = L["Fire"], -- Combustion
        [GetSpellInfo(12042)] = L["Arcane"], -- Arcane Power
        [GetSpellInfo(12043)] = L["Arcane"], -- Presence of Mind
        [GetSpellInfo(12472)] = L["Frost"], -- Icy Veins

        -- PALADIN
        [GetSpellInfo(31836)] = L["Holy"], -- Light's Grace
        [GetSpellInfo(31842)] = L["Holy"], -- Divine Illumination
        [GetSpellInfo(20216)] = L["Holy"], -- Divine Favor
        [GetSpellInfo(20375)] = L["Retribution"], -- Seal of Command
        [GetSpellInfo(20049)] = L["Retribution"], -- Vengeance
        [GetSpellInfo(20218)] = L["Retribution"], -- Sanctity Aura

        -- PRIEST
        [GetSpellInfo(15473)] = L["Shadow"], -- Shadowform
        [GetSpellInfo(45234)] = L["Discipline"], -- Focused Will
        [GetSpellInfo(27811)] = L["Discipline"], -- Blessed Recovery
        [GetSpellInfo(33142)] = L["Holy"], -- Blessed Resilience
        [GetSpellInfo(14752)] = L["Discipline"], -- Divine Spirit
        [GetSpellInfo(27681)] = L["Discipline"], -- Prayer of Spirit
        [GetSpellInfo(10060)] = L["Discipline"], -- Power Infusion
        [GetSpellInfo(33206)] = L["Discipline"], -- Pain Suppression
        [GetSpellInfo(14893)] = L["Discipline"], -- Inspiration

        -- ROGUE
        [GetSpellInfo(36554)] = L["Subtlety"], -- Shadowstep
        [GetSpellInfo(44373)] = L["Subtlety"], -- Shadowstep Speed
        [GetSpellInfo(36563)] = L["Subtlety"], -- Shadowstep DMG
        [GetSpellInfo(14278)] = L["Subtlety"], -- Ghostly Strike
        [GetSpellInfo(31233)] = L["Assassination"], -- Find Weakness

        --Shaman
        [GetSpellInfo(16190)] = L["Restoration"], -- Mana Tide Totem
        [GetSpellInfo(32594)] = L["Restoration"], -- Earth Shield
        [GetSpellInfo(30823)] = L["Enhancement"], -- Shamanistic Rage

        -- WARLOCK
        [GetSpellInfo(19028)] = L["Demonology"], -- Soul Link
        [GetSpellInfo(23759)] = L["Demonology"], -- Master Demonologist
        [GetSpellInfo(30302)] = L["Destruction"], -- Nether Protection
        [GetSpellInfo(34935)] = L["Destruction"], -- Backlash

        -- WARRIOR
        [GetSpellInfo(29838)] = L["Arms"], -- Second Wind
        [GetSpellInfo(12292)] = L["Arms"], -- Death Wish

    }
end

function Gladdy:GetSpecSpells()
    return {
        -- DRUID
        [GetSpellInfo(33831)] = L["Balance"], -- Force of Nature
        [GetSpellInfo(33983)] = L["Feral"], -- Mangle (Cat)
        [GetSpellInfo(33987)] = L["Feral"], -- Mangle (Bear)
        [GetSpellInfo(18562)] = L["Restoration"], -- Swiftmend
        [GetSpellInfo(16188)] = L["Restoration"], -- Nature's Swiftness

        -- HUNTER
        [GetSpellInfo(19577)] = L["Beast Mastery"], -- Intimidation
        [GetSpellInfo(34490)] = L["Marksmanship"], -- Silencing Shot
        [GetSpellInfo(27068)] = L["Survival"], -- Wyvern Sting
        [GetSpellInfo(19306)] = L["Survival"], -- Counterattack
        [GetSpellInfo(27066)] = L["Marksmanship"], -- Trueshot Aura

        -- MAGE
        [GetSpellInfo(12042)] = L["Arcane"], -- Arcane Power
        [GetSpellInfo(33043)] = L["Fire"], -- Dragon's Breath
        [GetSpellInfo(33933)] = L["Fire"], -- Blast Wave
        [GetSpellInfo(33405)] = L["Frost"], -- Ice Barrier
        [GetSpellInfo(31687)] = L["Frost"], -- Summon Water Elemental
        [GetSpellInfo(12472)] = L["Frost"], -- Icy Veins
        [GetSpellInfo(11958)] = L["Frost"], -- Cold Snap

        -- PALADIN
        [GetSpellInfo(33072)] = L["Holy"], -- Holy Shock
        [GetSpellInfo(20216)] = L["Holy"], -- Divine Favor
        [GetSpellInfo(31842)] = L["Holy"], -- Divine Illumination
        [GetSpellInfo(32700)] = L["Protection"], -- Avenger's Shield
        [GetSpellInfo(27170)] = L["Retribution"], -- Seal of Command
        [GetSpellInfo(35395)] = L["Retribution"], -- Crusader Strike
        [GetSpellInfo(20066)] = L["Retribution"], -- Repentance
        [GetSpellInfo(20218)] = L["Retribution"], -- Sanctity Aura

        -- PRIEST
        [GetSpellInfo(10060)] = L["Discipline"], -- Power Infusion
        [GetSpellInfo(33206)] = L["Discipline"], -- Pain Suppression
        [GetSpellInfo(14752)] = L["Discipline"], -- Divine Spirit
        [GetSpellInfo(33143)] = L["Holy"], -- Blessed Resilience
        [GetSpellInfo(34861)] = L["Holy"], -- Circle of Healing
        [GetSpellInfo(15473)] = L["Shadow"], -- Shadowform
        [GetSpellInfo(34917)] = L["Shadow"], -- Vampiric Touch

        -- ROGUE
        [GetSpellInfo(34413)] = L["Assassination"], -- Mutilate
        [GetSpellInfo(14177)] = L["Assassination"], -- Cold Blood
        [GetSpellInfo(13750)] = L["Combat"], -- Adrenaline Rush
        [GetSpellInfo(14185)] = L["Subtlety"], -- Preparation
        [GetSpellInfo(16511)] = L["Subtlety"], -- Hemorrhage
        [GetSpellInfo(36554)] = L["Subtlety"], -- Shadowstep
        [GetSpellInfo(14278)] = L["Subtlety"], -- Ghostly Strike
        [GetSpellInfo(14183)] = L["Subtlety"], -- Premeditation

        -- SHAMAN
        [GetSpellInfo(16166)] = L["Elemental"], -- Elemental Mastery
        [GetSpellInfo(30823)] = L["Enhancement"], -- Shamanistic Rage
        [GetSpellInfo(17364)] = L["Enhancement"], -- Stormstrike
        [GetSpellInfo(16190)] = L["Restoration"], -- Mana Tide Totem
        [GetSpellInfo(32594)] = L["Restoration"], -- Earth Shield
        --[GetSpellInfo(16188)] = L["Restoration"], -- Nature's Swiftness

        -- WARLOCK
        [GetSpellInfo(30405)] = L["Affliction"], -- Unstable Affliction
        --[GetSpellInfo(30911)] = L["Affliction"], -- Siphon Life
        [GetSpellInfo(30414)] = L["Destruction"], -- Shadowfury

        -- WARRIOR
        [GetSpellInfo(30330)] = L["Arms"], -- Mortal Strike
        [GetSpellInfo(12292)] = L["Arms"], -- Death Wish
        [GetSpellInfo(30335)] = L["Fury"], -- Bloodthirst
        [GetSpellInfo(12809)] = L["Protection"], -- Concussion Blow
        [GetSpellInfo(30022)] = L["Protection"], -- Devastation
    }
end

function Gladdy:GetImportantAuras()
    return {
        -- Cyclone
        [GetSpellInfo(33786)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 6,
            priority = 40,
            spellID = 33786,
        },
        -- Hibername
        [GetSpellInfo(18658)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 10,
            priority = 40,
            magic = true,
            spellID = 18658,
        },
        -- Entangling Roots
        [GetSpellInfo(26989)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 10,
            priority = 30,
            onDamage = true,
            magic = true,
            root = true,
            spellID = 26989,
        },
        -- Feral Charge
        [GetSpellInfo(16979)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 4,
            priority = 30,
            root = true,
            spellID = 16979,
        },
        -- Bash
        [GetSpellInfo(8983)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 4,
            priority = 30,
            spellID = 8983,
        },
        -- Pounce
        [GetSpellInfo(9005)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 3,
            priority = 40,
            spellID = 9005,
        },
        -- Maim
        [GetSpellInfo(22570)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 6,
            priority = 40,
            incapacite = true,
            spellID = 22570,
        },
        -- Innervate
        [GetSpellInfo(29166)] = {
            track = AURA_TYPE_BUFF,
            duration = 20,
            priority = 10,
            spellID = 29166,
        },
        -- Imp Starfire Stun
        [GetSpellInfo(16922)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 3,
            priority = 40,
            spellSchool = "physical",
            spellID = 16922,
        },


        -- Freezing Trap Effect
        [GetSpellInfo(14309)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 10,
            priority = 40,
            onDamage = true,
            magic = true,
            spellID = 14309,
        },
        -- Wyvern Sting
        [GetSpellInfo(19386)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 10,
            priority = 40,
            onDamage = true,
            poison = true,
            sleep = true,
            spellID = 19386,
        },
        -- Scatter Shot
        [GetSpellInfo(19503)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 4,
            priority = 40,
            onDamage = true,
            spellID = 19503,
        },
        -- Silencing Shot
        [GetSpellInfo(34490)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 3,
            priority = 15,
            magic = true,
            spellID = 34490,
        },
        -- Intimidation
        [GetSpellInfo(19577)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 2,
            priority = 40,
            spellID = 19577,
        },
        -- The Beast Within
        [GetSpellInfo(34692)] = {
            track = AURA_TYPE_BUFF,
            duration = 18,
            priority = 20,
            spellID = 34692,
        },


        -- Polymorph
        [GetSpellInfo(12826)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 10,
            priority = 40,
            onDamage = true,
            magic = true,
            spellID = 12826,
        },
        -- Dragon's Breath
        [GetSpellInfo(31661)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 3,
            priority = 40,
            onDamage = true,
            magic = true,
            spellID = 31661,
        },
        -- Frost Nova
        [GetSpellInfo(27088)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 8,
            priority = 30,
            onDamage = true,
            magic = true,
            root = true,
            spellID = 27088,
        },
        -- Freeze (Water Elemental)
        [GetSpellInfo(33395)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 8,
            priority = 30,
            onDamage = true,
            magic = true,
            root = true,
            spellID = 33395,
        },
        -- Counterspell - Silence
        [GetSpellInfo(18469)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 4,
            priority = 15,
            magic = true,
            spellID = 18469,
        },
        -- Ice Block
        [GetSpellInfo(45438)] = {
            track = AURA_TYPE_BUFF,
            duration = 10,
            priority = 20,
            spellID = 45438,
        },
        -- Impact
        [GetSpellInfo(12355)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 2,
            priority = 40,
            spellID = 12355,
        },

        -- Hammer of Justice
        [GetSpellInfo(10308)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 6,
            priority = 40,
            magic = true,
            spellID = 10308,
        },
        -- Repentance
        [GetSpellInfo(20066)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 6,
            priority = 40,
            onDamage = true,
            magic = true,
            incapacite = true,
            spellID = 20066,
        },
        -- Blessing of Protection
        [GetSpellInfo(10278)] = {
            track = AURA_TYPE_BUFF,
            duration = 10,
            priority = 10,
            spellID = 10278,
        },
        -- Blessing of Freedom
        [GetSpellInfo(1044)] = {
            track = AURA_TYPE_BUFF,
            duration = 14,
            priority = 10,
            spellID = 1044,
        },
        -- Divine Shield
        [GetSpellInfo(642)] = {
            track = AURA_TYPE_BUFF,
            duration = 12,
            priority = 20,
            spellID = 642,
        },


        -- Psychic Scream
        [GetSpellInfo(8122)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 8,
            priority = 40,
            onDamage = true,
            fear = true,
            magic = true,
            spellID = 8122,
        },
        -- Chastise
        [GetSpellInfo(44047)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 8,
            priority = 30,
            root = true,
            spellID = 44047,
        },
        -- Mind Control
        [GetSpellInfo(605)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 10,
            priority = 40,
            magic = true,
            spellID = 605,
        },
        -- Silence
        [GetSpellInfo(15487)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 5,
            priority = 15,
            magic = true,
            spellID = 15487,
        },
        -- Pain Suppression
        [GetSpellInfo(33206)] = {
            track = AURA_TYPE_BUFF,
            duration = 8,
            priority = 10,
            spellID = 33206,
        },


        -- Sap
        [GetSpellInfo(6770)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 10,
            priority = 40,
            onDamage = true,
            incapacite = true,
            spellID = 6770,
        },
        -- Blind
        [GetSpellInfo(2094)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 10,
            priority = 40,
            onDamage = true,
            spellID = 2094,
        },
        -- Cheap Shot
        [GetSpellInfo(1833)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 4,
            priority = 40,
            spellID = 1833,
        },
        -- Kidney Shot
        [GetSpellInfo(8643)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 6,
            priority = 40,
            spellID = 8643,
        },
        -- Gouge
        [GetSpellInfo(1776)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 4,
            priority = 40,
            onDamage = true,
            incapacite = true,
            spellID = 1776,
        },
        -- Kick - Silence
        [GetSpellInfo(18425)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 2,
            priority = 15,
            spellID = 18425,
        },
        -- Garrote - Silence
        [GetSpellInfo(1330)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 3,
            priority = 15,
            spellID = 1330,
        },
        -- Cloak of Shadows
        [GetSpellInfo(31224)] = {
            track = AURA_TYPE_BUFF,
            duration = 5,
            priority = 20,
            spellID = 31224,
        },


        -- Fear
        [GetSpellInfo(5782)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 10,
            priority = 40,
            onDamage = true,
            fear = true,
            magic = true,
            spellID = 5782,
        },
        -- Death Coil
        [GetSpellInfo(27223)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 3,
            priority = 40,
            spellID = 27223,
        },
        -- Shadowfury
        [GetSpellInfo(30283)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 2,
            priority = 40,
            magic = true,
            spellID = 30283,
        },
        -- Seduction (Succubus)
        [GetSpellInfo(6358)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 10,
            priority = 40,
            onDamage = true,
            fear = true,
            magic = true,
            spellID = 6358,
        },
        -- Howl of Terror
        [GetSpellInfo(5484)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 8,
            priority = 40,
            onDamage = true,
            fear = true,
            magic = true,
            spellID = 5484,
            texture = select(3, GetSpellInfo(5484))
        },
        -- Spell Lock (Felhunter)
        [GetSpellInfo(24259)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 3,
            priority = 15,
            magic = true,
            spellID = 24259,
        },
        -- Unstable Affliction Silence
        ["Unstable Affliction Silence"] = { -- GetSpellInfo returns "Unstable Affliction"
            track = AURA_TYPE_DEBUFF,
            duration = 5,
            priority = 15,
            magic = true,
            spellID = 31117,
        },


        -- Intimidating Shout
        [GetSpellInfo(5246)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 8,
            priority = 15,
            onDamage = true,
            fear = true,
            spellID = 5246,
        },
        -- Concussion Blow
        [GetSpellInfo(12809)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 5,
            priority = 40,
            spellID = 12809,
        },
        -- Intercept Stun
        [GetSpellInfo(25274)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 3,
            priority = 40,
            spellID = 25274,
        },
        -- Spell Reflection
        [GetSpellInfo(23920)] = {
            track = AURA_TYPE_BUFF,
            duration = 5,
            priority = 50,
            spellID = 23920,
        },
        -- Shield Bash - Silenced
        [GetSpellInfo(18498)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 3,
            priority = 15,
            spellSchool = "magic",
            spellID = 18498,
        },

        -- Grounding Totem Effect
        [GetSpellInfo(8178)] = {
            track = AURA_TYPE_BUFF,
            duration = 0,
            priority = 20,
            spellID = 8178
        },


        -- War Stomp
        [GetSpellInfo(20549)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 2,
            priority = 40,
            spellID = 20549,
        },
        -- Arcane Torrent
        [GetSpellInfo(28730)] = {
            track = AURA_TYPE_DEBUFF,
            duration = 2,
            priority = 15,
            magic = true,
            spellID = 28730,
        },
    }
end