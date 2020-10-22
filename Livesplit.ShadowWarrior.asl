// Autosplitter for Shadow Warrior Classic Redux GOG and Steam versions
// Made by: Dauswectus
// Steam SDL stuff and ModuleMemorySize by: Psych0sis

state("swcr") 
{
	byte Level : 0x03E86C, 0x0;
	byte Stats : 0x045658, 0x74;
	byte Pause : 0x1652B4, 0x8;
	byte Loading: 0x09220C, 0x0;
	byte Cutscene: 0x04389C, 0x0;
}
state("sw") 
{
	byte Level : 0x14A8D4, 0x0;
	byte Stats : 0x045658, 0x74;
	byte Pause : 0x01675F4, 0x8;
	byte Loading: 0x09457C, 0x0;
}
state("sw", "SDL")
{
	byte Level : 0x5DB0D8;
	byte Stats : 0x5DB0BA;
	byte Pause : 0x3CC4FC;
	byte Loading : 0x3D544F;
	byte Cutscene : 0x5DB6B0;
}
	
init
{
	if (modules.First().ModuleMemorySize == 10256384){
		version = "SDL";
	}
	
	vars.DoneMaps = new List<int>();
}

start
{
	if (current.Level == 1 && current.Loading != 1 && current.Pause != 1){
		vars.DoneMaps.Clear();
		return true;
	}
}
split
{
	if (old.Level != current.Level && current.Level != 1){
		if(!vars.DoneMaps.Contains(current.Level) && old.Level != 0)
		{
			vars.DoneMaps.Add(current.Level);
			return true;
		}
	}
	else if(current.Cutscene == 1 && current.Level == 20)
	{
		return true;
	}
}
