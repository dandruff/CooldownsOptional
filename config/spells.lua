local AddOnName, AddOn, _ = ...

local specs = {
	["DEATHKNIGHT"] = { ["Blood"] = 250, ["Frost"] = 251, ["Unholy"] = 252, },
  ["DRUID"] = { ["Balance"] = 102, ["Feral"] = 103, ["Guardian"] = 104, ["Restoration"] = 105, },
  ["HUNTER"] = { ["Beast Master"] = 253, ["Marksmanship"] = 254, ["Survival"] = 255, },
  ["MAGE"] = { ["Arcane"] = 62, ["Fire"] = 63, ["Frost"] = 64, },
  ["MONK"] = { ["Brewmaster"] = 268, ["Windwalker"] = 269, ["Mistweaver"] = 270, },
	["PALADIN"] = { ["Holy"] = 65, ["Protection"] = 66, ["Retribution"] = 67, },
  ["PRIEST"] = { ["Discipline"] = 256, ["Holy"] = 257, ["Shadow"] = 258, },
	["ROGUE"] = { ["Assassination"] = 259, ["Combat"] = 260, ["Subtlety"] = 261, },
	["SHAMAN"] = { ["Elemental"] = 262, ["Enhancement"] = 263, ["Restoration"] = 264, },
	["WARLOCK"] = { ["Affliction"] = 265, ["Demonology"] = 266, ["Destruction"] = 267, },
	["WARRIOR"] = { ["Arms"] = 71, ["Fury"] = 72, ["Protection"] = 73, }
}

-- Input: Class, Global Spec ID, Duration of Spell, Cooldown Length, Does the spell need a Target
local function CreateSpellEntry(c, s, d, l, r, t)
  return { ['Class'] = c, ['SpecName'] = s, ['Spec'] = specs[c][s], ['Duration'] = d, ['CD'] = l, ['RaidType'] = r, ['HasTarget'] = t }
end

-- Input: Class, Cooldown Length
local function CreateBattleResEntry(c, l)
  return { ['Class'] = c, ['CD'] = l }
end


AddOn.Spells = {

  -- Raid Cooldown Spells
  ['SPELL_CAST_SUCCESS'] = {
		-- Debug
		--[139]    = CreateSpellEntry("PRIEST", "All", 12, 6, "PROTECTION", true),            -- Renew (Priest) DEBUG

    -- Druid
    [29166]  = CreateSpellEntry("DRUID", "All", 10, 180, "MANA", true),           -- Innervate
    [102342] = CreateSpellEntry("DRUID", "All", 12, 120, "TANK", true),           -- Ironbark
    [740]    = CreateSpellEntry("DRUID", "Restoration", 8, 180, "HEAL"),          -- Tranquility

    -- Monk
    [116849] = CreateSpellEntry("MONK", "Mistweaver", 12, 120, "TANK", true),     -- Life Cocoon
    [115310] = CreateSpellEntry("MONK", "Mistweaver", 0, 180, "HEAL"),            -- Revival
    [115176] = CreateSpellEntry("MONK", "All", 8, 180, "PROTECTION"),             -- Zen Meditation

    -- Paladin
    [31821]  = CreateSpellEntry("PALADIN", "All", 6, 180, "PROTECTION"),          -- Devotion Aura
    [6940]   = CreateSpellEntry("PALADIN", "All", 12, 180, "TANK", true),         -- Hand of Sacrifice

    -- Priest
    [64843]  = CreateSpellEntry("PRIEST", "Holy", 10, 180, "HEAL"),               -- Divine Hymn
    [47788]  = CreateSpellEntry("PRIEST", "Holy", 10, 180, "TANK", true),         -- Guardian Spirit
    [64901]  = CreateSpellEntry("PRIEST", "All", 8, 360, "MANA"),                 -- Hymn of Hope
    [33206]  = CreateSpellEntry("PRIEST", "Discipline", 8, 180, "TANK", true),    -- Pain Suppression
    [62618]  = CreateSpellEntry("PRIEST", "Discipline", 10, 180, "PROTECTION"),   -- Power Word: Barrier
    [108968] = CreateSpellEntry("PRIEST", "All", 0, 360, "TANK", true),           -- Void Shift

		-- Rogue
		[76577]  = CreateSpellEntry("ROGUE", "All", 5, 180, "PROTECTION"),        		-- Smoke Bomb
		
    -- Shaman
    [16190]  = CreateSpellEntry("SHAMAN", "Restoration", 12, 180, "MANA"),        -- Mana Tide Totem
    [98008]  = CreateSpellEntry("SHAMAN", "Restoration", 6, 180, "HEAL"),         -- Spirit Link Totem
    [120668] = CreateSpellEntry("SHAMAN", "All", 10, 300, "DAMAGE"),              -- Stormlash Totem

    -- Warrior
    [114203] = CreateSpellEntry("WARRIOR", "All", 15, 180, "DAMAGE"),             -- Demoralizing Banner
    [97462]  = CreateSpellEntry("WARRIOR", "All", 10, 180, "PROTECTION"),         -- Rallying Cry
    [114207] = CreateSpellEntry("WARRIOR", "All", 10, 180, "DAMAGE"),             -- Skull Banner

  },
  
  -- Battle Resurection Spells
  ['SPELL_RESURRECT'] = {
  
    [61999]  = CreateBattleResEntry("DEATHKNIGHT", 600),                  -- Raise Ally
    [20484]  = CreateBattleResEntry("DRUID", 600),                        -- Rebirth
    [95750]  = CreateBattleResEntry("WARLOCK", 600),                      -- Soul Stone
    
  },
  
}
