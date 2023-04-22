breite = 50;
innenRadius = 17.5;
aussenRadius = 19.5;
vorwaerts = 30;
winkel = 10;
wandDicke = 2;
traegerBreite = 41;
gelaenderOffset=10;
//lochRadius = 10;
//
$fa = 5;
$fs = 1;
haelfteVonBreite = 0.5 * breite;
breiteMitPuffer = 1.2 * breite;
haelfteVonBreiteMitPuffer = 0.5 * breiteMitPuffer;
zweimalAussenRadius = 2 * aussenRadius;
leerBreite = breite - 2 * wandDicke;
haelfteVonLeerBreite = 0.5 * leerBreite;
leerHoehe = 2 * aussenRadius - 2 * wandDicke;
haelfteVonLeerHoehe = 0.5 * leerHoehe;
gross = 4 * breite;
haelfteVonGross = 0.5 * gross;
abschlussBreite = breite / cos(winkel);
haelfteVonAbschlussBreite = 0.5 * abschlussBreite;
zweimalWandDicke = 2 * wandDicke;
viermalWandDicke = 4 * wandDicke;
leistenBreite = 0.5 *(abschlussBreite - traegerBreite);
//
module lamelle(vorwaerts = 20, breite = 10, dicke = 0.3) {
    translate([0, -0.5 * breite, 0])
        cube([vorwaerts, breite, dicke]);
}


module lamellenSchar(vorwaerts = 20, breite = 10, dicke = 0.3, anzahlSeitlich = 3, abstand = 2) {
    lamelle(vorwaerts = vorwaerts, breite = breite, dicke = dicke);
    for (i = [1:1:anzahlSeitlich]) {
        translate([0, 0, i * abstand])
            lamelle(vorwaerts = vorwaerts, breite = breite, dicke = dicke);
        translate([0, 0, -i * abstand])
            lamelle(vorwaerts = vorwaerts, breite = breite, dicke = dicke);
    }
}


rotate([180, 0, 0]) {
difference() {
    difference() {
        union() {
            // Konkave Wand zum Geländer
            rotate([90, 0, 0])
                cylinder(h=breite, r=aussenRadius, center=true);
            difference() {
                // Vorwaertsquader
                translate([0, -haelfteVonBreite, -aussenRadius])
                    cube([vorwaerts, breite, zweimalAussenRadius]);
//                // Vorwaertsquader soll innen leer sein
//                translate([0, -haelfteVonLeerBreite, -haelfteVonLeerHoehe])
//                    cube([vorwaerts, leerBreite, leerHoehe]);
            }
//            // Rohr um Bohrloch
//            rotate([0, 90, 0])
//                cylinder(h=vorwaerts, r=lochRadius+wandDicke);
//            // Hohlraum mit Dreieckslamellen füllen/
//            rotate([15, 0, 0]) {
//                lamellenSchar(vorwaerts = vorwaerts, breite = 1.2 * breite, anzahlSeitlich = 13);
//                rotate([120, 0, 0])
//                    lamellenSchar(vorwaerts = vorwaerts, breite = 1.5 * breite, anzahlSeitlich = 13);
//                rotate([240, 0, 0])
//                    lamellenSchar(vorwaerts = vorwaerts, breite = 1.3 * breite, anzahlSeitlich = 13);
//            }
        }
        // Zylinder ausschneiden fuer Gelaender
        rotate([90, 0, 0])
            cylinder(h=breiteMitPuffer, r=innenRadius, center=true);
    }
    union() {
        // Vorwaertquader schraeg abschneiden
        translate([vorwaerts, -haelfteVonBreite, -haelfteVonGross])
            rotate([0, 0, winkel])
                cube([gross, gross, gross]);
//        // Bohrung auf Gelaenderseite
//        translate([0, 0, 0])
//            rotate([0, 90, 0])
//                cylinder(h=vorwaerts, r=lochRadius);
        // Hohlzylinder auf Geländerseite aufschneiden
        translate([-breite, -haelfteVonBreiteMitPuffer, -haelfteVonBreiteMitPuffer])
            cube([breite, breiteMitPuffer, breiteMitPuffer]);
        // Ueberhang abschneiden
        translate([-breite + gelaenderOffset, -haelfteVonBreiteMitPuffer, -breiteMitPuffer])
            cube([breite, breiteMitPuffer, breiteMitPuffer]);
        // Alles mit y>haelfteVonBreite abschneiden
        translate([-0.05 * vorwaerts, haelfteVonBreite, -haelfteVonGross])
            cube([1.1 * vorwaerts, breite, gross]);
        // Alles mit y<-haelfteVonBreite abschneiden
        translate([-0.05 * vorwaerts, -gross-haelfteVonBreite, -haelfteVonGross])
            cube([1.1 * vorwaerts, gross, gross]);
        // Alles mit z>aussenRadius abschneiden
        translate([-0.05 * vorwaerts, -haelfteVonGross, aussenRadius])
            cube([1.1 * vorwaerts, gross, gross]);
        // Alles mit z<-aussenRadius abschneiden
        translate([-0.05 * vorwaerts, -haelfteVonGross, -3 * aussenRadius])
            cube([1.1 * vorwaerts, gross, zweimalAussenRadius]);
    }
}

// Abschlussplatte
translate([0.999 * vorwaerts, -haelfteVonBreite, -aussenRadius])
    rotate([0, 0, winkel])
        difference() {
            union() {
                // Eigentliche Abschlussplatte
                cube([wandDicke, abschlussBreite, zweimalAussenRadius]);
                // Leiste auf einer Seite
                translate([0.999 * wandDicke, 0, 0])
                    cube([wandDicke, leistenBreite, zweimalAussenRadius]);
                translate([0.999 * wandDicke, abschlussBreite - leistenBreite, 0])
                    cube([wandDicke, leistenBreite, zweimalAussenRadius]);

            }
//            // Loch durch Abschlussplatte
//            translate([-zweimalWandDicke, haelfteVonAbschlussBreite, aussenRadius])
//                rotate([0, 90, 0])
//                    cylinder(h=viermalWandDicke, r=lochRadius);
        }

}