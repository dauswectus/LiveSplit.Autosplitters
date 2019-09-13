//Autosplitter for Duke Nukem 3D Atomic Edition (Steam version) with pkDuke3D v1.2
//Made by Dauswectus & NABN00B

state("pkDuke3d") 
{
	byte IsMenuActive : 0x034B364, 0x33C; // Is menu active? (0, 1)
	byte CurrentEpisode : 0x02A7420, 0x3C4; // Current Episode (0, 1, 2, 3)
	byte CurrentMap : 0x021B328, 0x34C; // Current Map (values below)
	
	
	/*
		E1: 0-7, done: 4 -> 5
		E2 & E3: 0-10, done: 8 -> 9
		E4: 0-10, done: 9 -> 10
	*/
}
init
{
	vars.DoneMaps = new List<int>();
}

startup
{
	vars.Episodes = new Dictionary<byte, string>
	{
		{0, "L.A. Meltdown"},
		{1, "Lunar Apocalypse"},
		{2, "Shrapnel City"},
		{3, "The Birth"}
	};
	vars.E1Levels = new Dictionary<byte, string>
	{
		{0, "E1L1: Hollywood Holocaust"},
		{1, "E1L2: Red Light District"},
		{2, "E1L3: Death Row"},
		{3, "E1L4: Toxic Dump"},
		{4, "E1L5: The Abyss"},
		{5, "E1L6: Launch Facility (Secret)"},
		{6, "E1L7: Faces of Death (Deathmatch)"},
		{7, "E1L8: User Map (Custom)"}
	};
	vars.E2Levels = new Dictionary<byte, string>
	{
		{0, "E2L1: Spaceport"},
		{1, "E2L2: Incubator"},
		{2, "E2L3: Warp Factor"},
		{3, "E2L4: Fusion Station"},
		{4, "E2L5: Occupied Territory"},
		{5, "E2L6: Tiberius Station"},
		{6, "E2L7: Lunar Reactor"},
		{7, "E2L8: Dark Side"},
		{8, "E2L9: Overlord"},
		{9, "E2L10: Spin Cycle (Secret)"},
		{10, "E2L11: Lunatic Fringe (Secret)"}
	};
	vars.E3Levels = new Dictionary<byte, string>
	{
		{0, "E3L1: Raw Meat"},
		{1, "E3L2: Bank Roll"},
		{2, "E3L3: Flood Zone"},
		{3, "E3L4: L.A. Rumble"},
		{4, "E3L5: Movie Set"},
		{5, "E3L6: Rabid Transit"},
		{6, "E3L7: Fahrenheit"},
		{7, "E3L8: Hotel Hell"},
		{8, "E3L9: Stadium"},
		{9, "E3L10: Tier Drops (Secret)"},
		{10, "E3L11: Freeway (Secret)"}
	};
	vars.E4Levels = new Dictionary<byte, string>
	{
		{0, "E4L1: It's Impossible"},
		{1, "E4L2: Duke-Burger"},
		{2, "E4L3: Shop-N-Bag"},
		{3, "E4L4: Babe Land"},
		{4, "E4L5: Pigsty"},
		{5, "E4L6: Going Postal"},
		{6, "E4L7: XXX-Stacy"},
		{7, "E4L8: Critical Mass"},
		{8, "E4L9: Derelict"},
		{9, "E4L10: The Queen"},
		{10, "E4L11: Area 51 (Secret)"}
	};
	vars.Episodes = new Dictionary<byte, Dictionary<byte, string>>
	{
		{0, vars.E1Levels},
		{1, vars.E2Levels},
		{2, vars.E3Levels},
		{3, vars.E4Levels}
	};
	
	settings.Add("0", true, "L.A. Meltdown");
	settings.Add("1", true, "Lunar Apocalypse");
	settings.Add("2", true, "Shrapnel City");
	settings.Add("3", true, "The Birth");
	settings.Add("E", false, "Only split at the end of each episode");
	
	foreach (var episode in vars.Episodes)
	{
		foreach (var level in episode.Value)
			settings.Add(level.Value, true, level.Value, episode.Key.ToString());
	}
}

split
{
	if (settings["E"])
	{
		if(current.CurrentEpisode == 0 && current.CurrentMap == 5 && old.CurrentMap == 4)
		{
			return true;
		}
		if(current.CurrentEpisode == 1 && current.CurrentMap == 9 && old.CurrentMap == 8)
		{
			return true;
		}
		if(current.CurrentEpisode == 2 && current.CurrentMap == 9 && old.CurrentMap == 8)
		{
			return true;
		}
		if(current.CurrentEpisode == 3 && current.CurrentMap == 10 && old.CurrentMap == 9)
		{
			return true;
		}
	}
	else
	{
		if(old.CurrentEpisode != current.CurrentEpisode)
		{
			vars.DoneMaps.Clear();
		}
		foreach (var episode in vars.Episodes)
		{
			if (current.CurrentEpisode == episode.Key)
			{
				foreach (var level in episode.Value)
				{
					if (settings[level.Value] && current.CurrentMap != old.CurrentMap && old.CurrentMap == level.Key && current.CurrentMap != 0)
					{
						if(!vars.DoneMaps.Contains(current.CurrentMap)) 
						{
							vars.DoneMaps.Add(current.CurrentMap);
							return true;
						}
					}
				}
			}
		}
	}
}

reset
{
	if(current.IsMenuActive != old.IsMenuActive && current.IsMenuActive == 0 && current.CurrentEpisode == 0 && current.CurrentMap == 0)
	{
		vars.DoneMaps.Clear();
		return true;
	}
}

start
{
    if(current.IsMenuActive != old.IsMenuActive && current.IsMenuActive == 0 && current.CurrentEpisode == 0 && current.CurrentMap == 0)
	{	
		vars.DoneMaps.Clear();
		return true;
	}
}
