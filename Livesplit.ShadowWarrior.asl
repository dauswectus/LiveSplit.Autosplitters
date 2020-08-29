// Autosplitter for Shadow Warrior Classic Redux GOG and Steam versions
// Made by: Dauswectus

state("swcr") 
{
	byte Level : 0x03E86C, 0x0;
	byte Stats : 0x045658, 0x74;
	byte Pause : 0x1652B4, 0x8;
	byte Loading: 0x09220C, 0x0;
}
state("sw") 
{
	byte Level : 0x14A8D4, 0x0;
	byte Stats : 0x045658, 0x74;
	byte Pause : 0x01675F4, 0x8;
	byte Loading: 0x09457C, 0x0;
}

init
{
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
		if(!vars.DoneMaps.Contains(current.Level))
		{
			vars.DoneMaps.Add(current.Level);
			return true;
		}
	}
}
