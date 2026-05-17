libname aids "C:\Users\bubus\Documents\studia\analiza czasu trwania\projekt\code";

proc import datafile="C:\Users\bubus\Documents\studia\analiza czasu trwania\projekt\code\AIDS_ClinicalTrial_GroupStudy175.csv"
    out=aids.data
    dbms=csv
    replace;
    getnames=yes;
run;

/*bardzo wstêpna analiza, czy s¹ jakieœ nieporz¹dane rzeczy*/
proc print data=aids.data(obs=10);
run;

proc means data=aids.data n nmiss min max mean;
run;

proc contents data=aids.data;
run;

/*Czyszczenie danych*/
proc format;
    value gender_fmt
        0 = 'Female'
        1 = 'Male';
    
    value race_fmt
        0 = 'White'
        1 = 'Non-White';
    
    value trt_fmt
        0 = 'AZT'
        1 = 'AZT + ddI'
        2 = 'AZT + ddC'
        3 = 'ddI';
        
    value treat_fmt
        0 = 'ZDV only'
        1 = 'Others';
        
    value yesno_fmt
        0 = 'No'
        1 = 'Yes';
        
    value strat_fmt
        1 = 'Antiretroviral Naive'
        2 = '> 1 but <= 52 weeks prior therapy'
        3 = '> 52 weeks prior therapy';
run;
/*tworzê s³owniki*/
proc format;
    value gender_fmt
        0 = 'Female'
        1 = 'Male';
    value race_fmt
        0 = 'White'
        1 = 'Non-White';
    value trt_fmt
        0 = 'ZDV only'
        1 = 'ZDV + ddI'
        2 = 'ZDV + Zal'
        3 = 'ddI only';
    value treat_fmt
        0 = 'ZDV only'
        1 = 'Others';
    value yesno_fmt
        0 = 'No'
        1 = 'Yes';
    value label_fmt
        0 = 'Censoring'
        1 = 'Failure';
    value str2_fmt
        0 = 'Naive'
        1 = 'Experienced';
    value symptom_fmt
        0 = 'Asymptomatic'
        1 = 'Symptomatic';
    value strat_fmt
        1 = 'Antiretroviral Naive'
        2 = '> 1 but <= 52 weeks prior therapy'
        3 = '> 52 weeks prior therapy';
run;

data aids.data_cleaned;
    set aids.data;
    format 
        gender gender_fmt.
        race race_fmt.
        trt trt_fmt.
        treat treat_fmt.
        strat strat_fmt.
        label label_fmt.
        str2 str2_fmt.
        symptom symptom_fmt.
        hemo homo drugs oprior z30 zprior offtrt yesno_fmt.;

    if age < 0 or age > 110 then age = .;
    if wtkg < 30 or wtkg > 250 then wtkg = .;
    if karnof < 0 or karnof > 100 then karnof = .;
    if cd40 < 0 then cd40 = .;
    if cd80 < 0 then cd80 = .;
    if cd420 < 0 then cd420 = .;
    if cd820 < 0 then cd820 = .;
    if time < 0 then time = .;
    if preanti < 0 then preanti = .;
run;