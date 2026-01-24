local Talented = Talented
local ipairs = ipairs

local L = LibStub("AceLocale-3.0"):GetLocale("Talented")
-- https://tbc.wowhead.com/talent-calc/rogue/0251030050502--05
-- https://tbc.wowhead.com/talent-calc/rogue/0251030050502-32
-- https://tbc.wowhead.com/talent-calc/rogue/0251030050502
-- https://tbc.wowhead.com/talent-calc/rogue/--05
-- https://tbc.wowhead.com/talent-calc/priest/05023013-235051002320054-5/2A0B1CEABMJfQ0DEHg1Krrrr
Talented.importers[".*/talent.calc/(.-)/(%d*)-?(%d*)-?(%d*).*"] = function(self, url, dst)
    local s, _, class, t1, t2, t3 = url:find(".*/talent.calc/(.-)/(%d*)-?(%d*)-?(%d*).*")
    if not s then
        return
    end

    if not dst then
        return class:upper()
    end

    src = {t1, t2, t3}
    -- src
    dst.class = class:upper()
    local info = self:GetTalentInfo(dst.class)
    local lens = {t1:len(), t2:len(), t3:len()}

    for tab, tree in ipairs(info) do
        local count = 1
        local t = {}
        dst[tab] = t
        for index = 1, #tree.talents do
            if count <= lens[tab] then
                t[index] = tonumber(src[tab]:sub(count, count))
                count = count + 1
            else
                t[index] = 0
            end
        end
    end
    return dst
end

Talented.importers["/%??talent#"] = function(self, url, dst)
    local s, _, code = url:find(".*/%??talent#(.*)$")
    if not s or not code then
        return
    end
    local p = code:find(":", nil, true)
    if p then
        code = code:sub(1, p - 1)
    end

    if not dst then
        return self:GetTemplateStringClass(code, "0zMcmVokRsaqbdrfwihuGINALpTjnyxtgevE")
    else
        local val, class = self:StringToTemplate(code, dst, "0zMcmVokRsaqbdrfwihuGINALpTjnyxtgevE")
        dst.class = class
        return dst
    end
end

Talented.exporters["Wowhead Talent Calculator"] = function(self, template)
    local s = {}
    local temp_s = {}
    for tab, tree in ipairs(template) do
        local built_tree = ""
        for i, n in ipairs(tree) do
            built_tree = built_tree .. tostring(n)
        end
        s[#s + 1] = built_tree
    end
    return ("https://tbc.wowhead.com/talent-calc/%s/%s"):format(template.class:lower(), table.concat(s, "-"))
end
