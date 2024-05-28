#set text(lang: "cs")
#set page(
  numbering: "1 / 1",
  header: align(right)[
    Disky
  ],
)

#align(center, text(24pt)[
  *Disky*
])

= Otázky:
6. Fyzikální popis HDD čtení, zápis a nákres. Vysvětlit podélný a kolmý zápis.
+ Popište a nakreslete stavbu disku. Nechtěl zápis.
+ Čtení CD - princip a obrázek.

= 6. Fyzikální popis HDD - čtení, zápis a nákres. Vysvětlit podélný a kolmý zápis.
Médium HDD (Hard Disk Drive), na kterém se data ukádají, je feromagnetická vrstva nanesena na plotnu disku (většinou sklo nebo slitina hliníku).
- pracuje s magnet. záznamem
- feromagnetická vrstva dokáže uchovat magnetická pole
- záznamová/zapisovací hlava - jádro s navlečenou cívkou 
- vrstva feromagneticka je trvale zmagnetována záznamovou hlavou
- v bodu dotyku hlav (zapisovací a čtecí) nebo v nepatrné vzdálenosti je štěrbina (1μm)
== Zápis na disk  
  - při průchodu el. proudu proudí magnet. tok jádrem 
  - jádro v části, kde je nejblíže záznamové vrstvě přerušeno úzkou štěrbinou vyplněnou nemagnetickou látkou (nejčastěji bronz) nebo ničím (vzduchem)
  - v místě štěrbiny dochází k mag. stínění jádra a následnému vychýlení indukčních čar z jádra cívky do feromagnetické vrstvy disku
  - měněním směru el. proudu v cívce se mění směr magnet. toku jádrem i štěrbinou a tím smysl magnetizace aktivní vrstvy
== Čtení z disku
  - na aktiv. vrstvě jsou místa magnetizované tím či oním směrem - mezi nimi jsou místa magnet. přechodu - _"magnetiké rezervace"_
  - právě ony představují zapsanou informaci
  - při čtení se disk pohybuje stejným směrem konst. rychlostí
  - změny mag. pole na feromag. vrstvě způsobují napěťové impulsy na svorkách cívky čtecí hlavy
  - impulsy jsou zesíleny el. zesilovači

#figure(
  caption: "Princip magnetického zápisu na feromagnetickou vrstvu disku",
  image("image1.png", width: 80%)
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

= 7. Popište a nakreslete stavbu pevného disku. Nechtěl podélý a kolmý zápis.
- uzavřená jednotka v počítači používaná pro trvalé ukládání dat (nevolatilní)
- pouzdro chrání disk před nečistotami a poškozením
- obsahuje nevýjmutelné pevné plotny diskového tvaru (slitiny hliníku/sklo) - termín pevný disk
  
- části pevného disku:
  - plotny disku
  - hlavy pro čtení a zápis
  - pohon hlav
  - vzduchové filtry
  - pohon ploten disku
  - řídící deska (deska s elektronikou)
  - kabely a konektory
  
== Geometrie disku
- uspořádání prostoru na disku - počet hlav, cylindrů a stop
- data jsou na disk ukládána v bytech
- byty jsou uspořádány do skupin po 512 (nové 4KiB) zvané sektory
- sektor je nejmenší jednotka dat, kterou lze na disk zapsat nebo z disku přečíst
- sektory jsou seskupeny do stop 
- stopy jsou uspořádány do skupin zvaných cylindry nebo válce
- předpokladem je, že jeden disk má nejméně dva povrchy
- systém adresuje sektory na pevném disku pomocí prostorové matice cylindrů, hlav a sektorů

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("image2.png", width: 120%) ],
        [ #image("image3.png", width: 130%) ],
    ),
    caption: "Geometrie pevného disku a popis plotna"
)
=== Stopy 
- každá strana každé plotny je rozdělena na soustředné stopy (kružnice)
- protože povrchů i hlav je několik, je při jedné poloze hlav přístupná na každém povrchu jedna stopa, stačí elektronicky přepínat hlavy

=== Cylindry
- pevné disky mají více ploten (disků), umístěných nad sebou, otáčejících se stejnou rychlostí
- každá plotna má dvě strany (povrchy), na které je možno data ukládat
- diskové hlavy nemohou být vystavovány nezávisle (pohybovány společným mechanismem)
- souhrn stop v jedné poloze hlav se nazývá cylindr (válec)
- počet stop na jednom povrchu je totožný s počtem cylindrů
- z tohoto důvodu většina výrobců neuvádí počet stop, ale počet cylindrů

=== Sektory 
- jedna stopa příliš velkou jednotku pro ukládání dat (100kB či více bytů dat)
  - stopa rozděluje na několik očíslovaných částí nazývané sektory
- můžeme si je představit jako výseče na plotně
- nejmenší adresovatelná jednotka na disku
- její velikost určí řadič při formátování disku
- na rozdíl od hlav nebo cylindrů, číslujeme od jedničky
- na začátku sektoru je hlavička, identifikující začátek sektoru a obsahující jeho číslo
- konec - tzv. zakončení sektoru 
  - pro ukládání kontrolního součtu - slouží ke kontrole integrity uložených dat
- jednotlivé sektory se oddělují mezisektorovými mezerami (není možné uložit data)
- proces čtení sektoru se skládá ze dvou kroků
  - čtecí a zápisová hlava musí přemístit nad požadovanou stopu
  - potom se čeká, až se disk natočí tak, že požadovaný sektor je pod hlavou, a pak probíhá čtení
- přemístění hlavy obvykle zabere nejvíce času
- nejrychleji se tedy čtou soubory, jejichž sektory jsou všechny na stejné stopě a stopy jsou umístěny nad sebou v jednom cylindru

= 8. Čtení CD - princip a obrázek.
- čtení zaznamenaných dat probíhá způsobem, kdy laser v přehrávači CD snímá z povrchu disku zaznamenaný vzor
- laser je umístěn rovnoběžně s povrchem disku
- paprsek je na disk odrážen zrcadlem přes dvě čočky
  - lze velmi úzce zaostřit na malé plochy disku CD-ROM
- fotodetektor pak měří intenzitu odraženého světla
- laser nemůže poškodit nosič a na něm uložená data
- při čtení se paprsek odráží od lesklého povrchu disku CD-ROM a nijak ho nepoškodí
- mechanismus laseru je od disku asi jeden milimetr

#figure(
  caption: "CD mechanika - princip zápisu a čtení",
  image("image4.png", width: 50%)
)

- čtení dat z CD média probíhá za pomocí laserové diody
  - emituje infračervený laserový paprsek směrem k pohyblivému zrcátku
  - na čtenou stopu přesune servomotor zrcátko na základě příkazů z mikroprocesoru
  - po dopadu paprsku na jamky a pevniny, resp. pity a pole, se světlo láme a odráží zpátky
  - dále je zaostřováno čočkou, nacházející se pod médiem
  - od čočky světlo prochází pohyblivým zrcátkem (reflexní)
  - odražené světlo dopadá na fotocitlivý senzor
    - převádí světelné impulsy na elektrické
    - samotné elektrické impulsy jsou dekódovány mikroprocesorem a předány do počítače ve formě dat
  