mines = {};
mine_length_min = 2 * 30;
mine_radius = 3;
mine_max_damage = 100;
mine_damage_type = "explosion";
last_poly = nil;
exit_poly = 704;

function level_init(rs)
	ProjectileTypes["special"].mnemonic = "mine";
	MonsterTypes["clone"].mnemonic = "mine";
	did_it_work=true
	Players[0]:play_sound(252, 1);

	if rs then
		for g in Monsters() do
			if (g.type == "mine") then
				table.insert(mines, {spell=g, timer=mine_length_min, ignited=false});
			end
		end

		return;
	end

	remove_items("wand", "epotion");
end

function level_idle()
	poly = Players[0].polygon.index;
	if did_it_work then
		Players[0].overlays[0].text = "worked?";
	end

	if poly ~= last_poly then
		last_poly = poly;

		if poly == exit_poly then
			Players[0]:teleport_to_level(23);
		end
	end

	for i,mine in ipairs(mines) do
		mine.timer = mine.timer - 1;

		if (mine.timer <= 0) and (not mine.ignited) then
			if mine.spell and mine.spell.valid then
				mine.spell:damage(500, mine_damage_type);
			end
		end
	end
end

function ignite_mine(mine)
	for g in Monsters() do
		if (g ~= mines[mine_index].spell) then
			mfloor = g.polygon.floor.height;
			floor_delta = math.abs(mfloor - mine.spell.poly.floor.height);
			hover = g.z - mfloor;
			wu_dist = math.sqrt((g.x - mine.spell.x) ^ 2 + (g.y - mine.spell.y) ^ 2) / 1024;

			if (wu_dist <= mine_radius) and (hover <= .5) and (floor_delta < 1.0) then
				if g.type == "mine" then
					mine_damage = 500;
				else
					mine_damage = mine_max_damage - (mine_max_damage * wu_dist / mine_radius);
				end

				g:damage_monster(mine_damage, mine_damage_type);
			end
		end
	end
end

function level_monster_killed(victim, killer, projectile)
	for i,mine in ipairs(mines) do
		if (mine.spell == victim) and (not mine.ignited) then
			Players.print(string.format("Mine #%d exploded...", i);
			mine.ignited = true;
			ignite_mine(mine);
		end
	end
end

function Triggers.projectile_detonated(type, owner, polygon, x, y, z)
	if (type == "mine") then
		spell = Monsters.new(x, y, 0, polygon, "mine");
		spell.active = true;
		Players[0]:play_sound(34, 1);
		numticks = mine_length_min + Game.global_random(90);
		table.insert(mines, {spell=spell, timer=numticks, ignited=false});
	end
end
