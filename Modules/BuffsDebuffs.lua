local GetSpellInfo = GetSpellInfo
local CreateFrame = CreateFrame
local GetTime = GetTime
local select, lower, ceil, tremove, tinsert, pairs, ipairs = select, string.lower, ceil, tremove, tinsert, pairs, ipairs
local auraTypeColor = { }
local AURA_TYPE_DEBUFF, AURA_TYPE_BUFF = AURA_TYPE_DEBUFF, AURA_TYPE_BUFF
local auraTypes = {AURA_TYPE_BUFF, AURA_TYPE_DEBUFF}

auraTypeColor["none"]     = { r = 0.80, g = 0, b = 0 , a = 1}
auraTypeColor["magic"]    = { r = 0.20, g = 0.60, b = 1.00, a = 1}
auraTypeColor["curse"]    = { r = 0.60, g = 0.00, b = 1.00, a = 1 }
auraTypeColor["disease"]  = { r = 0.60, g = 0.40, b = 0, a = 1 }
auraTypeColor["poison"]   = { r = 0.00, g = 0.60, b = 0, a = 1 }
auraTypeColor["immune"]   = { r = 1.00, g = 0.02, b = 0.99, a = 1 }
auraTypeColor["form"]     = auraTypeColor["none"]
auraTypeColor["aura"]     = auraTypeColor["none"]
auraTypeColor[""]         = auraTypeColor["none"]

---------------------------
-- Module init
---------------------------

local Gladdy = LibStub("Gladdy")
local L = Gladdy.L
local defaultTrackedDebuffs = select(2, Gladdy:GetAuras("debuff"))
local defaultTrackedBuffs = select(2, Gladdy:GetAuras("buff"))
local BuffsDebuffs = Gladdy:NewModule("BuffsDebuffs", nil, {
    buffsEnabled = true,
    buffsShowAuraDebuffs = false,
    buffsAlpha = 1,
    buffsIconSize = 30,
    buffsWidthFactor = 1,
    buffsIconPadding = 1,
    buffsBuffsAlpha = 1,
    buffsBuffsIconSize = 30,
    buffsBuffsWidthFactor = 1,
    buffsBuffsIconPadding = 1,
    buffsDisableCircle = false,
    buffsCooldownAlpha = 1,
    buffsFont = "DorisPP",
    buffsFontScale = 1,
    buffsFontColor = {r = 1, g = 1, b = 0, a = 1},
    buffsDynamicColor = true,
    buffsCooldownPos = "TOP",
    buffsCooldownGrowDirection = "RIGHT",
    buffsXOffset = 0,
    buffsYOffset = 0,
    buffsBuffsCooldownPos = "BOTTOM",
    buffsBuffsCooldownGrowDirection = "RIGHT",
    buffsBuffsXOffset = 0,
    buffsBuffsYOffset = 0,
    buffsBorderStyle = "Interface\\AddOns\\Gladdy\\Images\\Border_squared_blp",
    buffsBorderColor = {r = 1, g = 1, b = 1, a = 1},
    buffsBorderColorsEnabled = true,
    trackedDebuffs = defaultTrackedDebuffs,
    trackedBuffs = defaultTrackedBuffs,
    buffsBorderColorCurse = auraTypeColor["curse"],
    buffsBorderColorMagic = auraTypeColor["magic"],
    buffsBorderColorPoison = auraTypeColor["poison"],
    buffsBorderColorPhysical = auraTypeColor["none"],
    buffsBorderColorImmune = auraTypeColor["immune"],
    buffsBorderColorDisease = auraTypeColor["disease"],
    buffsBorderColorForm = auraTypeColor["form"],
    buffsBorderColorAura = auraTypeColor["aura"]
})

local spellSchoolToOptionValueTable
local function spellSchoolToOptionValue(spellSchool)
    if Gladdy.db.buffsBorderColorsEnabled and spellSchool then
        return spellSchoolToOptionValueTable[spellSchool].r,
        spellSchoolToOptionValueTable[spellSchool].g,
        spellSchoolToOptionValueTable[spellSchool].b,
        spellSchoolToOptionValueTable[spellSchool].a
    else
        return Gladdy.db.buffsBorderColor.r,Gladdy.db.buffsBorderColor.g,Gladdy.db.buffsBorderColor.b,Gladdy.db.buffsBorderColor.a
    end
end

function BuffsDebuffs:OnEvent(event, ...)
    self[event](self, ...)
end

function BuffsDebuffs:Initialize()
    self.frames = {}
    self.spells = {}
    self.icons = {}
    self.trackedCC = {}
    self.framePool = {}
    self:RegisterMessage("JOINED_ARENA")
    self:RegisterMessage("AURA_FADE")
    self:RegisterMessage("AURA_GAIN")
    self:RegisterMessage("AURA_GAIN_LIMIT")
    self:SetScript("OnEvent", BuffsDebuffs.OnEvent)
    spellSchoolToOptionValueTable = {
        curse = Gladdy.db.buffsBorderColorCurse,
        magic = Gladdy.db.buffsBorderColorMagic,
        poison = Gladdy.db.buffsBorderColorPoison,
        physical = Gladdy.db.buffsBorderColorPhysical,
        immune = Gladdy.db.buffsBorderColorImmune,
        disease = Gladdy.db.buffsBorderColorDisease,
        form = Gladdy.db.buffsBorderColorForm,
    }

end

function BuffsDebuffs:JOINED_ARENA()
    if Gladdy.db.buffsEnabled then
        for i=1, Gladdy.curBracket do
            local unit = "arena" .. i
            if not self.frames[unit].auras then
                self.frames[unit].auras = {[AURA_TYPE_DEBUFF] = {}, [AURA_TYPE_BUFF] = {}}
            end
        end
    end
end

function BuffsDebuffs:ResetUnit(unit)
    if not self.frames[unit] then return end
    for _, auraType in ipairs(auraTypes) do
        local i = #self.frames[unit].auras[auraType]
        while (#self.frames[unit].auras[auraType] > 0) do
            self.frames[unit].auras[auraType][i]:Hide()
            tinsert(self.framePool, tremove(self.frames[unit].auras[auraType], i))
            i = i - 1
        end
    end
end

function BuffsDebuffs:Reset()
    for i=1,#self.framePool do
        self.framePool[i]:Hide()
    end
end

function BuffsDebuffs:Test(unit)
    if Gladdy.db.buffsEnabled then
        if unit == "arena1" or unit == "arena3" then
            self:AddOrRefreshAura(unit, 1943, AURA_TYPE_DEBUFF, 10, 10, 1,"physical", select(3, GetSpellInfo(1943)), 1)
            self:AddOrRefreshAura(unit, 18647, AURA_TYPE_DEBUFF, 10, 10,1, "immune", select(3, GetSpellInfo(18647)), 2)
            self:AddOrRefreshAura(unit, 27218, AURA_TYPE_DEBUFF, 24, 20,1, "curse", select(3, GetSpellInfo(27218)), 3)
            self:AddOrRefreshAura(unit, 27216, AURA_TYPE_DEBUFF, 18, 18,1, "magic", select(3, GetSpellInfo(27216)), 4)
            self:AddOrRefreshAura(unit, 27189, AURA_TYPE_DEBUFF, 12, 12,5, "poison", select(3, GetSpellInfo(27189)), 5)
            self:AddOrRefreshAura(unit, 1, AURA_TYPE_BUFF, 20, 20,5, "magic", select(3, GetSpellInfo(32999)), 1)
            self:AddOrRefreshAura(unit, 1, AURA_TYPE_BUFF, 20, 20,5, "magic", select(3, GetSpellInfo(25389)), 2)
        elseif unit == "arena2" then
            self:AddOrRefreshAura(unit, 1943, AURA_TYPE_DEBUFF, 10, 10, 1, "physical", select(3, GetSpellInfo(1943)), 1)
            self:AddOrRefreshAura(unit, 1, AURA_TYPE_DEBUFF, 20, 20,5, "poison", select(3, GetSpellInfo(1)), 2)
            self:AddOrRefreshAura(unit, 1, AURA_TYPE_BUFF, 20, 20,5, "magic", select(3, GetSpellInfo(32999)), 1)
            self:AddOrRefreshAura(unit, 1, AURA_TYPE_BUFF, 20, 20,5, "magic", select(3, GetSpellInfo(25389)), 2)
        end
    end
end

---------------------------
-- Aura handlers
---------------------------

function BuffsDebuffs:AURA_FADE(unit, auraType)
    if (not self.frames[unit] or not Gladdy.db.buffsEnabled) then
        return
    end
    if auraType == AURA_TYPE_DEBUFF then
        self.frames[unit].numDebuffs = 0
    else
        self.frames[unit].numBuffs = 0
    end
end

function BuffsDebuffs:AURA_GAIN_LIMIT(unit, auraType, limit)
    if (not self.frames[unit] or not Gladdy.db.buffsEnabled) then
        return
    end
    local numAura
    if auraType == AURA_TYPE_DEBUFF then
        numAura = self.frames[unit].numDebuffs
    else
        numAura = self.frames[unit].numBuffs
    end
    for i=numAura + 1, #self.frames[unit].auras[auraType] do
        self.frames[unit].auras[auraType][i]:Hide()
    end
end

function BuffsDebuffs:AURA_GAIN(unit, auraType, spellID, spellName, texture, duration, expirationTime, count, spellSchool)
    if (not self.frames[unit] or not Gladdy.db.buffsEnabled) then
        return
    end
    local auraFrame = self.frames[unit]
    local aura = Gladdy.db.auraListDefault[spellName] and Gladdy.db.auraListDefault[spellName].enabled
    if aura and Gladdy.db.buffsShowAuraDebuffs then
        aura = false
    end
    if not aura and spellID and expirationTime and (Gladdy.db.trackedBuffs[spellName] or Gladdy.db.trackedDebuffs[spellName]) then
        local index
        if auraType == AURA_TYPE_DEBUFF then
            auraFrame.numDebuffs = auraFrame.numDebuffs + 1
            index = auraFrame.numDebuffs
        else
            auraFrame.numBuffs = auraFrame.numBuffs + 1
            index = auraFrame.numBuffs
        end
        BuffsDebuffs:AddOrRefreshAura(unit,spellID, auraType, duration, expirationTime - GetTime(), count, spellSchool and lower(spellSchool) or "physical", texture, index)
    end
end

---------------------------
-- Frame init
---------------------------

function BuffsDebuffs:CreateFrame(unit)
    local debuffFrame = CreateFrame("Frame", "GladdyDebuffs" .. unit, Gladdy.buttons[unit])
    debuffFrame:SetHeight(Gladdy.db.buffsIconSize)
    debuffFrame:SetWidth(1)
    debuffFrame:SetPoint("BOTTOMLEFT", Gladdy.buttons[unit].healthBar, "TOPLEFT", 0, Gladdy.db.highlightBorderSize + Gladdy.db.padding)
    debuffFrame.unit = unit
    local buffFrame = CreateFrame("Frame", "GladdyBuffs" .. unit, Gladdy.buttons[unit])
    buffFrame:SetHeight(Gladdy.db.buffsIconSize)
    buffFrame:SetWidth(1)
    buffFrame:SetPoint("BOTTOMLEFT", Gladdy.buttons[unit].healthBar, "TOPLEFT", 0, Gladdy.db.highlightBorderSize + Gladdy.db.padding)
    buffFrame.unit = unit
    self.frames[unit] = {}
    self.frames[unit].buffFrame = buffFrame
    self.frames[unit].debuffFrame = debuffFrame
    self.frames[unit].auras = {[AURA_TYPE_DEBUFF] = {}, [AURA_TYPE_BUFF] = {}}
end

local function setAuraSize(aura, auraType)
    if auraType == AURA_TYPE_DEBUFF then
        aura:SetWidth(Gladdy.db.buffsIconSize * Gladdy.db.buffsWidthFactor)
        aura:SetHeight(Gladdy.db.buffsIconSize)
        aura:SetAlpha(Gladdy.db.buffsAlpha)
    else
        aura:SetWidth(Gladdy.db.buffsBuffsIconSize * Gladdy.db.buffsBuffsWidthFactor)
        aura:SetHeight(Gladdy.db.buffsBuffsIconSize)
        aura:SetAlpha(Gladdy.db.buffsBuffsAlpha)
    end
    aura.cooldowncircle:SetWidth(aura:GetWidth() - aura:GetWidth()/16)
    aura.cooldowncircle:SetHeight(aura:GetHeight() - aura:GetHeight()/16)
    aura.cooldowncircle:ClearAllPoints()
    aura.cooldowncircle:SetPoint("CENTER", aura, "CENTER")
end

local function styleIcon(aura, auraType)
    setAuraSize(aura, auraType)
    if (Gladdy.db.buffsDisableCircle) then
        aura.cooldowncircle:SetAlpha(0)
    else
        aura.cooldowncircle:SetAlpha(Gladdy.db.buffsCooldownAlpha)
    end

    aura.border:SetTexture(Gladdy.db.buffsBorderStyle)
    aura.border:SetVertexColor(spellSchoolToOptionValue(aura.spellSchool))
    aura.cooldown:SetFont(Gladdy.LSM:Fetch("font", Gladdy.db.buffsFont), (Gladdy.db.buffsIconSize/2 - 1) * Gladdy.db.buffsFontScale, "OUTLINE")
    aura.cooldown:SetTextColor(Gladdy.db.buffsFontColor.r, Gladdy.db.buffsFontColor.g, Gladdy.db.buffsFontColor.b, Gladdy.db.buffsFontColor.a)
    aura.stacks:SetFont(Gladdy.LSM:Fetch("font", Gladdy.db.buffsFont), (Gladdy.db.buffsIconSize/3 - 1) * Gladdy.db.buffsFontScale, "OUTLINE")
    aura.stacks:SetTextColor(Gladdy.db.buffsFontColor.r, Gladdy.db.buffsFontColor.g, Gladdy.db.buffsFontColor.b, Gladdy.db.buffsFontColor.a)
end

function BuffsDebuffs:UpdateFrame(unit)
    self.frames[unit].debuffFrame:SetHeight(Gladdy.db.buffsIconSize)
    self.frames[unit].debuffFrame:ClearAllPoints()
    local horizontalMargin = Gladdy.db.highlightBorderSize
    local verticalMargin = -(Gladdy.db.powerBarHeight)/2
    if Gladdy.db.buffsCooldownPos == "TOP" then
        verticalMargin = horizontalMargin + 1
        if Gladdy.db.cooldownYPos == "TOP" and Gladdy.db.cooldown then
            verticalMargin = verticalMargin + Gladdy.db.cooldownSize
        end
        if Gladdy.db.buffsCooldownGrowDirection == "LEFT" then
            self.frames[unit].debuffFrame:SetPoint("BOTTOMLEFT", Gladdy.buttons[unit].healthBar, "TOPRIGHT", Gladdy.db.buffsXOffset, Gladdy.db.buffsYOffset + verticalMargin)
        else
            self.frames[unit].debuffFrame:SetPoint("BOTTOMRIGHT", Gladdy.buttons[unit].healthBar, "TOPLEFT", Gladdy.db.buffsXOffset, Gladdy.db.buffsYOffset + verticalMargin)
        end
    elseif Gladdy.db.buffsCooldownPos == "BOTTOM" then
        verticalMargin = horizontalMargin + 1
        if Gladdy.db.cooldownYPos == "BOTTOM" and Gladdy.db.cooldown then
            verticalMargin = verticalMargin + Gladdy.db.cooldownSize
        end
        if Gladdy.db.buffsCooldownGrowDirection == "LEFT" then
            self.frames[unit].debuffFrame:SetPoint("TOPLEFT", Gladdy.buttons[unit].powerBar, "BOTTOMRIGHT", Gladdy.db.buffsXOffset, Gladdy.db.buffsYOffset -verticalMargin)
        else
            self.frames[unit].debuffFrame:SetPoint("TOPRIGHT", Gladdy.buttons[unit].powerBar, "BOTTOMLEFT", Gladdy.db.buffsXOffset, Gladdy.db.buffsYOffset -verticalMargin)
        end
    elseif Gladdy.db.buffsCooldownPos == "LEFT" then
        horizontalMargin = horizontalMargin - 1 + Gladdy.db.padding
        if (Gladdy.db.trinketPos == "LEFT" and Gladdy.db.trinketEnabled) then
            horizontalMargin = horizontalMargin + (Gladdy.db.trinketSize * Gladdy.db.trinketWidthFactor) + Gladdy.db.padding
            if (Gladdy.db.classIconPos == "LEFT") then
                horizontalMargin = horizontalMargin + (Gladdy.db.classIconSize * Gladdy.db.classIconWidthFactor) + Gladdy.db.padding
            end
        elseif (Gladdy.db.classIconPos == "LEFT") then
            horizontalMargin = horizontalMargin + (Gladdy.db.classIconSize * Gladdy.db.classIconWidthFactor) + Gladdy.db.padding
            if (Gladdy.db.trinketPos == "LEFT" and Gladdy.db.trinketEnabled) then
                horizontalMargin = horizontalMargin + (Gladdy.db.trinketSize * Gladdy.db.trinketWidthFactor) + Gladdy.db.padding
            end
        end
        if (Gladdy.db.drCooldownPos == "LEFT" and Gladdy.db.drEnabled) then
            verticalMargin = verticalMargin + Gladdy.db.drIconSize/2 + Gladdy.db.padding/2
        end
        if (Gladdy.db.castBarPos == "LEFT") then
            verticalMargin = verticalMargin -
                    (((Gladdy.db.castBarHeight < Gladdy.db.castBarIconSize) and Gladdy.db.castBarIconSize
                            or Gladdy.db.castBarHeight)/2 + Gladdy.db.padding/2)
        end
        if (Gladdy.db.cooldownYPos == "LEFT" and Gladdy.db.cooldown) then
            verticalMargin = verticalMargin + (Gladdy.db.buffsIconSize/2 + Gladdy.db.padding/2)
        end
        self.frames[unit].debuffFrame:SetPoint("RIGHT", Gladdy.buttons[unit].healthBar, "LEFT", -horizontalMargin + Gladdy.db.buffsXOffset, Gladdy.db.buffsYOffset + verticalMargin)
    elseif Gladdy.db.buffsCooldownPos == "RIGHT" then
        horizontalMargin = horizontalMargin - 1 + Gladdy.db.padding
        if (Gladdy.db.trinketPos == "RIGHT" and Gladdy.db.trinketEnabled) then
            horizontalMargin = horizontalMargin + (Gladdy.db.trinketSize * Gladdy.db.trinketWidthFactor) + Gladdy.db.padding
            if (Gladdy.db.classIconPos == "RIGHT") then
                horizontalMargin = horizontalMargin + (Gladdy.db.classIconSize * Gladdy.db.classIconWidthFactor) + Gladdy.db.padding
            end
        elseif (Gladdy.db.classIconPos == "RIGHT") then
            horizontalMargin = horizontalMargin + (Gladdy.db.classIconSize * Gladdy.db.classIconWidthFactor) + Gladdy.db.padding
            if (Gladdy.db.trinketPos == "RIGHT" and Gladdy.db.trinketEnabled) then
                horizontalMargin = horizontalMargin + (Gladdy.db.trinketSize * Gladdy.db.trinketWidthFactor) + Gladdy.db.padding
            end
        end
        if (Gladdy.db.drCooldownPos == "RIGHT" and Gladdy.db.drEnabled) then
            verticalMargin = verticalMargin + Gladdy.db.drIconSize/2 + Gladdy.db.padding/2
        end
        if (Gladdy.db.castBarPos == "RIGHT") then
            verticalMargin = verticalMargin -
                    (((Gladdy.db.castBarHeight < Gladdy.db.castBarIconSize) and Gladdy.db.castBarIconSize
                            or Gladdy.db.castBarHeight)/2 + Gladdy.db.padding/2)
        end
        if (Gladdy.db.cooldownYPos == "RIGHT" and Gladdy.db.cooldown) then
            verticalMargin = verticalMargin + (Gladdy.db.buffsIconSize/2 + Gladdy.db.padding/2)
        end
        self.frames[unit].debuffFrame:SetPoint("LEFT", Gladdy.buttons[unit].healthBar, "RIGHT", horizontalMargin + Gladdy.db.buffsXOffset, Gladdy.db.buffsYOffset + verticalMargin)
    end

    self.frames[unit].buffFrame:SetHeight(Gladdy.db.buffsBuffsIconSize)
    self.frames[unit].buffFrame:ClearAllPoints()
    horizontalMargin = Gladdy.db.highlightBorderSize
    verticalMargin = -(Gladdy.db.powerBarHeight)/2
    if Gladdy.db.buffsBuffsCooldownPos == "TOP" then
        verticalMargin = horizontalMargin + 1
        if Gladdy.db.cooldownYPos == "TOP" and Gladdy.db.cooldown then
            verticalMargin = verticalMargin + Gladdy.db.cooldownSize
        end
        if Gladdy.db.buffsBuffsCooldownGrowDirection == "LEFT" then
            self.frames[unit].buffFrame:SetPoint("BOTTOMLEFT", Gladdy.buttons[unit].healthBar, "TOPRIGHT", Gladdy.db.buffsXOffset, Gladdy.db.buffsBuffsYOffset + verticalMargin)
        else
            self.frames[unit].buffFrame:SetPoint("BOTTOMRIGHT", Gladdy.buttons[unit].healthBar, "TOPLEFT", Gladdy.db.buffsXOffset, Gladdy.db.buffsBuffsYOffset + verticalMargin)
        end
    elseif Gladdy.db.buffsBuffsCooldownPos == "BOTTOM" then
        verticalMargin = horizontalMargin + 1
        if Gladdy.db.cooldownYPos == "BOTTOM" and Gladdy.db.cooldown then
            verticalMargin = verticalMargin + Gladdy.db.cooldownSize
        end
        if Gladdy.db.buffsBuffsCooldownGrowDirection == "LEFT" then
            self.frames[unit].buffFrame:SetPoint("TOPLEFT", Gladdy.buttons[unit].powerBar, "BOTTOMRIGHT", Gladdy.db.buffsBuffsXOffset, Gladdy.db.buffsBuffsYOffset -verticalMargin)
        else
            self.frames[unit].buffFrame:SetPoint("TOPRIGHT", Gladdy.buttons[unit].powerBar, "BOTTOMLEFT", Gladdy.db.buffsBuffsXOffset, Gladdy.db.buffsBuffsYOffset -verticalMargin)
        end
    elseif Gladdy.db.buffsBuffsCooldownPos == "LEFT" then
        horizontalMargin = horizontalMargin - 1 + Gladdy.db.padding
        if (Gladdy.db.trinketPos == "LEFT" and Gladdy.db.trinketEnabled) then
            horizontalMargin = horizontalMargin + (Gladdy.db.trinketSize * Gladdy.db.trinketWidthFactor) + Gladdy.db.padding
            if (Gladdy.db.classIconPos == "LEFT") then
                horizontalMargin = horizontalMargin + (Gladdy.db.classIconSize * Gladdy.db.classIconWidthFactor) + Gladdy.db.padding
            end
        elseif (Gladdy.db.classIconPos == "LEFT") then
            horizontalMargin = horizontalMargin + (Gladdy.db.classIconSize * Gladdy.db.classIconWidthFactor) + Gladdy.db.padding
            if (Gladdy.db.trinketPos == "LEFT" and Gladdy.db.trinketEnabled) then
                horizontalMargin = horizontalMargin + (Gladdy.db.trinketSize * Gladdy.db.trinketWidthFactor) + Gladdy.db.padding
            end
        end
        if (Gladdy.db.drCooldownPos == "LEFT" and Gladdy.db.drEnabled) then
            verticalMargin = verticalMargin + Gladdy.db.drIconSize/2 + Gladdy.db.padding/2
        end
        if (Gladdy.db.castBarPos == "LEFT") then
            verticalMargin = verticalMargin -
                    (((Gladdy.db.castBarHeight < Gladdy.db.castBarIconSize) and Gladdy.db.castBarIconSize
                            or Gladdy.db.castBarHeight)/2 + Gladdy.db.padding/2)
        end
        if (Gladdy.db.cooldownYPos == "LEFT" and Gladdy.db.cooldown) then
            verticalMargin = verticalMargin + (Gladdy.db.buffsBuffsIconSize/2 + Gladdy.db.padding/2)
        end
        self.frames[unit].buffFrame:SetPoint("RIGHT", Gladdy.buttons[unit].healthBar, "LEFT", -horizontalMargin + Gladdy.db.buffsBuffsXOffset, Gladdy.db.buffsBuffsYOffset + verticalMargin)
    elseif Gladdy.db.buffsBuffsCooldownPos == "RIGHT" then
        horizontalMargin = horizontalMargin - 1 + Gladdy.db.padding
        if (Gladdy.db.trinketPos == "RIGHT" and Gladdy.db.trinketEnabled) then
            horizontalMargin = horizontalMargin + (Gladdy.db.trinketSize * Gladdy.db.trinketWidthFactor) + Gladdy.db.padding
            if (Gladdy.db.classIconPos == "RIGHT") then
                horizontalMargin = horizontalMargin + (Gladdy.db.classIconSize * Gladdy.db.classIconWidthFactor) + Gladdy.db.padding
            end
        elseif (Gladdy.db.classIconPos == "RIGHT") then
            horizontalMargin = horizontalMargin + (Gladdy.db.classIconSize * Gladdy.db.classIconWidthFactor) + Gladdy.db.padding
            if (Gladdy.db.trinketPos == "RIGHT" and Gladdy.db.trinketEnabled) then
                horizontalMargin = horizontalMargin + (Gladdy.db.trinketSize * Gladdy.db.trinketWidthFactor) + Gladdy.db.padding
            end
        end
        if (Gladdy.db.drCooldownPos == "RIGHT" and Gladdy.db.drEnabled) then
            verticalMargin = verticalMargin + Gladdy.db.drIconSize/2 + Gladdy.db.padding/2
        end
        if (Gladdy.db.castBarPos == "RIGHT") then
            verticalMargin = verticalMargin -
                    (((Gladdy.db.castBarHeight < Gladdy.db.castBarIconSize) and Gladdy.db.castBarIconSize
                            or Gladdy.db.castBarHeight)/2 + Gladdy.db.padding/2)
        end
        if (Gladdy.db.cooldownYPos == "RIGHT" and Gladdy.db.cooldown) then
            verticalMargin = verticalMargin + (Gladdy.db.buffsBuffsIconSize/2 + Gladdy.db.padding/2)
        end
        self.frames[unit].buffFrame:SetPoint("LEFT", Gladdy.buttons[unit].healthBar, "RIGHT", horizontalMargin + Gladdy.db.buffsBuffsXOffset, Gladdy.db.buffsBuffsYOffset + verticalMargin)
    end
    for i=1, #self.frames[unit].auras[AURA_TYPE_BUFF] do
        styleIcon(self.frames[unit].auras[AURA_TYPE_BUFF][i], AURA_TYPE_BUFF)
    end
    for i=1, #self.frames[unit].auras[AURA_TYPE_DEBUFF] do
        styleIcon(self.frames[unit].auras[AURA_TYPE_DEBUFF][i], AURA_TYPE_DEBUFF)
    end
    for i=1, #self.framePool do
        styleIcon(self.framePool[i])
    end
    self:UpdateAurasOnUnit(unit)
end

---------------------------
-- Frame handlers
---------------------------

function BuffsDebuffs:UpdateAurasOnUnit(unit)
    for i=1, #self.frames[unit].auras[AURA_TYPE_BUFF] do
        if i == 1 then
            if Gladdy.db.buffsBuffsCooldownGrowDirection == "LEFT" then
                self.frames[unit].auras[AURA_TYPE_BUFF][i]:ClearAllPoints()
                self.frames[unit].auras[AURA_TYPE_BUFF][i]:SetPoint("RIGHT", self.frames[unit].buffFrame, "LEFT")
            else
                self.frames[unit].auras[AURA_TYPE_BUFF][i]:ClearAllPoints()
                self.frames[unit].auras[AURA_TYPE_BUFF][i]:SetPoint("LEFT", self.frames[unit].buffFrame, "RIGHT")
            end
        else
            if Gladdy.db.buffsBuffsCooldownGrowDirection == "LEFT" then
                self.frames[unit].auras[AURA_TYPE_BUFF][i]:ClearAllPoints()
                self.frames[unit].auras[AURA_TYPE_BUFF][i]:SetPoint("RIGHT", self.frames[unit].auras[AURA_TYPE_BUFF][i - 1], "LEFT", -Gladdy.db.buffsBuffsIconPadding, 0)
            else
                self.frames[unit].auras[AURA_TYPE_BUFF][i]:ClearAllPoints()
                self.frames[unit].auras[AURA_TYPE_BUFF][i]:SetPoint("LEFT", self.frames[unit].auras[AURA_TYPE_BUFF][i - 1], "RIGHT", Gladdy.db.buffsBuffsIconPadding, 0)
            end
        end
    end
    for i=1, #self.frames[unit].auras[AURA_TYPE_DEBUFF] do
        if i == 1 then
            if Gladdy.db.buffsCooldownGrowDirection == "LEFT" then
                self.frames[unit].auras[AURA_TYPE_DEBUFF][i]:ClearAllPoints()
                self.frames[unit].auras[AURA_TYPE_DEBUFF][i]:SetPoint("RIGHT", self.frames[unit].debuffFrame, "LEFT")
            else
                self.frames[unit].auras[AURA_TYPE_DEBUFF][i]:ClearAllPoints()
                self.frames[unit].auras[AURA_TYPE_DEBUFF][i]:SetPoint("LEFT", self.frames[unit].debuffFrame, "RIGHT")
            end
        else
            if Gladdy.db.buffsCooldownGrowDirection == "LEFT" then
                self.frames[unit].auras[AURA_TYPE_DEBUFF][i]:ClearAllPoints()
                self.frames[unit].auras[AURA_TYPE_DEBUFF][i]:SetPoint("RIGHT", self.frames[unit].auras[AURA_TYPE_DEBUFF][i - 1], "LEFT", -Gladdy.db.buffsIconPadding, 0)
            else
                self.frames[unit].auras[AURA_TYPE_DEBUFF][i]:ClearAllPoints()
                self.frames[unit].auras[AURA_TYPE_DEBUFF][i]:SetPoint("LEFT", self.frames[unit].auras[AURA_TYPE_DEBUFF][i - 1], "RIGHT", Gladdy.db.buffsIconPadding, 0)
            end
        end
    end
end

function BuffsDebuffs:UNIT_DEATH(destUnit)
    self:RemoveAuras(destUnit)
end

local function iconTimer(auraFrame, elapsed)
    if auraFrame.endtime ~= "undefined" then
        local timeLeftMilliSec = auraFrame.endtime - GetTime()
        local timeLeftSec = ceil(timeLeftMilliSec)
        auraFrame.timeLeft = timeLeftMilliSec
        --auraFrame.cooldowncircle:SetCooldown(auraFrame.startTime, auraFrame.endtime)
        if timeLeftSec >= 60 then
            if Gladdy.db.buffsDynamicColor then auraFrame.cooldown:SetTextColor(0.7, 1, 0) end
            auraFrame.cooldown:SetFormattedText("%dm", ceil(timeLeftSec / 60))
        elseif timeLeftSec < 60 and timeLeftSec >= 11 then
            --if it's less than 60s
            if Gladdy.db.buffsDynamicColor then auraFrame.cooldown:SetTextColor(0.7, 1, 0) end
            auraFrame.cooldown:SetFormattedText("%d", timeLeftSec)
        elseif timeLeftSec <= 10 and timeLeftSec >= 5 then
            if Gladdy.db.buffsDynamicColor then auraFrame.cooldown:SetTextColor(1, 0.7, 0) end
            auraFrame.cooldown:SetFormattedText("%d", timeLeftSec)
        elseif timeLeftSec <= 4 and timeLeftSec >= 3 then
            if Gladdy.db.buffsDynamicColor then auraFrame.cooldown:SetTextColor(1, 0, 0) end
            auraFrame.cooldown:SetFormattedText("%d", timeLeftSec)
        elseif timeLeftMilliSec <= 3 and timeLeftMilliSec > 0 then
            if Gladdy.db.buffsDynamicColor then auraFrame.cooldown:SetTextColor(1, 0, 0) end
            auraFrame.cooldown:SetFormattedText("%.1f", timeLeftMilliSec)
        elseif timeLeftMilliSec <= 0 and timeLeftMilliSec > -0.05 then -- 50ms ping max wait for SPELL_AURA_REMOVED event
            auraFrame.cooldown:SetText("")
        else -- fallback in case SPELL_AURA_REMOVED is not fired
            auraFrame:Hide()
        end
    else
        auraFrame.cooldown:SetText("")
    end
end

function BuffsDebuffs:AddAura(unit, spellID, auraType, duration, timeLeft, stacks, spellSchool, icon, index)
    local aura
    if not self.frames[unit].auras[auraType][index] then
        if #self.framePool > 0 then
            aura = tremove(self.framePool, #self.framePool)
        else
            aura = CreateFrame("Frame")
            aura:SetFrameLevel(3)
            aura.texture = aura:CreateTexture(nil, "BACKGROUND")
            aura.texture:SetAllPoints(aura)
            aura.cooldowncircle = CreateFrame("Cooldown", nil, aura, "CooldownFrameTemplate")
            aura.cooldowncircle:SetFrameLevel(4)
            aura.cooldowncircle.noCooldownCount = true -- disable OmniCC
            aura.cooldowncircle:SetAllPoints(aura)
            aura.cooldowncircle:SetReverse(true)
            aura.cooldowncircle:SetHideCountdownNumbers(true)
            aura.overlay = CreateFrame("Frame", nil, aura)
            aura.overlay:SetFrameLevel(5)
            aura.overlay:SetAllPoints(aura)
            aura.border = aura.overlay:CreateTexture(nil, "OVERLAY")
            aura.border:SetAllPoints(aura)
            aura.cooldown = aura.overlay:CreateFontString(nil, "OVERLAY")
            aura.cooldown:SetAllPoints(aura)
            aura.stacks = aura.overlay:CreateFontString(nil, "OVERLAY")
            aura.stacks:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 0, 3)
            styleIcon(aura)
            aura:SetScript("OnUpdate", iconTimer)
        end
        self.frames[unit].auras[auraType][index] = aura
        self:UpdateAurasOnUnit(unit)
        aura:SetParent(auraType == AURA_TYPE_DEBUFF and self.frames[unit].debuffFrame or self.frames[unit].buffFrame)
    else
        aura = self.frames[unit].auras[auraType][index]
    end

    setAuraSize(aura, auraType)
    aura.stacks:SetText(stacks > 1 and stacks or "")
    aura.texture:SetTexture(icon)
    aura.startTime = GetTime() - (duration - timeLeft)
    if duration == 0 then
        aura.endtime = "undefined"
        aura.cooldowncircle:Hide()
    else
        aura.endtime = GetTime() + timeLeft
        aura.cooldowncircle:SetCooldown(GetTime() - (duration - timeLeft), duration)
        aura.cooldowncircle:Show()
    end
    aura.spellID = spellID
    aura.type = auraType
    aura.unit = unit
    aura.spellSchool = spellSchool
    aura.border:SetVertexColor(spellSchoolToOptionValue(spellSchool))
    aura:Show()
end

function BuffsDebuffs:AddOrRefreshAura(unit, spellID, auraType, duration, timeLeft, stacks, spellSchool, icon, index)
    if self.frames[unit].auras[auraType][index] and self.frames[unit].auras[auraType][index].spellID == spellID then -- refresh
        if duration == 0 then
            self.frames[unit].auras[auraType][index].endtime = "undefined"
            self.frames[unit].auras[auraType][index].cooldowncircle:Hide()
        else
            self.frames[unit].auras[auraType][index].endtime = GetTime() + timeLeft
            self.frames[unit].auras[auraType][index].cooldowncircle:SetCooldown(GetTime() - (duration - timeLeft), duration)
            self.frames[unit].auras[auraType][index].cooldowncircle:Show()
        end
        self.frames[unit].auras[auraType][index].stacks:SetText(stacks > 1 and stacks or "")
        self.frames[unit].auras[auraType][index]:Show()
        self:UpdateAurasOnUnit(unit)
        return
    end
    --add
    self:AddAura(unit, spellID, auraType, duration, timeLeft, stacks, spellSchool, icon, index)
    self:UpdateAurasOnUnit(unit)
end

------------
-- OPTIONS
------------

local function option(params)
    local defaults = {
        get = function(info)
            local key = info.arg or info[#info]
            return Gladdy.dbi.profile[key]
        end,
        set = function(info, value)
            local key = info.arg or info[#info]
            Gladdy.dbi.profile[key] = value
            if Gladdy.db.buffsCooldownPos == "LEFT" then
                Gladdy.db.buffsCooldownGrowDirection = "LEFT"
            elseif Gladdy.db.buffsCooldownPos == "RIGHT" then
                Gladdy.db.buffsCooldownGrowDirection = "RIGHT"
            end
            if Gladdy.db.buffsBuffsCooldownPos == "LEFT" then
                Gladdy.db.buffsBuffsCooldownGrowDirection = "LEFT"
            elseif Gladdy.db.buffsBuffsCooldownPos == "RIGHT" then
                Gladdy.db.buffsBuffsCooldownGrowDirection = "RIGHT"
            end
            Gladdy:UpdateFrame()
        end,
    }

    for k, v in pairs(params) do
        defaults[k] = v
    end

    return defaults
end

function BuffsDebuffs:GetOptions()
    return {
        headerBuffs = {
            type = "header",
            name = L["Buffs and Debuffs"],
            order = 2,
        },
        buffsEnabled = Gladdy:option({
            type = "toggle",
            name = L["Enable"],
            desc = L["Enabled Buffs and Debuffs module"],
            order = 3,
        }),
        buffsShowAuraDebuffs = Gladdy:option({
            type = "toggle",
            name = L["Show CC"],
            desc = L["Shows all debuffs, which are displayed on the ClassIcon as well"],
            order = 4,
        }),
        group = {
            type = "group",
            childGroups = "tree",
            name = "Frame",
            order = 5,
            args = {
                buffs = {
                    type = "group",
                    name = L["Buffs"],
                    order = 1,
                    args = {
                        size = {
                            type = "group",
                            name = "Size & Padding",
                            order = 1,
                            args = {
                                header = {
                                    type = "header",
                                    name = L["Size & Padding"],
                                    order = 5,
                                },
                                buffsBuffsIconSize = Gladdy:option({
                                    type = "range",
                                    name = L["Icon Size"],
                                    desc = L["Size of the DR Icons"],
                                    order = 6,
                                    min = 5,
                                    max = 50,
                                    step = 1,
                                }),
                                buffsBuffsWidthFactor = Gladdy:option({
                                    type = "range",
                                    name = L["Icon Width Factor"],
                                    desc = L["Stretches the icon"],
                                    order = 7,
                                    min = 0.5,
                                    max = 2,
                                    step = 0.05,
                                }),
                                buffsBuffsIconPadding = Gladdy:option({
                                    type = "range",
                                    name = L["Icon Padding"],
                                    desc = L["Space between Icons"],
                                    order = 8,
                                    min = 0,
                                    max = 10,
                                    step = 0.1,
                                }),
                            },
                        },
                        position = {
                            type = "group",
                            name = "Position",
                            order = 3,
                            args = {
                                header = {
                                    type = "header",
                                    name = L["Position"],
                                    order = 5,
                                },
                                buffsBuffsCooldownPos = option({
                                    type = "select",
                                    name = L["Aura Position"],
                                    desc = L["Position of the aura icons"],
                                    order = 21,
                                    values = {
                                        ["TOP"] = L["Top"],
                                        ["BOTTOM"] = L["Bottom"],
                                        ["LEFT"] = L["Left"],
                                        ["RIGHT"] = L["Right"],
                                    },
                                }),
                                buffsBuffsCooldownGrowDirection = Gladdy:option({
                                    type = "select",
                                    name = L["Grow Direction"],
                                    desc = L["Grow Direction of the aura icons"],
                                    order = 21,
                                    values = {
                                        ["LEFT"] = L["Left"],
                                        ["RIGHT"] = L["Right"],
                                    },
                                }),
                                buffsBuffsXOffset = Gladdy:option({
                                    type = "range",
                                    name = L["Horizontal offset"],
                                    order = 22,
                                    min = -400,
                                    max = 400,
                                    step = 0.1,
                                }),
                                buffsBuffsYOffset = Gladdy:option({
                                    type = "range",
                                    name = L["Vertical offset"],
                                    order = 23,
                                    min = -400,
                                    max = 400,
                                    step = 0.1,
                                }),
                            },
                        },
                        alpha = {
                            type = "group",
                            name = L["Alpha"],
                            order = 2,
                            args = {
                                header = {
                                    type = "header",
                                    name = L["Alpha"],
                                    order = 1,
                                },
                                buffsBuffsAlpha =  Gladdy:option({
                                    type = "range",
                                    name = L["Alpha"],
                                    order = 2,
                                    min = 0,
                                    max = 1,
                                    step = 0.05,
                                }),
                            }
                        }
                    }
                },
                debuffs = {
                    type = "group",
                    name = L["Debuffs"],
                    order = 2,
                    args = {
                        size = {
                            type = "group",
                            name = "Size & Padding",
                            order = 1,
                            args = {
                                header = {
                                    type = "header",
                                    name = L["Size & Padding"],
                                    order = 5,
                                },
                                buffsIconSize = Gladdy:option({
                                    type = "range",
                                    name = L["Icon Size"],
                                    desc = L["Size of the DR Icons"],
                                    order = 6,
                                    min = 5,
                                    max = 50,
                                    step = 1,
                                }),
                                buffsWidthFactor = Gladdy:option({
                                    type = "range",
                                    name = L["Icon Width Factor"],
                                    desc = L["Stretches the icon"],
                                    order = 7,
                                    min = 0.5,
                                    max = 2,
                                    step = 0.05,
                                }),
                                buffsIconPadding = Gladdy:option({
                                    type = "range",
                                    name = L["Icon Padding"],
                                    desc = L["Space between Icons"],
                                    order = 8,
                                    min = 0,
                                    max = 10,
                                    step = 0.1,
                                }),
                            },
                        },
                        position = {
                            type = "group",
                            name = "Position",
                            order = 3,
                            args = {
                                header = {
                                    type = "header",
                                    name = L["Position"],
                                    order = 5,
                                },
                                buffsCooldownPos = option({
                                    type = "select",
                                    name = L["Aura Position"],
                                    desc = L["Position of the aura icons"],
                                    order = 21,
                                    values = {
                                        ["TOP"] = L["Top"],
                                        ["BOTTOM"] = L["Bottom"],
                                        ["LEFT"] = L["Left"],
                                        ["RIGHT"] = L["Right"],
                                    },
                                }),
                                buffsCooldownGrowDirection = Gladdy:option({
                                    type = "select",
                                    name = L["Grow Direction"],
                                    desc = L["Grow Direction of the aura icons"],
                                    order = 21,
                                    values = {
                                        ["LEFT"] = L["Left"],
                                        ["RIGHT"] = L["Right"],
                                    },
                                }),
                                buffsXOffset = Gladdy:option({
                                    type = "range",
                                    name = L["Horizontal offset"],
                                    order = 22,
                                    min = -400,
                                    max = 400,
                                    step = 0.1,
                                }),
                                buffsYOffset = Gladdy:option({
                                    type = "range",
                                    name = L["Vertical offset"],
                                    order = 23,
                                    min = -400,
                                    max = 400,
                                    step = 0.1,
                                }),
                            },
                        },
                        alpha = {
                            type = "group",
                            name = L["Alpha"],
                            order = 2,
                            args = {
                                header = {
                                    type = "header",
                                    name = L["Alpha"],
                                    order = 1,
                                },
                                buffsAlpha =  Gladdy:option({
                                    type = "range",
                                    name = L["Alpha"],
                                    order = 2,
                                    min = 0,
                                    max = 1,
                                    step = 0.05,
                                }),
                            }
                        }
                    },
                },
                cooldown = {
                    type = "group",
                    name = "Cooldown",
                    order = 3,
                    args = {
                        header = {
                            type = "header",
                            name = L["Cooldown"],
                            order = 5,
                        },
                        buffsDisableCircle = Gladdy:option({
                            type = "toggle",
                            name = L["No Cooldown Circle"],
                            order = 9,
                        }),
                        buffsCooldownAlpha = Gladdy:option({
                            type = "range",
                            name = L["Cooldown circle alpha"],
                            min = 0,
                            max = 1,
                            step = 0.1,
                            order = 10,
                        }),
                    },
                },
                font = {
                    type = "group",
                    name = "Font",
                    order = 4,
                    args = {
                        header = {
                            type = "header",
                            name = L["Font"],
                            order = 5,
                        },
                        buffsFont = Gladdy:option({
                            type = "select",
                            name = L["Font"],
                            desc = L["Font of the cooldown"],
                            order = 12,
                            dialogControl = "LSM30_Font",
                            values = AceGUIWidgetLSMlists.font,
                        }),
                        buffsFontScale = Gladdy:option({
                            type = "range",
                            name = L["Font scale"],
                            desc = L["Scale of the text"],
                            order = 13,
                            min = 0.1,
                            max = 2,
                            step = 0.1,
                        }),
                        buffsDynamicColor = Gladdy:option({
                            type = "toggle",
                            name = L["Dynamic Timer Color"],
                            desc = L["Show dynamic color on cooldown numbers"],
                            order = 14,
                        }),
                        buffsFontColor = Gladdy:colorOption({
                            type = "color",
                            name = L["Font color"],
                            desc = L["Color of the cooldown timer and stacks"],
                            order = 15,
                            hasAlpha = true,
                        }),
                    },
                },
                border = {
                    type = "group",
                    name = "Border",
                    order = 5,
                    args = {
                        header = {
                            type = "header",
                            name = L["Border"],
                            order = 5,
                        },
                        buffsBorderStyle = Gladdy:option({
                            type = "select",
                            name = L["Border style"],
                            order = 31,
                            values = Gladdy:GetIconStyles()
                        }),
                        headerBorder = {
                            type = "header",
                            name = L["Spell School Colors"],
                            order = 40,
                        },
                        buffsBorderColorsEnabled = Gladdy:option({
                            type = "toggle",
                            name = L["Spell School Colors Enabled"],
                            desc = L["Show border colors by spell school"],
                            order = 41,
                            width = "full",
                        }),
                        buffsBorderColorCurse = Gladdy:colorOption({
                            type = "color",
                            name = L["Curse"],
                            desc = L["Color of the border"],
                            order = 42,
                            hasAlpha = true,
                        }),
                        buffsBorderColorMagic = Gladdy:colorOption({
                            type = "color",
                            name = L["Magic"],
                            desc = L["Color of the border"],
                            order = 43,
                            hasAlpha = true,
                        }),
                        buffsBorderColorPoison = Gladdy:colorOption({
                            type = "color",
                            name = L["Poison"],
                            desc = L["Color of the border"],
                            order = 44,
                            hasAlpha = true,
                        }),
                        buffsBorderColorPhysical = Gladdy:colorOption({
                            type = "color",
                            name = L["Physical"],
                            desc = L["Color of the border"],
                            order = 45,
                            hasAlpha = true,
                        }),
                        buffsBorderColorImmune = Gladdy:colorOption({
                            type = "color",
                            name = L["Immune"],
                            desc = L["Color of the border"],
                            order = 46,
                            hasAlpha = true,
                        }),
                        buffsBorderColorDisease = Gladdy:colorOption({
                            type = "color",
                            name = L["Disease"],
                            desc = L["Color of the border"],
                            order = 47,
                            hasAlpha = true,
                        }),
                        buffsBorderColorAura = Gladdy:colorOption({
                            type = "color",
                            name = L["Aura"],
                            desc = L["Color of the border"],
                            order = 48,
                            hasAlpha = true,
                        }),
                        buffsBorderColorForm = Gladdy:colorOption({
                            type = "color",
                            name = L["Form"],
                            desc = L["Color of the border"],
                            order = 49,
                            hasAlpha = true,
                        }),
                    },
                },
            },
        },
        debuffList = {
            name = "Debuff Lists",
            type = "group",
            order = 11,
            childGroups = "tree",
            args = select(1, Gladdy:GetAuras("debuff")),
            set = function(info, state)
                local optionKey = info[#info]
                Gladdy.dbi.profile.trackedDebuffs[optionKey] = state
            end,
            get = function(info)
                local optionKey = info[#info]
                return Gladdy.dbi.profile.trackedDebuffs[optionKey]
            end,
        },
        buffList = {
            name = "Buff Lists",
            type = "group",
            order = 12,
            childGroups = "tree",
            args = select(1, Gladdy:GetAuras("buffs")),
            set = function(info, state)
                local optionKey = info[#info]
                Gladdy.dbi.profile.trackedBuffs[optionKey] = state
            end,
            get = function(info)
                local optionKey = info[#info]
                return Gladdy.dbi.profile.trackedBuffs[optionKey]
            end,
        },
    }
end
