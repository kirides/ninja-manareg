/*
 * Ensure that all necessary LeGo packages will be loaded without breaking already loaded LeGo packages
 *
 * Caution: When re-using this function elsewhere, it is important to rename it to prevent clashes!
 * Each ninja patch that needs it, has to have their own function with a unique name. Otherwise they cannot be stacked.
 */
func void Ninja_ManaReg_MergeLeGoFlags(var int flags) {
    const int isInitialized = 0; // Once per session
    var   int isLoaded;          // Once per game save

    // Check if LeGo is already used and initialized by the underlying mod
    const int MOD_USES_LEGO = -1;
    if (MOD_USES_LEGO == -1) {
        MOD_USES_LEGO = _LeGo_Init; // Yes/No
    };

    // Only perform the merging of flags if LeGo is initialized by the underlying mod
    if (MOD_USES_LEGO) {
        // Already initialized packages
        var int currentFlags; currentFlags = _LeGo_Flags;

        // Find necessary packages that have not been initialized yet
        LeGo_InitFlags(flags);
        var int missingFlags; missingFlags = _LeGo_Flags & ~currentFlags;

        // Reset the loading indicator
        _LeGo_Loaded = isLoaded;

        // Re-initialize LeGo, but only with the remaining flags (so that nothing is done twice)
        if (!isInitialized) {
            LeGo_InitGamestart(missingFlags);
        };
        LeGo_InitAlways(missingFlags);

        _LeGo_Loaded = 1;

        // Finally update _LeGo_Flags (only for reference)
        LeGo_InitFlags(currentFlags | flags);
    } else {
        // Otherwise (LeGo is not used by the underlying mod), initialize it here
        LeGo_Init(flags);
    };

    // Set the indicators
    isInitialized = 1;
    isLoaded = 1;
};


/*
 * Init-function called by Ninja
 */
func void Ninja_ManaReg_Init() {
    // This function is useful to ensure correct LeGo initialization without breaking the mod
    Ninja_ManaReg_MergeLeGoFlags(Ninja_ManaReg_LeGo_Flags);
    ManaReg_Init(0);
};