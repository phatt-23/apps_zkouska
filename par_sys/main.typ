#set text(lang: "cs")
#set page(numbering: "1 / 1",
  header: align(right)[Paralelní systémy],
)

#align(center, text(24pt)[
  *Paralelní systémy*
])

= Otázky
34. Charakterizujte Flynnovu taxonomii paralelních systémů.
+ Charakterizjte komunikační modely paralelních systémů.
+ Vysvětlit Amdahlův zákon a jak bychom se podle něj rozhodovali.

= 34. Charakterizujte Flynnovu taxonomii paralelních systémů.
#figure(
  caption: [Flynnova taxonomie paralelních systémů],
  image("image1.png", width: 60%)
)
- *SISD architektury* _(Single-Instruction Single-Data)_
  - na jednu instrukci připadá jedny data
  - jde o typické jednoprocesorové architektury
    - mohou sice zpracovávat více instrukcí zároveň - pipelining
    - to neznamená, že provádí kód paralelně
    - jen zpracovávají několik instrukcí zároveň pomocí sekvenčního obvodu
- *SIMD architektury* _(Single-Instruction Multiple-Data)_
  - na jednu instrukci připadá více dat
  - příkladem mohou být různá vektorové a maticové operace
    - násobení vektorů a matic, sčítání vektorů a matic, konvoluce matic, ...
  - tyto architektury mají jednu řídicí jednotku a několik výpočetních jednotek
    - výpočetní jednotky v jednu danou chvíli provádí stejnou instrukci na jiných datech
  - jde tedy hlavně o vektorové procesory:
    - procesory s rozšířenou instrukční sadou
      - MMX - Multi-Media Extension
      - SSE - _Streaming SIMD Extension_
      - 3DNow! 
      - AVX - _Advanced Vector Extension_
      - AMX - _Advanced Matrix Extension_
      - VNNI - _Virtual Neural Network Instructions_
    - grafické karty - grafické editory, úprava fotek, médii obecně, CUDA
    
#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image6.png", width: 100%) ],
        [ #image("image7.png", width: 100%) ],
    ),
    caption: [_SIMD_ architektura a _MISD_ architektura]
)

- *MISD architektury* _(Multiple-Instruction Single-Data)_
  - jedny data jsou postupně zpracovány více instrukcemi
  - typickým zástupcem jsou systolická pole
    - homogenní síť úzce spojených DPU, _"Data Processing Units"_, neboli uzlů
    - z latinského systola, znamená kontrakce srdce - krev = data, kontrakce = více instrukcí
  - použítí:
    - obvody implementující třídicí algoritmy, Hornerovo schéma pro vyčíslení polynomu, násobení matic Cannonovym algoritmem

- *MIMD architektury* _(Multiple-Instruction Multiple-Data)_
  - systémy schopní provádět různé instrukce s různými daty
  - typickými zástupcemi jsou multiprocesory (na GPU) a multipočítače
  - v praxi se nepíše kód pro každý procesor
    - všude běží stejný kód - podle ID procesu se zpracovávají různé větve
    - mluví se spíš o SPMD _(Single-Program Multiple-Data)_
  - všechny významné paralelní architektury dnes spadají do MIMD kategorie

#figure(caption: [_MIMD_ architektura], image("image8.png", width: 70%))

#pagebreak()

= 35. Charakterizjte komunikační modely paralelních systémů.

#figure(
  caption: [Klasifikace komunikačních modelů paralelních systémů],
  image("image2.png", width: 70%)
)

*Architektury se sdílenou pamětí* (_ANO Sdílený adresový prostor, NE Distribuovaná paměť_)
- obsahují fyzicky sdílenou paměť
  - všechny procesory, výpočetní jednotky, mají stejně rychlý přístup
  - jde o UMA _(Unified Memory Access)_ architektury
    - stejná adresa na různýc procesorech odkazuje na stejnou paměťovou buňku ve fyzické paměti
  - je prostředkem komunikace mezi procesory
    - tvoří úzké místo _(bottleneck)_ - omezuje se počet procesorů (do 100)
- jednotlivé procesory mají také svou lokální paměť _Cache_
  - mnohem rychlejší - není přístupná jiným procesorům - už to ale není UMA ale NUMA
- typický příklad je SMP _(Symmetric Multiprocessing)_ 
  - grafické karty mívají několik multiprocesorů, každý se svou "Shared Memory" (viz CUDA)
- standardem pro vývoj je _OpenMP_

*Architektury s distribuovanou pamětí* (_NE Sdílený adresový prostor, ANO Distribuovaná paměť_)
- nemají společnou paměť ani virtuální adresový prostor
  - adresa do paměti v různých procesorech neodkazují na stejnou fyzickou paměťovou buňku
- procesory komunikují spolu zasíláním zpráv přes komunikační síť
  - náročnější z pohledu programátora
- odstranění společné paměti umožňuje vytvářet systémy s tisíci procesory
- standardem pro vývoj je _MPI_

*Architektury se sdíleně-distribuovanou pamětí* (_ANO Sdílený adresový prostor, ANO Distribuovaná paměť_)
  - jde o architektury s distribuovanou pamětí s podporou sdíleného adresového prostoru
  - jde o NUMA _(Non-Unified Memory Access)_
  
#pagebreak()

*Porovnání systému se sdíleným a nesdíleným adresovým prostorem*
  - programování postavené na principu zasílání zpráv je náročnější
  - posílání zpráv lze emulovat na systémech se sdílenou pamětí
    - programy napsané se standardem MPI (Arch. s dist. pam.) běží na SMP (Arch. se sdíl. pam.)
    - programy napsané stadardem _OpenMP_ (Arch. se sdíl. pam.) neběží na systémech s dist. pamětí 

*SMP (Symmetric Multiprocessing)* - multiprocesory se sdílěnou pamětí
- stovky procesoru se skrytou pamětí (Cache)
- jedna cetrální sdílená paměť
  - je nutná sychronizace přístupu do této paměti
  - škálovatelnost je limitována propustnosti paměťového rozhraní (Memory Interface)
- propojavací síťě:
#set enum(numbering: "a)")
  + centrální sběrnice _(bus based)_ - desítky okolo jedné sběrnice
  + křížový _(crossbar)_ přepínač - přepínání procesorů mezi více bank paměti
  + nepřímá vícestupňová síť _(multistage interconnection network)_ - levnější a chudší _crossbar_

#figure(
  caption: [Projovací síťě u _SMP_ architektur],
  image("image5.png", width: 60%)
)
*DMP (Distributed Multiprocessing)* - multiprocesory s distribuovanou pamětí
- výkonné samostatné počítače s lokalními pamětmi
  - mají-li sdílenou paměť $->$ mohou být také SMP
- všechny procesory mohou současně přistupovat do svých lokálníhc pamětí
- škalovatelnost je mnohem vyšší než u SMP
- projovací síťě:
#set enum(numbering: "a)")
  + 2D mřížka _(matrix based)_
  + křížový přepínač _(crossbar)_
  + nepřímá vícestupňová síť _(multistage interconnection network)_
  + přímá síť _(mesh)_

#figure(
  caption: [Propojovací sítě u _DMP_ architektur],
  image("image4.png")
)
#figure(
  caption: [Různé typy projovacíh síťí],
  image("image3.png", width: 60%)
)
  
= 36. Vysvětlit Amdahlův zákon a jak bychom se podle něj rozhodovali.
- u paralelizace je problém růstu výkonnosti jako celku
  - navýšením výpočetní síly, by měl, v ideálním světě, růst výkon stejným faktorem   
  - objevují se zde však ztráty výkonu při komunikaci
    - pomalé sběrnice, nutná koordinace (jeden po druhém)
  - nerovnoměrné či neoptimální vytížení procesorů
    - některé procesory pracují naplno, jiné jen se jen někdy zapojí 
  - neznalost vhodných algoritmů - vyberem neoptimální řešení při řešení problému
- zrychlení jsou trojího typu:
#set enum(numbering: "1.")
  + zpomalení - velmi často se systém zpomalí
  + lineární - ideální růst výkonu
  + superlineární - nad-lineární růst výkonu (vzácně)
- čistě paralelních úloh je velmi málo
  - ve většině případů je kombinováno se sériovým zpracováním - program není paralelně zpracován po celou dobu běhu, většina je zpracována sériově 
- zrychlení výkonu lze odvodit z Amdahlova zákonu:
  $ S_z = 1/( (1 - f_p) + f_p/N) #text("nebo") S_z = t/( t f_s + t f_p/N ) $
  $ 
  S_z &display(" součinitel zrychlení - poměr doby výpočtu na jednom procesoru k době při částečné paralelizaci") \ 
  f_s &display(" je podílem sériové délky při výpočtu") \
  f_p &display(" je podílem paralelní délky při výpočtu") (1 = f_s + f_p) \
  t &display(" je celková doba sériového výpočtu") \
  N &display(" je počet použitých procesorů při paralelním výpočtu") \
  $
