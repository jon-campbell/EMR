last_poly = -1;
timer = 0;
bad_grog_dead = false;
lair_pod_poly = 218;

function level_monster_killed(victim, victor, projectile)
	if (victim.type  == "black knight") then
		bad_grog_dead = true;
		Players[0]:print("zo 'Tumba has been slain!");
		s.control_panel.permutation = 3;
	end
end

function level_init (rs)
	lair_pod_line = Lines[831];
	Players[0]:play_sound(249, 1);

	if lair_pod_line.counterclockwise_polygon ~= nil and lair_pod_line.counterclockwise_polygon.index == lair_pod_poly then
		s = lair_pod_line.counterclockwise_side
	elseif lair_pod_line.clockwise_polygon.index == lair_pod_poly then
		s = lair_pod_line.clockwise_side
	end

	if rs then
		return;
	end

	items_to_add = {
		["snyper"]=2,
		["snyper ammo"]=12,
		["dachron"]=1,
		["dachron ammo"]=12,
		["spear"]=1,
		["rocks"]=5
	};

	remove_items("hightech", "crossbow", "snyper", "snyper ammo", "dachron", "dachron ammo", "spear", "rocks");

	for p in Players() do
		for item,amount in pairs(items_to_add) do
			p.items[item] = amount;
		end
	end
end

function level_idle ()
	player_poly = Players[0].polygon.index;

	if (player_poly ~= last_poly) then
		last_poly = player_poly;

		if (timer == 0) and ((player_poly == 285) or (player_poly == 188)) then
			Players[0]:play_sound(226, 1);
			timer = 1;
		end
	end

	if (timer > 0) then
		timer = timer + 1;
	end

	if (timer == 240) then
		Players[0]:play_sound(176, 1);
		timer = 0;
	end

	if ((timer > 15) and (timer < 240)) then
		for p in Players() do
			local theta = Game.global_random(360);
			local vel = (Game.global_random(100+timer*0.5))/10000;
			p:accelerate(theta, vel, 0);
		end
	end
end
