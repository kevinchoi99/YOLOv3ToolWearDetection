function YPredCell = yolov3Predict(fullnet,Xtest,networkOutputs,anchorBoxMasks)
% Predict the output of network and extract the confidence, x, y,
% width, height, and class.
YPredictions = cell(size(networkOutputs));
[YPredictions{:}] = predict(fullnet, Xtest);
YPredCell = extractPredictions(YPredictions, anchorBoxMasks);

% Apply activation to the predicted cell array.
YPredCell = applyActivations(YPredCell);
end