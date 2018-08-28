var int Ninja_ManaReg_Mana_Threshold;
var int Ninja_ManaReg_MaxManaDivf;

func void Ninja_ManaReg_Regeneration() {
    var c_npc n; n = Hlp_GetNpc(PC_Hero);
    
    if (n.attribute[ATR_MANA_MAX] >= Ninja_ManaReg_Mana_Threshold) {
        if (n.attribute[ATR_MANA] < n.attribute[ATR_MANA_MAX]) {
            var int mreg_div; mreg_div = divf(mkf(n.attribute[ATR_MANA_MAX]), Ninja_ManaReg_MaxManaDivf);
            var int menge; menge = roundf(mreg_div);

            Npc_ChangeAttribute(n, ATR_MANA, menge);
        };
    };
};