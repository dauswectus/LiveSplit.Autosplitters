// Autosplitter for Duke Nukem 3D, Duke It Out in D.C., Duke: Nuclear Winter and Duke Caribbean: Life's a Beach
// for EDuke32, Megaton Edition, pkDuke3D, and 20th Anniversary World Tour editions
// Made by Dauswectus & NABN00B
// Thanks to Psych0sis for finding versions and state setup

state("pkDuke3d") // pkDuke3D
{
	byte IsMenuActive : 0x034B364, 0x33C; // Is menu active? (0, 1)
	byte CurrentEpisode : 0x02A7420, 0x3C4; // Current Episode (0, 1, 2, 3)
	byte CurrentMap : 0x021B328, 0x34C; // Current Map (values below)
	uint IsButtonPressed : 0x02C99B4, 0x2EC; // NukeButtonIsPressed (65536 EXPERIMENTAL)
}
state("duke3d", "Megaton") // Megaton Edition
{
	byte IsMenuActive : 0x01CE4B4, 0x8DC;
	byte CurrentEpisode : 0x00D1E34, 0x3B4;
	byte CurrentMap : 0x00C0C10, 0x3B4;
	uint IsButtonPressed : 0x00DEBA4, 0x4EC;
}
state("duke3d", "WorldTour") // 20th Anniversary World Tour
{
	byte IsMenuActive : 0x002A384, 0x15C; // Is menu active? (0, 1) (Actually loading screen not menu since you can start a new game in the middle of an episode)
	byte CurrentEpisode : 0x0049078, 0x44; // Current Episode (0, 1, 2, 3, 4)
	byte CurrentMap : 0x008348C, 0x3A0;
	uint IsButtonPressed : 0x013350C, 0x100;
}
state("Eduke32") // EDuke32
{
	byte IsMenuActive : 0x042AC40, 0x248; // Is menu active? (0, 1) (Actually loading screen not menu since you can start a new game in the middle of an episode)
	byte CurrentEpisode : 0x03C3CA8, 0x84;
	byte CurrentMap : 0x11F8A6E8, 0x1C;
	uint IsButtonPressedTemp : 0x09921EC, 0x65C;
}

/*
	+-----------------------------------------+
	| LEVEL BREAKDOWN                         |
	+----+--------+--------+---------+--------+
	| Ep | Levels | Secret | Deleted | Finish |
	+----+--------+--------+---------+--------+
	|  0 |  0- 7  |  5- 7  |   8-10  |  4-> 5 |
	+----+--------+--------+---------+--------+
	|  1 |        |        |         |        |
	+----+        |  9-10  |         |  8-> 9 |
	|  2 |  0-10  |        |  none   |        |
	+----+        +--------+         +--------+
	|  3 |        | 10     |         |  9->10 |
	+----+--------+--------+---------+--------+
	|  4 |  0- 7  |  7     |   8     |  6-> 7 |
	+----+--------+--------+---------+--------+
*/

init
{
	vars.DoneMaps = new List<int>();
	if (modules.First().ModuleMemorySize == 28385280)
	{
        version = "WorldTour";
	}
	else if (modules.First().ModuleMemorySize == 28860416)
	{
		version = "Megaton";
	}
	else
	{
        version = modules.First().FileVersionInfo.ProductVersion;
    }
}

startup
{
	vars.Episodes = new Dictionary<byte, string>
	{
		{0, "L.A. Meltdown"},
		{1, "Lunar Apocalypse"},
		{2, "Shrapnel City"},
		{3, "The Birth"},
		{4, "Alien World Order"}
	};
	vars.E1Levels = new Dictionary<byte, string>
	{
		{0, "E1L1: Hollywood Holocaust"},
		{1, "E1L2: Red Light District"},
		{2, "E1L3: Death Row (Disable on Any% skip)"},
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
	vars.E5Levels = new Dictionary<byte, string>
	{
		{0, "E5L1: High Times"},
		{1, "E5L2: Red Ruckus"},
		{2, "E5L3: Bloody Hell"},
		{3, "E5L4: Mirage Barrage"},
		{4, "E5L5: Tour de Nukem"},
		{5, "E5L6: Golden Carnage"},
		{6, "E5L7: Hollywood Inferno"},
		{7, "E5L8: Prima Arena"},
	};
	vars.Episodes = new Dictionary<byte, Dictionary<byte, string>>
	{
		{0, vars.E1Levels},
		{1, vars.E2Levels},
		{2, vars.E3Levels},
		{3, vars.E4Levels},
		{4, vars.E5Levels}
	};
	
	settings.Add("0", true, "L.A. Meltdown");
	settings.Add("1", true, "Lunar Apocalypse");
	settings.Add("2", true, "Shrapnel City");
	settings.Add("3", true, "The Birth");
	settings.Add("4", true, "Alien World Order");
	settings.Add("E", false, "Only split at the end of each episode");
	settings.Add("I", false, "IL time splitting (EXPERIMENTAL)");
	
	foreach (var episode in vars.Episodes)
	{
		foreach (var level in episode.Value)
			settings.Add(level.Value, true, level.Value, episode.Key.ToString());
	}
}

split
{
	if(settings["I"])
	{
		if(current.IsButtonPressed >= 15)
		{
			return true;
		}
	}
	else if (settings["E"])
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
		if(current.CurrentEpisode == 4 && current.CurrentMap == 7 && old.CurrentMap == 6)
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
						else
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
							if(current.CurrentEpisode == 4 && current.CurrentMap == 7 && old.CurrentMap == 6)
							{
								return true;
							}
						}
					}
				}
			}
		}
	}
}

start
{
	if(settings["I"])
	{
		if(current.IsMenuActive != old.IsMenuActive && current.IsMenuActive == 0)
		{
			return true;
		}
	}
    else if(current.IsMenuActive != old.IsMenuActive && current.IsMenuActive == 0 && current.CurrentMap == 0)
	{	
		vars.DoneMaps.Clear();
		return true;
	}
}

reset
{
	if(settings["I"])
	{
		if(current.IsMenuActive != old.IsMenuActive && current.IsMenuActive == 0)
		{
			return true;
		}
	}
	if(current.IsMenuActive != old.IsMenuActive && current.IsMenuActive == 0 && current.CurrentEpisode == 0 && current.CurrentMap == 0)
	{
		vars.DoneMaps.Clear();
		return true;
	}
}
