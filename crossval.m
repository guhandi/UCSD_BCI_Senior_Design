function accuracy= crossval(trainedClassifier, feats, labels)

predictions=zeros(length(labels),1);

parfor i=1:length(predictions)
    predictions(i)= trainedClassifier.predictFcn(feats(:,i));
end

accuracyvec= predictions==labels;
accuracy= mean(accuracyvec);
display(accuracy)
end