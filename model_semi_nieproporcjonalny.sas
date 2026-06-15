options nofmterr;
ods graphics on;

libname dane "/workspaces/myfolder/ACT";


proc means data=dane.data_cleaned n mean median p25 p75 min max;
    var cd40;
run;

data work.acg;
    set dane.data_cleaned;
    if cd40 < 340 then cd4_grp = 1;
                  else cd4_grp = 2;
run;

proc lifetest data=work.acg method=lt plots=(s, h);
    time time*label(0);
    strata cd4_grp;
run;

data work.data_nph;
    set dane.data_cleaned;
    if cd40 < 340 then cd4_grp = 1;
                  else cd4_grp = 2;
    if time <= 750 then do;
        cd40_1 = cd40;
        cd40_2 = 0;
    end;
    else do;
        cd40_1 = 0;
        cd40_2 = cd40;
    end;
run;

proc phreg data=work.data_nph;
    class gender race hemo / ref=first;
    model time*label(0) = age gender race wtkg hemo cd40_1 cd40_2 / ties=efron;
    title 'Model nieproporcjonalnych hazardow Coxa - NPH';
run;

proc phreg data=work.data_nph;
    class gender race hemo / ref=first;
    model time*label(0) = age gender race wtkg hemo cd40_1 cd40_2
                          / ties=efron;
    output out=work.Outp xbeta=Xb resmart=Mart resdev=Dev;
run;

proc sgplot data=work.Outp;
    yaxis grid;
    refline 0 / axis=y;
    scatter y=Mart x=Xb;
    xaxis label='Predyktor liniowy';
    yaxis label='Reszty martyngalowe';
    title 'Reszty martyngalowe - model NPH';
run;

proc sgplot data=work.Outp;
    yaxis grid;
    refline 0 / axis=y;
    scatter y=Dev x=Xb;
    xaxis label='Predyktor liniowy';
    yaxis label='Reszty odchylenia';
    title 'Reszty odchylenia - model NPH';
run;

data work.outliers;
    set work.Outp;
    if Mart < -3;
run;
proc print data=work.outliers; run;

proc phreg data=work.data_nph plots=survival;
    class gender race hemo / ref=first;
    model time*label(0) = age gender race wtkg hemo cd40_1 cd40_2 / ties=efron;
    baseline covariates=work.data_nph out=work.Pred_sur_np
             survival=_all_ / diradj;
    title 'Bezposrednio skorygowana funkcja przezycia';
run;
