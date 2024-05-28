#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Komuinikace
  ],
)

#align(center, text(24pt)[
  *Komunikace*
])

= Otázky
25. Komunikace se semafory a bez semaforů (indikátoru). Nakresli aspoň jedním směrem.
+ Přenos dat použitím V/V brány s bufferem. Nakreslit obrázek komunikace jedním směrem a jak se liší komunikace druhým směrem. V jakých periferiích se používá.
+ Popiš DMA blok a nakresli schéma DMA řadič v architekuře dle von~Neumanna.


== Technika _I/O_ brán
- _I/O gate_ (vstupně-vystupní brány) 
  - obvod zprostředkovávajicí předávání dat mezi sběrnicí počítače a perifériemi 
  - základem je _latch register_ (záchytný registr) s _tří-stavovým výstupem_ (three-state, tří-stavový budič sběrnice)
  - možnost použít brány s pamětí _(buffer)_
    - ten je potřebný při obostranném korespondenčním režimu

= 25. Komunikace se semafory a bez semaforů (indikátoru). Nakresli aspoň jedním směrem.
== Technika nepodmíněný vstup a výstup _(bez semaforu/indikátoru)_
#figure(image("image1.png", width: 60%), caption: [Technika nepodméněného vstupu a výstupu _bufferu_])
- #underline[vstup] _(input)_ - procesor vyšle signál _RD_ (read) 
  - přikáže tím vstupnímu zařízení předat data do procesoru
  - nijak se nekotroluje jestli je periférie připravená (očekává se, že je vždy připravená)
- #underline[výstup] _(output)_ - procesor vyšle signál _WR_ (write) 
  - výstupní zařízení data z procesoru převezme
- tento způsob je velmi jednoduchý
- předpokládá neustýlou připravenost periferního zařízení
#pagebreak()
==  Technika podmíněného vstupu a výstupu _(se semaforem/indikátorem)_
#figure(
    grid(columns: (auto, auto), rows: (auto, auto), gutter: 1em,
        [ #image("image2.png", width: 100%) ],
        [ #image("image3.png", width: 100%) ],
    ),
    caption: [Technika podmíněného vstupu a výstupu bez _bufferu_]
)
- #underline[vstup] _(input)_
  - periferní zařízení připraví data na vyslání - pokud jsou data platná vyšle signál _STB (Strobe)_
  - ten nastaví indikátor _(flag)_ $Q$ na 1 - $Q = 1$
  - pokud je $Q = 1$ jsou data připravena pro předání do procesoru
  - data se přečtou procesorem vysláním signálu _RD (read)_ z procesoru - ten zároveň nastaví $Q = 0$
- #underline[výstup] _(output)_
  - procesor vyšle signál _WR (write)_ pro zápis dat do výstupního zařízení - zárověň nastaví $Q=1$
  - periferní zařízení data z procesoru převezme a vyšle signál _ACK_
    - nastaví $Q = 0$
      - dá tím procesoru najevo, že data skutečně převzalo, 
      - procesor může vyslat další data
   
- obrázky popisují #emph[jednosměrný korespondenční režim] - není zde _buffer_ uprostřed komunikace
  - vysílač dat (ať už procesor nebo periférie) je povinen si data udržovat při celém průběhu komunikaci
    - nemá _buffer_ (na obrázku jako registr), kam by je průběžně mohl zapisovat

= 26. Přenos dat použitím V/V brány s bufferem. Nakreslit obrázek komunikace jedním směrem a jak se liší komunikace druhým směrem. V jakých periferiích se používá.

- funguje na principu _input/output_ v technice bez _bufferu_ (minulá otázka) ale tentokrát ten _buffer_ má
- využíva _buffer_ (na obrázku registr) jako vyrovnávací paměť a klopný obvod _(flip-flop)_ jako semafor/indikátor
- jde o #emph[obousměrný korespondenční režim] komunikace
  - možnost vzájemného blokování _(interlock)_
  - vysílač dat a přijímač dat testují stav indikátoru $Q$
- #underline[vstup] _(input)_
  - $Q$ informuje procesoru připravenost dat ve vyrovnávací paměti _(bufferu)_
  - pro periférii informuje $Q$ 
    - zda procesor data již přečetl a je možno do _bufferu_ zaslat další data
    - nebo data jěště přečtena nebyla a nemůže zaslat další data do _bufferu_
- #underline[výstup] _(output)_ 
  - význam indikátoru $Q$ je pro procesor a periferii opačný než v _input_
  
#figure(
    grid(columns: (auto, auto), rows: (auto, auto), gutter: 1em,
        [ #image("image5.png", width: 100%) ],
        [ #image("image4.png", width: 100%) ],
    ),
    caption: [Technika korespondenčně obousměrná s _bufferem_],
)

= 27. Popiš DMA blok a nakresli schéma DMA řadič v architekuře dle von~Neumanna.

- DMA _(Direct Memory Access)_ blok / kontrolér / řadič 
  - umožňuje perifením zařízením vstupovat do hlavní paměti přímo
    - přímý přesun dat mezi hlavní pamětí a periférii s minimální účasti procesoru
      - bez _DMA_ bloku musí každý byte dat z periférie projít procesorem a až potom procesor může přistoupit do paměti
      - procesor se samotného přesunu dat neučastní - pouze nastaví/naprogramuje _DMA blok_ 
      - sběrnice musí být při přesunu uvolněna - může byt maximálně jeden _budič_ sběrnice
        - procesor přepne všechny budiče sběrnic do stavu vysoké impedance
      - _DMA_ zajistí přesun - generuje sám adresy v paměti, kam se bude zapisovat/číst
      
- v tomto bloku jsou tři registry pro styk se sběrnicí
  - _data register_ - obsahuje slovo, které má být přesunuto z periferie do paměti nebo naopak
  - _address register_ - pro uchování adresy v hlavní paměti, na kterou bude slovo zapsáno nebo čteno
  - _counter_ - počet slov, které mají být ještě přesunuty
- operace přístupu do paměti:
  1. procesor naprograuje blok DMA - nastaví se registry (counter, address)
  + blok DMA spustí periferní zařízení a čeká až bude připraveno
  + periferie oznámí DMA bloku, že je připravena - DMA blok vyšle _DMA request_
  + procesor dokončí strojovou instrukci a začne se věnovat _DMA requestu_
  + přímý přístup do paměti se vykonává synchronně s normální činnosti procesoru
    - přpíná se přístup sběrnice a paměti mezi DMA blokem a procesorem
    - DMA blok pracuje s pamětí ve fázi $Phi_1$ a procesor ve fázi $Phi_2$
  + DMA blok vyšle na adresovou sběrnici obsah svého _address registru_ a na datovou sběrnici obsah svého _data registru_
  + počka jeden paměťový cyklus $arrow$ inkrementuje _address register_, dekrementuje _counter_ (počet dlov, které mají být ještě přesunuté)
  + testuje zda _counter_ $= 0$
    - pokud ano - ukončí DMA komunikaci a předá kontrolu nad sběrnici procesoru 
    - pokud ne - proces se opakuje od 6. kroku
  
#figure(image("image6.png", width: 60%), caption: [Přenos dat bez DMA bloku vyžadující zásah procesor])

#figure(image("image7.png", width: 90%), caption: [Přenos dat s DMA blokem ve von Neumann nevyžaduje zásah procesoru])
  
