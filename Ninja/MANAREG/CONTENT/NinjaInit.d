/// Init-function called by Ninja
func void Ninja_ManaReg_Init() {
	// Initialize Ikarus
	MEM_InitAll();
	Ninja_ManaReg_Init_Internal();
};
