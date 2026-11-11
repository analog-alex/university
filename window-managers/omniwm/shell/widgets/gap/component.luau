-- gap: component view — click to cycle outer padding presets
-- medium (50) → large (100) → default (0), via the approved helper script.

return {
	views = {
		compact = function(ctx)
			local mode = "…"
			local inst = ctx.instance
			if inst and inst.provider and inst.provider.state then
				mode = inst.provider.state.mode or mode
			end
			return ui.row({
				key = "gap", gap = 6,
				onClick = function()
					local handle, err = omniwm.provider.send("cycle", {}, nil, function(result)
						if not result.ok then
							omniwm.log("gap: " .. tostring(result.error))
						end
					end)
					if err then omniwm.log("gap send: " .. err) end
				end,
				ui.symbol{ name = "rectangle.inset.topleft.filled", size = 13, color = "accent" },
				ui.text{ text = mode, size = 11, color = "secondaryForeground", reserve = "default" },
			})
		end,
	},
}
