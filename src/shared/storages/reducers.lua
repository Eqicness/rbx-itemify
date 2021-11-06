local Rodux = require(script.Parent.Rodux)
local table_util = require(script.Parent.table_util)
local ITEM_MANIFEST = require(script.Parent.item_manifest)

local reducers = {}

reducers["setInfo"] = function(state, action)
	if not state.info[action.infoName] then
		error(("No info of name '%s' for storage!"):format(action.infoName))
	end

	local newState = table_util.clone(state)

	newState.info[action.infoName] = action.infoValue

	return newState
end

reducers["addItem"] = function(state, action)
	if state.items[action.itemId] then
		error(("Item ID '%s' already exists in storage!"):format(action.itemId))
	end

	local newState = table_util.clone(state)

	local item_info = ITEM_MANIFEST[action.itemType]
	newState.items[action.itemId] = {
		type = action.itemType,
		info = item_info,

		data = {
			amount = 1,
			min = action.itemData.min,
			max = action.itemData.min + item_info.size,
		},
	}

	return newState
end

reducers["removeItem"] = function(state, action)
	if not state.items[action.itemId] then
		error(("Item ID '%s' does not exist in storage!"):format(action.itemId))
	end

	local newState = table_util.clone(state)

	newState.items[action.itemId] = nil

	return newState
end

reducers["moveItem"] = function(state, action)
	if not state.items[action.itemId] then
		error(("Item ID '%s' does not exist in storage!"):format(action.itemId))
	end

	local newState = table_util.clone(state)

	newState.items[action.itemId].data.min = action.itemMin
	newState.items[action.itemId].data.max = action.itemMin + newState.items[action.itemId].info.size

	return newState
end

return Rodux.createReducer({}, reducers)