local UnitName = UnitName

local Gladdy = LibStub("Gladdy")
local L = Gladdy.L
local VersionCheck = Gladdy:NewModule("VersionCheck", 1, {
})
LibStub("AceComm-3.0"):Embed(VersionCheck)

function VersionCheck:Initialize()
    self.frames = {}

    self:RegisterMessage("JOINED_ARENA")
    self.playerName = UnitName("player")
end

function VersionCheck:Reset()
    self:UnregisterComm("GladdyVCheck")
end

function VersionCheck:JOINED_ARENA()
    self:RegisterComm("GladdyVCheck", VersionCheck.OnCommReceived)
end

function VersionCheck:Test(unit)
    if unit == "arena1" then
        self:RegisterComm("GladdyVCheck", VersionCheck.OnCommReceived)
        self:SendCommMessage("GladdyVCheck", Gladdy.version, "RAID", self.playerName)
    end
end

function VersionCheck.OnCommReceived(prefix, message, distribution, sender)
    if sender ~= VersionCheck.playerName then
        local addonVersion = Gladdy.version
        if (message == addonVersion) then
            --Gladdy:Print("Version", "\"".. addonVersion.."\"", "is up to date")
        else
            Gladdy:Warn("Current version", "\"".. addonVersion.."\"", "is outdated. Most recent version is", "\"".. message.."\"")
            Gladdy:Warn("Please download the latest Gladdy version at:")
            Gladdy:Warn("https://github.com/XiconQoo/Gladdy")
        end
    end
end

function VersionCheck:GetOptions()
    return nil
end