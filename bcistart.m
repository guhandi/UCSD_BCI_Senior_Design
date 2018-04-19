clear
close all
clc

tic


fs=250;
startsample=525;
windowsize=975;
featdim=8;
baseclass=2;
%baseclass and noclass are numbers between 1 and 4, can't be same number
noclass=3;
x=1;
Fpass1=7;
Fstop1=Fpass1-3;
Fpass2=13;
Fstop2=Fpass2+3;
freqstep=5;



numbtrials=130;

%numbtrials indicates how many trials will be used in the training set
%the number of trials in the crossval set equals total trials-numbtrials
%{
[combined, combinedlabels]= get_data_A0xT(noclass,windowsize,startsample);

crossval=[];
crossvallabels=[];

crossval=combined(windowsize*numbtrials+1:end,:);
crossvallabels=combinedlabels(windowsize*numbtrials+1:end);

combined=combined(1:windowsize*numbtrials,:);
combinedlabels=combinedlabels(1:windowsize*numbtrials);
%}
%}
%crossval=combined;
%crossvallabels=combinedlabels;
%}
%if bcimain is ran without crossvalset or crossvallabels,
%crossvalidationaccuracy will return as 0
%[crossvalidationaccuracy, trainingfeats]= bcimain(combined, combinedlabels, crossval, crossvallabels, fs, windowsize, featdim, baseclass,Fstop1,Fpass1,Fpass2,Fstop2,classalg);

%code below iterates through each class and cspbase combination

%
besttot=[];
accs=[];
for x=1:5
Fpass1=7;
Fstop1=Fpass1-3;
Fpass2=13;
Fstop2=Fpass2+3;
freqstep=5;
featdim=8;
valAcc=[];
ncvec=[];
bcvec=[];
classalg=1;
for noclass=1:4
    for baseclass=1:4
        if baseclass~=noclass
            display(noclass)
            display(baseclass)
            [combined, combinedlabels]= get_data_A0xT(noclass, windowsize, startsample,x);
            
            crossval=combined(windowsize*numbtrials+1:end,:);
            crossvallabels=combinedlabels(windowsize*numbtrials+1:end);

            combined=combined(1:windowsize*numbtrials,:);
            combinedlabels=combinedlabels(1:windowsize*numbtrials);
            
            [crossvalidationaccuracy, trainingfeats]= bcimain(combined, combinedlabels, crossval, crossvallabels, fs, windowsize, featdim, baseclass,Fstop1,Fpass1,Fpass2,Fstop2,classalg);
            valAcc=[valAcc crossvalidationaccuracy];
            ncvec=[ncvec noclass];
            bcvec=[bcvec baseclass];
        end
    end
end
vectot=[valAcc; ncvec; bcvec];


sum1=0;
sum2=0;
sum3=0;
sum4=0;

for i=1:length(valAcc)
    if vectot(3,i)==1
        sum1=sum1+vectot(1,i);
    end
    if vectot(3,i)==2
        sum2=sum2+vectot(1,i);
    end
    if vectot(3,i)==3
        sum3=sum3+vectot(1,i);
    end
    if vectot(3,i)==4
        sum4=sum4+vectot(1,i);
    end
end
means=zeros(1,4);
means(1)=sum1/3;
means(2)=sum2/3;
means(3)=sum3/3;
means(4)=sum4/3;

[mean, bestbase]=max(means);
[mean2,bestbase2]=max(means(means<max(means)));
%}


%{
valAcc=[];
ssvec=[];
wsizevec=[];
for startsample= 525:25:550
    for windowsize=675:25:975
            display(startsample)
            display(windowsize)
            [combined, combinedlabels]= get_data_A0xT(noclass, windowsize, startsample);
            
            crossval=combined(windowsize*numbtrials+1:end,:);
            crossvallabels=combinedlabels(windowsize*numbtrials+1:end);

            combined=combined(1:windowsize*numbtrials,:);
            combinedlabels=combinedlabels(1:windowsize*numbtrials);
            
            [crossvalidationaccuracy, trainingfeats]= bcimain(combined, combinedlabels, crossval, crossvallabels, fs, windowsize, featdim, baseclass,Fstop1,Fpass1,Fpass2,Fstop2);
            valAcc=[valAcc crossvalidationaccuracy];
            ssvec=[ssvec startsample];
            wsizevec=[wsizevec windowsize];
    end
end
vectot=[valAcc; ssvec; wsizevec];
%}

%{
valAcc=[];
pass1vec=[];
pass2vec=[];
for i=1:7
    [crossvalidationaccuracy, trainingfeats]= bcimain(combined, combinedlabels, crossval, crossvallabels, fs, windowsize, featdim, baseclass,Fstop1,Fpass1,Fpass2,Fstop2);
    valAcc=[valAcc crossvalidationaccuracy];
    pass1vec=[pass1vec Fpass1];
    pass2vec=[pass2vec Fpass2];
    Fstop1=Fstop1+freqstep;
    Fpass1=Fpass1+freqstep;
    Fpass2=Fpass2+freqstep;
    Fstop2=Fstop2+freqstep;
end
vectot=[valAcc; pass1vec; pass2vec];
%}


%

featdim=30;
classalg=2;

Fpass1=7;
Fstop1=Fpass1-3;
Fpass2=13;
Fstop2=Fpass2+3;
freqstep=5;

valAcc=[];
pass1vec=[];
pass2vec=[];
ncvec=[];


for i=1:6
    for noclass=1:4
        baseclass=bestbase;
        if bestbase==noclass
            baseclass=bestbase2;
        end
        
        [combined, combinedlabels]= get_data_A0xT(noclass,windowsize,startsample,x);
        
        crossval=combined(windowsize*numbtrials+1:end,:);
        crossvallabels=combinedlabels(windowsize*numbtrials+1:end);

        combined=combined(1:windowsize*numbtrials,:);
        combinedlabels=combinedlabels(1:windowsize*numbtrials);

        [crossvalidationaccuracy, trainingfeats]= bcimain(combined, combinedlabels, crossval, crossvallabels, fs, windowsize, featdim, baseclass,Fstop1,Fpass1,Fpass2,Fstop2,classalg);
        valAcc=[valAcc crossvalidationaccuracy];
        pass1vec=[pass1vec Fpass1];
        pass2vec=[pass2vec Fpass2];
        ncvec=[ncvec noclass];
    end
    Fstop1=Fstop1+freqstep;
    Fpass1=Fpass1+freqstep;
    Fpass2=Fpass2+freqstep;
    Fstop2=Fstop2+freqstep;
end
vectot2=[valAcc; pass1vec; pass2vec; ncvec];
[maxacc, index]=max(valAcc);
bestpass1=vectot2(2,index);
bestpass2=vectot2(3,index);
bestnc=vectot2(4,index);

best=[bestpass1 bestpass2 bestnc bestbase bestbase2];
besttot=[besttot; best];
accs=[accs; maxacc];

%}
end
toc