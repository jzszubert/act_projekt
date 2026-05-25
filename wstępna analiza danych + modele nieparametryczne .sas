/* 1. Podłączenie biblioteki */

libname aids "/home/u64469512/dane";
run;


/* 2. Wczytanie oczyszczonych danych  */

data work.aids_data;
set aids.aids_cleaned;
run;


/* 3. Struktura zbioru danych */

proc contents data=work.aids_data;
title "Struktura zbioru danych";
run;


/* 4. Statystyki opisowe - zmienne liczbowe*/

proc means data=work.aids_data
n mean median std min max maxdec=2;

var age wtkg karnof preanti cd40 cd420 cd80 cd820 time;

title "Statystyki opisowe zmiennych liczbowych";
run;



/* 5. Statystyki opisowe - zmienne jakościowe*/

proc freq data=work.aids_data;

tables gender race hemo homo drugs symptom treat offtrt label;

title "Rozkład zmiennych jakościowych";
run;


/* 6. Histogram wieku*/

proc sgplot data=work.aids_data;

histogram age;
density age;

title "Rozkład wieku pacjentów";
run;


/* 7. Histogram liczby limfocytów CD4*/

proc sgplot data=work.aids_data;

histogram cd40;
density cd40;

title "Rozkład liczby limfocytów CD4";
run;


/* 8. Boxplot czasu przeżycia według płci*/

proc sgplot data=work.aids_data;

vbox time / category=gender;

title "Czas przeżycia według płci";
run;


/* 9. Liczba zdarzeń i obserwacji cenzorowanych*/

proc freq data=work.aids_data;

tables label;

title "Liczba zdarzeń i obserwacji cenzorowanych";
run;


/* 10. Kaplan-Meier dla całej próby*/

proc lifetest data=work.aids_data
plots=survival(atrisk);

time time*label(0);

title "Krzywa przeżycia Kaplan-Meier dla całej próby";
run;


/* 11. Kaplan-Meier według płci*/

proc lifetest data=work.aids_data
plots=survival(atrisk);

time time*label(0);

strata gender;

title "Krzywe przeżycia według płci";
run;


/* 12. Kaplan-Meier według hemofilii*/

proc lifetest data=work.aids_data
plots=survival(atrisk);

time time*label(0);

strata hemo;

title "Krzywe przeżycia według występowania hemofilii";
run;


/* 13. Utworzenie grup CD4*/

data aids_cd4;

set work.aids_data;

if cd40 < 200 then cd4_group = "Low CD4";
else cd4_group = "High CD4";

run;


/* 14. Kaplan-Meier według poziomu CD4*/

proc lifetest data=aids_cd4
plots=survival(atrisk);

time time*label(0);

strata cd4_group;

title "Krzywe przeżycia według poziomu CD4";
run;


/* 15. Utworzenie grup wieku */


data aids_age;

set work.aids_data;

if age < 35 then age_group = "Younger";
else age_group = "Older";

run;


/* 16. Kaplan-Meier według wieku*/


proc lifetest data=aids_age
plots=survival(atrisk);

time time*label(0);

strata age_group;

title "Krzywe przeżycia według wieku";
run;