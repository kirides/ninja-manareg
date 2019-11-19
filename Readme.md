# Verwendete Bibliotheken

- Ikarus (Ninja-Intern)
- LeGo (Ninja-Intern)

# Build Anleitung

1. GothicVDFS 2.6 starten.
1. Filename auf "Mein\Toller\Pfad\Ninja_ManaReg.vdf" setzen.
1. Root Path auf "Pfad\Zu\Repository\" setzen.
1. Unter "File(mask)(s) to search for" den Wert "*.*" hinzufügen.
1. Build Volume drücken.
1. ~~Sytempack 1.7+ installieren, wenn noch nicht getan.~~ *Nicht mehr zwangsweise benötigt*
1. Ninja 2+ installieren, wenn noch nicht getan.
1. Erstellte .VDF in das "Gothic2\Data"-Verzeichnis legen.
1. 2% Manaregeneration alle 2 Sekunden, ab 50 maximalem Mana genießen :)

# Konfiguration

Um die Standardwerte (THRESHOLD/Schwellenwert: 50 Mana, DIVISOR: 50) zu überschreiben,
trägt man folgendes (z.B. ans Ende) in die System\Gothic.ini ein:

```
[NINJA_MANAREG]
THRESHOLD=50
DIVISOR=20
TICKRATE=2000
PER_TICK=1
```

## Erklärung

`THRESHOLD`: Der "Maximales Mana"-Wert, den der Held benötigt, damit die Manaregeneration freigeschaltet wird. (Standard: 50)  
`DIVISOR`: Der Wert mithilfe dessen, die Regenerationsrate bestimmt wird. (Standard: 50)
- Berechnung: `Regenerationsrate = (Maximales Mana + (DIVISOR / 2)) / DIVISOR` (mindestens `1`)

`TICKRATE`: Häufigkeit der Regeneration in Millisekunden
`PER_TICK`: Feste Menge Mana welche Pro Tick regeneriert wird. (Sinnvoll in G1, wo Manakosten sehr gering sind)
