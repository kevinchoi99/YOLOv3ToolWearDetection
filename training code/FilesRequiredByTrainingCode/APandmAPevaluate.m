function APandmAPevaluate(~)
%% function can only be called on testing data
% Obtain the results
results = yolov3detect(net, imdstest)

% Evaluate the object detector using Average Precision metric.
[ap,recall,precision] = evaluateDetectionPrecision(results,bldstest);

% Plot precision-recall curve.
figure
plot(recall,precision)
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('Average Precision = %.2f', ap))

%evaluate the mAP
[mAP] = mean(ap);
plot(mAP)
xlabel('mAP')
ylabel('Percentage')
grid on
title(sprintf('mean Average Precision'))

end