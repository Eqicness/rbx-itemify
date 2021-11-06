local HttpService = game:GetService("HttpService")

local Rodux = require(script.Rodux)
local reducer = require(script.reducers)
local actions = require(script.actions)
local storage_util = require(script.storage_util)

local storage = {}
storage.__index = storage

function storage:Destroy()
	self.store:destruct()
end

function storage:newItemId()
	return HttpService:GenerateGUID()
end

function storage:getEmptySpace(size)
	return storage_util.getEmptyOfSize(self.store:getState(), size)
end

function storage:dispatch(name, ...)
	self.store:dispatch(actions[name](...))
end

function storage.new()
	local self = setmetatable({}, storage)

	self.store = Rodux.Store.new(reducer, {
		info = {
			bounds = Vector2.new(10, 10)
		},
		data = {
			items = {
				-- sample_item_id = {
				-- 	data = {
				-- 		item_type = "sample_item",
				-- 		item_info = {
				-- 			-- info from manifest here
				-- 		},
						-- amount = 1
				-- 	},
				-- 	min = Vector2.new(0, 0),
				-- }
			},
		},
	})

	self:dispatch("addItem", self:newItemId(), {item_type="sample_item"}, Vector2.new(0, 0))

	return self
end

local storage_api = {}

storage_api.storage = storage

return storage_api