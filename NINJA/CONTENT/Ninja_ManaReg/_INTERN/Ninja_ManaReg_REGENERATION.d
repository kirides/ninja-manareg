
func void Ninja_ManaReg_Regeneration() {
    // HACK: Entfernen wenn es FF gibt, welche nur im nicht pausierten Modus feuern.
    if (!mem_game.timestep) {
        return;
    };

    var c_npc n; n = Hlp_GetNpc(hero);
    
    if (n.attribute[ATR_MANA_MAX] >= NINJA_MANAREG_MANA_THRESHOLD) {
        if (n.attribute[ATR_MANA] < n.attribute[ATR_MANA_MAX]) {
            var int menge; menge = (n.attribute[ATR_MANA_MAX] + (NINJA_MANAREG_MAX_MANA_DIVISOR/2)) / NINJA_MANAREG_MAX_MANA_DIVISOR;
            Npc_ChangeAttribute(n, ATR_MANA, menge);
        };
    };
};