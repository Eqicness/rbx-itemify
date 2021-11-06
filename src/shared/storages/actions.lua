local Rodux = require(script.Parent.Rodux)

-- todo: use typed lua here?

local actions = {}

local function makeActionCreator(name, ...)
	actions[name] = Rodux.makeActionCreator(name, ...)
end

makeActionCreator("setInfo", function(name, val)
	return {
		infoName = name,
		infoValue = val,
	}
end)

makeActionCreator("addItem", function(id, type, data)
	return {
		itemId = id,
		itemType = type,
		itemData = data,
	}
end)

makeActionCreator("removeItem", function(id)
	return {
		itemId = id,
	}
end)

makeActionCreator("moveItem", function(id, min)
	return {
		itemId = id,
		itemMin = min,
	}
end)

return actions