# Für Anwender

## Installationsanleitung
	
1. Ninja 2+ installieren, wenn noch nicht getan.
1. Aktuelle Version herunterladen  
    [unter "Assets" ManaReg.vdf herunterladen](https://github.com/Kirides/ninja-manareg/releases/latest)
1. ManaReg.vdf in das "Gothic\Data"-Verzeichnis legen.
1. 1% Manaregeneration jede Sekunde, ab 50 maximalem Mana genießen :)

## Konfiguration

Um die Standardwerte (PERMILLE/Pro tausendstel: 10) zu überschreiben,
trägt man folgendes (z.B. ans Ende) in die System\Gothic.ini ein:

```
[NINJA_MANAREG]
THRESHOLD=50
PERMILLE=10
TICKRATE=1000
PER_TICK=1
```

## Erklärung

`THRESHOLD`: Der "Maximales Mana"-Wert, den der Held benötigt, damit die Manaregeneration freigeschaltet wird. (Standard: 50)  
`PERMILLE`: Der Wert mithilfe dessen, die Regenerationsrate bestimmt wird. (Standard: 10 => 1% Pro Tick)
`TICKRATE`: Häufigkeit der Regeneration in Millisekunden 
`PER_TICK`: Feste Menge Mana welche Pro Tick regeneriert wird. (Sinnvoll in G1, wo Manakosten sehr gering sind)


# Für Entwickler

## Verwendete Bibliotheken

- Ikarus (Ninja-Intern)
- LeGo (Ninja-Intern)

## Build Anleitung

1. Quellcode herunterladen ([als Zip](https://github.com/Kirides/ninja-manareg/archive/master.zip))
1. Irgendwo entpacken
1. [ManaReg.vm](https://github.com/Kirides/ninja-manareg/blob/master/ManaReg.vm) mit GothicVDFS öffnen (draufziehen)
1. Build Volume drücken
