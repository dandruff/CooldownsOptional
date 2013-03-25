local AddOnName, AddOn, _ = ...
local E, C = unpack(AddOn)
local AC = LibStub('AceConfig-3.0')
local ACD = LibStub('AceConfigDialog-3.0')

local function getOption(info) return C[info[#info-1]][info[#info]] end
local function setOption(info, value) C[info[#info-1]][info[#info]] = value end
local function getSpell(info) return C.TrackSpells[tonumber(info[#info-1])][info[#info]] end
local function setSpell(info, value) C.TrackSpells[tonumber(info[#info-1])][info[#info]] = value end
local function getEnabled(info) return not C.TrackSpells[tonumber(info[#info-1])].Enabled end

local function getChatChannels()
	local channels, list = { }, { GetChannelList() }
	
	channels["00SELF"] = "Self"
	channels["01SAY"] = "Say"
	channels["02Yell"] = "Yell"
	channels["03PARTY"] = "Party"
	channels["04INSTANCE_CHAT"] = "Instance"
	channels["05RAID"] = "Raid"
	channels["06GUILD"] = "Guild"
	channels["07OFFICER"] = "Officer"
	
	for i = 1, #list/2 do
		channels[i.."CHANNEL"] = i .. " - " .. list[i*2]
	end
	
	return channels
end

AddOn.Options = {
  name = "CooldownsOptional Control Panel",
  type = 'group',
  handler = E,
  args = {
    title = {
      order = 0,
      type = "description",
      name = "Made for |cff40FF80<Skill Optional>|r on |cff40D0FFWhisperwind-US|r by |cffFF8000Dandruff|r.",
    },
		
		barOptions = {
			type = 'group',
			name = "Announce Options",
			guiInline = true,
			order = 1,
			args = {
				width = {
          order = 1,
          name = "Bar Width",
          type = 'range',
          min = 50, max = 750, step = 1,
        },
				
				height = {
          order = 1,
          name = "Bar Height",
          type = 'range',
          min = 10, max = 50, step = 1,
        },
				
				spacing = {
          order = 1,
          name = "Vertical Spacing",
          type = 'range',
          min = -4, max = 30, step = 1,
        },
				
				font = {
          type = 'select', dialogControl = 'LSM30_Font',
          order = 21,
          name = "Font",
          values = AceGUIWidgetLSMlists.font,
        }, 
				
				fontSize = {
          order = 22,
          name = "Font Size",
          type = 'range',
          min = 6, max = 32, step = 1,
        },
			},
		},
		
		announceOptions = {
			type = 'group',
			name = "Announce Options",
			guiInline = true,
			order = 2,
			args = {
				enableAnnounce = {
					type = 'toggle',
					order = 1,
					name = "Enable",
					desc = "Enables/disables all spell announcement.",
					get = getOption,
					set = setOption,
				},
			
				announceChannel = {
					type = 'select',
					order = 2,
					name = "Chat Channel",
					values = getChatChannels,
					get = getOption,
					set = setOption,
				},
				
				showPrefixes = {
					type = 'toggle',
					order = 3,
					name = "Show Prefixes",
					desc = "Enabling this option will add icons to the announce message:\n\n" ..
						"Triangle - Raid Healing Cooldowns\n" ..
						"Star - Raid Damage Reduction Cooldowns\n" ..
						"Square - Raid Mana Cooldowns\n" ..
						"Circle - Single Target Cooldowns\n" ..
						"Cross - Raid DPS Cooldowns\n",
				},
				
			},
		},
		
  },
}

AddOn.OptionsSpells = {
  type = "group",
  order = 1,
  name = "Spells",
  args = {
	  HEAL_TITLE = {
			name = "\n|cff798BDDRaid Healing Cooldowns|r",
		  type = 'description',
			fontSize = 'large',
			order = 1,
		},
		
    HEAL = {
      type = "group",
      order = 2,
      name = "",
      guiInline = true,
      args = { },
    },
		
		PROTECTION_TITLE = {
			name = "\n|cff798BDDRaid Damage Reduction Cooldowns|r",
		  type = 'description',
			fontSize = 'large',
			order = 3,
		},
    
    PROTECTION = {
      type = "group",
      order = 4,
      name = "",
      guiInline = true,
      args = { },
    },
		
		MANA_TITLE = {
			name = "\n|cff798BDDRaid Mana Cooldowns|r",
		  type = 'description',
			fontSize = 'large',
			order = 5,
		},
    
    MANA = {
      type = "group",
      order = 6,
      name = "",
      guiInline = true,
      args = { },
    },
		
		TANK_TITLE = {
			name = "\n|cff798BDDSingle Target Cooldowns|r",
		  type = 'description',
			fontSize = 'large',
			order = 7,
		},
    
    TANK = {
      type = "group",
      order = 8,
      name = "",
      guiInline = true,
      args = { },
    },
		
		DAMAGE_TITLE = {
			name = "\n|cff798BDDRaid DPS Cooldowns|r",
		  type = 'description',
			fontSize = 'large',
			order = 9,
		},
    
    DAMAGE = {
      type = "group",
      order = 10,
      name = "",
      guiInline = true,
      args = { },
    },
    
  },
}

local getSpellDescription
do
	local cache = {}
	local scanner = CreateFrame("GameTooltip")
	scanner:SetOwner(WorldFrame, "ANCHOR_NONE")
	local lcache, rcache = {}, {}
	for i = 1, 4 do
		lcache[i], rcache[i] = scanner:CreateFontString(), scanner:CreateFontString()
		lcache[i]:SetFontObject(GameFontNormal); rcache[i]:SetFontObject(GameFontNormal)
		scanner:AddFontStrings(lcache[i], rcache[i])
	end
	function getSpellDescription(spellId)
		if cache[spellId] then return cache[spellId] end
		scanner:ClearLines()
		scanner:SetHyperlink("spell:"..spellId)
		for i = scanner:NumLines(), 1, -1 do
			local desc = lcache[i] and lcache[i]:GetText()
			if desc then
				cache[spellId] = desc
				return desc
			end
		end
	end
end

local classes = { }
FillLocalizedClassList(classes)

function E:InitializeOptionSpells()
  for id, entry in pairs(AddOn.Spells.SPELL_CAST_SUCCESS) do
    local name, _, icon = GetSpellInfo(id)
    local description = "|c" .. RAID_CLASS_COLORS[entry.Class].colorStr
    if entry.SpecName == "All" then
      description = description .. classes[entry.Class] .. "|r - |cffFF0000ID|r |cffFFFF00"..tostring(id).."|r\n\n"
    else
      description = description .. entry.SpecName .. " " .. classes[entry.Class] .. "|r - |cffFF0000ID|r |cffFFFF00"..tostring(id).."|r\n\n"
    end
		
		description = description .. getSpellDescription(id)
		
    local group = {
		  name = name,
			order = #AddOn.OptionsSpells.args[entry.RaidType].args,
			type = 'group',
			args = {
				icon = {
					type = 'execute',
					order = 0,
					name = name,
					image = icon, --string.format('|TInterface\Icons\Spell_Holy_Renew:18:18:0:0:64:64:5:59:5:59|t ', icon)
					desc = description,
					func = E.noop,
				},
				spacer = {
					type = 'description',
					name = "",
					width = 'double',
					order = 1,
				},
				Enabled = {
					type = 'toggle',
					order = 2,
					name = "Track Group CD",
					desc = "Attempts to track the cooldown of your raid members.",
					get = getSpell,
					set = setSpell,
				},
				Announce = {
					type = 'toggle',
					order = 3,
					name = "Announce to Group",
					desc = "Enable this spell to be announced to your raid.",
					get = getSpell,
					set = setSpell,
					disabled = getEnabled,
				},
				Active = {
					type = 'toggle',
					order = 4,
					name = "Show when Active",
					desc = "Display a bar when this spell is active by yourself or raid member.",
					get = getSpell,
					set = setSpell,
					disabled = getEnabled,
				},
			},
		}
    AddOn.OptionsSpells.args[entry.RaidType].args[tostring(id)] = group
  end
end

AC:RegisterOptionsTable(AddOnName.."Options", AddOn.Options)
AC:RegisterOptionsTable(AddOnName.."OptionsSpells", AddOn.OptionsSpells)
ACD:AddToBlizOptions(AddOnName.."Options", "CooldownsOptional")
ACD:AddToBlizOptions(AddOnName.."OptionsSpells", "Spells", "CooldownsOptional")
