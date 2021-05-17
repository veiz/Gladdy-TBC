local type, pairs = type, pairs

local Gladdy = LibStub("Gladdy")
local AceSerializer = LibStub("AceSerializer-3.0")
local L = Gladdy.L
local AceGUI = LibStub("AceGUI-3.0")
local LibDeflate = LibStub:GetLibrary("LibDeflate")

local function table_copy(t)
    local t2 = {};
    for k,v in pairs(t) do
        if type(v) == "table" then
            t2[k] = table_copy(v);
        else
            t2[k] = v;
        end
    end
    return t2;
end

local function applyImport(t)
    for k,v in pairs(t) do
        if type(v) == "table" then
            applyImport(v, Gladdy.dbi.profile[k]);
        else
            Gladdy.dbi.profile[k] = v;
        end
    end
end

local ExportImport = Gladdy:NewModule("ExportImport", nil, {
})

local export = AceGUI:Create("Frame")
export:SetWidth(550)
export.sizer_se:Hide()
export:SetStatusText("")
export:SetLayout("Flow")
export:SetTitle("Export")
export:Hide()
local exportEditBox = AceGUI:Create("MultiLineEditBox")
exportEditBox:SetLabel('ExportString')
exportEditBox:SetNumLines(29)
exportEditBox:SetText("")
exportEditBox:SetWidth(500)
exportEditBox.button:Hide()
exportEditBox.frame:SetClipsChildren(true)
export:AddChild(exportEditBox)
export.eb = exportEditBox

local import = AceGUI:Create("Frame")
import:SetWidth(550)
import:Hide()
import:SetLayout("Flow")
import.sizer_se:Hide()
import:SetStatusText("")
import:SetTitle("Import")
import:SetCallback("OnClose", function(widget)
    import.eb:SetCallback("OnTextChanged", nil)
end)
local importEditBox = AceGUI:Create("MultiLineEditBox")
importEditBox:SetLabel('ImportString')
importEditBox:SetNumLines(23)
importEditBox:SetText("")
importEditBox:SetWidth(500)
importEditBox.button:Hide()
importEditBox.frame:SetClipsChildren(true)
import:AddChild(importEditBox)
import.eb = importEditBox
local importButton = AceGUI:Create("Button")
importButton:SetText("Import\n(this will overwrite your current profile!)")
importButton:SetWidth(200)
importButton:SetHeight(50)
importButton:SetCallback("OnClick", function(widget)
    applyImport(import.deserializedTable)
    Gladdy:UpdateFrame()
    import:Hide()
end)
import:AddChild(importButton)
import.button = importButton
local importClearButton = AceGUI:Create("Button")
importClearButton:SetText("Clear")
importClearButton:SetWidth(200)
importClearButton:SetCallback("OnClick", function(widget)
    import.eb:SetText("")
    import.eb:SetFocus()
    import.button.frame:Disable()
    import:SetStatusText("Invalid Import String")
    import.statustext:SetTextColor(1,0,0)
end)
import:AddChild(importClearButton)
import.clearButton = importClearButton

function ExportImport:CheckDeserializedOptions(tbl, refTbl, str)
    if str == nil and not tbl.version_major then
        return false, "Version conflict: version_major not seen"
    end
    if str == nil and tbl.version_major ~= Gladdy.version_major then
        return false, "Version conflict: " .. tbl.version_major .. " ~= " .. Gladdy.version_major
    end
    if str == nil then
        str = "Gladdy.db"
        tbl.version_major = nil
    end
    if type(tbl) == "table" then
        for k,v in pairs(tbl) do
            if refTbl[k] ~= nil then
                if type(v) ~= type(refTbl[k]) then
                    return false, str .. "." .. k .. " type error. Expected " .. type(refTbl[k]) .. " found " .. type(v)
                end
                ExportImport:CheckDeserializedOptions(v, refTbl[k], str .. "." .. k)
            else
                return false, str .. "." .. k .. " does not exist"
            end
        end
    end
    return true
end

local dump
local printable_compressed
function ExportImport:GetOptions()
    return {
        headerProfileClassic = {
            type = "header",
            name = L["Profile Export Import"],
            order = 2,
        },
        export = {
            type = "execute",
            func = function()
                local db = table_copy(Gladdy.db)
                db.version_major = Gladdy.version_major
                dump = AceSerializer:Serialize(db)
                local compress_deflate = LibDeflate:CompressZlib(dump)
                printable_compressed = LibDeflate:EncodeForPrint(compress_deflate)
                export.eb:SetText(printable_compressed)
                export:Show()
                export.eb:SetFocus()
                export.eb:HighlightText(0, export.eb.editBox:GetNumLetters())
                export:SetStatusText("Copy this string to share your configuration with others.")
            end,
            name = "Export",
            desc = "Export your current profile to share with others or your various accounts.",
            order = 3,
        },
        import = {
            type = "execute",
            func = function()
                import.eb:SetText("")
                import:Show()
                import:SetStatusText("Invalid Import String")
                import.button.frame:Disable()
                import.statustext:SetTextColor(1,0,0)
                import.eb:SetFocus()
                import.eb:SetCallback("OnTextChanged", function(widget)
                    local decoded_string = LibDeflate:DecodeForPrint(widget:GetText())
                    if not decoded_string then
                        import.statustext:SetTextColor(1,0,0)
                        import:SetStatusText("Invalid Import String FAILED LibDeflate:DecodeForPrint")
                        import.button.frame:Disable()
                        return
                    end
                    local decompress_deflate = LibDeflate:DecompressZlib(decoded_string)
                    if not decompress_deflate then
                        import.statustext:SetTextColor(1,0,0)
                        import:SetStatusText("Invalid Import String FAILED LibDeflate:DecompressZlib")
                        import.button.frame:Disable()
                        return
                    end
                    local success, deserialized = AceSerializer:Deserialize(decompress_deflate)
                    if not success then
                        import.statustext:SetTextColor(1,0,0)
                        import:SetStatusText("Invalid Import String FAILED AceSerializer:Deserialize")
                        import.button.frame:Disable()
                        return
                    end
                    local statusOption, error = ExportImport:CheckDeserializedOptions(deserialized, Gladdy.db)
                    if not statusOption then
                        import.statustext:SetTextColor(1,0,0)
                        import:SetStatusText(error)
                        import.button.frame:Disable()
                        return
                    end

                    import.statustext:SetTextColor(0,1,0)
                    import:SetStatusText("SUCCESS")
                    import.button.frame:Enable()
                    import.deserializedTable = deserialized
                end)
            end,
            name = "Import",
            desc = "This will overwrite your current profile!",
            order = 4,
        },
    }
end