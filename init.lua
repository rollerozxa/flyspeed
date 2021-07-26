local data = {}

minetest.register_chatcommand('flyspeed', {
	params = "<speed>",

	description = "Change the flight speed.",

	privs = { fly = true },

	func = function(name, param)
		data[name] = tonumber(param)
	end,
})

minetest.register_globalstep(function(dtime)
	for k, v in pairs(data) do
		if v ~= nil then
			player = minetest.get_player_by_name(k)
			if (minetest.get_node({x = player:get_pos().x, y = math.floor(player:get_pos().y) - 1, z = player:get_pos().z}).name == "air"
			and minetest.get_node({x = player:get_pos().x, y = math.floor(player:get_pos().y), z = player:get_pos().z}).name == "air") and player:get_velocity().y >= 0 then
				player:set_physics_override({ speed = tonumber(v) })
			else
				player:set_physics_override({ speed = 1 })
			end
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	data[player:get_player_name()] = nil
end)
