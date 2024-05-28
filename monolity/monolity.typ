#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Monolity
  ],
)

#align(center, text(24pt)[
  *Monolity*
])

= Otázky:
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= 1. Popiš základní konstrukci a vlastnosti mikroprocesoru (monolitu).
- mikroprocesory mohou být vyráběny pro řešení velmi specifických úloh, proto nelze jejich konstrukce a vlastnosti zcela zgeneralizovat - můžeme očekávat velké rozdíly mezi jednotlivými mikroprocesory
- převážně se používá harvardská koncepce:
  - oddělená paměť pro program a data
  - možnost použít jiné technologie (ROM, RWM) a nejměnší adresovatelnou jednotku (12, 16, 32)
- procesory jsou obvykle RISC:
  - kvůli jednoduchosti, menší spotřebě energie a menší velikosti
- typy paměti mikroprocesorů / monotlitických počítačů:
  - pro data se používá _RWM-SRAM (Read-Write Static Random-Access Memory)_
    - statické - jejich elementární paměťové buňky jsou realizovány klopnými obvody
  - pro program se používají _ROM_ paměti:
    - nejčastěji _EPROM_, _EEPROM_ a _Flash_ paměti + také _PROM_ (OTP - _One-Time Programmable_)
    - některé mikroprocesory jsou ozačeny jako _"ROM-less"_
      - nemají osazenou paměť pro program přímo na čipu _(On-Chip)_
      - paměť pro program se připojuje k monolitu jako externí pamět
        - např. Flash stick zapojený do _QSPI_ portu na _RP2040_
- paměť je organizována na:
  - pracovní registry - obvykle jeden, dva 
    - ukládají aktuálně vypracovaná data
    - jsou nějčastějšími operandy strojových instrukcí
  - _"sctratch-pad"_ registry
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jeko registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (rozdílná tepota způsobí značné odchylky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - program tedy musí průběžně tento časovač vynulovávat
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a vástupní brány (I/O)
- nejčstější paralelní brána - port
- lze nastavit jednotlivě vstupní a výstupní piny (vodiče)
- obvykle 8 pinů - lze pracovat jako jednot. bity nebo celky
- umožňuji komunikaci po sériové lince s vnějšími zařízeními

== Seriové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485
  - uvnitř el. zařízení - I2C (Inter Integrated Circuit)

== Čítače a časovače
- čítač - registr, čítá vnější události (je inkrementován vnějšího signálu)
- časovač - je inkrementován internímy hodinamy

== A/D převodníky
- fyzikal. veličiny vstupují do MCU v analog. formě (spojité)
- analog. signál - napětá, proud, odpor
- převede do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem

== D/A převodníky
- převede z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periferie
- řízení dobíjení baterii
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a pčijímač
- řadiče LCD nebo LED

#pagebreak()

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- buď programová implementace nebo dedikovaným obvodem
- číslicový signál na výstupu MCU má obvykle 2 konst. napět. úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem času, kdy je výstup na log. 1 a log. 0, můžeme modulovat z dig. signálu signál analogový (bude roven střední hodnotě napětí)
  - čas $T_0$ - U je na úrovni $U_0$
  - čas $T_1$ - U je na úrovni $U_1$
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) * T_1/(T_0 + T_1) $

- výstup se zesílí výsupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (PWM Regist a čítač)

- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image1.png", width: 110%) ],
        [ #image("image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenční hodnotou, rozdělenou na několik hodnot v určitém poměru - odporová dělička
    - paralelní převodník - rozdělujeme měřenou analog. hodnotu na několik hodnot
    - velmi rychlé - více komparátoru roste přesnost
    - kóder převede do binarního formátu
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("image4.png", width: 34%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se ref. hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota na počátku ve středě mezi minimem a maximem měřitelného rozsahu
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou vždy posune ref. hodnotu nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $log_2n$, kde $n$ je počet měřitelných hodnot

#figure(
  caption: "A/D převodník s D/A převodem",
  image("image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = T_2/T_1 * U_R $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičémž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřenýn odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] * (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: "Integrační ADC - schéma obvodu, znázornění růstu " + $U_1$ + " a\n" + "A/D převodník s RC článkem, znázornění napětí v kondenzátoru v čase"
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu dig. hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částešné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odporem v poměrech 1:2:4: ... :64:128
      - R-2R - stačí rezistory s odpory R a 2R

#figure(
  caption: "paralelní D/A převodník řešenými pomocí R-2R",
  image("image3.png", width: 39%)
)

= 5. I2C - co, jak, kde, naskreslit.
- sériová komunikační sběrnice
- umožňuje přenos dat mezi různými zařizeními
- vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA (Serial Data Line) - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL (Serial Clock Line) - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi Master a Slave zařizeními
  - *Master* - zodpovědný za řízení komunikace, inicijuje přenos
  - *Slave* - řízení přijímá a vykoná (vykoná funkci, předá zpět data)
- praxe:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem START - přivedením SDA na 0, hned po ní SCL na 0 
  - ukončí se řídicím signálem STOP - SCL na log. 1 a hned po ní SDA na log. 1
    
#figure(caption: "Znázornění START a STOP řídicích signálů na SCL a SDA vodičích", image("image8.png", width: 40%) )

  - musíme na začátku komunikace adresovat "slave" zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst (RD) od nebo zapisovat (WR) do "slave" zařízení:
    - po SDA předáme adresu zařízení - pokud adresované zařízení zaznamená, vyšle ACK (log. 0) po datovém vodiči
    - 1 byte informace - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
  - zápis/write - posílame byte postupně po bitu, po každém bytu dat musí "slave" vyslat ACK 
  - čtení/read - očekaváme data od zařízení, po každém bytu, který přijmem, vyšlem ACK
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[specifikace přímo od Raspberry Pi]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[obrázek monolitu RP2040 přímo od Raspberry Pi]
#image("image9.png")
- dual ARM Cortex-M0+
  - 2 cores/jádra
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16Mb pro off-chip Flash pamět pro program - přes QSPI port
- DMA řadič
- fully connected AHB bus fabric - propojovací síť všech komponent s procesorem
- LDO - Low-Dropout Regulator - pro generování core voltage supply
- PLL - phased-locked loops - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO - Genereal Purpose IO - piny pro obecné připojení periferií
- periférie:
  - UART (Universal Asynchronous Receiver-Transmitter)
  - SPI (Serial Pedripheral Interface)
  - I2C (Inter-Intergrated Circuit)
  - PWM (Pulse Width Modulation)
  - PIO (Programmable I/O)
  - RTC (Real Time Clock)
  - watchdog
  - reset control
  - timer
  - sysinfo & syscontrol
  - ADC (A/D converter)
  


  
  
