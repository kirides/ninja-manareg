const string NINJA_MANAREG_VERSION = "ManaReg v3.0.1";

const string NINJA_MANAREG_INI           = "NINJA_MANAREG";
const string NINJA_MANAREG_INI_TICKRATE  = "TICKRATE";
const string NINJA_MANAREG_INI_THRESHOLD = "THRESHOLD";
const string NINJA_MANAREG_INI_PERMILLE  = "PERMILLE";
const string NINJA_MANAREG_INI_PER_TICK  = "PER_TICK";

const int Ninja_ManaReg_TickRate         = 0;
const int Ninja_ManaReg_Permille         = 0;
const int Ninja_ManaReg_Permille_InFight = 0;
const int Ninja_ManaReg_SumMenge         = 0;
const int Ninja_ManaReg_PerTick          = 0;
const int Ninja_ManaReg_Threshold        = 0;

/// This function is based on mud-freak's work in [Autosave Patch](https://forum.worldofplayers.de/forum/threads/1560461-Patch-Autosave).
func int Ninja_ManaReg_IsInFight() {
    /*
        Not in fight or during threat
        oHERO_STATUS_STD = 0 // Default
        oHERO_STATUS_THR = 1 // Threatened
        oHERO_STATUS_FGT = 2 // In Fight
     */
    const int oCZoneMusic__s_herostatus_G1 =  9299208; //0x8DE508
    const int oCZoneMusic__s_herostatus_G2 = 10111520; //0x9A4A20
    if (MEM_ReadInt(MEMINT_SwitchG1G2(oCZoneMusic__s_herostatus_G1, oCZoneMusic__s_herostatus_G2))) {
        return TRUE;
    };
    return FALSE;
};

func void Ninja_ManaReg_Regeneration() {
	if (hero.attribute[ATR_MANA_MAX] < Ninja_ManaReg_Threshold) {
		return;
	};
	if (hero.attribute[ATR_MANA] < hero.attribute[ATR_MANA_MAX]) {
		var int heroManaMax; heroManaMax = mkf(hero.attribute[ATR_MANA_MAX]);

		if (Ninja_ManaReg_PerTick) {
			Npc_ChangeAttribute(hero, ATR_MANA, Ninja_ManaReg_PerTick);
			return;
		};

		var int menge;
		if (Ninja_ManaReg_IsInFight()) { menge = mulf(heroManaMax, Ninja_ManaReg_Permille_InFight); }
		else                           { menge = mulf(heroManaMax, Ninja_ManaReg_Permille);         };

		Ninja_ManaReg_SumMenge = addf(Ninja_ManaReg_SumMenge, menge);

		menge = truncf(Ninja_ManaReg_SumMenge);
		if (menge < 1) { return; };

		Npc_ChangeAttribute(hero, ATR_MANA, menge);
		Ninja_ManaReg_SumMenge = FLOATNULL;
	};
};

func string Ninja_ManaReg_GothOpt(var string section, var string option, var string default) {
	if (!MEM_GothOptExists(section, option)) {
		MEM_SetGothOpt(section, option, default);
		return default;
	};
	var string opt; opt = MEM_GetGothOpt(section, option);
	return opt;
};
func string Ninja_ManaReg_SwitchStringG1G2(var string g1, var string g2) {
	if (GOTHIC_BASE_VERSION == 2) {
		return g2;
	};
	return g1;
};

/// Reads information from INI and sets some constants for use in this patch.
func void Ninja_ManaReg_ApplyINI() {
	var string ini_tickrate;  ini_tickrate  = Ninja_ManaReg_GothOpt(NINJA_MANAREG_INI, NINJA_MANAREG_INI_TICKRATE, "1000");
	var string ini_permille;  ini_permille  = Ninja_ManaReg_GothOpt(NINJA_MANAREG_INI, NINJA_MANAREG_INI_PERMILLE, "10");
	var string ini_threshold; ini_threshold = Ninja_ManaReg_GothOpt(NINJA_MANAREG_INI, NINJA_MANAREG_INI_THRESHOLD, "50");
	var string ini_per_tick;  ini_per_tick  = Ninja_ManaReg_GothOpt(NINJA_MANAREG_INI, NINJA_MANAREG_INI_PER_TICK, Ninja_ManaReg_SwitchStringG1G2("1", "0"));
	
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": TICKRATE FROM INI = "), ini_tickrate));
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": PERMILLE FROM INI = "), ini_permille));
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": THRESHOLD FROM INI = "), ini_threshold));
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": PER_TICK FROM INI = "), ini_per_tick));
	
	Ninja_ManaReg_TickRate   = STR_ToInt(ini_tickrate);
	Ninja_ManaReg_Permille   = STR_ToInt(ini_permille);
	Ninja_ManaReg_Threshold  = STR_ToInt(ini_threshold);
	Ninja_ManaReg_PerTick    = STR_ToInt(ini_per_tick);


	Ninja_ManaReg_Permille         = divf(mkf(Ninja_ManaReg_Permille), mkf(1000));
	Ninja_ManaReg_Permille_InFight = divf(Ninja_ManaReg_Permille, mkf(2));
	Ninja_ManaReg_SumMenge         = FLOATNULL;
};

func void Ninja_ManaReg_SetupRegeneration(var int tickRate) {
    var int hndl;
    if (!hndl) {
        FF_Remove(Ninja_ManaReg_Regeneration); // Remove any previous Framefunction. (Shouldn't be there, beware the dragons)
        FF_ApplyExtGT(Ninja_ManaReg_Regeneration, tickRate, -1);
        hndl = nextHandle;
		MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": " ), "FrameFunction installed"));	
    } else {
        var FFItem ff; ff = get(hndl);
        ff.delay = tickRate;
        ff.next = TimerGT() + ff.delay;
		MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": " ), "FrameFunction updated"));	
    };
};

/// Start/update FrameFunction 
/// ____
/// `on every initialization!`
func void Ninja_ManaReg_Init_Internal() {
	// Initialize Ikarus
	MEM_InitAll();
	Lego_MergeFlags(LeGo_FrameFunctions);

	MEM_Info(ConcatStrings(ConcatStrings("Initialize ", NINJA_MANAREG_VERSION), "."));
	
	const int once = 1;
	if (once) {
		MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": " ), "Applying Gothic.INI."));
		Ninja_ManaReg_ApplyINI();
		MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": " ), "Gothic.INI applied"));	
		once = 0;
	};

	Ninja_ManaReg_SetupRegeneration(Ninja_ManaReg_TickRate);

    MEM_Info(ConcatStrings(NINJA_MANAREG_VERSION, " was initialized successfully."));
};
