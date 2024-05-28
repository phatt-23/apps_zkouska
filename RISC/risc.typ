#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[RISC],
)

#align(center, text(24pt)[
  *RISC*
])

= Otázky
13. Popište na RISC procesoru zřetězené zpracování instrukcí, jaké má chyby a jak se řeší.
+ Popište na RISC procesoru zřetězené zpracování instrukcí a jak nám pomůže predikce skoku.
+ Jaké problémy a hazardy mohou nastat u RISC.
+ Popiš základní konstrukci a vlastnosti mikroprocesoru RISC.
+ Popiš a nakresli schéma RISC procesoru, se kterým ses seznámil.


= 13. Popište na RISC procesoru zřetězené zpracování instrukcí, jaké má chyby a jak se řeší.
- procesor je sekvenční obvod - vstup - instrukce a data z paměti, výstup - výsledky uloženy do paměti
- instrukce jsou vždy zpracovány stejným způsobem v několika fázích, např.:
  1. *VI* Výběr instrukcí z paměti (Instruction Fetch)
  + *DE* Dékódování (Instruction Decoder)
  + *VA* Výpočet adresy operandů (Operand Address Calculation) - získá se adresa operandů, se kterou instrukce pracuje 
  + *PI* Provedení instrukce (Instruction Execution)
  + *UV* Uložení výsledku zpět do paměti
- instrukce projde všemi těto fázemi - pokud by trvala každá fáze 1 stroj. cyklus, tak by se 1 instrukce vykonala za 5 stroj. cyklů
- instrukce $I_2$ se nemůže vykonat, když procesor zpracovává inst. $I_1$
- osamostatněním jednot. fází vlastními obvody - je možné instr. zřetězit
  - zatímco *VI* vybíra instrukci z paměti, může *DE* dekédovat instr., kterou před jedním stroj. cyklem vybrala *VI* z paměti
  - teoreticky se tím zvýší výkon o násobek hloubky zřetězení
    - tomuto zrychlení avšak zabraňují podmíněné skoky 
      - adresa IP se změní - rozpracované instrukce jsou neplatné - musí se _flushnout_ fronta instrukcí - *_problém plnění fronty_*
      - existují mechanismy jak tomu předcházet
        - predikce skoku (_Brach Prediction_)
          - jednobitová - v instrukci skoku je 1 bit vyhrazen pro _flag_, který předpovídá, jestli se bude či nebude skákat (přepíná se po jednom vykonání a nevykonání skoku)
          - dvoubitová - v instrukci jsou vyhrazeny 2 bity (přepína se až po dvou konsukutivních vyhodnocení skoku)
        - zpoždění skoku - pokud možno, vykonají se instruce jiné ještě před instrukcí skoku (i přesto, že jim v programu instrukce skoku předchází)
        - buffer s pamětí skoků (_Branch Target Buffer_) - pamatuje si stovky tzv. _target_ adres skoků
    - strukturální hazardy
      - pomalé sběrnice a registry mezi jednotkami jednot. fází
      - musí se koordinovat
    - datové hazardy
      - instrukce potřebuje výsledky od instrukce, která ještě nebyla vykonána
#figure(
  caption: "Sériové zpracování instrukcí - CISC",
  image("image4.png")
)
#figure(
  caption: "Rozdělení obvodu pro zpracování instrukcí na jednot. fázové jednotky",
  image("image6.png")
)
#figure(
  caption: "Zřetězené zpracování instrukcí - RISC",
  image("image5.png")
)

#pagebreak()
      
= 14. Popište na RISC procesoru zřetězené zpracování instrukcí a jak nám pomůže predikce skoku.
- viz 13. otázku - jak funguje zřetězené zpracování instrukcí
- typy řešení predikcí skoků - _jednobitová, dvoubitová, BTB_:
  - jednobitová
    - ve formátu instrukce skoku se vyhradí jeden pro uložení stavu _flagu_ predikující, zda se skok vykoná či ne
    - buď _flag_ nastaví _staticky_ programátorem/kompilátorem (_hard coded_)
    - nebo se nastavuje při běhu programu _dynamicky_ dle výsledku podmínky předchízejicí skoku
    - v cyklu k selhání predikce dojde vždy 2x - první a poslední iterace
  - dvoubitová 
    - vyhradí se dva bity - 4 možné hodnoty/stavy
    - funguje jako stavový automat se 4 stavy - NE = nebude se skákat, ANO = bude se skákat
      - 00 (ANO) - stály skákání
      - 01 (ANO) - jeden neprovedený skok
      - 10 (NE) - jeden provedený skok
      - 11 (NE) - stálý stav "neskákání"
    - přechody $a$ a $n$ ukazují jestli se naposledy skákalo či ne
    - v cyklu omezí počet selhání na jeden
    
#figure(
  caption: "Dvoubitová predikce - čtyřstavový automat",
  image("image3.png", width: 70%)
)
  - BTB (Branch Target Buffer) 
    - tabulka s uloženými adresami provedených podmíněných skoků
    - ať už jednobitová nebo dvounitová predikce
    - většinou implementována přímo na procesorech
    - může mít až tisíce položek

      
#pagebreak()

= 15. Jaké problémy a hazardy mohou nastat u RISC.
- viz předchozí otázky - popsaný datové a strukturální hazardy, problematika zpracování podmíněných skoků

= 16. Popiš základní konstrukci a vlastnosti mikroprocesoru RISC.
- malý instrukční soubor
- vývojová větev RISC vyvinula řadu zásadních kritérií, charakterizujících metodiku návrhu nejen procesoru, ale celého počítače
- procesor - přenechat jen tu činnost, která je nezbytně nutná
  - další potřebné funkce přenést do architektury počítače, programového vybavení a kompilátoru
- výsledkem návrhu jsou zejména tyto vlastnosti:
  - jedna instrukce dokončena každý stroj. cyklus
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
    - přesto se většina výrobců CISC procesorů uchýlila při výrobě procesorů k realizaci stále většího počtu vlastností arch. RISC

#pagebreak()

= 17. Popiš a nakresli schéma RISC procesoru, se kterým ses seznámil.
== ARM Cortex A77
- frekvence 3 GHz
- ARM v8-A architektura (hardvardká arch.)
- 64-bitová instrukční sada s SIMD rozšířením
- 13-ti úrovňové zřetězení
- 8 jader
- cache:
  - L1 - 2x64kB na jádrech pro instrukce a data
  - L2 - 256 nebo 512 kB - vyrovnávací pamět mezi procesorem a hlavní pamětí (RWM SDRAM)
- out-of-order vykonávaní instrukcí - reorder buffer může mít 160 položek
- výpočetní jednotky: 4x ALU, FPU, ASIMD, 2x Branch
- prediktor větvení - až 8000 položek
- macro-OP cache - až 1500 položek
  - ukládá již dekédované instrukce
  - urychluje vykonávání smyček - nemusí se vždy instrukce uvnitř cyklu dekódovat znovu
  - dokóder - 6 instrucí / cyklus
  - využití
    - modbilní zařízení s Android
    - SoC (System On Chip) - mikrokontroléry/monolity
#figure(
  caption: "Architektura ARM A77",
  image("image2.png")
)
#figure(
  caption: "Architektura ARM A77",
  image("image7.png", width: 80%)
)
#figure(
  caption: "mrtka",
  image("image1.png")
)  