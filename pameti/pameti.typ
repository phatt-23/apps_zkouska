#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[Paměti],
)

#align(center, text(24pt)[
  *Paměti*
])

= Otázky
19. Rozdělení polovodičových pamětí a jejich popis (klíčová slova a zkratky nestačí).
+ Jak funguje DRAM, nakresli. Napiš stručně historii.
+ Hierarchie paměti, popsat a zakreslit.

= 19. Rozdělení polovodičových pamětí a jejich popis (klíčová slova a zkratky nestačí).
- dělení podle typu:
  - #underline[přístupu do paměti]:
    - RAM _(Random Access Memory)_ - náhodný přístup, kamkoli odkudkoli
    - SAM _(Serial Access Memory)_ - přístup sériově, postupně (byte after byte)
    - speciální 
      - fronta - lze nahlížet na _front_ a _back_, ne do těla
      - zásobník - lze nahlížet jen na _top_ zásobníku, ne do těla
      - asociativní
  - #underline[zápis/čtení]:
    - RWM _(Read Write Memory)_ - lze číst i zapisovat 
    - ROM _(Read Only Memory)_ - lze jenom číst
    - kombinované:
      - NVRAM _(Non-Volatile RAM)_ - EEPROM _(Electrically Erasable PROM)_ a Flash paměti
      - WOM _(Write Only Memory)_ - lze jen zapisovat (nepraktické, na Linuxu `/dev/null`)
      - WORM _(Write-Once Read-Many times Memory)_ - např. CD-ROM (vypálí se jednou, nejsou přepsatelné, číst lze opakovaně)
  - #underline[elementární buňky:]
    - DRAM _(Dynamic RAM)_ - náboj v kondenzátor drží bit dat
      - postupně se vybíjí - musí se _refreshnout_, jinak se data ztratí
      - proto název dynamický
    - SRAM _(Static RAM)_ - stav klopného obvodu drží bit dat
      - dokud je zapojený proud, udržuje data
      - netřeba žádný _refresh_ - proto název statický
    - PROM - přepálené pojistky _(fuse blowing)_
      - přeplené a nepřepálené pojistky reprezentují log. 0 a log. 1 - jeden bit dat
    - EPROM _(Erasable Programmable ROM)_, EEPROM _(Electrically EPROM)_, Flash Memory
  - #underline[uchování info po odpojení napájení:]
    - _Volatile_ - neuchovají data, musí se nepřetržitě napájet, jsou rychlejší
      - hlavní operační paměti DRAM _("ramka")_ a SRAM _("cache")_
    - _Non-Volatile_ - uchovají data i po odpojení, nezávislé, jsou pomalejší
      - xxROM paměti - pro bootloadery, BIOSy atd.
      - SSD _(Solid State Drive)_, HDD _(Hard Disk Drive)_ - externí pamět

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
- kapacita $C$ je velmi malá (jednotky femtoFahrad) - časem ztrácí na napětí (proud teče do/ven z $C$)
- nutný častý _refresh_ (obřerstvení), aby si uchovala svou informaci (každých \~10 ms)
  - provede se pro celý řádek při každém čtení buňky z tohoto řádku

#figure(
    grid(columns: (auto, auto), rows: (auto, auto), gutter: 1em,
        [ #image("image1.png", width: 80%) ],
        [ #image("image2.png", width: 130%) ],
    ),
    caption: "Paměťové buňky v DRAM a Organizace paměťových buněk v DRAM"
)

- buňky jsou umístěny ve čtvercové matice (matic je vedle sebe naskládaných více)
- adresování buňky probíha v dvou krocích
  1. vybere se řádek _(ROW)_ buňky pomocí _Row Decoder_
  - aktivuje vodič (_wordline_) vedoucí z _Row Decoderu_ na daném řádku
  2. vybere se sloupec _(COL)_ buňky pomocí _Column Decoder_
  - informace uložena v této buňce (1 nebo 0) se pošle do _I/O bufferu_ přes vodič (_bitline_) vedoucí z _Column Decoderu_
- rozdělení adresování na dva dekódery (_Row_ a _Column_) znamená, že stačí poloviční počet vodičů pro adresování - např. pro $2^20$ buňek stačí $10$ vodičů - $2^10 * 2^10 = 2^20$
  - musíme ale zavést dva řídicí signály:
    - _RAS_ (Row Access Strobe) a _CAS_ (Column Access Strobe)
    - proto aby se vědělo jakému dekóderu je adresa určena
- _DRAM_ paměť je organizována tak, že se při čtení/zápisu předá více než jeden bit - to určí počet datových vodičů vedoucí do _I/O bufferu_
- #underline[princip čtení] z _DRAM_:
  - _address buffer_ příjme adresu, kterou poskytlo CPU
  - adresa je rozdělena na adresu řádku a sloupce
    - pošle se do _address buffer_ jedna po druhé - adresní _multiplexing_
    - _multiplexing_ je kontrolován _RAS_ a _CAS_ řídicími signály
    - pokud se pošle adr. řádku aktivuje se předtím _RAS_ signál
    - pokud sloupce tak _CAS_ signál
    - _address buffer_ pošle (na základě _RAS_ a _CAS_ signálu) částečnou _multiplexovanou_ adresu buď _Row Decoderu_ nebo _Column Decoderu_
    - vyšle se _READ_ řídicí signál, data adresované paměťové buňky se zesílí el. zesilovači a předají do _I/O bufferu_ - výstupní data
- #underline[princip zápisu] je obdobný čtení z _DRAM_:
  - probíha klasicky vybrání řádku a sloupce
  - vyšle se _WE_ _(Write Enable)_ řídicí signál, do _I/O bufferu_ se zapíšou data, která se mají uložit
  - data z _I/O bufferu_ se zesílí a přepíšou adresované místo
  
#pagebreak()
  

= 21. Hierarchie paměti, popsat a zakreslit do von Neumann.
- v počítači se používají různé typy paměti
  - důvody jsou ekonomické, technické a praktické
    - kdyby byl typ paměti, který je levný, nevolatilní, umožňuje náhodný přístup k datům a je rychlý, nepotřebovalo by se vytvářet tolik typů pamětí - taková technologie však zatím neexistuje
    - bere se v potaz kompromis mezi cenou, rychlotí a kapacitou

#figure(
    grid(columns: (auto, auto), rows: (auto, auto), gutter: 1em,
        [ #image("image3.png", width: 100%) ],
        [ #image("image4.png", width: 100%) ],
    ),
    caption: "Pyramida hierarchie pamětí a druhy paměti ve von Neumann",
)

- paměti uspořádaný podle ceny, rychlosti a kapacity
- každá úroveň paměti tvoří vyrovnávací _(cache)_ pamět té pod ní 
  - data z OpMem jsou částečně v LCache
  - data z SSD jsou částečně v OpMem atd.
- dělí na volatilní _(Temporary Storage Area)_ a nevolatilní _(Permanent Storage Area)_
- dělí se na čistě polovodičové a mechanické
- podle _"H"_ úrovně:
  - _H0_ - registry procesorů, odpovídá rychlostí CPU 
  - _H1_ - _Cache L1_, _SRAM_ - rychlost odpovídá vnitř. sběrnicím _CPU_, kapacita 10s až 100s kB / jádro  
  - _H2_ - _Cache L2_, _SRAM_ - rychlost odpovídá. 100s kB / jádro
  - _H3_ - _Cache L3_, _SRAM_ - 10s MB
  - _H4_ - _Cache L4_, _SRAM_ - 10s až 100s MB
  - _H5_ - hlavní _operační_ paměť, _DRAM_ - 1s až 100s GB
  - _H6_ - SSD _(Solid State Drive)_, HDD _(Hard Disk Drive)_, Flash - 100s GB až 1s TB 
  - _H7_ - disková pole _(Disk Array)_ - "naskládané" pevné disky, 10s TB až 1s PB
  - _H8_ - pásové jednotky _(Tapes)_ - #emph[velmi] pomalé, mrtě kapacity
