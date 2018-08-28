var int Ninja_ManaReg_Initialized;

/*
 * Initializations to perform only once every session. This function overwrites memory protection at certain addresses,
 * and registers hooks and console commands, all depending on the selected features (see config\settings.d). The
 * function is called from GFA_Init().
 */
func int ManaReg_InitOnce() {
    return TRUE;
};

/*
 * Initializations to perfrom on every game start, level change and loading of saved games. This function is called from ManaReg_Init().
 */
func void ManaReg_InitAlways() {
    Ninja_ManaReg_Mana_Threshold = 50;
    Ninja_ManaReg_MaxManaDivf = mkf(50);
    Timer_SetPauseInMenu(1);
    if(!FF_Active(Ninja_ManaReg_Regeneration)) {
        FF_ApplyExt(Ninja_ManaReg_Regeneration, 2000, -1);
    };
};

/*
 * Initialize framework. This function is called in Init_Global(). It includes registering hooks, console commands
 * and the retrieval of settings from the INI-file and other initializations.
 */
func void ManaReg_Init(var int flags) {
    // Ikarus and LeGo need to be initialized first
    MEM_Info(ConcatStrings(ConcatStrings("Initialize ", NINJA_MANAREG_VERSION), "."));
    // Perform only once per session
    if (!Ninja_ManaReg_Initialized) {
        if (!ManaReg_InitOnce()) {
            MEM_Info(ConcatStrings(NINJA_MANAREG_VERSION, " failed to initialize."));
            return;
        };
        Ninja_ManaReg_Initialized = 1;
    };

    // Perform for every new session and on every load and level change
    ManaReg_InitAlways();

    MEM_Info(ConcatStrings(NINJA_MANAREG_VERSION, " was initialized successfully."));
};
