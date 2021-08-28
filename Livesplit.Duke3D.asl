// Autosplitter for Duke Nukem 3D, Duke It Out in D.C., Duke: Nuclear Winter and Duke Caribbean: Life's a Beach
// for EDuke32, Megaton Edition, pkDuke3D, and 20th Anniversary World Tour editions
// Made by Dauswectus & NABN00B
// https://github.com/dauswectus/LiveSplit.Autosplitters/
// Thanks to Psych0sis for finding versions and state setup

state("pkDuke3d") // pkDuke3D
{
	byte IsMenuActive : 0x034B364, 0x33C; // Is menu active? (0, 1)
	byte CurrentEpisode : 0x02A7420, 0x3C4; // Current Episode (0, 1, 2, 3)
	byte CurrentMap : 0x021B328, 0x34C; // Current Map (values below)
	uint IsButtonPressed : 0x02C99B4, 0x2EC; // NukeButtonIsPressed (65536 EXPERIMENTAL)
}
state("pkDuke3d", "pkDuke3D13") // pkDuke3D 1.3
{
	byte IsMenuActive : 0x02A7624, 0x0; // Is menu active? (0, 1)
	byte CurrentEpisode : 0x02A78F0, 0x4; // Current Episode (0, 1, 2, 3)
	byte CurrentMap : 0x02ABC48, 0x4; // Current Map (values below)
	uint IsButtonPressed : 0x02C99B4, 0x2EC; // NukeButtonIsPressed (65536 EXPERIMENTAL) //Not working
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
	byte IsMenuActive : 0x04A3350, 0x0; // Is menu active? (0, 1)
	byte CurrentEpisode : 0x0416B28, 0x4;
	byte CurrentMap : 0x0416B68, 0x4;
	uint IsButtonPressedTemp : 0x09921EC, 0x65C; //Not working
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
	else if (modules.First().ModuleMemorySize == 32632832)
	{
		version = "pkDuke3D13";
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
		{1, "Lunar Apocalypse / Nuclear Winter / Vacation Dukematch"},
		{2, "Shrapnel City / Duke It Out in D.C. / Life's a Beach"},
		{3, "The Birth"},
		{4, "Alien World Order"}
	};
	vars.E1Levels = new Dictionary<byte, string>
	{
		{0, "E1L1: Hollywood Holocaust"},
		{1, "E1L2: Red Light District"},
		{2, "E1L3: Death Row (Disable for Any% skip)"},
		{3, "E1L4: Toxic Dump"},
		{4, "E1L5: The Abyss"},
		{5, "E1L6: Launch Facility (Secret)"},
		{6, "E1L7: Faces of Death (Secret)"},
		{7, "E1L8: User Map (Custom)"}
		//,{8, "E1L9: Void Zone"}
		//,{9, "E1L10: Roach Condo"}
		//,{10, "E1L11: Antiprofit"}
	};
	vars.E2Levels = new Dictionary<byte, string>
	{
		{0, "E2L1: Spaceport / Deja Vu / Island Hopping"},
		{1, "E2L2: Incubator / Where It All Began / Hidden Grotto"},
		{2, "E2L3: Warp Factor / Land of Forgotten Toys / Cruise Ship"},
		{3, "E2L4: Fusion Station / Santa's Corporate HQ / The Docks"},
		{4, "E2L5: Occupied Territory / The Backdoor"},
		{5, "E2L6: Tiberius Station / Christmas Village"},
		{6, "E2L7: Lunar Reactor / Here Comes Santa Claws"},
		{7, "E2L8: Dark Side / Santamatch"},
		{8, "E2L9: Overlord"},
		{9, "E2L10: Spin Cycle (Secret)"},
		{10, "E2L11: Lunatic Fringe (Secret)"}
	};
	vars.E3Levels = new Dictionary<byte, string>
	{
		{0, "E3L1: Raw Meat / Hell to the Chief / Caribbean Catastrophe"},
		{1, "E3L2: Bank Roll / Memorial Service / Market Melee"},
		{2, "E3L3: Flood Zone / Nuked Files / Mr. Splashy's"},
		{3, "E3L4: L.A. Rumble / Smithsonian Terror / The Wavemistress"},
		{4, "E3L5: Movie Set / Capitol Punishment / Lost Lagoon"},
		{5, "E3L6: Rabid Transit / Metro Mayhem / Voodoo Caves"},
		{6, "E3L7: Fahrenheit / Brown Water / The Alien Remains"},
		{7, "E3L8: Hotel Hell / Dread October / A Full House"},
		{8, "E3L9: Stadium / Nuke Proof"},
		{9, "E3L10: Tier Drops / Top Secret (Secret)"},
		{10, "E3L11: Freeway (Secret)"}
	};
	vars.E4Levels = new Dictionary<byte, string>
	{
		{0, "E4L1: It's Impossible"},
		{1, "E4L2: Duke-Burger"},
		{2, "E4L3: Shop-n-Bag"},
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
		{7, "E5L8: Prima Arena (Secret)"}
		//,{8, "E5L9"}
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
	settings.Add("1", true, "Lunar Apocalypse / Nuclear Winter / Vacation Dukematch");
	settings.Add("2", true, "Shrapnel City / Duke It Out in D.C. / Life's a Beach");
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
