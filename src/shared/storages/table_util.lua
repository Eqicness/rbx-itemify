-- table util
-- eqicness
-- 29 may 2021

local util = {}

-- deep clones table t
function util.clone(t)
	local clone = {}
	for k, v in pairs(t) do
		clone[k] = typeof(v) == "table" and util.clone(v) or v
	end
	-- clone the metatable?
	local metatable = getmetatable(t)
	setmetatable(clone, metatable)
	return clone
end

-- fills table t1 with new values from table t2.
function util.update(t1, t2)
	local t = util.clone(t1)
	for k, v in pairs(t2) do
		if t[k] and typeof(t[k]) == "table" then
			t[k] = util.update(t[k], v)
		else
			t[k] = v
		end
	end
	return t
end

-- turn a table into an informative string
function util.string(tab, newlines, indent)
	indent = indent or 1
	local theString = "{"
	local format = "[%s] = %s"
	local stringFormat = "\"%s\""

	for k, v in pairs(tab) do
		if newlines then
			theString = theString .. "\n" .. string.rep("\t", indent)
		end
		local key = tostring(k)
		if typeof(key) == "table" then
			key = util.string(k, newlines, indent+1)
		elseif typeof(k) == "string" then
			key = stringFormat:format(key)
		end
		local value = tostring(v)
		if typeof(v) == "table" then
			value = util.string(v, newlines, indent+1)
		elseif typeof(v) == "string" then
			value = stringFormat:format(value)
		end
		theString = theString .. format:format(key, value) .. ", "
	end

	if theString:sub(theString:len()-1) == ", " then
		theString = theString:sub(1, theString:len()-2)
	end
	if newlines and theString:gsub("%s", "") ~= "{" then
		theString = theString .. "\n" .. string.rep("\t", indent-1)
	end
	theString = theString .. "}"

	return theString
end

-- check if two individual tables are different
-- todo: does this work correctly?
-- todo: can this be optimized?
function util.different(t1, t2)
	local checked = {}
	for k, v in pairs(t1) do
		if typeof(v) == "table" and t2[k] and typeof(t2[k]) == "table" then
			if util.different(v, t2[k]) then
				return true
			end
		else
			if v ~= t2[k] then
				return true
			end
		end
		checked[k] = true
	end
	for k, v in pairs(t2) do
		if checked[k] then
			continue
		end

		if typeof(v) == "table" then
			if t1[k] and typeof(t1[k]) == "table" then
				if util.different(v, t1[k]) then
					return true
				end
			end
		else
			if v ~= t1[k] then
				return true
			end
		end
	end
	checked = nil
	return false
end

return util