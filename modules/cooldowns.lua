-- ========================================================================
--
--   CooldownsOptional.Cooldowns
--
--      This module was created to handle all the tasks that are
--     required for figuring out class's of group members and the
--     cooldowns each of those classes have.
--
-- ========================================================================
local AddOnName, AddOn, _ = ...
local Candy = LibStub("LibCandyBar-3.0")
local E, C = unpack(AddOn)
local CD = E:NewModule('Cooldowns')

-- ========================================================================
--   Setup A List of Cooldown Spells
-- ========================================================================
do
  local SpellList = { }
  local BattleResSpellList = { }
  
  -- Raid Cooldown Spells
  for SpellID in pairs(AddOn.Spells['SPELL_CAST_SUCCESS']) do
    SpellList[SpellID] = { }
  end
  
  -- Battle Resurection Spells
  for SpellID in pairs(AddOn.Spells['SPELL_RESURRECT']) do
    BattleResSpellList[SpellID] = { }
  end
  
  CD.SpellList = SpellList
  CD.BattleResSpellList = BattleResSpellList
end

-- ========================================================================
--   Create a Frame so that we can hook into the Combat Log
-- ========================================================================
do
  local frame = CreateFrame("FRAME")
  frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  
  local function Cooldowns_OnEvent(self, event, ...)
    local timestamp, subEvent = ...
    
    if subEvent == "SPELL_CAST_SUCCESS" then
      CD:OnSpellCastSuccess(...)
    elseif subEvent == "SPELL_RESURRECT" then
      CD:OnSpellResurrect(...)
    end
  end
  
  frame:SetScript("OnEvent", Cooldowns_OnEvent)
  CD.frame = frame
end

-- ========================================================================
--   Cooldown Funtions
-- ========================================================================
function CD:OnSpellCastSuccess(timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool)
  local settings = C.TrackSpells[spellId]
	if settings and settings.Enabled then
    local currentSpell, link = AddOn.Spells[subEvent][spellId], GetSpellLink(spellId)
    local currentPlayer = E.GroupMembers[sourceGUID]

    if currentSpell then
      CD:CreateNewActiveBar(settings, spellId, currentSpell, sourceName, destName)
    end
    
  end
end

function CD:OnSpellResurrect(timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool)
  --if C.BattleResSpellList[spellId] then
    --[==[local currentSpell = AddOn.Spells[subEvent][spellId]
    
    print(sourceName, "casts", spellName)]==]
    
  --end
end

-- ========================================================================
--   Anchor
-- /run CooldownsOptional[1]:GetModule("Cooldowns"):ShowAnchors()
-- /run CooldownsOptional[1]:GetModule("Cooldowns"):HideAnchors()
-- /run CooldownsOptionalDB = nil;ReloadUI()
-- ========================================================================
do  -- Create the "CooldownsOptionalDuration" Anchor
  local frame = CreateFrame("Frame", "CooldownsOptionalDurationAnchor", UIParent)
  frame:ClearAllPoints()
  frame:SetPoint("CENTER")
  frame:SetWidth(180)
  frame:SetHeight(22)
  
  CD.Anchor = frame
end

function CD:ShowAnchors()
  do  -- Show the "CooldownsOptionalDuration" Anchor
    local frame = CD.Anchor
    
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    
    if not frame.title then
      frame.title = frame:CreateFontString(nil, "OVERLAY")
      frame.title:SetPoint("CENTER", frame)
      frame.title:SetFont("Fonts\\FRIZQT__.TTF", 12)
      frame.title:SetText("Active Cooldowns Anchor")
    else
      frame.title:Show()
    end
    
    -- This is for dargging the window
    if not frame.region then
      frame.region = frame:CreateTitleRegion()
      frame.region:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
      frame.region:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
      frame.region:SetHeight(22)
    end
    
    frame:SetBackdrop( {
      bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
      edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
      tile     = false,
      tileSize = 0,
      edgeSize = 2,
      insets   = { left = 0, right = 0, top = 0, bottom = 0 }
    } )
     
    frame:SetBackdropColor(.1, .1, .1, .8)
    frame:SetBackdropBorderColor(.1, .1, .1, .5)
  end
end

function CD:HideAnchors()
  do  -- Hide the "CooldownsOptionalDuration" Anchor
    local frame = CD.Anchor
    frame:EnableMouse(false)
    frame.title:Hide()
    frame:SetBackdrop(nil)
  end
end

-- ========================================================================
--   Candy Cooldown Bars
-- /run CooldownsOptional[1]:GetModule("Cooldowns"):CreateNewActiveBar(97462, CooldownsOptional.Spells.SPELL_CAST_SUCCESS[97462], "")
-- ========================================================================
local Bars = { }

-- /run CooldownsOptional[1]:GetModule("Cooldowns"):CreateTestBar()
function CD:CreateTestBar()
	local raidTypes = {
		[16190] = "MANA",
		[102342] = "TANK",
		[62618] = "PROTECTION",
		[64843] = "HEAL",
		[114207] = "DAMAGE"
	}

  for spellID, raidType in pairs(raidTypes) do
		local settings = { Enabled = true, Announce = false, Active = true }
		local currentSpell = { HasTarget = false, RaidType = raidType, Duration = 30, CD = 180 }
		
		CD:CreateNewActiveBar(settings, spellID, currentSpell, "Test", "n/a")
	end
end

function CD:CreateNewActiveBar(settings, spellID, currentSpell, sourceName, destName)

  -- Filter out instant cast spells
  if currentSpell.Duration < 1 then
		if settings.Announce then
			E:SendMessageToGroup(currentSpell.RaidType, currentSpell.HasTarget, spellID, sourceName, destName)
		end
	
		return
	end

  local spellName = GetSpellInfo(spellID)
  local mybar = nil
	
	if settings.Active then
		local name, _, icon = GetSpellInfo(spellID)
		
		-- Create A Timer
		local texture = [[Interface\AddOns\Ferous Media\StatusBars\fer34]]
		
		--[[Interface\TargetingFrame\UI-StatusBar]]
		mybar = Candy:New(texture, 320, 24)
		
		name = " (" .. sourceName .. ") " .. name 
		
		table.insert(Bars, mybar)
		mybar.index = #Bars
		
		mybar:SetParent(CD.Anchor)
		mybar:SetPoint("BOTTOM", 0, -32 * mybar.index)
		
		--/run SendChatMessage("|TInterface\Icons\Spell_Holy_Renew:18:18:0:0:64:64:5:59:5:59|t Test Message", "CHANNEL", nil, 7)
		--mybar:SetColor(RAID_CLASS_COLORS[currentSpell.Class].r, RAID_CLASS_COLORS[currentSpell.Class].g, RAID_CLASS_COLORS[currentSpell.Class].b, 255)
		
		mybar:SetColor(unpack(C.RaidTypeColors[currentSpell.RaidType]))
		
		if currentSpell.HasTarget then
			name = name .. " on " .. destName
		end
		
		mybar:SetLabel(name)
		mybar:SetIcon(icon)
		mybar.candyBarLabel:SetFont([[Interface\AddOns\xCT+\media\homespun.ttf]], 10, "MONOCHROMEOUTLINE")
		mybar.candyBarLabel:SetJustifyH("LEFT")
		mybar.candyBarLabel:SetShadowColor(0, 0, 0, 0)
		mybar:SetDuration(currentSpell.Duration)
		mybar:Start()
	end
	
	if settings.Announce then
		E:SendMessageToGroup(currentSpell.RaidType, currentSpell.HasTarget, spellID, sourceName, destName)
	end
	
  E:ScheduleTimer("ActiveCooldownFinished", currentSpell.Duration + 0.2, mybar, spellID, settings, currentSpell, sourceName, destName)
end

function E:ActiveCooldownFinished(mybar, spellID, settings, currentSpell, sourceName, destName)
	if mybar then
		local found = nil
		
		for i, bar in ipairs(Bars) do
			if bar == mybar then
				found = i
			end
			if found then
				bar.index = bar.index - 1
				bar:SetPoint("BOTTOM", 0, -32 * bar.index)
			end
		end
		
		table.remove(Bars, found)
	end
	
	if settings.Announce then
		E:SendMessageToGroupFades(currentSpell.RaidType, currentSpell.HasTarget, spellID, sourceName, destName)
	end
end

function E:GetChatOptions()
	local channelIndex, channel = string.match(C.announceOptions.announceChannel ,"(%d)%d*([A-Z_]+)")
	
	return channel, nil, tonumber(channelIndex)
end

function E:SendMessageToGroup(raidType, hasTarget, spellID, sourceName, destName)
	local prefix = C.RaidTypeIcons[raidType]
	local link = GetSpellLink(spellID)
	
	local message = prefix .. " " .. sourceName .. " casts " .. link
	
	if hasTarget then
		message = message .. " on " .. destName
	end
	
	message = message .. "!"
	
	local channel, languageIndex, channelIndex = E:GetChatOptions()
	
	if channel == "SELF" then
		print(message)
	else
		SendChatMessage(message, channel, languageIndex, channelIndex)
	end
end

function E:SendMessageToGroupFades(raidType, hasTarget, spellID, sourceName, destName)
	local prefix = C.RaidTypeIcons[raidType]
	local link = GetSpellLink(spellID)
	local action = " casts "
	
	local message = prefix .. " " .. sourceName .. "'s " .. link .. " ended"
	
	if hasTarget then
		message = message .. " on " .. destName
	end
	
	message = message .. "!"
	
	local channel, languageIndex, channelIndex = E:GetChatOptions()
	
	if channel == "SELF" then
		print(message)
	else
		SendChatMessage(message, channel, languageIndex, channelIndex)
	end
end

