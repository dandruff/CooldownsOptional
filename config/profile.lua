local AddOnName, AddOn, _ = ...

local function GetSpellEntry(enabled, announce, active)
  return { Enabled = enabled, Announce = announce, Active = active }
end

AddOn.Defaults = {
  ['showStartupMesasge'] = true,
  
  ['announceOptions'] = {
    ['enableAnnounce'] = true,
    ['announceChannel'] = "04INSTANCE_CHAT",
  },
  
  ['TrackSpells'] = {
    --[139] = GetSpellEntry(true, false, true),  -- Priest Renew (Debug Spell)
  
    [29166]  = GetSpellEntry(true, false, true),  -- Innervate (Druid)
    [102342] = GetSpellEntry(true, false, true),  -- Ironbark (Druid)
    [740]    = GetSpellEntry(true, false, true),  -- 111 (Druid)
    [116849] = GetSpellEntry(true, false, true),  -- Life Cocoon (Monk)
    [115310] = GetSpellEntry(true, false, true),  -- Revival (Monk)
    [115176] = GetSpellEntry(true, false, true),  -- Zen Meditation (Monk)
    [31821]  = GetSpellEntry(true, false, true),  -- Devotion Aura (Paladin)
    [6940]   = GetSpellEntry(true, false, true),  -- Hand of Sacrifice (Paladin)
    [64843]  = GetSpellEntry(true, false, true),  -- Divine Hymn (Priest)
    [47788]  = GetSpellEntry(true, false, true),  -- Guardian Spirit (Priest)
    [64901]  = GetSpellEntry(true, false, true),  -- Hymn of Hope (Priest)
    [33206]  = GetSpellEntry(true, false, true),  -- Pain Suppression (Priest)
    [62618]  = GetSpellEntry(true, false, true),  -- Power Word: Barrier (Priest)
    [108968] = GetSpellEntry(true, false, true),  -- Void Shift (Priest)
		[76577]  = GetSpellEntry(true, false, true),  -- Smoke Bomb (Rogue)
    [16190]  = GetSpellEntry(true, false, true),  -- Mana Tide Totem (Shaman)
    [98008]  = GetSpellEntry(true, false, true),  -- Spirit Link Totem (Shaman)
    [120668] = GetSpellEntry(true, false, true),  -- Stormlash Totem (Shaman)
    [114203] = GetSpellEntry(true, false, true),  -- Demoralizing Banner (Warrior)
    [97462]  = GetSpellEntry(true, false, true),  -- Rallying Cry (Warrior)
    [114207] = GetSpellEntry(true, false, true),  -- Skull Banner (Warrior)
  },
  
  ['TrackBattleResSpells'] = {
    [61999]  = true,  -- Raise Ally (Death Knight)
    [20484]  = true,  -- Rebirth (Druid)
    [95750]  = true,  -- Soul Stone (Warlock)
  },
  
  ['RaidTypeColors'] = {
    ['DAMAGE'] = { .78, .61, .43, 1 },
    ['HEAL'] = { .1, 1, .1, 1 },
    ['MANA'] = { .2, .4, 1, 1 },
    ['PROTECTION'] = { 1, 1, .1, 1 },
    ['TANK'] = { 1, .1, .1, 1 },
  },
  
  ['RaidTypeIcons'] = {
    ['DAMAGE'] = "{rt7}",
    ['HEAL'] = "{rt4}",
    ['MANA'] = "{rt6}",
    ['PROTECTION'] = "{rt1}",
    ['TANK'] = "{rt2}",
  },
  
}
