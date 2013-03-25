-- ========================================================================
--
--   CooldownsOptional.Tracker
--
--      This module was created as a wrapper to 'LibGroupInSpecT-1.0'
--    for the rest of the addon to interface through.  It will also
--    handle the raid member caching and updating the rest of the addon
--    when a member is added, removed, or updated.
--
-- ========================================================================
local AddOnName, AddOn, _ = ...

local E, C = unpack(AddOn)
local T = E:NewModule('Tracker')
local InspecLib = LibStub:GetLibrary("LibGroupInSpecT-1.0")


E.GroupMembers = { }
T.GroupCooldowns = { }


function E:InitializeTracker()
  InspecLib.RegisterCallback(T, "GroupInSpecT_Update", "UnitUpdated")
  InspecLib.RegisterCallback(T, "GroupInSpecT_Remove", "UnitRemoved")
end

function T:UnitUpdated(event, guid, unit, info)
  -- It appears that LibGroupInSpecT invokes this event when you first event the world
	-- I'm just going to use it to update the player :D
  if not guid then
		guid, unit, info = UnitGUID("player"), "player", { }
		UpdatePlayerInfo(guid, unit, info)
	end
	
	E.GroupMembers[guid] = info
  T:UpdateUnitCooldown(info, true)
	
	E:Debug("Adding", info.name, "(" .. tostring(info.spec_name_localized) .. ")", "to the database.")
end

function T:UnitRemoved(event, guid)
  E.GroupMembers[guid] = nil
  T:UpdateUnitCooldown(info, false)
end

function T:SetRaidTargetUnit(guid, iconId)
  local unit = InspecLib:GuidToUnit(guid)
  if unit then
    SetRaidTarget(unit, iconId)
  end
end

function T:ClearRaidTargetUnit(guid)
  local unit = InspecLib:GuidToUnit(guid)
  if unit then
    SetRaidTarget(unit, 0)
  end
end

-- ========================================================================
--   Cooldown Tracker
-- ========================================================================
function T:ClearCooldowns()
	
end

local function CreateCooldownEntry(lastActive)
	return { lastActive = lastActive or 0 }
end

function T:UpdateUnitCooldown(info, add)
	local guid = tostring(info.guid)

	for spell, entry in pairs(AddOn.Spells) do
		if entry.Class == info.class and (not entry.Spec or entry.Spec == info.global_spec_id) then
			if not self.GroupCooldowns[spell] then
				self.GroupCooldowns[spell] = { }
			end
			
			if add then
				if not self.GroupCooldowns[spell][guid] then
					self.GroupCooldowns[spell][guid] = CreateCooldownEntry()
				end
			else
				self.GroupCooldowns[spell][guid] = { }
			end
		end
	end
end