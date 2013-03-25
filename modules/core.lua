local AddOnName, AddOn, _ = ...
local DEBUG = false

-- ========================================================================
--   Initial CooldownsOptional AddOn
-- ========================================================================
AddOn[1] = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceConsole-3.0", "AceTimer-3.0")
AddOn[2] = { } -- Config

_G[AddOnName] = AddOn


local AC, ACD = LibStub('AceConfig-3.0'), LibStub('AceConfigDialog-3.0')
local E, C = unpack(AddOn)

E.noop = function() end

-- ========================================================================
--   Core CooldownsOptional Functions
-- ========================================================================
function E:OnInitialize()

  -- Load the Database
  self.db = LibStub('AceDB-3.0'):New('CooldownOptionalDB')
  self.db:RegisterDefaults({profile = AddOn.Defaults})
  self.db.RegisterCallback(self, 'OnProfileChanged', 'UpdateProfile')
  self.db.RegisterCallback(self, 'OnProfileCopied', 'UpdateProfile')
  self.db.RegisterCallback(self, 'OnProfileReset', 'UpdateProfile')
  self.db:GetCurrentProfile()
  E:UpdateProfile()
  
  -- Add Ace3 Profile manager to the Options
  local profile = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
  AC:RegisterOptionsTable(AddOnName.."Profiles", profile)
  ACD:AddToBlizOptions(AddOnName.."Profiles", "Profiles", "CooldownsOptional")
  
  E:Debug("C.showStartupMesasge", C.showStartupMesasge)
  
  if C.showStartupMesasge then
    self:DisplayMesage("Loaded Successfully. Type '/cdo' to show the config.")
  end

end

local frame = CreateFrame("FRAME")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function (self, event)
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  
  E:InitializeTracker()
	E:InitializeOptionSpells()
  
end)

function E:DisplayMesage(message)
  print("CooldownOptional: " .. tostring(message))
end

function E:Debug(...)
  if DEBUG then
    print("CDO Debug: ", ...)
  end
end

function E:UpdateProfile()
  E:Debug("Updating Profile")
  
  -- Hook into 'AddOn[2]' (also 'C') as our database
  setmetatable(C, {
    __index = function(_,k) return self.db.profile[k] end,
    __newindex = function(_,k,v) self.db.profile[k] = v end,
  })
end
