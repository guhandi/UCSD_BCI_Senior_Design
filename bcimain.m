function [crossvalidationaccuracy, trainingfeats, crossvallabelsseg, predictions]= bcimain(trainingset, traininglabels, crossvalset, crossvallabels, fs, windowsize, featdim, baseclass,Fstop1,Fpass1,Fpass2,Fstop2,classalg)

%currently, bcimain only outputs the crossvalidation accuracy and the
%training features, however this can easily be changed to output things
%such as the trained classifier, the specific predictions, etc.

%datasets and labels must be same length
%that length must be divisible by windowsize or else program will fail
P=[];
%
P1=train_CSP(trainingset,traininglabels,1);
P1=P1(:,[1:4 end-3:end]);
P2=train_CSP(trainingset,traininglabels,2);
P2=P2(:,[1:4 end-3:end]);
P3=train_CSP(trainingset,traininglabels,4);
P3=P3(:,[1:4 end-3:end]);
%}

trainingfeats=zeros(featdim, length(trainingset)/windowsize);
if classalg==1
parfor i=1:length(trainingset)/windowsize
    trainingfeats(:,i)=extract_feats2(trainingset((i-1)*windowsize+1:(i-1)*windowsize+windowsize,:), size(trainingset,2), fs, featdim,P1,P2,P3,Fstop1,Fpass1,Fpass2,Fstop2);
end

end
if classalg==2
parfor i=1:length(trainingset)/windowsize
    trainingfeats(:,i)=extract_feats(trainingset((i-1)*windowsize+1:(i-1)*windowsize+windowsize,:),P,Fstop1,Fpass1,Fpass2,Fstop2);
end
end

traininglabelsseg=zeros(length(traininglabels)/windowsize,1); 

% for loop below calculates most likely label for each window by taking
% averages of labels over the window and rounding

%%{
for i=1:length(traininglabels)/windowsize
    traininglabelsseg(i)= round(mean(traininglabels((i-1)*windowsize+1:(i-1)*windowsize+windowsize)));
end

traininglabelsseg=transpose(traininglabelsseg);
%}

%size(trainingfeats)
%size(traininglabelsseg)
trainingfeats= [trainingfeats; traininglabelsseg];

crossvalidationaccuracy=0;
validationAccuracy=0;
crossvallabelsseg=0;
predictions=0;

[trainedClassifier, validationAccuracy]=trainsde24(trainingfeats);
%[trainedClassifier, validationAccuracy] = trainlinSVM30f(trainingfeats);
%{
if classalg==2
    [trainedClassifier, validationAccuracy] = trainsde30f(trainingfeats);
end
if classalg==1
    [trainedClassifier, validationAccuracy] = trainlinSVM8f(trainingfeats);
end
%}
%[trainedClassifier, validationAccuracy] = trainlinSVM22(trainingfeats);
%[trainedClassifier, validationAccuracy] = trainsde22(trainingfeats);

%display(validationAccuracy)


if isempty(crossvalset) || isempty(crossvallabels)  %this allows you to run code without including crossvalset
    return;
end


%cross validation analysis

crossvalfeats=zeros(featdim, length(crossvalset)/windowsize);
if classalg==1
parfor i=1:length(crossvalset)/windowsize
    crossvalfeats(:,i)=extract_feats2(crossvalset((i-1)*windowsize+1:(i-1)*windowsize+windowsize,:), size(crossvalset,2), fs, featdim, P1,P2,P3,Fstop1,Fpass1,Fpass2,Fstop2);
end
end
if classalg==2
parfor i=1:length(crossvalset)/windowsize
    crossvalfeats(:,i)=extract_feats(crossvalset((i-1)*windowsize+1:(i-1)*windowsize+windowsize,:), P,Fstop1,Fpass1,Fpass2,Fstop2);
end
end

crossvallabelsseg= zeros(length(crossvallabels)/windowsize,1); 
for i=1:length(crossvallabels)/windowsize
    crossvallabelsseg(i)= round(mean(crossvallabels((i-1)*windowsize+1:(i-1)*windowsize+windowsize)));
end

[crossvalidationaccuracy,predictions]= crossval(trainedClassifier, crossvalfeats, crossvallabelsseg);


%}


end