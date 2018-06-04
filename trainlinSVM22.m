function [trainedClassifier, validationAccuracy] = trainlinSVM22(trainingData)
% trainClassifier(trainingData)
%  returns a trained classifier and its accuracy.
%  This code recreates the classification model trained in
%  Classification Learner app.
%
%   Input:
%       trainingData: the training data of same data type as imported
%        in the app (table or matrix).
%
%   Output:
%       trainedClassifier: a struct containing the trained classifier.
%        The struct contains various fields with information about the
%        trained classifier.
%
%       trainedClassifier.predictFcn: a function to make predictions
%        on new data. It takes an input of the same form as this training
%        code (table or matrix) and returns predictions for the response.
%        If you supply a matrix, include only the predictors columns (or
%        rows).
%
%       validationAccuracy: a double containing the accuracy in
%        percent. In the app, the History list displays this
%        overall accuracy score for each model.
%
%  Use the code to train the model with new data.
%  To retrain your classifier, call the function from the command line
%  with your original data or new data as the input argument trainingData.
%
%  For example, to retrain a classifier trained with the original data set
%  T, enter:
%    [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
%  To make predictions with the returned 'trainedClassifier' on new data T,
%  use
%    yfit = trainedClassifier.predictFcn(T)
%
%  To automate training the same classifier with new data, or to learn how
%  to programmatically train classifiers, examine the generated code.

% Auto-generated by MATLAB on 02-Apr-2018 21:20:16


% Extract predictors and response
% This code processes the data into the right shape for training the
% classifier.
% Convert input to table
inputTable = array2table(trainingData', 'VariableNames', {'row_1', 'row_2', 'row_3', 'row_4', 'row_5', 'row_6', 'row_7', 'row_8', 'row_9', 'row_10', 'row_11', 'row_12', 'row_13', 'row_14', 'row_15', 'row_16', 'row_17', 'row_18', 'row_19', 'row_20', 'row_21', 'row_22', 'row_23'});

predictorNames = {'row_1', 'row_2', 'row_3', 'row_4', 'row_5', 'row_6', 'row_7', 'row_8', 'row_9', 'row_10', 'row_11', 'row_12', 'row_13', 'row_14', 'row_15', 'row_16', 'row_17', 'row_18', 'row_19', 'row_20', 'row_21', 'row_22'};
predictors = inputTable(:, predictorNames);
response = inputTable.row_23;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
template = templateSVM(...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);
classificationSVM = fitcecoc(...
    predictors, ...
    response, ...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames', [1; 2; 4]);

% Create the result struct with predict function
predictorExtractionFcn = @(x) array2table(x', 'VariableNames', predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = 'This struct is a trained classifier exported from Classification Learner R2016b.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new predictor row matrix, X, use: \n  yfit = c.predictFcn(X) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedClassifier''. \n \nX must contain exactly 22 rows because this classifier was trained using 22 predictors. \nX must contain only predictor rows in exactly the same order and format as your training \ndata. Do not include the response row or any rows you did not import into \nClassification Learner. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% classifier.
% Convert input to table
inputTable = array2table(trainingData', 'VariableNames', {'row_1', 'row_2', 'row_3', 'row_4', 'row_5', 'row_6', 'row_7', 'row_8', 'row_9', 'row_10', 'row_11', 'row_12', 'row_13', 'row_14', 'row_15', 'row_16', 'row_17', 'row_18', 'row_19', 'row_20', 'row_21', 'row_22', 'row_23'});

predictorNames = {'row_1', 'row_2', 'row_3', 'row_4', 'row_5', 'row_6', 'row_7', 'row_8', 'row_9', 'row_10', 'row_11', 'row_12', 'row_13', 'row_14', 'row_15', 'row_16', 'row_17', 'row_18', 'row_19', 'row_20', 'row_21', 'row_22'};
predictors = inputTable(:, predictorNames);
response = inputTable.row_23;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Perform cross-validation
partitionedModel = crossval(trainedClassifier.ClassificationSVM, 'KFold', 5);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');

% Compute validation predictions and scores
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);
