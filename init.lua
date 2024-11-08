local data = {}

local S = core.get_translator('flyspeed')

local storage = core.get_mod_storage()

-- Read flight speed data from mod storage on startup
core.register_on_mods_loaded(function()
	data = core.parse_json(storage:get("data") or "{}")
end)

-- Function to set speed to 'speed' for 'name'
function update_speed(name, speed)
	data[name] = speed
	storage:set_string("data", core.write_json(data))
end

core.register_chatcommand('flyspeed', {
	params = "<speed>",

	description = S("Change the flight speed."),

	privs = { fly = true },

	func = function(name, param)
		local speed = tonumber(param) or -1
		if speed >= 0 then
			core.chat_send_player(name, S("Set flight speed to @1", param))
			update_speed(name, speed)
		else
			core.chat_send_player(name, core.colorize("#ff0000", S("Invalid speed.")))
		end
	end,
})

core.register_globalstep(function(dtime)
	for _,player in pairs(core.get_connected_players()) do
		local speed = data[player:get_player_name()]
		if speed then
			if (core.get_node({x = player:get_pos().x, y = math.floor(player:get_pos().y) - 1, z = player:get_pos().z}).name == "air"
			and core.get_node({x = player:get_pos().x, y = math.floor(player:get_pos().y), z = player:get_pos().z}).name == "air") and player:get_velocity().y >= 0 then
				player:set_physics_override({ speed = speed })
			else
				player:set_physics_override({ speed = 1 })
			end
		end
	end
end)
