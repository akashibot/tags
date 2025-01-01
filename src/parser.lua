local TagParser = {}

TagParser.variables = {}

function TagParser.parse(input)
    local processedInput = input

    processedInput = processedInput:gsub("{set%((.-)%)%:(.-)}", function(varname, value)
        TagParser.variables[varname] = value
        return ""
    end)

    processedInput = processedInput:gsub("{get:(.-)}", function(varname)
        return TagParser.variables[varname] or "undefined"
    end)

    return processedInput
end

function TagParser.clearVariables()
    TagParser.variables = {}
    collectgarbage("collect") -- Force immediate garbage collection
end


function TagParser.debugVariables()
    for k, v in pairs(TagParser.variables) do
        print(k .. " = " .. v)
    end
end

output = TagParser.parse(input)

TagParser.debugVariables()
TagParser.clearVariables()