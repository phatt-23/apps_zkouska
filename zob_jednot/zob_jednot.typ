#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Zobrazovací jednotky
  ],
)

#align(center, text(24pt)[
  *Zobrazovací jednotky*
])

= Otázky:
9. Popište a nakreslete technologii LCD - výhody, nevýhody, rozdíl mezi pasivním a aktivním.
+ Popište a nakreslete technologii OLED - výhody, nevýhody.
+ Popsat E-ink - jaké má barevné rozmezí, výhody a nevýhody.
+ Vybrat která zobrazovací jednotka je podle tebe technicky nejzajimavější a proč (OLED, LCD, E-ink).

= 9. Popište a nakreslete technologii LCD - výhody, nevýhody, rozdíl mezi pasivním a aktivním.

- používá tekuté krystaly k zobrazení jednotlivých pixelů

== Princip TN (Twisted Nematic)
  1. světlo projde polarizačním filtrem a polarizuje se
  + projde vrstvami tekutých krystalů - světlo se otočí o 90°
  + projde druhým polarizačním filtrem (které je otočené o 90° proti prvnímu)
  - klidový režim (bez napětí) - propouští světlo
  - přivede-li se napětí, krystalická struktura se zorientuje podle směru toku proudu
  - nutno podsvítit bílým světlem (elektroluminiscenční výbojky, LED, OLED)
  - vrstva krystalů je rozdělená na malé buňky stejné velikosti, tvořící pixely
  
== Princip IPS
  - podobné TN
  - krystaly jsou uspořádány v rovině
  - elektrody jsou po obou stranách buňky v jedné vrstvě
  - přivede-li se napětí, krystaly se začnou otáčet ve směru elek. proudu - otočení celé roviny krystalů
  - klidový stav - světlo neprochází přes 2. pol. filtr - "nesvítí"
  
#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png") ],
        [ #image("image2.png") ],
    ),
    caption: "Princip činnosti TN a IPS displeje"
)
#pagebreak()
  
== Barevné LCD
  - každý pixel se skládá ze 3 menších bodů obsahující R, G, B filtr
  - propouštěním světla do barevných filtrů a složením barev dostaneme výslednou barvu pixelu

#image("image3.png", width: 50%)

== Pasivní LCD
  - obsahuje mřížku vodičů, body se nacházejí na průsečicích mřížky
  - při vyšším počtu bodů narůstá potřebné napětí → rozostřený obraz, velká doba odezvy (3 FPS) nevhodné pro hry, filmy, televizi atd.
  - používá se v zařízeních s malým displejem (hodinky)
  
== Aktivní LCD
  - každý průsečík v matici obsahuje tranzistor nebo diodu, řídicí činnost daného bodu
  - lze rychle a přesně ovládat svítivost každého bodu
  - TFT (Thin Film Transistor) izolují jeden bod od ostatních

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image4.png") ],
        [ #image("image5.png") ],
    ),
    caption: "Struktura pasivního a TFT displeje"
)

#pagebreak()

== Výhody:
  - kvalita obrazu
  - životnost
  - spotřeba energie
  - odrazivost a solnivost
  - bez emisi

== Nevýhody:
  - citlivost na teplotu
  - pevné rozlišení
  - vadné pixely
  - doba odezvy

= 10. Popište a nakreslete technologii OLED - výhody, nevýhody.
- hlavním prvkem - organická dioda emitující světlo (Organic Ligh Emitting Diode)
- po přivedení napětí na obě elektrody se začnou eletrony hromadit v org. vrstvy blíže k anodě
- díry, představující kladné částice, se hromadí na opačné straně blíže ke katodě
- v organické vrstvě začně docházet ke "srážkám" mezi elektrony a dírami a jejich vzájemné eliminaci, doprovázené vyzářením energie ve formě fotonu - *rekombinace*

#figure(
  grid(
    columns: (auto, auto),
    rows:    (auto, auto),
    gutter: 1em,
    [#image("image6.png")],
    [#image("image7.png")],
  ),
  caption: "Základní struktura OLED diody, Princip činnosti organické vrstvy OLED",
)
#pagebreak()

== AMOLED vs. PMOLED
- stejný princip jako aktivní/ pasivní LCD
- body organizovány do pravoúhlé matice
  - pasivní - každá OLED je aktitována dvěma na sebe kolmými elektrodami, procházejícími celou šířkou a výškou displeje
  - aktivní - každá OLED aktitována vlastním tranzistorem

#image("image8.png", width: 70%)
  
== Výhody
- vysoký kontrast
- velmi tenké
- plně barevné
- nízká spotřeba
- dobrý pozorovací úhel
- bez zpoždění
- možnost instalace na pružný podklad

== Nevýhody
- vyšší cena

= 11. Popsat E-ink - jaké má barevné rozmezí, výhody a nevýhody.
- technologii E-ink používají zařízení EPD (Electronic Paper Device)
  - EPD nepotřebují elektrický proud
- inkoust tvořen mikrokapslemi (\~ desítky-stovky µm)
- částice v kapslích se přitahují k elektrodě s opačnou polaritou
- roztok - hydrokarbonový olej (částice vydrží na míste i po odpojení napájení)
- černé částice jsou z uhlíku
- bíle z oxidu titaničitého
- k pohybu částic je potřeba proud \~ desítky nA při napětí 5-15 V
- pro barvy se používají barevné filtry (stejně jako u LCD)
  - barevná hloubka - 4096 (16#super[3])

#image("image9.png", width: 70%)

== Výhody
- vysoké rozlišení
- dobrý kontrast
- čitelnost na přímém slunci
- není nutné podsvětlení
- velký pozorovací úhel
- velmi tenké
- možno používat i na pružném podkladu
- nulova spotřeba proudu při zobrazení statické informace
- minimální spotřeba při překreslení

== Nevýhody
- málo odstínů šedí
- špatné barevné rozlišení
- velké zpoždění

= 12. Vybrat která zobrazovací jednotka je podle tebe technicky nejzajimavější a proč (OLED, LCD, E-ink).