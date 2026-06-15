options nofmterr;
libname dane "/workspaces/myfolder/projekt act";

proc phreg data=dane.data_cleaned;
class trt hemo homo drugs karnof
      oprior z30 race gender
      str2 strat symptom treat offtrt;
model time*label(0)=
trt age wtkg hemo homo drugs
karnof oprior z30 preanti
race gender str2 strat symptom
treat offtrt cd40 cd420 cd80 cd820
/ selection=stepwise;
run;

proc phreg data=dane.data_cleaned;
class treat offtrt symptom drugs;
model time*label(0)=
cd420 treat cd820 offtrt
preanti symptom cd40 age drugs
cd420_t cd820_t preanti_t
cd40_t age_t;
cd420_t = cd420*time;
cd820_t = cd820*time;
preanti_t = preanti*time;
cd40_t = cd40*time;
age_t = age*time;
run;

proc lifetest data=dane.data_cleaned
              method=lt
              plots=(s,h);
time time*label(0);
run;

data dane.bayes;
set dane.data_cleaned;
cd420_w = cd420*(time<1000);
run;

proc phreg data=dane.bayes;
class treat offtrt symptom drugs;
model time*label(0)=
cd420 treat cd820 offtrt
preanti symptom cd40 age drugs
cd420_w;
bayes
seed=123
nbi=2000
nmc=10000
coeffprior=normal
diagnostics=all;
ods output PosteriorSample = PS_data_cleaned;
run;

data Prior_ACTG;
   input _type_ $ cd420 treat0 treat1 cd820 offtrt0 offtrt1 preanti symptom0 symptom1 cd40 age drugs0 drugs1 cd420_w;
   cards;
mean -0.01894 0.44145 0 0.00075 -0.48679 0 0.00017 -0.33694 0 0.00323 0.02542 0.29286 0 -0.00908
var  0.000002 0.00869 1E6 0.00000 0.00863 1E6 0.00000 0.01042 1E6 0.00000 0.00015 0.02154 1E6 0.00001
;
run;

proc phreg data=dane.bayes;
   class treat offtrt symptom drugs;
   model time*label(0) = cd420 treat cd820 offtrt preanti symptom cd40 age drugs cd420_w;
   bayes seed=123 
         nbi=2000 
         nmc=10000 
         diagnostics=(autocorr ess geweke)
         coeffprior=normal(input=Prior_ACTG);
run;