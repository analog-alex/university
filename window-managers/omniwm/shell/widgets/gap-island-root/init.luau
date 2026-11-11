-- gap-island-root: minimal island root that mounts the gap cycler component
-- in a small capsule below the menu bar / notch.

local CAPSULE_W = 96
local CAPSULE_H = 30

function render(ctx)
	local island = ctx.data.island
	if not island then return ui.box{ w = 0, h = 0 } end
	local top = math.max(island.menuBar or 0, island.notch and island.notch.h or 0) + 8
	local dx = math.max(8, math.floor((island.size.w - CAPSULE_W) / 2))
	return ui.box{ w = island.size.w, h = island.size.h, align = "top",
		ui.box{ key = "gap-capsule", w = CAPSULE_W, h = CAPSULE_H,
			dx = dx, dy = top, align = "center",
			pad = 8, radius = CAPSULE_H / 2,
			fill = "#000000",
			ui.component{ id = "gap", view = "compact",
				w = CAPSULE_W - 16, h = CAPSULE_H - 12 } } }
end
