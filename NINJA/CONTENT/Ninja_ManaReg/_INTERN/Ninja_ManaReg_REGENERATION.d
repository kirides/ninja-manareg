
func void Ninja_ManaReg_Regeneration() {
    // HACK: Entfernen wenn es FF gibt, welche nur im nicht pausierten Modus feuern.
    if (!mem_game.timestep) {
        return;
    };

    var c_npc n; n = Hlp_GetNpc(hero);
    
    if (n.attribute[ATR_MANA_MAX] >= Ninja_ManaReg_Mana_Threshold) {
        if (n.attribute[ATR_MANA] < n.attribute[ATR_MANA_MAX]) {
            var int menge; menge = (n.attribute[ATR_MANA_MAX] + (Ninja_ManaReg_Max_Mana_Divisor/2)) / Ninja_ManaReg_Max_Mana_Divisor;
            Npc_ChangeAttribute(n, ATR_MANA, menge);
        };
    };
};