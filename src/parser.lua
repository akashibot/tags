local TagParser = {}

TagParser.variables = {}
TagParser.tagHandlers = {}

function TagParser.registerTag(pattern, handler)
    table.insert(TagParser.tagHandlers, {pattern = pattern, handler = handler})
end

function TagParser.parse(input)
    local processedInput = input
    for _, tag in ipairs(TagParser.tagHandlers) do
        processedInput = processedInput:gsub(tag.pattern, tag.handler)
    end
    return processedInput
end

function TagParser.clearVariables()
    TagParser.variables = {}
    collectgarbage("collect")
end

function TagParser.debugVariables()
    for k, v in pairs(TagParser.variables) do
        print(k .. " = " .. v)
    end
end

-- Register default tag handlers
TagParser.registerTag("{set%((.-)%)%:(.-)}", function(varname, value)
    TagParser.variables[varname] = value
    return ""
end)

TagParser.registerTag("{get:(.-)}", function(varname)
    return TagParser.variables[varname] or "undefined"
end)

TagParser.registerTag("{if%((.-)%)%:(.-)%:(.-)}", function(varname, trueValue, falseValue)
    if TagParser.variables[varname] then
        return trueValue
    else
        return falseValue
    end
end)

output = TagParser.parse(input)

TagParser.debugVariables()
TagParser.clearVariables()
