libname aids "C:\Users\bubus\Documents\studia\analiza czasu trwania\projekt";

proc import datafile="C:\Users\bubus\Documents\studia\analiza czasu trwania\projekt\AIDS_ClinicalTrial_GroupStudy175.csv"
    out=aids.data
    dbms=csv
    replace;
    getnames=yes;
run;

/*bardzo wstêpna analiza, czy s¹ jakieœ dziwne rzeczy*/
proc print data=aids.data(obs=10);
run;

proc means data=aids.data n nmiss min max mean;
run;

