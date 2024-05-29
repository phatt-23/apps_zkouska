#set text(lang: "cs")
#set enum(numbering: "1)")
#set page(footer: context(
  smallcaps([
    Architektury počítačů a paralelních systémů - zkouška
  #h(1fr)
  #counter(page).display(
    "[1 / 1]",
    both: true,
  )
  ])),
  header: align(right)[Zkouškové otázky]
)

#align(center, 
  text(22pt)[*Architektury počítačů a paralelních systémů*]
)

= Monolity

+ Periférie monolitických počítačů - vybrat si a popsat.
+ Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
+ A/D a D/A převodníky a k čemu se používá. Nákres dobrovolný.
+ I2C - co, jak, kde, naskreslit.
+ Popiš základní konstrukci a vlastnosti mikroprocesoru.
+ Popiš mikropočítač, se kterým ses seznámil. Nákres.

= Disky

7. Fyzikální popis HDD čtení, zápis a nákres. Vysvětlit podélný a kolmý zápis.
+ Popište a nakreslete stavbu disku. Nechtěl zápis.
+ Čtení CD - princip a obrázek.

= Zobrazovací jednotky

10. Popište a nakreslete technologii LCD - výhody, nevýhody, rozdíl mezi pasivním a aktivním.
+ Popište a nakreslete technologii OLED - výhody, nevýhody.
+ Popsat E-ink - jaké má barevné rozmezí, výhody a nevýhody.
+ Vybrat která zobrazovací jednotka je podle tebe technicky nejzajimavější a proč (OLED, LCD, E-ink).

= RISC

14. Popište na RISC procesoru zřetězené zpracování instrukcí, jaké má chyby a jak se řeší.
+ Popište na RISC procesoru zřetězené zpracování instrukcí a jak nám pomůže predikce skoku.
+ Jaké problémy a hazardy mohou nastat u RISC.
+ Popiš a nakresli schéma RISC procesoru, se kterým ses seznámil.

= CISC

18. Popište a nakreslete jakéhokoli nástupce Intel Pentium Pro, se kterým jsme se seznámili.

= Paměti

19. Rozdělení polovodičových pamětí a jejich popis (klíčová slova a zkratky nestačí).
+ Jak funguje DRAM, nakresli. Napiš stručně historii.
+ Hierarchie paměti, popsat a zakreslit.

= Architektura počítačů

22. Popiš základní konstrukci a vlastnosti počítače.
+ Jak funguje počítač a jak se vykonávají skokové instrukce.
+ Popište a nakreslete harvardskou architekturu, popište rozdíly, výhody a nevýhody oproti von Neumann. Na obrázku vyznačte části, které mají a nemají společné. Která architektura je podle vás lepší a proč?
+ Popište a nakreslete architekturu dle von Neumann. Napište jeho vlastnosti, výhody a nevýhody.
#pagebreak()
= Komunikace

26. Komunikace se semafory a bez semaforů (indikátoru). Nakresli aspoň jedním směrem.
+ Přenos dat použitím V/V brány s bufferem. Nakreslit obrázek komunikace jedním směrem a jak se liší komunikace druhým směrem. V jakých periferiích se používá.
+ Popiš DMA blok a nakresli schéma DMA řadič v architekuře dle von~Neumanna.

= Assembly x86

29. Jak adresujeme na úrovni strojového kódu - příklad. 
+ Podmíněné a nepodmíněné skoky v strojovém kódu.
+ Jak řešíme v Assembly x86 podmínky - co jím musí předcházet. Jaký je vztah mezi tím, co je předchází, a tou podminkou. Kde a proč záleží na datových typech.

= CUDA

32. Princip programování CUDA - jak, kde, kdy se přesouvají data při výpočtu.
+ Jaké je C/C++ rozšíření CUDA a jak to využije programátor. Jak si programátor organizuje výpočet. K čemu je mřížka. Nákres dobrovolný.
+ Čemu by se měl programátor vyhnout a jak CUDA funguje.

= Paralelní systémy

33. Vysvětlit Amdahlův zákon a jak bychom se podle něj rozhodovali.
+ Charakterizjte komunikační modely paralelních systémů.
+ Charakterizujte Flynnovu taxonomii paralelních systémů.

#pagebreak()

//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

#set page(numbering: "1 / 1", header: align(right)[Monolity])
#align(center, text(24pt)[*Monolity*])

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
  - možnost použít jiné technologie (ROM, RWM) a nejmenší adresovatelnou jednotku (12, 16, 32)
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
  - _"sctratch-pad"_ registry:
    - pro ukládání nejčastěji používaných dat
    - část strojových instrukcí pracuje přímo s těmito registry
  - paměť dat _RWM:_
    - pro ukládání rozsáhlejších a méně používaných dat
    - instrukční sada nedovoluje krom přesunových instrukcí s touto pamětí pracovat přímo
    - musí se neprve přesunout do pracovních registrů
- počítač obsahuje také speciální registry:
  - instrukční ukazatel _(Instruction Pointer)_ - ukazuje na instrukci v paměti, která se bude vykonávat 
  - instrukční registr - ukládá vykonávanou instrukci
- zásobník s návratovými adresami:
  - buď je v paměti na vyhrazeném místě nebo jako samostatná paměť typu _LIFO_
  - aby se vědělo kde je vrchol zásobníku je třeba mít _ukazatel na vrchol zásobníku_ (jako registr)
- zdroje synchronizace mohou být interní a externí:
  - integrován přímo na čipu - není dobrá stabilita (i rozdílná tepota způsobí značné odchýlky)
    - hodí se tam, kde není potřebna vazba na reálný čas
  - externí generátory - často se používájí:
    - krystal (křemenný výbrus) - dobrá stabilita, dražší
    - keramický rezonátor - dobrá stabilita, dražší
    - RC oscilátory - může být nepřesný, levný
#figure(
    grid(columns: (auto, auto), rows: (auto, auto), gutter: 0em,
        [ #image("monolity/image13.png", width: 80%) ],
        [ #image("monolity/image14.png", width: 80%) ],
        [ #image("monolity/image15.png", width: 80%) ],
    ),
    caption: [Externí zdroje synchronizace - _a)_ externí zdroj, _b)_ oscilátor s _RC_ článkem, _c)_ krystal]
)
- počáteční stav _RESET_
  - monolit je sekvenční obvod závislý nejen na instrukcích ale i na stavech a signálech
  - aby počítač spolehlivě spustil program, musí být definován přesný počáteční stav (stav _RESET_)
  - proto jsou implementovány inicializační obvody, které počítač do tohoto stavu dostanou
- ochrana proti rušení / nestabilitě / zničení obvodů:
  - mechanické vlivy - náhodné rázy, vibrace - musí být _galvanicky_ oddělen od okolí
  - program může vlivem okolí _"zabloudit"_ - tento problém řeší obvod _WATCHDOG_
    - je to časovač, který je neustále inkrementován nebo dekrementován při běhu počítače
    - přeteční nebo podtečení tohoto časovače způsobí _RESET_
    - procesor tedy musí průběžně tento časovač vynulovávat
    - pokud je ale _"zablouděný"_, tak tuto činnost nedělá $->$ přetečení $->$ _RESET_
  - hlídání rozsahu napětí, ve kterém počítač pracuje:
    - např. počítač funguje jen ve stanoveném rozmezí 3-6V
    - dojde-li k tomu, že napětí napájení stoupne nad nebo klesne pod toto rozmezí $->$ _RESET_
- má integrovaný přerušovací podsystém _(Interrupt Subsystem)_
  - povoluje a zakazuje _interrupts_ - požadavky od periferií pro procesor, aby něco bylo vykonáno
  - definuje způsob obsluhy _interruptů_
  - zjišťuje zdroj a prioritu _interruptů_
- periférie: #emph[(viz další otázka more dyk)]
  - vstupně-výstupní brány _(I/O gates)_
  - sériové rozhraní _(SPI - Serial Peripheral Interface)_
  - čítače a časovače _(Counter & Timer)_ 
    - čítač vnějších událostí = inkrementuje se vnějším signálem
    - časovač = registr, který je inkrementován hodinovým signálem
  - A/D _(Analog to Digital)_ a D/A _(Digital to Analogue)_ převodníky _(ADC & DAC)_

#pagebreak()
  
= 2. Periférie monolitických počítačů - vybrat si a popsat.
== Vstupní a výstupní brány _(I/O gates)_
- nejčastějším a nejjednodušším rozhraním je paralelní brána neboli _port_
  - skupina jednobitových vývodů - mohou nabývat log. 0 a log. 1
  - většinou je 4-bit nebo 8-bit - předají se naráz (ne sériově)
  - lze nastavit jednotlivé vývody jako vstupní a výstupní piny (vodiče)
  - instrukční soubor s nimi pracuje buď jako s jednotlivými bity nebo celky
- umožňují komunikaci po sériové lince s vnějšími zařízeními

== Sériové rozhraní
- pro přenášení dat mezi periferními zařízeními a procesorem
- stačí minimální počet vodičů
- nízka přenosová rychlost
- delší časový interval mezi přenášenými daty - třeba data zakódovat a dekódovat (např. checkword u I2C rádiové komunikace)
- základní klasifikace komunikace (standardy):
  - na větší vzdálenosti - RS232 nebo RS485 - mezi řídicím počítačem a podřízenými stanicemi 
  - uvnitř elektronikého zařízení - I2C (Inter-Integrated Circuit)

== Čítače a časovače
- čítač - registr o $N$ bitech
  - čítá vnější události (je inkrementován vnějším signálem dle jeho náběžné nebo sestupné hrany)
  - při jeho přetečení se předá _Interrupt Request_ do _Interrupt Subsystem_ mikropočítače
  - jeho počáteční hodnota se nastaví programově
  - je možné ho v libovolné chvíli od externího signálu odpojit a opět připojit  
- časovač - čítač, který je inkrementován interním hodinovým signálem
  - lze jim zajistit řízení událostí a chování v reálném čase
  - při přeteční se automaticky předa _Interrupt Request_ 
  - krom počáteční hodnot lze nastavit i předdeličku

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("monolity/image11.png", width: 100%) ],
        [ #image("monolity/image12.png", width: 100%) ],
    ),
    caption: "Schéma čítače s přepínačem a časovače s předděličkou"
)

== A/D převodníky
- fyzikal. veličiny vstupují do mikropočítače v analog. formě (spojité)
- analog. signály mohou být - napětí _(U - Voltage)_, proud _(I - Current)_, odpor _(R - Resistance)_
- převede analog. signál do digital. formy
- základní typy:
  - komparační A/D převodník
  - A/D převodník s pomocí D/A převodem
  - integrační A/D převodník
  - převodník s RC článkem
#pagebreak()
== D/A převodníky
- převede hodnotu z digital. formy do analog. formy
- typy:
  - PWM - Pulse Width Modulation
  - paralelní převodník

== RTC - real time clock
- hodiny reálného času

== Speciální periférie
- řízení dobíjení baterií
- dvoutonový multifrekvenční generátor a přijímač
- TV přijímač
- IR vysílač a přijímač
- řadiče LCD nebo LED

= 3. Vysvětlete PWM a kde se používá. Obrázek dobrovolný.
- realizován buď programovou implementací nebo dedikovaným obvodem
- číslicový signál na výstupu mikropočítače má obvykle 2 konstantní napěťové úrovně
  - $U_0$ pro logickou 0 a $U_1$ pro logickou 1
- poměrem časů, kdy je výstup na log. 1 a log. 0, můžeme modulovat z digitální hodnoty signál analogový
  - bude roven střední hodnotě napětí za dobu jedné dané periody
  - čas $T_0$ - U je na úrovni $U_0$ neboli napětí reprezentujicí log. 0
  - čas $T_1$ - U je na úrovni $U_1$ neboli napětí reprezentujicí log. 1
  - perioda - $T = T_0 + T_1$ 
- střední hodnota napětí, $U#sub[PWM]$, je vypočitána vztahem: 
  $ U#sub[PWM] = U_0 + (U_1 - U_0) dot T_1/(T_0 + T_1) $
- výstup se zesílí výstupním zesilovačem
- pro převod PWM pulsu na analog. veličinu se používá RC článek
  - časová konstanta RC musí být výrazně větší než $T$ (toto způsobuje zpomalení)
- rozlišení výstup. signálu zavisí na počtu bitů komparovaných registrů (_PWM Registr_ a _Čítač_)
- využití: kontrola jasu LED diod, síly fénu, větráku, LCD pixelu
- princip u LED/LCD diod: _"Lidské oko nevnímá rychlé blikání jako blikání, ale jako jas."_ 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("monolity/image1.png", width: 110%) ],
        [ #image("monolity/image2.png", width: 90%) ],
    ),
    caption: "Schéma PWM obvodu a přepínání napětí v čase"
)
#pagebreak()

= 4. A/D a D/A převodníky a k čemu se používají. Nákres dobrovolný.
== A/D typy:
  - *A/D komparační* - srovnání měřené analog. veličiny s referenčními hodnotami napětí a to v~určitém poměru (1 : 2 : 4 : 8 : 16 : 32 : 64 : 128 : 256) -- odporová dělička
    - je to paralelní převodník 
      - $U#sub[INP]$ se chytne k nějakému komparátoru stejného nebo podobného napětí
      - vybraný komparátor bude mít na výstupu 1 a ostatní 0 
      - kóder převede tento signál do binarního formátu
    - velmi rychlé - s více komparátory roste přesnost
    
#figure(
  caption: "Komparační A/D převodník - odporová dělička",
  image("monolity/image4.png", width: 33%)
)

  - *A/D převodník s D/A převodem* - jeden komparátor, mění se referenční hodnota
    - podle způsobu řízení ref. hodnoty, dělíme na sledovací a aproximační
      - sledovací: 
        - najde měřenou hodnotu postupnou inkrementací a dekrementací ref. hodnoty o jeden krok
        - je pomalý - vhodný pro měření pomalu měnicích se veličin - teplota, vlhkost
      - aproximační:
        - ref. hodnota je na počátku ve středě mezi minimem a maximem měřitelného rozsahu napětí
        - podle výsledku komparátoru měřené hodnoty s ref. hodnotou se vždy posune ref. hodnota nahoru nebo dolů o polovinu zbytku intervalu
        - složitost algoritmu je $O(log_2n)$, kde $n$ je počet měřitelných hodnot -- jde o binární vyhledávání

#figure(
  caption: "A/D převodník s D/A převodem",
  image("monolity/image5.png", width: 40%)
)

#pagebreak()

  - *integrační A/D převodník:*
    - integrátor integruje vstupní napětí $U#sub[INP]$ po pevně stanovenou dobu $T_1$ do $U_1$
    - po skončení $T_1$
      - se přepne vstup integrátoru $P_1$
      - integruje se dle ref. napětí $U_R$ opačné polarity k $U#sub[INP]$
    - nyní se po dobu $T_2$ integruje $U_R$ dokud $U_1$ neklesne na $0V$
    - doba $T_2$ je závislá na $U_1$ na konci $T_1$ - z ní lze získat hodnotu měřeného napětí:
    $ U#sub[INP] = -(T_2/T_1 dot U_R) $

    
- *A/D převodník s RC článkem:*
    - na vstupu měří odpor $R#sub[INP]$ ne napětí - např. tenzometr, termistor
    - princip:
      - necháme nabíjet kondenzátor přes ref. odpor $R#sub[REF]$ dokud $U_C$ v kondenzátoru  nedosáhne $U#sub[CC]$
      - teď necháme konden. $C$ vybíjet 
        - přes stejný odpor dokud $U$ v konden. neklesne na hodnotu $U#sub[KOMP]$
        - přičemž měříme čas vybíjení $T#sub[REF]$
      - to samé uděláme s měřeným odporem $R#sub[INP]$ - získáme tím čas vybíjení $T#sub[INP]$ (na obrázku $T_s$)
      - hodnotu vstupního napětí, $R#sub[INP]$, získáme vztahem:
      $ R#sub[INP] = R#sub[REF] dot (T#sub[INP])/(T#sub[REF]) #text[ protože ] (R#sub[INP])/(R#sub[REF]) = (T#sub[INP])/(T#sub[REF]) $
      

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("monolity/image6.png", width: 100%) ],
        [ #image("monolity/image7.png", width: 100%) ],
    ),
    caption: [Integrační _ADC_ - schéma obvodu, znázornění růstu $U_1$ \ & _ADC_ s _RC_ článkem, znázornění napětí v kondenzátoru v čase]
)

#pagebreak()

== D/A převodníky
  - *PWM* (viz otázka na PWM)
  - *paralelní převodník*
    - je rychlý
    - založeny na přímém převodu digitální hodnoty na analog. veličinu
    - základem je odporová síť, na níž se vytvářejí částečné výstupní proudy:
      - váhově řazené hodnoty - rezistory s odpory v poměrech 1 : 2 : 4 : ... : 64 : 128
      - R-2R - stačí rezistory s odpory R a 2R
  - digitalní hodnota přepína přepínače pod 2R rezisotory
  - výstupem je el. proud $I_A$ a jeho komplementární (znegovaný) proud $I_B$

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("monolity/image3.png", width: 100%) ],
        [ #image("monolity/image8.png", width: 100%) ],
    ),
    caption: [Paralelní D/A převodník řešený pomocí R-2R \ & Znázornění _START_ a _STOP_ řídicích signálů na _SCL_ a _SDA_ vodičích]
)

= 5. I2C - co to je, jak funguje, kde se používá a naskreslit.
- je sériová komunikační sběrnice
  - umožňuje přenos dat mezi různými zařizeními
- byla vyvinuta firmou Phillips 
  - stala se populární mezi integrovanými obvody _(IC - integrated circuit)_ a perifer. zařizeními
  - pro svou jednoduchost a snadnou rozšířitelnost
- funguje na základě 2 obousměrných vodičů (ty mohou nabývat hodnot log. 0 a log. 1):
  - SDA _(Serial Data Line)_ - pro přenos dat mezi zařizeními, data jsou zasílana sériově po bitech
  - SCL _(Serial Clock Line)_ - pro synchronizaci přenosu 
- funguje ve formě přenosu dat mezi _"Master"_ a _"Slave"_ zařizeními
  - *_Master_* - zodpovědný za řízení komunikace, inicijuje přenos
  - *_Slave_* - řízení od _"Master"_ přijímá a vykoná (vykoná funkci / poskytuje data)
- princip fungování:
  - v klidovém stavu obě na log. 1
  - komunikace se zahajuje řídicím signálem _START_ - přivedením _SDA_ na 0, hned po ní _SCL_ na 0 
  - ukončí se řídicím signálem _STOP_ - _SCL_ na log. 1 a hned po ní SDA na log. 1  
  - musíme na začátku komunikace adresovat _"Slave"_ zařízení, se kterým chceme komunikovat, a zadat směr komunikace - zda chceme číst _(RD)_ od nebo zapisovat _(WR)_ do _"Slave"_ zařízení:
    - po _SDA_ předáme adresu zařízení s řídicím bitem _RD_ nebo _WR_ jako 1 byte dat 
      - 7 bitů slouží pro adresování zařízení a 1 bit (LSB) pro směr komunikace
      - pokud adresované zařízení zaznamená, vyšle signál _ACK_ (log. 0) po datovém vodiči
  - zápis/write - posílame byte postupně po bitech - po každém bytu dat musí _"Slave"_ vyslat _ACK_ 
  - čtení/read - očekaváme data od zařízení - po každém bytu, který přijmem, vyšlem _ACK_
  

  
= 6. Popiš a nakresli schéma mikropočítače, se kterým ses seznámil.
== Raspberry Pi RP2040
#show link: underline
#link("https://datasheets.raspberrypi.com/rp2040/rp2040-product-brief.pdf")[[specifikace přímo od Raspberry Pi]]\
#link("https://datasheets.raspberrypi.com/rp2040/hardware-design-with-rp2040.pdf")[[obrázek monolitu RP2040 přímo od Raspberry Pi]]
#figure(
  caption: [Schéma mikropočítače / mikroprocesoru / monolitu / monolitického počítače RP2040],
  image("monolity/image10.png", width: 80%)
)
- dual ARM Cortex-M0+ - 2 jádra
- taktovací frenkvence 133MHz
- SRAM - 264kB, 6 na sobě nezávislých bank 
- až 16MB pro off-chip Flash pamět s programem - přes QSPI port
- DMA řadič
- fully connected AHB _(Advanced High-performance Bus)_ 
  - propojovací síť všech komponent s procesorem
- LDO _(Low-Dropout Regulator)_ - pro generování core voltage supply
- PLL _(Phased-Locked Loops)_ - pro generování hodinového signálu pro USB rozhraní a core clock
- GPIO _(Genereal Purpose IO)_ - piny pro obecné připojení periferií
- periférie:
  - UART _(Universal Asynchronous Receiver-Transmitter)_
  - SPI _(Serial Pedripheral Interface)_
  - I2C _(Inter-Intergrated Circuit)_
  - PWM _(Pulse Width Modulation)_
  - PIO _(Programmable I/O)_ - pro naprogramování vlastního protokolu komunikace
  - RTC _(Real Time Clock)_
  - Watchdog
  - Reset Control
  - Timer
  - Sysinfo & Syscontrol
  - ADC _(A/D converter)_


//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

#set page(numbering: "1 / 1", header: align(right)[Disky])
#align(center, text(24pt)[*Disky*])

= Otázky:
7. Fyzikální popis HDD čtení, zápis a nákres. Vysvětlit podélný a kolmý zápis.
+ Popište a nakreslete stavbu disku. Nechtěl zápis.
+ Čtení CD - princip a obrázek.

= 7. Fyzikální popis HDD - čtení, zápis a nákres. Vysvětlit podélný a kolmý zápis.
- médium HDD _(Hard Disk Drive)_, na kterém se data ukládají, je feromagnetická vrstva nanesena na plotnu disku (většinou ze skla / slitiny hliníku)
- pracuje s magnetickým záznamem - tím zaznamená data
- feromagnetická vrstva dokáže uchovat magnetická pole
- záznamová/zapisovací hlava - jádro s úzkou štěrbinou (1μm) a navlečenou cívkou 
  - vrstva feromagnetická je trvale zmagnetována záznamovou hlavou
  - v bodu dotyku hlav (zapisovací a čtecí) nebo v nepatrné vzdálenosti s médiem je štěrbina 
== Zápis na disk  
  - při průchodu el. proudu cívkou proudí magnet. tok jádrem 
  - jádro v je části, kde je nejblíže záznamové vrstvě, přerušeno úzkou štěrbinou vyplněnou nemagnetickou látkou (nejčastěji bronz) nebo "ničím" (vzduchem)
  - v místě štěrbiny dochází k magnatickému stínění jádra a následnému vychýlení indukčních čar z jádra cívky do feromagnetické vrstvy disku
  - měněním směru el. proudu v cívce se mění směr magnet. toku jádrem i štěrbinou a tím smysl magnetizace aktivní vrstvy
== Čtení z disku
  - při čtení se disk pohybuje stejným směrem konstantní rychlostí
  - na aktivní feromagnetické vrstvě jsou místa magnetizované tím či oním směrem - mezi nimi jsou místa magnetického přechodu - tzv. _"magnetiké rezervace"_
    - právě ony představují zapsanou informaci
    - změny mag. pole na feromag. vrstvě způsobují napěťové impulsy na svorkách cívky čtecí hlavy
  - impulsy jsou nádledovně zesíleny elektrickými zesilovači

#figure(
  caption: "Princip magnetického zápisu na feromagnetickou vrstvu disku",
  image("disky/image1.png", width: 80%)
)

#figure(
  caption: [Podélný a kolmý zápis aktivní vrstvy pevného disku],
  image("disky/image5.png", width: 80%)
)

== Podélný zápis (longitudinální zápis) 
- způsob, jakým byla data tradičně zapisována na pevné disky
- magnetická pole, která reprezentují jednotlivé bity dat, jsou orientována podél povrchu disku
- data jsou zapsána v podélných stopách na disku, které jsou rozděleny na sektory

== Kolmý zápis (perpendikulární zápis) 
- modernější způsob zápisu na pevný disk, který umožňuje vyšší kapacitu a rychlost zápisu
- při kolmém zápisu jsou magnetická pole orientována kolmo na povrch disku
- to umožňuje menší a hustší záznam dat na povrchu disku - zvyšuje kapacitu pevného disku
- při kolmém zápisu jsou magnetická pole stabilnější a méně náchylná k rušení

= 8. Popište a nakreslete stavbu pevného disku. Nechtěl podélý a kolmý zápis.
- je to uzavřená jednotka v počítači používaná pro trvalé ukládání dat (nevolatilní)
- pouzdro chrání disk před nečistotami a poškozením
- obsahuje nevýjmutelné pevné plotny diskového tvaru (slitiny hliníku / sklo) - odtud _pevný_ disk
- části pevného disku:
  - plotny disku
  - hlavy pro čtení a zápis
  - vzduchové filtry
  - pohon hlav
  - pohon ploten disku
  - řídící deska (deska s elektronikou)
  - kabely a konektory

#pagebreak()

== Geometrie disku
- uspořádání prostoru na disku - počet hlav (zapisovací a čtecí), cylindrů a stop
- data jsou na disk ukládána v bytech
  - byty jsou uspořádány do skupin po 512 bytech (nové 4KiB) zvané sektory
- sektor je nejmenší jednotka dat, kterou lze na disk zapsat nebo z disku přečíst
  - sektory jsou seskupeny do stop 
    - stopy jsou uspořádány do skupin zvaných cylindry nebo válce
- předpokladem je, že jeden disk má nejméně dva povrchy (dolní a horní plocha plotny)
- systém adresuje sektory na pevném disku pomocí prostorové matice cylindrů, hlav a sektorů

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("disky/image2.png", width: 120%) ],
        [ #image("disky/image3.png", width: 90%) ],
    ),
    caption: "Geometrie pevného disku a popis plotny"
)
=== Stopy 
- každá strana každé plotny je rozdělena na soustředné stopy (kružnice)
- protože povrchů i hlav je několik, je při jedné poloze hlav přístupná na každém povrchu jedna stopa - pro vybrání jedné stopy stačí elektronicky přepínat hlavy

=== Cylindry
- pevné disky mají více ploten (disků), umístěných nad sebou, otáčejících se stejnou rychlostí
- každá plotna má dvě strany (povrchy), na které je možno data ukládat
- diskové hlavy nemohou být vystavovány nezávisle (jsou pohybovány společným mechanismem)
- souhrn stop v jedné poloze hlav se nazývá cylindr (válec)
- počet stop na jednom povrchu je totožný s počtem cylindrů
- z tohoto důvodu většina výrobců neuvádí počet stop, ale počet cylindrů

=== Sektory 
- jedna stopa je příliš velkou jednotku pro ukládání dat (100KiB či více bytů dat)
  - stopa se rozděluje na několik očíslovaných částí nazývané sektory
  - můžeme si je představit jako výseče na plotně
  - je to nejmenší adresovatelná jednotka na disku - na rozdíl od hlav nebo cylindrů, číslujeme od 1
  - její velikost určí řadič při formátování disku
- na začátku sektoru je hlavička, identifikující začátek sektoru a obsahující jeho číslo
- konec - tzv. zakončení sektoru - pro ukládání kontrolního součtu _(ECC - Error Correcting Code)_ 
  - slouží ke kontrole integrity uložených dat
- jednotlivé sektory se oddělují mezisektorovými mezerami - zde není možné data uložit 
- proces čtení sektoru se skládá ze dvou kroků:
  - čtecí a zápisová hlava musí přemístit nad požadovanou stopu
  - potom se čeká, až se disk natočí tak, že požadovaný sektor je pod hlavou, a pak probíhá čtení
- přemístění hlavy obvykle zabere nejvíce času
- nejrychleji se tedy čtou soubory, jejichž sektory jsou všechny na stejné stopě a stopy jsou umístěny nad sebou v jednom cylindru

= 9. Čtení CD - princip a obrázek.
- jako materiál CDčka se používá polykarbonát, strana se záznamem je pokryta reflexní vrstvou a ochranným lakem
  - záznam je v podobě pitů (prohlubně) a polí (ostrůvky) na disku 
- čtení zaznamenaných dat probíhá způsobem, kdy laser v přehrávači CD snímá z povrchu disku zaznamenaný vzor
- mechanika CD:
  - laser je umístěn rovnoběžně s povrchem disku
  - paprsek je na disk odrážen zrcadlem přes dvě čočky
    - lze velmi úzce zaostřit na malé plochy disku CD-ROM
  - fotodetektor pak měří intenzitu odraženého světla
  - laser nemůže poškodit nosič a na něm uložená data
  - při čtení se paprsek odráží od lesklého povrchu disku CD-ROM a nijak ho nepoškodí
  - mechanismus laseru je od disku asi jeden milimetr

#figure(
  caption: "CD mechanika - princip zápisu a čtení",
  image("disky/image4.png", width: 50%)
)

- čtení dat z CD média probíhá za pomocí laserové diody
  - emituje infračervený laserový paprsek směrem k pohyblivému zrcátku
  - čtenou stopu přesune servomotor pod zrcátko na základě příkazů z mikroprocesoru
  - po dopadu paprsku na jamky a pevniny, resp. pity a pole, se světlo láme a odráží zpátky
  - dále je zaostřováno čočkou, nacházející se pod médiem
  - od čočky světlo prochází pohyblivým zrcátkem - reflexní zrcadlo
  - odražené světlo dopadá na fotocitlivý senzor - fotodioda
    - převádí světelné impulsy na elektrické
    - samotné elektrické impulsy jsou dekódovány mikroprocesorem a předány do počítače ve formě dat v binárním formátu

//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

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

- LCD - _Liquid Crystal Display_
- používá tekuté krystaly k zobrazení jednotlivých pixelů
- v základě jsou dvojího typu: 
  - TN-TFT - _Twisted-Nematic Thin-Film-Transistor_
  - IPS - _In-Place-Switching_

== Princip TN-TFT LCD _(Twisted-Nematic Thin-Film-Transistor LCD)_
  1. světlo projde polarizačním filtrem a polarizuje se
  + projde vrstvami tekutých krystalů (uspořádaných do šroubovice) - světlo se otočí o 90°
  + projde druhým polarizačním filtrem (které je otočené o 90° proti prvnímu)
  - klidový režim (bez napětí) - propouští světlo
  - přivede-li se napětí, krystalická struktura (šroubovice) se zorientuje podle směru toku proudu
    - světlo projde prvnímpolarizačním filtrem, neotočí se $->$ je definitivně zablokováno
    - střídáním proudu lze určit intenzitu propouštěného světla
  - nutno podsvítit bílým světlem (elektroluminiscenční výbojky, LED, OLED)
  - vrstva krystalů je rozdělená na malé buňky stejné velikosti, tvořící pixely
  
== Princip IPS LCD _(In-Place-Switching LCD)_
  - podobné TN
  - krystaly jsou uspořádány v rovině
  - elektrody jsou po obou stranách buňky v jedné vrstvě
  - přivede-li se napětí, krystaly se začnou otáčet ve směru elek. proudu - otočení celé roviny krystalů
    - tím otočí i světlo, které jím procházelo, a propustí se druhým polarizačním filtrem
  - klidový stav - světlo neprochází přes 2. pol. filtr - "nesvítí"
  
#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("zob_jednot/image1.png", width: 110%) ],
        [ #image("zob_jednot/image2.png") ],
    ),
    caption: [Princip činnosti _TN-TFT LCD_ a _IPS LCD_ displeje]
)

#pagebreak()
  
== Barevné LCD
  - každý pixel se skládá ze 3 menších bodů (subpixelů) obsahující Red, Green, Blue filtr
  - propouštěním světla do barevných filtrů a složením barev dostaneme výslednou barvu pixelu

#figure(
  caption: [Barevný LCD - průchod bílého světla přes barevné filtry],
  image("zob_jednot/image3.png", width: 50%)
)

== Pasivní matice LCD
  - obsahuje mřížku vodičů, body se nacházejí na průsečících mřížky
  - při vyšším počtu bodů narůstá potřebné napětí → rozostřený obraz, velká doba odezvy (3 FPS) nevhodné pro hry, filmy, televizi atd.
    - z jediného rosvícenéhpo bodu se rozbíhají postupně slábnoucí vertikální a horiznontální čáry
  - používá se v zařízeních s malým displejem (hodinky)
  
== Aktivní matice LCD
  - každý průsečík v matici obsahuje svůj tranzistor nebo diodu - řeší řídicí činnost daného bodu
  - pomocí tranzistoru ve spolupráci s kondenzátorem lze rychle a přesně ovládat svítivost $forall$ bodu
  - TF _(Thin Film)_ tranzistory izolují jeden bod od ostatních - eliminace "čár" na pasivním LCD

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("zob_jednot/image4.png", width: 65%) ],
        [ #image("zob_jednot/image5.png", width: 120%) ],
    ),
    caption: [Struktura pasivního a _TFT_ (aktivního) displeje]
)
#grid(
  columns: (auto, auto),
  rows: (auto, auto),
  gutter: 1em,
  [ 
    == Výhody:
      - kvalita obrazu
      - životnost
      - spotřeba energie
      - odrazivost a oslnivost
      - bez emisí
  ],
  [ 
    == Nevýhody:
      - citlivost na teplotu
      - pevné rozlišení
      - vadné pixely
      - doba odezvy
  ]
)
= 10. Popište a nakreslete technologii OLED - výhody, nevýhody.
- hlavním prvkem - organická dioda emitující světlo _(Organic Ligh Emitting Diode)_
- po přivedení napětí na obě elektrody se začnou eletrony hromadit v org. vrstvy blíže k anodě 
  - anoda přítahuje elektrony
  - tím vznikají "díry" - kladné částice / absence elektronů - ve _"vrstvě pro přenos děr"_
- díry představující kladné částice se hromadí na opačné straně blíže ke katodě 
  - katoda odpuzuje elektrony
  - tím se ve _"vrstvě pro přenos elektronů"_ hromadí elektrony
- v organické vrstvě _("emisní vrstvě")_ začně docházet ke "srážkám" mezi elektrony a dírami
  - elektrony zaplňí "díry"
  - to způsobí jejich vzájemnou eliminaci - *rekombinace* 
    - doprovází vyzáření energie ve formě fotonu, které vnímáme jako světlo
- měněním napětí, které do diody přivádíme, způsobuje změnu jasu diody
  - čím větší napětí, tím víc vzniká "děr" $->$ vyšší výskyt rekombinace $->$ více vyzářených fotonů

#figure(
  caption: [Základní struktura _OLED_ diody],
  image("zob_jednot/image6.png", width: 70%)
)
#figure(
  image("zob_jednot/image7.png", width: 45%),
  caption: [Princip činnosti organické vrstvy _OLED_]
)

#pagebreak()

== Barevný OLED
- skládání jednotlivých pixelů ze tří základních barev
- je více možnosti složení barev (jak je seskládat):
#set enum(numbering: "a)")
  + standardně je naskládat vedle sebe
  + vertikální uspořádání
  + vertikální uspořádání s bílou složkou
#set enum(numbering: "1)")

#figure(
  caption: [Způsuby naskládání barevných složek jednoho pixelu v _OLED_ displejích],
  image("zob_jednot/image10.png")
)

== AMOLED vs. PMOLED _(Active / Pasive Matrix OLED)_
- stejný princip jako aktivní / pasivní LCD
- body organizovány do pravoúhlé matice
  - pasivní - každá OLED je aktitována dvěma na sebe kolmými elektrodami, procházejícími celou šířkou a výškou displeje
  - aktivní - každá OLED aktitována vlastním tranzistorem _(TFT - Thin Film Transistor)_

#figure(
  caption: [Technologie _OLED_ - pasivní _(PMOLED)_ a aktivní _(AMOLED)_],
  image("zob_jednot/image8.png", width: 70%)
)

#grid(
  columns: (auto, auto),
  rows: (auto, auto),
  gutter: 1em,
  [
    == Výhody
    - vysoký kontrast
    - velmi tenké
    - plně barevné
    - nízká spotřeba
    - dobrý pozorovací úhel
    - bez zpoždění
    - možnost instalace na pružný podklad
  ],
  [
    == Nevýhody
    - vyšší cena
  ]
)

#pagebreak()

= 11. Popsat E-ink - jaké má barevné rozmezí, výhody a nevýhody.
- technologii E-ink používají zařízení EPD (Electronic Paper Device)
  - EPD nepotřebují elektrický proud pro statické zobrazování
- inkoust tvořen mikrokapslemi (\~ desítky-stovky µm)
- částice v kapslích se přitahují k elektrodě s opačnou polaritou
- roztok - hydrokarbonový olej (díky jeho viskozitě vydrží částice na míste i po odpojení napájení)
- "stavba" kapsle:
  - černé záporné částice jsou z uhlíku -- C
  - bíle kladná částice z oxidu titaničitého -- TiO#sub[2]
  - obal z oxid křemičitého -- SiO#sub[2] -- a tenké vrstvy polymeru
  - jako elektoforetický roztok (elektricky separovatelný) se používá hydrokarbonový olej
- k pohybu částic je potřeba proud \~desítky nA při napětí 5-15 V
- pro barvy se používají barevné filtry (stejně jako u LCD)
  - barevná hloubka - je závislá na počtu elektrod na jeden zobrazovací bod
  - $(2^n)^c$ kde $n$ je počet elektrod a $c$ počet barevných složek (např. $(2^4)3 = 16^3 = 4096$)

#figure(
  caption: [Technologie _E-ink_ - pohled na kapsle ze strany],
  image("zob_jednot/image9.png", width: 70%)
)

#grid(
  columns: (auto, auto),
  rows: (auto, auto),
  gutter: 1em,
  [
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
  ],
  [
    == Nevýhody
    - málo odstínů šedí
    - špatné barevné rozlišení
    - velké zpoždění
  ]
)

= 12. Vybrat která zobrazovací jednotka je podle tebe technicky nejzajimavější a proč (OLED, LCD, E-ink).
- viz předchozí otázky

//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

#set page(numbering: "1 / 1", header: align(right)[RISC])
#align(center, text(24pt)[*RISC*])

= Otázky
13. Popište na RISC procesoru zřetězené zpracování instrukcí, jaké má chyby a jak se řeší.
+ Popište na RISC procesoru zřetězené zpracování instrukcí a jak nám pomůže predikce skoku.
+ Jaké problémy a hazardy mohou nastat u RISC.
+ Popiš základní konstrukci a vlastnosti mikroprocesoru RISC.
+ Popiš a nakresli schéma RISC procesoru, se kterým ses seznámil.


= 13. Popište na RISC procesoru zřetězené zpracování instrukcí, jaké má chyby a jak se řeší.
- procesor je sekvenční obvod 
  - vstup - instrukce a data z paměti
  - výstup - výsledky uloženy do paměti
- instrukce jsou vždy zpracovány stejným způsobem v několika fázích, např.:
  1. *VI* -- Výběr instrukcí z paměti (Instruction Fetch)
  + *DE* -- Dékódování instrukce (Instruction Decoder)
  + *VA* -- Výpočet adresy operandů (Operand Address Calculation) 
    - získá se adresa operandů, se kterou instrukce pracuje 
  + *PI* -- Provedení instrukce (Instruction Execution)
  + *UV* -- Uložení výsledku zpět do paměti (Store Result)
- instrukce projde všemi těto fázemi - pokud by trvala každá fáze 1 stroj. cyklus, tak by se 1 instrukce vykonala za 5 stroj. cyklů
- instrukce $I_2$ se nemůže vykonat, když procesor zpracovává inst. $I_1$
- osamostatněním jednot. fází vlastními obvody - je možné instr. zřetězit
  - zatímco *VI* vybíra instrukci z paměti, může *DE* dekédovat instr., kterou před jedním stroj. cyklem vybrala *VI* z paměti
  - teoreticky se tím zvýší výkon o násobek hloubky zřetězení
    - tomuto zrychlení avšak zabraňují podmíněné skoky, datové a strukturální hazardy
      - podmíněné skoky:
        - neví se, kdy se skok provede a kdy ne
        - adresa IP se změní - rozpracované instrukce jsou neplatné - musí se _flushnout_ fronta instrukcí - *_problém plnění fronty_*
        - existují mechanismy jak tomu předcházet
          - predikce skoku (_Brach Prediction_)
            - jednobitová - v instrukci skoku je 1 bit vyhrazen pro _flag_, který předpovídá, jestli se bude či nebude skákat (přepíná se po jednom vykonání a nevykonání skoku)
            - dvoubitová - v instrukci jsou vyhrazeny 2 bity (přepína se až po dvou konsekutivních vyhodnocení skoku)
          - zpoždění skoku - pokud možno, vykonají se instruce jiné ještě před instrukcí skoku (i přesto, že jim v programu instrukce skoku předchází)
          - buffer s pamětí skoků (_BTB -- Branch Target Buffer_) - pamatuje si stovky tzv. _target_ adres skoků
      - strukturální hazardy:
        - pomalé sběrnice a registry mezi jednotkami jednot. fází
        - musí se koordinovat přístup ke sběrnici
      - datové hazardy:
        - instrukce potřebuje výsledky od instrukce, která ještě nebyla vykonána
#figure(
  caption: "Sériové zpracování instrukcí - CISC",
  image("RISC/image4.png")
)
#figure(
  caption: "Rozdělení obvodu pro zpracování instrukcí na jednot. fázové jednotky",
  image("RISC/image6.png")
)
#figure(
  caption: "Zřetězené zpracování instrukcí - RISC",
  image("RISC/image5.png")
)

#pagebreak()
      
= 14. Popište na RISC procesoru zřetězené zpracování instrukcí a jak nám pomůže predikce skoku.
- viz 13. otázku - jak funguje zřetězené zpracování instrukcí
- typy řešení predikcí skoků - _jednobitová, dvoubitová, BTB_:
  - _jednobitová_ predikce:
    - ve formátu instrukce skoku se vyhradí jeden bit pro uložení stavu _flagu_ predikující, zda se skok vykoná či ne
    - buď se _flag_ nastaví _staticky_ programátorem/kompilátorem _(hard coded)_
    - nebo se nastavuje při běhu programu _dynamicky_ dle výsledku podmínky předcházejicího skoku
    - v cyklu k selhání predikce dojde vždy 2x - první a poslední iterace
  - _dvoubitová_ predikce:
    - vyhradí se dva bity - 4 možné hodnoty/stavy
    - funguje jako stavový automat se 4 stavy - NE = nebude se skákat, ANO = bude se skákat
      - 00 _(ANO)_ - stálý stav skákání
      - 01 _(ANO)_ - jeden neprovedený skok
      - 10 _(NE)_ - jeden provedený skok
      - 11 _(NE)_ - stálý stav "neskákání"
    - přechody $a$ a $n$ ukazují jestli se naposledy skákalo či ne
    - v cyklu se omezí počet selhání na jeden
    
#figure(
  caption: "Dvoubitová predikce - čtyřstavový automat",
  image("RISC/image3.png", width: 70%)
)
  - _BTB (Branch Target Buffer):_ 
    - tabulka s uloženými adresami provedených podmíněných skoků
    - ať už jednobitová nebo dvoubitová predikce
    - většinou implementována přímo na procesorech
    - může mít až tisíce položek

      
#pagebreak()

= 15. Jaké problémy a hazardy mohou nastat u RISC.
- viz předchozí otázky - popsaný datové a strukturální hazardy, problematika zpracování podmíněných skoků

= 16. Popiš základní konstrukci a vlastnosti mikroprocesoru RISC.
- mají malý instrukční soubor
- vývojová větev RISC vyvinula řadu zásadních kritérií, charakterizujících metodiku návrhu nejen procesoru, ale celého počítače
- procesoru se má přenechat jenom ta činnost, která je nezbytně nutná
  - další potřebné funkce přenést do architektury počítače, programového vybavení a kompilátoru
- výsledkem návrhu jsou zejména tyto vlastnosti:
  - jedna instrukce dokončena každý strojový cyklus
  - mikroprogramový řadič (software) nahrazen rychlejším obvodovým řadičem (fyz. dráty)
  - zřetězené zpracování instrukcí
  - počet instrukcí a způsobů adresování je malý
  - data jsou z hlavní paměti vybírána a ukládána výhradně pomocí dvou instrukcí LOAD a STORE
  - instrukce mají pevnou délku a jednotný formát
  - použit vyšší počet registrů
  - složitost se z technického vybavení přesouvá částečně do optimalizujícího kompilátoru
- všechny uvedené vlastnosti tvoří dobře promyšlený a provázaný celek:
  - navýšení počtu registrů & omezení komunikace s pamětí na dvě instrukce LOAD a STORE
    - ostatní instrukce nemohou používat pam. operandy - třeba mít v procesoru více dat
  - zřetězené zpracování & formát instrukcí
    - jednotná délka instrukcí dovoluje rychlejší výběr instrukcí z paměti 
    - zajišťuje lepší plnění fronty instrukcí 
    - jednotný formát zjednodušuje dekódování instrukcí
  - výsledné počítače vytvořené podle těchto pravidel přinášejí výhody pro uživatele i pro výrobce
    - zkracuje se vývoj procesoru - již první realizované čipy fungují správně
  - architektura RISC má i své nedostatky 
    - nutný nárůst délky programů - tvořený omezeným počtem instrukcí jednotné délky 
      - zpomalení, které by z toho mělo nutně plynout, se ale v praxi nepotvrdilo
        - procento instrukcí, které muselo být rozepsáno, je malé
    - většina výrobců CISC procesorů se uchýlila při výrobě procesorů k realizaci stále většího počtu vlastností arch. RISC

#pagebreak()

= 17. Popiš a nakresli schéma RISC procesoru, se kterým ses seznámil.
== ARM Cortex A77
- frekvence 3 GHz
- ARM v8-A architektura (harvardká arch.)
- 64-bitová instrukční sada se SIMD rozšířením
- 13-ti úrovňové zřetězení
- 8 jader
- cache:
  - L1 - 2x64 KiB na jádrech pro instrukce a data
  - L2 - 256 nebo 512 KiB - vyrovnávací pamět mezi procesorem a hlavní pamětí (RWM SDRAM)
- out-of-order vykonávaní instrukcí - reorder buffer může mít 160 položek
- výpočetní jednotky: 4x ALU, FPU, ASIMD, 2x Branch
- prediktor větvení \~8000 položek
- macro-OP cache \~1500 položek
  - ukládá již dekódované instrukce
  - urychluje vykonávání smyček - nemusí se vždy instrukce uvnitř cyklu dekódovat znovu
  - dekóder - 6 instrucí / cyklus
- využití:
  - mobilní zařízení s Android
  - SoC (System On Chip) - mikrokontroléry/monolity

#figure(
  caption: "Architektura ARM A77",
  image("RISC/image2.png", width: 120%)
)
#figure(
  caption: "Architektura ARM A77",
  image("RISC/image7.png", width: 100%)
)
#figure(
  caption: "mrtka",
  image("RISC/image1.png", width: 50%)
)  

//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

#set page(numbering: "1 / 1", header: align(right)[CISC],)

#align(center, text(24pt)[*CISC*])

= Otázky
18. Popište a nakreslete jakéhokoli nástupce Intel Pentium Pro, se kterým jsme se seznámili.

= 18. Popište a nakreslete jakéhokoli nástupce Intel Pentium Pro, se kterým jsme se seznámili.
== Intel Core i9-12900K _(2021)_
- 12-tá generace - codename _"Alder Lake"_
  - hybridní arch. _"Alder Lake"_ - na jednom čipu dvě rozdílné arch. jader
  - nastavila nový standard
- 10 nm - Enhanced Super-Fin _(Intel 7)_
- 16 jader:
  - 8 P-cores - arch. _"Golden Cove"_, vhodné pro hry, videa, grafic. editory
  - 8 E-cores - arch. _"Gracemont"_, daemon aplikace, méně zatěžujicí úlohy
- taktovací frakvence - 3,2 GHz (base-mode) až 5,2 GHz (turbo-mode)
- cache:
  - L1: 80 KB per P-core (32KB I-cache + 48KB D-cache), blízko jednot. jader
  - L2: 1,25 MB per P-core, 2MB per E-core, mezi CPU a hlavní pamětí
  - L3: 30 MB společná sdílená pamět všech jader
- podpora DDR4 _(Double Data Rate)_ a DDR5 čipů SDRAM
  - vysoká propustnost - rychlý přenos dat mezi hlavní pamětí a procesorem
- podpora PCIe 4.0 _(Peripheral Component Interconnect Express)_ a PCIe 5.0
  - komunikace CPU s I/O zařízeními (GPU, SSD, ...)
- integrovaná grafika na čipu _Intel UHD Graphics 770_
- _"out-of-order"_ vykonávání instrukcí (512 položek na P-core, 256 položek na E-core)
- _"Ringbus"_ - název bus fabric od Intel, sběrnicová spojnice
- nový _"Thread Director"_ - nutný kvůli hybridnímu designu, pro rovnoměrné rozdělení zátěže úlohy procesorům

#link("https://www.techpowerup.com/review/intel-core-i9-12900k-alder-lake-12th-gen/2.html")[[Intel Core i9-12900K schémata]]\
#link("https://poli.cs.vsb.cz/edu/apps/down/microarchitectures/Intel/High%20Power/2021%20-%20Golden%20Cove.jpg")[[Schéma jádra arch. Golden Cove]]

#figure(
  caption: "Vnitřní uspořádání čipu Intel Core i9-12900K",
  image("cisc/image2.png", width: 80%)
)

#figure(
  caption: "Architekrura jádra Golden Cove - High Power",
  image("cisc/image1.png", width: 80%)
)

#figure(
  caption: "Architektura jádra Gracemont - Low Power",
  image("cisc/image3.png", width: 80%)
)

== Golden Cove
- Branch Predictor
  - BTB \~12000 entries
- L1 I-cache 32KB
- L1 D-cache 48KB
- L2 cache 1.25MB
- 6 instructions / cycle
- 512 entry ROB _(Re-Order Buffer = Out-Of-Order Window)_
- 10 Execution Units:
  - VALU _(Vector ALU)_
  - FPU
  - Branch
- supports these instruction sets:
  - FMA - extension of SSE _(Streaming SIMD Extension)_
  - AMX _(Advanced Matrix Extension)_
  - AVX-512 _(Advanced Vector Extension)_
  - VNNI _(Virtual Neural Network Instructions)_
- 2x Store Data, 2x Store AGU 
- 3x Load AGU

== Gracemont
- BTB - 5000 entries
- I-cache 64KB
- 6 decoded instructions/cycle
  - decodes opcode to μOps
- out-of-order window - 256 entries - dispatch to the execution units _(EU)_
- 17 Execution Units
  - integer EU 
  - SIMD ALU
  - FPU
  - VALU _(Vector ALU)_
- newly supports these instruction sets: 
  - VNNI _(Virtual Neural Network Instructions)_
  - AVX _(Advanced Vector Extension)_



//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

#set page(numbering: "1 / 1", header: align(right)[Paměti])
#align(center, text(24pt)[*Paměti*])

= Otázky
19. Rozdělení polovodičových pamětí a jejich popis (klíčová slova a zkratky nestačí).
+ Jak funguje DRAM, nakresli. Napiš stručně historii.
+ Hierarchie paměti, popsat a zakreslit.

= 19. Rozdělení polovodičových pamětí a jejich popis (klíčová slova a zkratky nestačí).
- dělení podle typu:
  - #underline[přístupu do paměti]:
    - RAM _(Random Access Memory)_ - náhodný přístup, kamkoli odkudkoli
    - SAM _(Serial Access Memory)_ - přístup sériově, postupně (byte after byte)
    - speciální:
      - fronta - lze nahlížet na _front_ a _back_ ale ne do těla
      - zásobník - lze nahlížet jen na _top_ zásobníku ale ne do těla
      - asociativní
  - #underline[zápis/čtení]:
    - RWM _(Read Write Memory)_ - lze číst i zapisovat 
    - ROM _(Read Only Memory)_ - lze jenom číst
    - kombinované:
      - NVRAM _(Non-Volatile RAM)_ - EEPROM _(Electrically Erasable PROM)_ a Flash paměti
      - WOM _(Write Only Memory)_ - lze jen zapisovat (nepraktické, na Linuxu `/dev/null`)
      - WORM _(Write-Once Read-Many times Memory)_ - např. CD-ROM (vypálí se jednou, nejsou přepsatelné, číst lze opakovaně)
  - #underline[elementární buňky:]
    - DRAM _(Dynamic RAM)_ - náboj v kondenzátoru drží bit dat
      - postupně se vybíjí - musí se _refreshnout_, jinak se data ztratí
      - proto název dynamický
    - SRAM _(Static RAM)_ - stav klopného obvodu drží bit dat
      - dokud je zapojený proud, udržuje data
      - netřeba žádný _refresh_ - proto název statický
    - PROM - přepálené pojistky _(fuse blowing)_
      - přeplené a nepřepálené pojistky reprezentují log. 0 a log. 1 - jeden bit dat
    - EPROM _(Erasable Programmable ROM)_, EEPROM _(Electrically EPROM)_, Flash Memory 
      - tranzistor s plovoucím hradlem (floating-gate transistor)
  - #underline[uchování dat po odpojení napájení:]
    - _Volatile_ - neuchovají data, musí se nepřetržitě napájet, bývají rychlejší
      - hlavní operační paměti DRAM _("ramka")_ a SRAM _("cache" paměti)_
    - _Non-Volatile_ - uchovají data i po odpojení, nezávislé na napájení, bývají pomalejší
      - xxROM paměti - pro bootloadery, BIOSy, Firmware atd.
      - SSD _(Solid State Drive)_, HDD _(Hard Disk Drive)_ - externí paměti, hlavní uložiště

#pagebreak()
      
= 20. Jak funguje DRAM, nakresli. Napiš stručně historii.
== Stručná historie
- 50. léta 20. st. - bubnové paměti, feritová jádra
- 70. léta 20. st. - bublinové paměti
- 1969 - polovodičová technologie MOS
- 1970 - Dynamický RAM
- 1971 - Statický RAM

== DRAM
- informace uložena ve formě náboje v kondenzátoru
  - nabitý = log. 1
  - vybitý = log. 0
- jedna "_buňka_" dynamické paměti je sestavena z kondenzátoru $C$ a tranzistoru $T$ (jako el. _switch_)
- kapacita $C$ je velmi malá (jednotky femtoFahrad) - časem ztrácí napětí (proud teče do/ven z $C$)
- nutný častý _refresh_ (občerstvení), aby si uchovala svou informaci (každých \~10 ms)
  - provede se pro celý řádek při každém čtení buňky z tohoto řádku

#figure(
    grid(columns: (auto, auto), rows: (auto, auto), gutter: 1em,
        [ #image("pameti/image1.png", width: 80%) ],
        [ #image("pameti/image2.png", width: 130%) ],
    ),
    caption: "Paměťové buňky v DRAM a Organizace paměťových buněk v DRAM"
)

- buňky jsou umístěny ve čtvercové matici (matic je vedle sebe naskládaných více)
- adresování buňky probíha ve dvou krocích:
  1. vybere se řádek _(ROW)_ buňky pomocí _Row Decoder_
  - aktivuje vodič (_wordline_) daného řádku vedoucího z _Row Decoderu_ 
  2. vybere se sloupec _(COL)_ buňky pomocí _Column Decoder_
  - informace uložena v této buňce (1 nebo 0) se pošle do _I/O bufferu_ přes vodič _(bitline)_ vedoucí z _Column Decoderu_
- rozdělení adresování na dva dekódery (_Row_ a _Column_) znamená, že stačí poloviční počet vodičů pro adresování - např. pro $2^20$ buňek stačí $10$ vodičů - $2^10 dot 2^10 = 2^20$
  - sdílení stejných vodičů pro přenos částečné informace se nazývá _"multiplexing"_
  - musíme ale zavést dva řídicí signály:
    - _RAS_ (Row Access Strobe) a _CAS_ (Column Access Strobe)
    - proto aby se vědělo jakému dekóderu je adresa určena
- _DRAM_ paměť je organizována tak, že se při čtení/zápisu předá více než jeden bit - to určí počet bitů v _I/O bufferu_
- #underline[princip čtení] z _DRAM_:
  - _address buffer_ příjme adresu, kterou poskytlo CPU
  - adresa je rozdělena na adresu řádku a sloupce
    - pošle se do _address buffer_ jedna po druhé - adresní _multiplexing_
    - _multiplexing_ je kontrolován _RAS_ a _CAS_ řídicími signály
    - pokud se pošle adresa řádku aktivuje se předtím _RAS_ signál
    - pokud adresa sloupce tak _CAS_ signál
    - _address buffer_ pošle (na základě _RAS_ a _CAS_ signálu) částečnou _multiplexovanou_ adresu buď _Row Decoderu_ nebo _Column Decoderu_
    - vyšle se _READ_ řídicí signál, data adresované paměťové buňky se zesílí el. zesilovači a předá do _I/O bufferu_ - výstupní data
- #underline[princip zápisu] je obdobný čtení z _DRAM_:
  - probíha klasicky vybrání řádku a sloupce
  - namísto signálu _READ_ se ale vyšle _WE_ _(Write Enable)_ řídicí signál
    - do _I/O bufferu_ se zapíšou data, která se mají uložit
    - data z _I/O bufferu_ se zesílí a tím přepíšou adresované buňky
  
#pagebreak()
  

= 21. Hierarchie paměti, popsat a zakreslit do von Neumann.
- v počítači se používají různé typy paměti
  - důvody jsou ekonomické, technické a praktické
    - kdyby existoval typ paměti, který je levný, nevolatilní, umožňuje náhodný přístup k datům a je rychlý, nepotřebovalo by se vytvářet tolik typů pamětí - taková technologie však zatím neexistuje
    - bere se v potaz kompromis mezi cenou, rychlostí a kapacitou

#figure(
    grid(columns: (auto, auto), rows: (auto, auto), gutter: 1em,
        [ #image("pameti/image3.png", width: 100%) ],
        [ #image("pameti/image4.png", width: 100%) ],
    ),
    caption: "Pyramida hierarchie pamětí a druhy paměti ve von Neumann",
)

- paměti uspořádaný podle ceny, rychlosti a kapacity
- každá úroveň paměti tvoří vyrovnávací _(cache)_ pamět té pod ní 
  - data z OpMem jsou částečně v LCache
  - data z SSD jsou částečně v OpMem atd.
- dělí se na volatilní _(Temporary Storage Area)_ a nevolatilní _(Permanent Storage Area)_
- dělí se na čistě polovodičové a mechanické
- podle _"H"_ úrovně:
  - _H0_ - registry procesorů, odpovídá rychlostí CPU 
  - _H1_ - _Cache L1_, _SRAM_ - rychlost odpovídá vnitř. sběrnicím _CPU_, kapacita 10s až 100s kB / jádro  
  - _H2_ - _Cache L2_, _SRAM_ - 100s kB až 1s MB / jádro
  - _H3_ - _Cache L3_, _SRAM_ - 10s MB, sdílena mezi jádry, mezi _CPU_ a hlavní pamětí
  - _H4_ - _Cache L4_, _SRAM_ - 10s až 100s MB
  - _H5_ - hlavní _operační_ paměť, _DRAM_ - 1s až 100s GB
  - _H6_ - SSD _(Solid State Drive)_, HDD _(Hard Disk Drive)_, Flash - 100s GB až 1s TB 
  - _H7_ - disková pole _(Disk Array)_ - "naskládané" pevné disky, 10s TB až 1s PB
  - _H8_ - pásové jednotky _(Tapes)_ - #emph[velmi] pomalé, mrtě kapacity

//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

#set page(numbering: "1 / 1", header: align(right)[Architektura počítačů])

#align(center, text(24pt)[*Architektura počítačů*])

= Otázky
21. Popiš základní konstrukci a vlastnosti počítače.
+ Jak funguje počítač a jak se vykonávají skokové instrukce.
+ Popište a nakreslete architekturu dle von Neumann. Napište jeho vlastnosti, výhody a nevýhody.
+ Popište a nakreslete harvardskou architekturu, popište rozdíly, výhody a nevýhody oproti von Neumann. Na obrázku vyznačte části, které mají a nemají společné. Která architektura je podle vás lepší a proč?

= 21. Popiš základní konstrukci a vlastnosti počítače.
- všechny počítače pochází z von Neumannovy základní koncepce - počítač je řízen obsahem paměti
  - představen v roce 1945 - EDVAC _(Electronic Discrete Variable Automatic Computer)_
- von Neumann stanovil kritéria a principy, které musí počítač splňovat:
  1. generický design - struktura počítače je nezávislá na typu řešené úlohy
  + počítač se programuje obsahem paměti
  + strojové instrukce a data jsou uloženy v téže paměti - stejný přístup do paměti 
    - rozdílné je to u harvardské koncepce - samostatná paměť pro program _(instrukce)_ a data
  + paměť je rozdělena do buňěk stejné velikosti - jejich pořadová čísla jako adresy
  + následujicí krok je závislý na tom předchozím
  + program je sekvence instrukcí, které se sekvenčně vykonají
  + změna pořadí provádění instrukcí se provádí za pomocí skoků ((ne)podmíněný)
  + pro rezprezenaci instrukcí, dat, čísel, znaků se používá dvojková soustava
  + počítač se skládá z řídicí a aritmeticko-logické jednotky (dnes jako celek _CPU_ - centrální procesní jednotka), paměti a _I/O_ jednotek

  
= 22. Jak funguje počítač a jak se vykonávají skokové instrukce.
- počítač je programován obsahem paměti 
- instrukce se vykonávají sekvenčně
- každy krok závisí a tom předchozím
- procesor _(CPU)_ je sekvenční obvod - vstupem jsou strojové instrukce z paměti
  - má svou vlastní rychlou paměť pro ukládání výsledku instrukcí - _registry_
  - instrukční ukazatel _(IP - Instrukction Pointer)_ - někdy jako _PC_ _(Program Counter)_
    - ukazuje na instrukci v paměti, která má být vykonána
    - pomocí něj _"fetchne"_ insrukci z paměti a vykoná jí
  #figure(caption: "Princip fungování počítače",image("arch_poc/arch_poc1.png", width: 50%))
    - následně se inkrementuje o délku právě provedené instrukce
  - pokud instrukce potřebuje data z paměti, vyžádá si je _CPU_ stejným způsobem jako instrukce
  - výsledek se uloží do paměti přes sběrnici (nebo ještě zůstává v registrech)
- skokové instrukce jsou dvojího typu - podmíněné a nepodmíněné 
  - když _CPU_ zpracovává nepodmíněný skok, nastaví svůj _IP_ na místo kam se skáče
    - následné instrukce se _fetchují_ od této adresy
  - u podmíněného skoku, _CPU_ vyhodnotí, jestli se bude skákat
    - na základě stavu _flags_ registru, který uchovává aktuální stav procesoru
    - až potom se nastaví _IP_ na cílovou _(target)_ adresu (skočilo se) nebo
    - se pouze inkrementuje o délku právě vykonané instrukce (neskočilo se)  


= 23. Popište a nakreslete architekturu dle von Neumann. Napište jeho vlastnosti, výhody a nevýhody.

#figure(caption: [Počítač dle _von Neumann_], image("arch_poc/arch_poc2.png", width: 50%))

- pro vlastnosti viz otázku 21
- CPU _(Central Processing Unit)_ - sdružené řídicí a výpočetní jednotky
- paměť - společná pro program i data
- vstup/výstup _(Input/Output)_ - pro externí zařízení
- sběrnice - sdružené datové a řídicí signály, propojuje _CPU_, paměť a _I/O_ 
- #underline[výhody]:
  - rozdělení paměťi pro program a data si rozhodne sám programátor
  - řídicí jednotka přistupuje do paměti pro data i instrukce jednotným způsobem
  - jedná sběrnice znamená jednodušší design a výrobu
- #underline[nevýhody:]
  - společné uložení dat a programu může vést při chybě k přepsání valstního programu
  - jediná sběrnice je _bottleneck_ (úzké místo) - nižší proputnost dat

#pagebreak()
  
= 24. Popište a nakreslete harvardskou architekturu, popište rozdíly, výhody a nevýhody oproti von Neumann. Na obrázku vyznačte části, které mají a nemají společné. Která architektura je podle vás lepší a proč?

#figure(image("arch_poc/arch_poc3.png", width: 70%), caption: [Počítač dle harvardské architektury])

- vznikla pár let potom, co von Neumann představil svou koncepci
- vymyslel jej odborný tým z Harvardsé univerzity
- od von Neumann se moc neliší - snažila se vyřešit její nedostatky
  - pouze oddělení paměti na dvě samostatné - pro program a pro data
- pro vlastnosti viz 21. otázku - jsou až na rozdělení paměti stejné
- #underline[výhody:]
  - oddělení paměti pro data a program
    - program nemůže přepsat sám sebe
    - paměti mohou být vytvořeny odlišnými technologiemi
      - jiná velikost nejmenší adresovací jednotky
      - např. ROM pro program a RWM pro data
    - dvě sběrnice zvyšují propustnost - souběžné přistupování pro data i instrukce
- #underline[nevýhody:]
  - dvě sběrnice - vyšší nároky při vývoji řídicí jednotky + zvyšuje náklady pro výrobce
  - nevyužitelná část paměti nelze využít - program nemůže být v paměti pro data a naopak 

//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

#set page(numbering: "1 / 1", header: align(right)[Komunikace])

#align(center, text(24pt)[*Komunikace*])

= Otázky
25. Komunikace se semafory a bez semaforů (indikátorů). Nakresli aspoň jedním směrem.
+ Přenos dat použitím V/V brány s bufferem. Nakreslit obrázek komunikace jedním směrem a jak se liší komunikace druhým směrem. V jakých periferiích se používá.
+ Popiš DMA blok a nakresli schéma DMA řadič v architekuře dle von~Neumanna.


== Technika _I/O_ brán
- _I/O gate_ (vstupně-vystupní brány) 
  - obvod zprostředkovávajicí předávání dat mezi sběrnicí počítače a perifériemi 
  - základem je _latch register_ (záchytný registr) s _tří-stavovým výstupem_ (three-state, tří-stavový budič sběrnice)
    + _Inactive_ stav - stav vysoké impedance, "Do not disturb" 
    + _Input_ stav - periférie vysíla data
    + _Output_ stav - periférie data přijímá
  - možnost použít brány s pamětí _(buffer)_
    - ten je potřebný při obostranném (úplného) korespondenčním režimu

= 25. Komunikace se semafory a bez semaforů (indikátorů). Nakresli aspoň jedním směrem.
== Technika nepodmíněného vstupu a výstupu _(bez semaforu/indikátoru)_
#figure(image("komunikace/image1.png", width: 60%), caption: [Technika nepodméněného vstupu a výstupu _bufferu_])
- #underline[vstup] _(input)_ - procesor vyšle signál _RD_ (read) 
  - přikáže tím vstupnímu zařízení předat data do procesoru
  - nijak se nekotroluje jestli je periférie připravená (očekává se, že je vždy připravená)
- #underline[výstup] _(output)_ - procesor vyšle signál _WR_ (write) 
  - výstupní zařízení data z procesoru převezme
  - nijak se nekontroluje, jestli data perfiferní zařízení opravdu převzalo
- tento způsob je velmi jednoduchý
- předpokládá neustálou připravenost periferního zařízení

#pagebreak()
==  Technika podmíněného vstupu a výstupu _(se semaforem/indikátorem)_
#figure(
    grid(columns: (auto, auto), rows: (auto, auto), gutter: 1em,
        [ #image("komunikace/image2.png", width: 100%) ],
        [ #image("komunikace/image3.png", width: 100%) ],
    ),
    caption: [Technika podmíněného vstupu a výstupu bez _bufferu_]
)
- #underline[vstup] _(input)_
  - periferní zařízení připraví data na vyslání - pokud jsou data platná vyšle signál _STB (Strobe)_
  - ten nastaví indikátor _(flag)_ $Q$ na 1 - $Q = 1$
  - pokud je $Q = 1$ jsou data připravena pro předání do procesoru
  - procesor si průběžně stav $Q$ kontroluje:
    - vidí že $Q = 1$ $->$ data se přečtou procesorem vysláním signálu _RD (read)_ z procesoru 
      - ten zároveň nastaví $Q = 0$
- #underline[výstup] _(output)_
  - procesor vyšle signál _WR (write)_ pro zápis dat do výstupního zařízení a data pošle 
    - zárověň tím nastaví $Q=1$
  - periferní zařízení data z procesoru převezme a vyšle signál _ACK_ - data převzata
    - nastaví tím $Q = 0$
      - dá tím procesoru najevo, že data skutečně převzalo
      - procesor může vyslat další data - periférie je připravena přijímat další data
   
- obrázky popisují #emph[jednosměrný korespondenční režim] (neúplný) - není zde _buffer_ uprostřed komunikace
  - vysílač dat (ať už procesor nebo periférie) je povinen si data udržovat při celém průběhu komunikace - nemá _buffer_ (na obrázku jako registr), kam by je průběžně mohl zapisovat

= 26. Přenos dat použitím V/V brány s bufferem. Nakreslit obrázek komunikace jedním směrem a jak se liší komunikace druhým směrem. V jakých periferiích se používá.

- funguje na principu _input/output_ v technice bez _bufferu_ (minulá otázka) ale tentokrát ten _buffer_ má
- využíva _buffer_ (na obrázku registr) jako vyrovnávací paměť a klopný obvod _(flip-flop)_ jako semafor/indikátor
- jde o #emph[obousměrný korespondenční režim] (úplný) komunikace
  - možnost vzájemného blokování _(interlock)_ - vysílač dat a přijímač dat testují stav indikátoru $Q$
- #underline[vstup] _(input)_
  - $Q$ informuje procesoru připravenost dat ve vyrovnávací paměti _(bufferu)_
  - pro periférii informuje $Q$ 
    - zda procesor data již přečetl a je možno do _bufferu_ zaslat další data
    - nebo data jěště přečtena nebyla a nemůže zaslat další data do _bufferu_
- #underline[výstup] _(output)_ - význam indikátoru $Q$ je pro procesor a periferii opačný než v _input_
- #underline[využití:] sériové komunikační porty (_SPI_, _UART_, _I2C_ apod.), paměťové karty, audio a video zařízení, síťové karty, tiskárny
#figure(
    grid(columns: (auto, auto), rows: (auto, auto), gutter: 1em,
        [ #image("komunikace/image5.png", width: 100%) ],
        [ #image("komunikace/image4.png", width: 100%) ],
    ),
    caption: [Technika korespondenčně obousměrná s _bufferem_],
)

= 27. Popiš DMA blok a nakresli schéma DMA řadič v architekuře dle von~Neumanna.

- DMA _(Direct Memory Access)_ blok / kontrolér / řadič 
  - umožňuje perifením zařízením vstupovat do hlavní paměti přímo
    - přímý přesun dat mezi hlavní pamětí a periférii s minimální účasti procesoru
      - bez _DMA_ bloku musí každý byte dat z periférie projít procesorem a až potom procesor může přistoupit do paměti
      - procesor se samotného přesunu dat neučastní - pouze nastaví/naprogramuje _DMA blok_ 
      - sběrnice musí být při přesunu uvolněna - může být maximálně jeden _budič_ sběrnice
        - procesor přepne všechny budiče sběrnic do stavu vysoké impedance
      - _DMA_ zajistí přesun - generuje sám adresy v paměti, kam se bude zapisovat/číst
      
- v _DMA_ bloku jsou tři registry sloužící pro styk se sběrnicí:
  - _data register_ - obsahuje slovo, které má být přesunuto z periferie do paměti nebo naopak
  - _address register_ - pro uchování adresy v hlavní paměti, na kterou bude slovo zapsáno nebo čteno
  - _counter_ - počet slov, které mají být ještě přesunuty
- operace přístupu do paměti (z pohledu zápisu do paměti):
  1. procesor naprogramuje blok _DMA_ - nastaví se registry _counter_ a _address_
  + blok _DMA_ spustí periferní zařízení a čeká až bude připraveno
  + periférie oznámí _DMA_ bloku, že je připravena - _DMA_ blok vyšle _DMA Request_
  + procesor dokončí strojovou instrukci a začne se věnovat _DMA Requestu_
    - přímý přístup do paměti se vykonává synchronně při normální činnosti procesoru
      - synchronně se přepíná přístup ke sběrnici a paměti mezi _DMA_ blokem a procesorem
      - _DMA_ blok pracuje s pamětí ve fázi $Phi_1$ a procesor ve fázi $Phi_2$ interního hodin. signálu 
  + DMA blok vyšle na adresovou sběrnici obsah svého _address registru_ a na datovou sběrnici obsah svého _data registru_
  + počka jeden paměťový cyklus $arrow$ inkrementuje _address register_, dekrementuje _counter_ (počet slov, které mají být ještě přesunuty)
  + testuje zda _counter_ $= 0$
    - pokud ano - ukončí _DMA_ komunikaci a vrátí kontrolu nad sběrnici procesoru 
    - pokud ne - proces se opakuje od 6. kroku
  - čtení funguje obdobně, jen opačným směrem
  
#figure(image("komunikace/image6.png", width: 60%), caption: [Přenos dat #emph[bez] _DMA_ bloku _(ve von Neumann)_ vyžadující neustálý zásah procesoru])

#figure(image("komunikace/image7.png", width: 90%), caption: [Přenos dat #emph[s] _DMA_ blokem _(ve von Neumann)_ nevyžaduje zásah procesoru (minimální)])
  
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

#set page(numbering: "1 / 1", header: align(right)[Assembly x86],)
#align(center, text(24pt)[*Assembly x86*])

= Otázky
28. Jak adresujeme na úrovni strojového kódu - příklad. 
+ Podmíněné a nepodmíněné skoky v strojovém kódu.
+ Jak řešíme v Assembly x86 podmínky - co jím musí předcházet. Jaký je vztah mezi tím, co je předchází, a tou podminkou. Kde a proč záleží na datových typech.

= 28. Jak adresujeme na úrovni strojového kódu - příklad. 
- adresování dělíme na _přímé_ a _nepřímé_
- #underline[přímé adresování:]
  - uvádíme konkrétní adresu v paměti 
  ```c 
  int a = 12;                       // v jazyce C
  int* a_ptr = &a;
  printf("%p\n", a_ptr);
  $> 0x7ffc58e5f904                 // kontrétní adresa v paměti
  ```
  ```asm
  mov eax, dword [0x7ffc58e5f904]   ; v jazyce Assembly
  ```
  - např. adresy globálních proměnných
  - není běžné aby programátor adresoval data v paměti přímo
-  #underline[nepřímé adresování:]
  - adresujeme přes registry
  ```asm
  mov rdx, 0x7ffc58e5f904           ; v registru se uloží adresa v paměti           
  mov eax, dword [rdx]              ; do registru eax se uloží hodnota 12
  ```
  
  - v 64-bit systémech s x86 instrukční sadou adresujeme pomocí:
    - registrů (bázová adresa a index v poli, max. 2 registry)
    - měřítka (počet bytů - `char = 1`, `short = 2`, `int = 4`, `long = 8`, a více),
    - konstanty - většinou není potřebná
    ```asm
    [bázový_registr + index_registr * měřítko + konstanta] 
    mov eax, dword [rdx + rcx * 4 + 0]
    ```
    
    - `rdx` registr je zde bázovým registrem
    - `rcx` registr představuje indexový registr
    - číslo `4` je měřítkem - např. adresujeme pole ```c int array[N] = {0}```, protože ```c sizeof(int) = 4```
    - vevnitř `[ ... ]` můžeme použít jenom operace sčítání $(+)$ a násobení $(*)$ 

#pagebreak()

= 29. Podmíněné a nepodmíněné skoky v strojovém kódu.
- skokové instrukce:
  ```asm
  ; tyto jsou nepodmíněné
  jmp <target>              ; nepodmíněný skok na <target>
  call <target>             ; zavolání podprogramu, skočí se <target>
  ret                       ; skočí se zpět do nadprogramu (jeho adresa je na stacku)
  ; další jsou už podmíněné
  ; tyto testují regitr rcx a jsou využivány pro cykly
  loop <target>             ; if(--ecx) goto <target>
  loope <target>            ; if(--ecx && zf) goto <target>
  loopz <target>            ; stejné jako loope
  loopne <target>           ; if(--ecx && !zf) goto <target>
  loopnz <target>           ; stejné jako loopne
  jcxz <target>             ; if(!rcx) goto <target>
  ; tyto testují přímo jednotlivé bity ve stavovém registru procesoru
  jz / je <target>          ; if equal = 1
  jnz / jne <target>        ; if equal = 0
  js <target>               ; if sign = 1
  jns <target>              ; if sign = 0
  jc <target>               ; if carry = 1
  jnc <target>              ; if carry = 0
  jo <target>               ; if overflow = 1
  jno <target>              ; if overflow = 0
  ; tyto řeší porovnavání čísel
  ja / jnbe <target>        ; if below = 0 && equal = 0
  jb / jnae / jc <target>   ; if below = 1 && equal = 0
  jae / jnb / jnc <target>  ; if below = 0 && equal = 1 
  jbe / jna <target>        ; if below = 1 && equal = 1
  jg / jnle <target>        ; if less = 0 && equal = 0
  jl / jnge <target>        ; if less = 1 && equal = 0
  jge / jnl <target>        ; if less = 0 && equal = 1
  jle / jng <target>        ; if less = 1 && equal = 1
  ```
- skoky nepodmíněné, ```asm jmp, call, ret```, se vykonají vždy - _IP_ skočí na cílovou _(target)_ adresu
- skoky podmíněné se vykonají pouze, tehdy když jsou nastaveny správné flagy
  - podmíněným skokovým instrukcím vždy předchází operace, které _setnou_ nebo _clearnou_ flagy ve _flags_ registru, který uchovává aktuální stav procesoru
    - jakékoli aritmetické nebo logické operace ```asm sub, add, mul, and, or, xor ...```
    - nejjednodušeji instrukcí ```asm cmp <cokoli>, <cokoli>``` 
      - stejná jako instrukce ```asm sub```, ale neuloží výsledek 
      - pouze nastaví příznakové bity v registru ```asm flags```
    - instrukce ```asm test <cokoliv>, <cokoliv>``` je stejná jako instrukce ```asm and```, ale neuloží výsledek
- viz další otázka pro podrobnější vysvětlení podmínek v Assembly

#pagebreak()

= 30. Jak řešíme v Assembly x86 podmínky - co jím musí předcházet. Jaký je vztah mezi tím, co je předchází, a tou podmínkou. Kde a proč záleží na datových typech.
- viz předchozí otázka - řeší se tam skokové instrukce a komparační instrukce ```asm cmp, test```
- v Assembly řešíme podmínky instrukcemi, které nastaví příznakové bity v registru ```asm flags```, a skokovými instrukcemi
  - příznakové bity v 8-bit ```asm flags``` registru:
    - ZF _(zero flag)_ - nastaví se pokud výsledek operace je nula
    - SF _(sign flag)_ - nastaví se pokud výsledek operace je záporné číslo
    - OF _(overflow flag)_ - nastaví pokud dojde ke znamékovému přetečení _(signed overflow)_
    - CF _(carry flag)_ - nastaví se pokud dojde k neznámekovému přetečení _(unsigned overflow)_
    - PF _(parity flag)_ - nastaví se pokud výsledek má sudý počet jedniček (např. `0110 1001`)
    - AF _(auxiliary carry flag)_ - nastaví se pokud dojde ke `carry out` ve spodním `nibble`
    - DF _(direction flag)_ - řídí směr `string` operací
    - IF _(interrupt flag)_ - řídí povolení a zakázání přerušení
    
  - instrukce, které nastaví příznakové bity:
    - logické operace - ```asm and <d>, <s>|or <d>, <s>|xor <d>, <s>|not <r>```
    - aritmetické operace - ```asm add <d>, <s>|sub <d>, <s>|inc <r>|dec <r>|mul <r>|div <r>```
    - komparační a testovací operace - ```asm cmp <d>, <s>|test <d>, <s>```
    - řídící operace - ```asm clc ; clear carry```, ```asm stc ; set carry``` - obdobně pro všechny příznak. bity
    - řetězcové operace - ```asm movs, cmps, lods, stos```
  - skokové instrukce: (viz minulá otázka bruv)
- na datových typech záleží v Assembly při všem - programátor je zodpovědný za vše a to i za správné určení datových typů
  - Assembly neřeší co nějaká sekvence bitů v paměti znaměná/reprezentuje - ```c int, float, long, struct {int, float}, char```
  - je mu to jedno - jsou to jenom bity v paměti bez žádného významu
  - programátor jím dává význam - sami o sobě jen jsou jen "jedničky" a "nuly"
- syntakticky hledí Assembly na datové typy zadané programátorem u instrukcí s $d$ a $s$ parametry: 
  ```asm INTRUCTION_NAME <d>, <s>     ; d = destination, s = source``` 
  - myšleno jako `destination` a `source` parametry - jsou jimi např.:
    - přesuny - ```asm mov dest src    ; velikost dest a src musí být stejná```
    - násobení a dělení - ```asm div reg    ; registry musí být stejné velikosti (rax / rcx)```
    - komparace - ```asm cmp dest src   ; musí být stejné velikosti```
- datové typy specifikují pouze velikost vyhrazené paměti
  - žádné info o tom zda je to ```c int, char, char[], float```
    - ```asm db / byte    ; 1 byte, 8 bitů```
    - ```asm dw / word    ; 2 byty, 16 bitů```
    - ```asm dd / dword   ; 4 byty, 32 bitů```
    - ```asm dq / qword   ; 8 bytů, 64 bitů```
  - zkrácené se používají při deklaraci proměnných v ```asm section .data```
  - plné názvy se používají pro určení velikosti operandu v ```asm section .text```
  ```asm
  section .data
    some_var: db "Hello, World!", 0x00    ; some_var = "Hello, World!" + "\0"
  
  section .text
    mov eax, dword [rdx + rcx * 4]       ; do eax se vloží dword toho co je na adrese
  ```

//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

#set page(numbering: "1 / 1", header: align(right)[CUDA])

#align(center, text(24pt)[*CUDA*])


= Otázky
31. Princip programování CUDA - jak, kde, kdy se přesouvají data při výpočtu.
+ Jaké je C/C++ rozšíření CUDA a jak to využije programátor. Jak si programátor organizuje výpočet. K čemu je mřížka. Nákres dobrovolný.
+ Čemu by se měl programátor vyhnout a jak CUDA funguje.

== Grafické karty (Nvidia) a CUDA
- CUDA je málé rozšíření jazyka C/C++ (také Python, Fortran)
  - programové rozhraní umožňujicí využití _GPU_ vypočetní síly
- umožňuje využití výpočetní síly grafické karty:
  - masivní paralelismus - stovky tisíc vláken vykonávají stejný kód 
  - všechna vlákna musí být na sobě nezávislé 
    - _GPU_ nezaručuje synchronní pořadí vykonání instrukcí
  - grafické karty jsou navrženy tak, aby maximalizovali výpočetní výkon
    - nejlépe by se mělo cyklům a podmíněným skokům zcela vyhnout 
  - nepodporuje _"out-of-order"_ vykonávání instrukcí jako _CPU_-čka od Intelu
  - je optimalizováno pro sekvenční přístup do globální (hlavní / _"Device"_) paměti grafické karty
    - přenosová rychlost až stovky GB/sekunda
  - většina tranzistorů na kartě je výpočetních (je zde minimum řídicích a pomocných obvodů)


#figure(
  image("cuda/image1.png", width: 50%),
  caption: [Pohled na GPU architekturu z _"high level"_]
)
  - na obrázku: 
    - grafikcé karty jsou rozdělené do _multiprocesorů_
      - je to "pole" procesorů, které pracují spolu - vykonávají stejné instrukce na jiných datech _(SIMD)_
      - každý _multiprocesor_ může vykonávat jiný kód _(MIMD)_
    - každá grafická karta obsahuje různý počet _multiprocesorů_ 
    - _Device Memory_ je paměť sdílená všemi _multiprocesory_
      - skládá se z _Global Memory_, _Texture Memory_ a _Constant Memory_
    - každý multiprocesor obsahuje svůj _Shared Memory_, jednotlivé procesory a vyrovnávací paměti
      - _Shared Memory_ je sdílená paměť mezi všemi procesory v jednom multiprocesoru
      - každý procesor má navíc své vlastní registry
      - každy multiprocesor má  vyrovnávací paměti _(Cache Memory)_ pro rychlejší přístup k datům v globální _Device_ paměti 
        - _Constant Cache_ je pro rychlý přístup k datům v _Constant Memory_
        - _Texture Cache_ je pro rychlý přístup k datům v _Texture Memory_
      

#figure(
    grid(columns:(auto,auto),rows:(auto,auto),gutter:1em,[ #image("cuda/image2.png", width: 110%) ],[ #image("cuda/image3.png", width: 100%) ],),caption: "Fermi architektura schéma v GPU a jeho zjednodušené schéma"
)

#figure(
  image("cuda/image4.png", width: 80%),
  caption: [Organizace paměti - grafická karta _("Device")_ v počítači]
)

- _"Device"_ je grafické karta a skládá se z:
  - _DRAM_ paměti _(Globální paměť grafikcé karty_ neboli _"Device Memory")_ 
  - _GPU_ multiprocesorů
- _"Host"_ je jakýkoli počítač s nainstalovanou grafickou kartou
- paměti od _"Host"_ a _"Device"_ jsou propojeny pouze sběrnicí - nejsou sdíléné

#pagebreak()


#figure(
  image("cuda/image5.png", width: 60%),
  caption: [Unifikované paměť u moderních GPU architektur]
)

- některé počítače mají společnou sdílenou paměť mezi _CPU_ a _GPU_

= 31. Princip programování CUDA - jak, kde, kdy se přesouvají data při výpočtu.

#figure(
  image("cuda/image6.png", width: 65%),
  caption: [Výpočetní proces na grafické kartě]
)

- výpočetní proces s _CUDA_ se skláda z několika kroků:
  1. data se z hlavní operační paměti počítače ("Host Memory") přesunou do paměti grafické karty ("Device Memory")
    - nakopírují se data z _"ramky"_ do globální paměti grafické karty
    - data jsou přenášena přes sběrnici počítače - dnes obvykle přes _PCIe_ (_Peripheral Component Interconnent Express_ - standard pro vysokorychlostní seriové sběrnice)
  2. procesor _CPU_ dá pokyn ke zpracování 
    - naorganizuje vlákna (konfiguruje mřížku) a poskytne kód (instrukce), který se má spustit
  3. vlákna (procesory) v _GPU_ multiproceserech vykonají poskytnutý kód (instrukce)
    - paralelně se spustí všechna nakonfigurovaná vlákna, která vykonají stejný kód (instrukce) na jiných datech - _SIMD (Single Instruction Multiple Data)_
  4. přesunutí výsledných zpracovaných dat z globální paměti grafické karty ("Device Memory") zpět do hlavní paměti ("Host Memory")

#pagebreak()

= 32. Jaké je C/C++ rozšíření CUDA a jak to využije programátor. Jak si programátor organizuje výpočet. K čemu je mřížka. Nákres dobrovolný.
- CUDA přínáší rozšíření jazyka C/C++, které umožňuje využít výpočetní výkon grafických karet vyráběných společností Nvidia
- jsou jimi _kernely_, modifikátory funkcí a proměnných, datové typy a struktury, předdefinované globální proměnné, API funkce s předponou `cuda`
  - _kernel_ je funkce napsaná pro spuštění v jednotlivých jádrech grafické karty:
    - klasicky napíšeme funkci v C++ a označíme ji modifikátorem ```c __global__``` (před/nad signatúru funkce)
    - voláme je z _CPU_-čka ("Host") následujicí syntakcí: 
      
    ```c functionName<<<gridDimensions, blockDimensions>>>(parameters...) ```

    - do trojtých _"chevrons"_ ```<<< >>>``` zadáváme konfiguraci mřížky a to:
      - velikost (dimenze) mřížky - jejím datovým typ je ```c dim3```
      - velikost (dimenze) bloků v mřížce - jejím datovým typ je také ```c dim3```
      - mřížka je od toho aby se _GPU_-čku při spuštění _kernelu_ nařídilo, jaký májí data _"tvar"_
        - _RGBA_ obrázek o velikosti `1200x800` nakonfigurujeme do mřížky `1200x800x4`, kde čísla jsou odpovídají počtům vláken na danou dimenzi
          - při spuštění se ještě musí hledět na to, jak tyto vlákna přerozdělíme do bloků stejných rozměrů, tak aby se vešel každý pixel obrázku do finální mřížky 
        - mřížka může dále představovat tvar tenzorů, matic, vektorů apod.
  - modifikátory funkcí - píšeme před signatúrou funkcí:
    - ```c __host__``` - značí, že tuto funkci může spustit/zavolat pouze _CPU_-čko ("Host")  
    - ```c __device__``` - značí, že tuto funkci může spustit/zavolat pouze _GPU_-čko ("Device") 
    - ```c __global__``` - modifikátor pro tzv. _kernely_ - funkce spouštějicí se na _GPU_ multiprocesorech ("Device") a jsou zavolány _CPU_-čkem ("Host")
  - modifikátory proměnných - píšeme před datovým typem proměnné:
    - ```c __device__``` - deklaruje proměnnou, která bude sídlit v "Device" paměti po celou dobu běhu programu
    - ```c __constant__``` - stejný jako `__device__` ale není možné ji přepsat - je _"read-only"_
    - ```c __shared__``` - proměnná sídlí v "Shared Memory" jednoho bloku - je přístupná pouze pro vlákna v tomto bloku, nikým jiným 
    - `__managed__` - je přístupná jak z "Host" tak i z "Device" a je spravována tzv. "Unified Memory" systémem - CUDA spravuje přesun dat automaticky
  - datové typy a struktury:
    - všechny běžné datová typy v C/C++:
    ```cpp 
    char,  uchar    // typedef unsigned char uchar 
    int,   uint     // typedef unsigned int uint
    short, ushort   // typedef unsigned short ushort
    long,  ulong    // typedef unsigned long ulong
    float, double
    ```
    - používají se struktury se stejnými jmény jako datové typy s číselnou příponou (1 až 4)
      - značí kolik je tohoto datového typu vně struktury - přistupuje se k nim pomocí přístupových operátoru (```c . ->```) a jmén položek ```c .x, .y, .z, .w``` (klasická C syntaxe)
      - ```cpp int3, uchar3, float3, uint3, ..., dim3 = uint3```
    ```cpp
    int3 some_variable(12, 34, 56); // int3 some_variable = { .x=12, .y=34, .z=56 };
    some_variable.x = 61;           // int3 some_variable = { .x=61, .y=34, .z=56 };
    ```

    - `dim3` je datovým typem mřížky a bloku zadávané do trojtých _"chevrons"_ při volání _kernelu_
    - `cudaError_t` je datový typ pro udržení _error code_ (návratové hodnoty CUDA API funkcí) 
      - je důležitý při ladění kódu -- lze ho předat do `cudaGetErrorString(...)` funkce, která vrátí zprávu o tom, kde nastala chyba (co se stalo) 
  - předdefinované globální proměnné:
    - slouží k zjištění přesného _ID_ (polohy, adresy) každého vlákna ve spuštěném _kernelu_
    - ```c dim3 gridDim``` - udává dimenze trojrozměrné mřížky
    - ```c dim3 blockDim``` - udává jak velký je blok v mřížce, opět je trojrozměrný
    - ```c uint3 blockIdx``` - udává pozici bloku v mřížce, ve kterém se vlákno zrovna nachází  
    - ```c uint3 threadIdx``` - udává třídimenzionální pozici vlákna v bloku, ve kterém se nachází 
    - ```c int warpSize``` - záleží na architekruře grafické karty, udává kolik je vláken na jednom "Warp"
      - není pro výpočet důležitý - je užitečný pro optimalizaci výpočtu pro určité architektrury grafických karet
    - různé flagy/makra zadávané do `cuda` funkcí jako: ```c cudaMemcpyHostToDevice, cudaMemcpyDeviceToHost, cudaMemcpyDeviceToDevice, ...``` 

  #figure(
    caption: [Způsob adresování jednotlivých vláken ve dvou-dimenzionální mřížce],
    image("cuda/image7.png", width: 60%)
  )  
  ```cpp
  uint3 pos = { 
      blockIdx.x * blockDim.x + threadIdx.x,
      blockIdx.y * blockDim.y + threadIdx.y,
      blockIdx.z * blockDim.z + threadIdx.z
  }; // uint3 pos ... představuje přesnou pozici jednoho vlákna v celé mřížce
  ```

  - API funkce s předponou `cuda`: (je jich stovky, tady jen pár z nich)
  ```cpp
  cudaError_t cudaDeviceReset(void);
  cudaError_t cudaDeviceSynchronize(void);
  cudaError_t cudaGetLastError(void);
  const char* cudaGetErrorString(cudaError_t error);
  cudaError_t cudaMalloc(void** devPtr, size_t size);
  cudaError_t cudaMallocManaged(void** devPtr, size_t size, unsigned int flags);
  cudaError_t cudaFree(void* devPtr);
  cudaError_t cudaMemcpy(void* dst, const void* src, size_t count, cudaMemcpyKind k);
  ```

#pagebreak()

= 33. Čemu by se měl programátor vyhnout a jak CUDA funguje.
- fungování CUDA je popsáno v předchozích otázkách
- měl by se minimalizovat přesun dat mezi _"Host"_ a _"Device"_ paměťmi
  - přes API funkci ```c cudaMemcpy(...)```, ideálně přesouvat data jen dvakrát - před výpočtem a po dokončení výpočtu
- používat _GPU_ pouze pro výpočetně náročné úlohy: 
  - image-processing (grafické editory)
  - signal-processing (DAW - Digital Audio Workspace)
  - v odvětví Machine-Learning - maticové a tenzorové operace 
  - ale ne všechny úlohy jsou vhodné počítat přes grafickou kartu
- pro intensivní přesuny mezi paměťmi využít _"pipelining"_ a _"prefetching"_
  - přes API volání funkce ```c cudaMemPrefetchAsync(...)``` - asynchronně začne přesun dat za současného běhu hlavního programu
- data by se měla zorganizovat tak, aby se k nim mohlo přistupovat sekvenčně/sériově
  - _GPU_ multiprocesory jsou optimalizováný na sekvenční přístup do svých _"Shared Memory"_
  - např. při násobení matic $A dot B = C$ bychom měli matici $B$ před výpočtem transponovat
- zredukovat co nejvíce počet _"divergentních"_ vláken
  - nejlépe, aby všechny vlákna vykonávali stejný sekvenční kód
- optimálně nakonfigurovat velikost mřížky (Grid) a bloků (Block) v mřížce
  - pomáhá znalost architektury pracující grafické karty

//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*

#set page(numbering: "1 / 1", header: align(right)[Paralelní systémy])
#align(center, text(24pt)[*Paralelní systémy*])

= Otázky
34. Charakterizujte Flynnovu taxonomii paralelních systémů.
+ Charakterizujte komunikační modely paralelních systémů.
+ Vysvětlit Amdahlův zákon a jak bychom se podle něj rozhodovali.

= 34. Charakterizujte Flynnovu taxonomii paralelních systémů.
#figure(
  caption: [Flynnova taxonomie paralelních systémů],
  image("par_sys/image1.png", width: 60%)
)
- *SISD architektury* _(Single-Instruction Single-Data)_
  - na jednu instrukci připadají jedny data
  - jde o typické jednoprocesorové architektury
    - mohou sice zpracovávat více instrukcí zároveň pomocí _"pipelining"_
    - to však neznamená, že provádí kód paralelně
    - jen zpracovávají několik instrukcí zároveň pomocí sekvenčního obvodu
- *SIMD architektury* _(Single-Instruction Multiple-Data)_
  - na jednu instrukci připadá více dat
  - příkladem mohou být různé vektorové a maticové operace
    - násobení vektorů a matic, sčítání vektorů a matic, konvoluce matic, ...
  - tyto architektury mají jednu řídicí jednotku a několik výpočetních jednotek
    - výpočetní jednotky v jednu danou chvíli provádí stejnou instrukci na jiných datech
  - jde tedy hlavně o vektorové procesory (specializované pro operace na vektorech) a procesorová pole (matice _elementárních_ procesorů - PE - Processing Element)
  - jsou jimi např.:
    - procesory s rozšířenou instrukční sadou
      - MMX - _Multi-Media Extension_
      - SSE - _Streaming SIMD Extension_
      - 3DNow! 
      - AVX - _Advanced Vector Extension_
      - AMX - _Advanced Matrix Extension_
      - VNNI - _Virtual Neural Network Instructions_
    - jednotlivé multiprocesory v grafických kartách
    
#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("par_sys/image6.png", width: 100%) ],
        [ #image("par_sys/image7.png", width: 100%) ],
    ),
    caption: [_SIMD_ architektura a _MISD_ architektura]
)

- *MISD architektury* _(Multiple-Instruction Single-Data)_
  - jedny data jsou postupně zpracovány více instrukcemi
  - typickým zástupcem jsou systolická pole
    - je to homogenní síť úzce spojených _DPU_-ček _("Data Processing Units")_ neboli uzlů
    - z latinského _systola_ - kontrakce srdce - krev jako data, kontrakce jako více instrukcí
  - použítí:
    - obvody implementující třídicí algoritmy, Hornerovo schéma pro vyčíslení polynomu, násobení matic Cannonovym algoritmem apod.

- *MIMD architektury* _(Multiple-Instruction Multiple-Data)_
  - systémy schopné provádět různé instrukce nad různými daty
  - typickými zástupcemi jsou multiprocesory (na GPU) a multipočítače
    - samostatné jednotky propojené komunikační sítí
  - v praxi se nepíše kód pro každý procesor zvlášť
    - všude běží stejný kód - podle ID procesu se zpracovávají různé větve kódu
    - mluví se spíš o SPMD _(Single-Program Multiple-Data)_
  - všechny významné paralelní architektury dnes spadají do MIMD kategorie

#figure(caption: [_MIMD_ architektura], image("par_sys/image8.png", width: 70%))

#pagebreak()

= 35. Charakterizujte komunikační modely paralelních systémů.

#figure(
  caption: [Klasifikace komunikačních modelů paralelních systémů],
  image("par_sys/image2.png", width: 70%)
)

*Architektury se sdílenou pamětí* _(ANO Sdílený adresový prostor, NE Distribuovaná paměť)_
- obsahují fyzicky sdílenou paměť (společná paměť i virtualní adresový prostor)
  - všechny procesory, výpočetní jednotky, do ní mají stejně rychlý přístup
  - jde o UMA _(Unified Memory Access)_ architektury
    - stejná adresa na různých procesorech odkazuje na stejnou paměťovou buňku ve fyzické paměti
  - je prostředkem komunikace mezi procesory
    - tvoří úzké místo _(bottleneck)_ - omezuje se počet procesorů (do 100)
- jednotlivé procesory mají také svou lokální paměť _Cache_
  - mnohem rychlejší - není přístupná jiným procesorům - to už není _UMA_ ale _NUMA (Non-UMA)_
- typický příklad je SMP _(Symmetric Multiprocessing)_ 
  - grafické karty mívají několik multiprocesorů, každý se svou "Shared Memory" (viz CUDA)
- standardem pro vývoj je _OpenMP (Open Multi-Processing)_ API pro C, C++ a Fortran

*Architektury s distribuovanou pamětí* _(NE Sdílený adresový prostor, ANO Distribuovaná paměť)_
- nemají společnou paměť ani virtuální adresový prostor
  - adresa do paměti v procesorech neodkazuje na stejnou fyzickou paměťovou buňku
  - procesory komunikují spolu zasíláním zpráv přes komunikační síť
    - náročnější z pohledu programátora
- odstranění společné paměti umožňuje vytvářet systémy s tisíci procesory
- standardem pro vývoj je _MPI (Message Passing Interface)_ API

*Architektury se sdíleně-distribuovanou pamětí* _(ANO Sdílený adresový prostor, ANO Distribuovaná paměť)_
  - jde o architektury s distribuovanou pamětí s podporou sdíleného adresového prostoru
  - jde o NUMA _(Non-Unified Memory Access)_
  
#pagebreak()

*Porovnání systému se sdíleným a nesdíleným adresovým prostorem*
  - programování postavené na principu zasílání zpráv je náročnější
  - posílání zpráv lze emulovat na systémech se sdílenou pamětí
    - programy napsané se standardem _MPI_ (Arch. s dist. pam.) běží na SMP (Arch. se sdíl. pam.)
    - programy napsané stadardem _OpenMP_ (Arch. se sdíl. pam.) neběží na systémech s dist. pamětí 

*SMP (Symmetric Multiprocessing)* - multiprocesory se sdílenou pamětí
- stovky procesoru se skrytou pamětí (Cache paměti)
- mají jednu centrální sdílenou paměť - může mít několik bank
  - je nutná sychronizace přístupu do této paměti
  - škálovatelnost je limitována propustnosti paměťového rozhraní (Memory Interface)
- propojavací síťě:
#set enum(numbering: "a)")
  + centrální sběrnice _(bus based)_ - desítky okolo jedné sběrnice
  + křížový _(crossbar)_ přepínač - přepínání procesorů mezi více bank paměti
  + nepřímá vícestupňová síť _(multistage interconnection network)_ - levnější a chudší _crossbar_

#figure(
  caption: [Projovací síťě u _SMP_ architektur],
  image("par_sys/image5.png", width: 80%)
)
*DMP (Distributed Multiprocessing)* - multiprocesory s distribuovanou pamětí
- výkonné samostatné počítače s lokalními pamětmi
  - mají-li sdílenou paměť $->$ mohou být také SMP
- všechny procesory mohou současně přistupovat navzájem do svých lokálních pamětí
- škalovatelnost je mnohem vyšší než u SMP
- projovací síťě:
#set enum(numbering: "a)")
  + 2D mřížka _(matrix based)_
  + křížový přepínač _(crossbar)_
  + nepřímá vícestupňová síť _(multistage interconnection network)_
  + přímá síť _(mesh)_

#figure(
  caption: [Propojovací sítě u _DMP_ architektur],
  image("par_sys/image4.png", width: 120%)
)
#figure(
  caption: [Různé typy projovacíh síťí],
  image("par_sys/image3.png", width: 55%)
)
  
= 36. Vysvětlit Amdahlův zákon a jak bychom se podle něj rozhodovali.
- u paralelizace je problém růstu výkonnosti jako celku
  - navýšením výpočetní síly, by měl (v ideálním světě) růst výkon o stejný faktor   
  - objevují se zde však ztráty výkonu:
    - při komunikaci - pomalé sběrnice, nutná koordinace (jeden po druhém) apod.
    - kvůli nerovnoměrné či neoptimální vytížení procesorů - některé procesory pracují naplno, jiné jen se jen částečné zapojí do zpracování úlohy
    - kvůli neznalosti vhodných algoritmů - vyberem neoptimální řešení pro řešení problému
- zrychlení jsou trojího typu:
#set enum(numbering: "1.")
  + zpomalení - velmi často se systém zpomalí
  + lineární - ideální růst výkonu
  + superlineární - nad-lineární růst výkonu (vzácně)
- čistě paralelních úloh je velmi málo:
  - ve většině případů je kombinováno se sériovým zpracováním - program není paralelně zpracován po celou dobu jeho běhu, většina segmentů je zpracována sériově 
  - paralelizace je proto jenom částečná
- zrychlení výkonu lze odvodit z Amdahlova zákonu:
  $ S_z = 1/( (1 - f_p) + f_p/N) #text(" nebo   ") S_z = t/( t f_s + t f_p/N ) #text[kde platí] f_s + f_p = 1 $
  $ 
  S_z &display(" součinitel zrychlení - poměr doby výpočtu na jednom procesoru k době při částečné paralelizaci") \ 
  f_s &display(" je podílem sériové délky při výpočtu (běhu programu)") \
  f_p &display(" je podílem paralelní délky při výpočtu (běhu programu)") \
  t &display(" je celková doba sériového výpočtu (běhu programu)") \
  N &display(" je počet použitých procesorů při paralelním výpočtu (běhu programu)") \
  $

//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*
//////////////////////////////////////////////////////////////////////////////////////////*



