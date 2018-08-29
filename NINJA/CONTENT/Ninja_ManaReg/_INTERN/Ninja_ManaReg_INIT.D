/*
* Ausgeführt durch NINJA_ManaReg_INITCONTENT.D -> Ninja_ManaReg_Init()
*/
func void ManaReg_Init(var int flags) {
    MEM_Info(ConcatStrings(ConcatStrings("Initialize ", NINJA_MANAREG_VERSION), "."));
    
    FF_ApplyOnceExt(Ninja_ManaReg_Regeneration, 2000, -1);

    MEM_Info(ConcatStrings(NINJA_MANAREG_VERSION, " was initialized successfully."));
};
