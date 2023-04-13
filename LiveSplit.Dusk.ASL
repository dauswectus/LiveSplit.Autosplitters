//Made by Dauswectus

state("Dusk") 
{
	byte Level: "UnityPlayer.dll", 0x14C5AA8, 0x30, 0x430, 0x60, 0x120, 0x10, 0x40, 0xC88;
	float StatsScreenTimeSeconds: "UnityPlayer.dll", 0x14C49D0, 0x60, 0x10, 0x90, 0x40, 0x40, 0xC54;
	float StatsScreenTimeMinutes: "UnityPlayer.dll", 0x14C4A10, 0x2C8, 0x228, 0xD8, 0x28, 0x440, 0x40, 0xC50;
	byte menu: "UnityPlayer.dll", 0x14C7470, 0x880, 0x30, 0x10, 0x48, 0x100, 0x30, 0x16C;
}

init 
{
	vars.CurrTime = 0;
	vars.IGT = 0;
	vars.IGTA = 0;
	vars.isadded = false;
	vars.SplitIndex = 0;
}

startup
{
	//settings.Add("Fixup", false, "No sync (Experimental)");
}

update
{
	if(current.menu == 1 && vars.isadded && current.Level != 21 && current.Level != 48 && current.Level != 33)
	{
		current.StatsTimer = current.StatsScreenTimeMinutes*60000 + (int)Math.Round(current.StatsScreenTimeSeconds*100)*10;
		
		if(current.Level == 22 || current.Level == 37 || current.Level == 3)
		{
			old.StatsTimer = 0;
		}
		
		if (current.StatsTimer > old.StatsTimer)
		{
			current.IGT = (current.StatsTimer - old.StatsTimer);
		}
		else
		{
			current.IGT = 0;
		}
		double timeToAdd = current.IGT;
		vars.IGTA += timeToAdd;
		vars.isadded = false;
	}
	else if(current.menu == 0)
	{
		vars.isadded = true;
	}
}

start 
{
	vars.IGT = 0;
	vars.IGTA = 0;
	vars.CurrTime = 0;
	vars.SplitIndex = 0;
	
	//-------------------------------------------------------------------------------
	// E1	||	  3,   4, [14],  5,      6,    7,    8,    9,   10,   11,   12,  (13)		
	// E2	||	 22,  23,   24,  25,  [32],   26,   27,   28,   29,   30,   31,  (35)		
	// E3	||	 37,  38,   39,  40,  [47],   41,   42,   43,   44,   45,   46,  (47)
	//-------------------------------------------------------------------------------
	
	if(current.Level == 3 && old.Level == 21)	
	{
		return true;
	}	
	else if(current.Level == 22 && old.Level == 33)
	{
		return true;
	}
	else if (current.Level == 37 && old.Level == 48)
	{
		return true;
	}
}

split 
{
	if (current.Level == old.Level + 1 && current.menu == 1)
	{
		return true;
	}
	
	//E2 Ending
	if((current.Level == 35 && old.Level == 31 && current.menu == 1))
	{
		return true;
	}
		
	//E1 Secret Level
	if((current.Level == 14 && old.Level == 4 && current.menu == 1) || (current.Level == 5 && old.Level == 14 && current.menu == 1))
	{
		return true;
	}
	//E2 Secret Level
	if((current.Level == 32 && old.Level == 25 && current.menu == 1) || (current.Level == 26 && old.Level == 32 && current.menu == 1))
	{
		return true;
	}
	//E3 Secret Level
	if((current.Level == 47 && old.Level == 40 && current.menu == 1) || (current.Level == 41 && old.Level == 47 && current.menu == 1))
	{
		return true;
	}
}

reset 
{
	if (current.Level == 21 && current.menu == 1)
	{
		return true;
	}
}

gameTime 
{
	if(current.menu == 1)
	{
		return TimeSpan.FromMilliseconds(vars.IGTA);
	}
}

isLoading 
{
	return (current.menu == 1);	
}
