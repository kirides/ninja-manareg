func void Ninja_ManaReg_ApplyINI() {
	var string ini_threshold; ini_threshold = MEM_GetGothOpt(NINJA_MANAREG_INI, NINJA_MANAREG_INI_THRESHOLD);
	var string ini_divisor; ini_divisor = MEM_GetGothOpt(NINJA_MANAREG_INI, NINJA_MANAREG_INI_DIVISOR);

	Ninja_ManaReg_Mana_Threshold = DEFAULT_NINJA_MANAREG_MANA_THRESHOLD;
	Ninja_ManaReg_Max_Mana_Divisor = DEFAULT_NINJA_MANAREG_MAX_MANA_DIVISOR;
	
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": THRESHOLD FROM INI = "), ini_threshold));
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": DIVISOR FROM INI = "), ini_divisor));
	
	if (!Hlp_StrCmp(ini_threshold, "")) {
		Ninja_ManaReg_Mana_Threshold = STR_ToInt(ini_threshold);
	};
	
	if (!Hlp_StrCmp(ini_divisor, "")) {
		Ninja_ManaReg_Max_Mana_Divisor = STR_ToInt(ini_divisor);
	};
};

/*
* Ausgeführt durch NINJA_ManaReg_INITCONTENT.D -> Ninja_ManaReg_Init()
*/
func void ManaReg_Init(var int flags) {
    MEM_Info(ConcatStrings(ConcatStrings("Initialize ", NINJA_MANAREG_VERSION), "."));
	
	Ninja_ManaReg_ApplyINI();
    FF_ApplyOnceExt(Ninja_ManaReg_Regeneration, 2000, -1);

    MEM_Info(ConcatStrings(NINJA_MANAREG_VERSION, " was initialized successfully."));
};
