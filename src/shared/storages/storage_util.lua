local ZERO_VEC2 = Vector2.new(0, 0)

local util = {}

-- check if a position is within a region
function util.isInRegion(pos, min, max)
	return (pos.X >= min.X and pos.X <= max.X) and (pos.Y >= min.Y and pos.Y <= max.Y)
end

-- check if a region is within certain max bounds
function util.regionInBounds(min, max, bounds)
	return util.isInRegion(min, ZERO_VEC2, bounds) and util.isInRegion(max, ZERO_VEC2, bounds)
end

-- check if two regions intersect
-- this seems a bit too complicated but also very clear
function util.intersects(minA, maxA, minB, maxB)
	return util.isInRegion(minA, minB, maxB)
		or util.isInRegion(maxA, minB, maxB)
		or util.isInRegion(minB, maxA, maxB)
		or util.isInRegion(maxB, maxA, maxB)
end

function util.isRegionFilled(state, min, max)
	local items = state.data.items
	local filled = false
	
	for _, item in ipairs(items) do
		filled = util.intersects(min, max, item.data.min, item.data.max)
		if filled then
			break
		end
	end

	return filled
end

function util.getEmptyOfSize(state, size)
	local pos = Vector2.new(0, 0)
	local bounds = state.info.bounds
	while (pos.Y+size.Y) <= bounds.Y do
		local filled = util.isRegionFilled(state, pos, pos+size)
		if not filled then
			return pos
		end

		pos = Vector2.new(pos.X+1, pos.Y)
		if (pos.X+size.X) > bounds.X then
			pos = Vector2.new(0, pos.Y+1)
		end
	end
	return nil
end

return util