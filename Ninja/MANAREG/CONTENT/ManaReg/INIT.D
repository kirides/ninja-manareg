const string NINJA_MANAREG_VERSION = "ManaReg 2.0.1";

const string NINJA_MANAREG_INI = "NINJA_MANAREG";
const string NINJA_MANAREG_INI_THRESHOLD = "THRESHOLD";
const string NINJA_MANAREG_INI_DIVISOR = "DIVISOR";
const string NINJA_MANAREG_INI_TICKRATE = "TICKRATE";
const string NINJA_MANAREG_INI_PER_TICK = "PER_TICK";

const int DEFAULT_NINJA_MANAREG_MANA_THRESHOLD = 50;
const int DEFAULT_NINJA_MANAREG_MAX_MANA_DIVISOR = 50;
const int DEFAULT_NINJA_MANAREG_TICKRATE = 2000;
const int DEFAULT_NINJA_MANAREG_FLAT_MANA = 0;

var int Ninja_ManaReg_Mana_Threshold;
var int Ninja_ManaReg_Max_Mana_Divisor;
var int Ninja_ManaReg_TickRate;
var int Ninja_ManaReg_Flat_Mana;

func void Ninja_ManaReg_Regeneration() {
    // Not during loading
    if (!Hlp_IsValidNpc(hero)) { return; };
    // Only in-game
    if (!MEM_Game.timestep) { return; };
    // Only in a certain interval
    var int delayTimer; delayTimer += MEM_Timer.frameTime;
    if (delayTimer < Ninja_ManaReg_TickRate) { return; };
	
    delayTimer -= Ninja_ManaReg_TickRate;
    
    if (hero.attribute[ATR_MANA_MAX] >= Ninja_ManaReg_Mana_Threshold) {
        if (hero.attribute[ATR_MANA] < hero.attribute[ATR_MANA_MAX]) {
            var int menge; menge = (hero.attribute[ATR_MANA_MAX] + (Ninja_ManaReg_Max_Mana_Divisor/2)) / Ninja_ManaReg_Max_Mana_Divisor;
			if (menge <= 0) { menge = 1; }; /* Minimum of 1 mana */
            Npc_ChangeAttribute(hero, ATR_MANA, menge);
        };
    };
};

func void Ninja_ManaReg_Regeneration_Flat() {
    // Not during loading
    if (!Hlp_IsValidNpc(hero)) { return; };
    // Only in-game
    if (!MEM_Game.timestep) { return; };
    // Only in a certain interval
    var int delayTimer; delayTimer += MEM_Timer.frameTime;
    if (delayTimer < Ninja_ManaReg_TickRate) { return; };
    
	delayTimer -= Ninja_ManaReg_TickRate;

    var c_npc n; n = Hlp_GetNpc(hero);
    
    if (n.attribute[ATR_MANA_MAX] >= Ninja_ManaReg_Mana_Threshold) {
        if (n.attribute[ATR_MANA] < n.attribute[ATR_MANA_MAX]) {
            Npc_ChangeAttribute(n, ATR_MANA, Ninja_ManaReg_Flat_Mana);
        };
    };
};

func void Ninja_ManaReg_ApplyINI() {
	var string ini_threshold; ini_threshold = MEM_GetGothOpt(NINJA_MANAREG_INI, NINJA_MANAREG_INI_THRESHOLD);
	var string ini_divisor; ini_divisor = MEM_GetGothOpt(NINJA_MANAREG_INI, NINJA_MANAREG_INI_DIVISOR);
	var string ini_tickrate; ini_tickrate = MEM_GetGothOpt(NINJA_MANAREG_INI, NINJA_MANAREG_INI_TICKRATE);
	var string ini_per_tick; ini_per_tick = MEM_GetGothOpt(NINJA_MANAREG_INI, NINJA_MANAREG_INI_PER_TICK);
	
	Ninja_ManaReg_Mana_Threshold = DEFAULT_NINJA_MANAREG_MANA_THRESHOLD;
	Ninja_ManaReg_Max_Mana_Divisor = DEFAULT_NINJA_MANAREG_MAX_MANA_DIVISOR;
	Ninja_ManaReg_Flat_Mana = DEFAULT_NINJA_MANAREG_FLAT_MANA;
	Ninja_ManaReg_TickRate = DEFAULT_NINJA_MANAREG_TICKRATE;
	
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": THRESHOLD FROM INI = "), ini_threshold));
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": DIVISOR FROM INI = "), ini_divisor));
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": TICKRATE FROM INI = "), ini_tickrate));
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": FLAT MANA FROM INI = "), ini_per_tick));
	
	if (!Hlp_StrCmp(ini_threshold, "")) {
		Ninja_ManaReg_Mana_Threshold = STR_ToInt(ini_threshold);
	};
	
	if (!Hlp_StrCmp(ini_divisor, "")) {
		Ninja_ManaReg_Max_Mana_Divisor = STR_ToInt(ini_divisor);
	};
	
	if (!Hlp_StrCmp(ini_tickrate, "")) {
		Ninja_ManaReg_TickRate = STR_ToInt(ini_tickrate);
	};
	
	if (!Hlp_StrCmp(ini_per_tick, "")) {
		Ninja_ManaReg_Flat_Mana = STR_ToInt(ini_per_tick);
	};
};

/// Init-function called by Ninja
func void ManaReg_Init() {
	// Initialize Ikarus
	MEM_InitAll();

	MEM_Info(ConcatStrings(ConcatStrings("Initialize ", NINJA_MANAREG_VERSION), "."));
	
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": " ), "Applying Gothic.INI."));
	Ninja_ManaReg_ApplyINI();
	MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": " ), "Gothic.INI applied"));
	
    MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": " ), "Hooking into oCGame__Render."));
	if (Ninja_ManaReg_Flat_Mana) {
		// Wenn eine statische Regeneration
		HookEngineF(oCGame__Render, 7, Ninja_ManaReg_Regeneration_Flat);
	} else {
		// Wenn eine dynamische Regeneration
		HookEngineF(oCGame__Render, 7, Ninja_ManaReg_Regeneration);
	};
    MEM_Info(ConcatStrings(ConcatStrings(NINJA_MANAREG_VERSION, ": " ), "Hooking into oCGame__Render finished."));

    MEM_Info(ConcatStrings(NINJA_MANAREG_VERSION, " was initialized successfully."));
};

func void Ninja_ManaReg_Dummy(){};