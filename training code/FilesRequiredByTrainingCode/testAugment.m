function aug_data = testAugment(data)
 
theta = 0;
num = 8;

aug_images = transpose(repelem(data(:,1),num));
aug_bboxes = transpose(repelem(data(:,2),num));
aug_labels = transpose(repelem(data(:,3),num));

resize_data = [aug_images aug_bboxes aug_labels];
aug_data=cell(size(resize_data));

for ii = 1:size(resize_data,1)
    
    I = resize_data{ii,1};
    % bounding boxes positions
    bboxes = resize_data{ii,2};
    % bounding boxes data
    labels = resize_data{ii,3};
    
    sz = size(I);
    
    tform = affine2d([ ...
    cosd(theta) sind(theta) 0;...
    -sind(theta) cosd(theta) 0; ...
    0 0 1]);

    outputView = affineOutputView(sz,tform,'BoundsStyle','centerOutput');
    I=imwarp(I,tform,'OutputView',outputView);
    % Apply same transform to boxes.
    [bboxes,indices] = bboxwarp(bboxes,tform,outputView,'OverlapThreshold',0.25);
    labels = labels(indices);
    
    % Return original data only when all boxes are removed by warping.
    if isempty(indices)
        aug_data(ii,:) = resize_data(ii,:);
    else
        aug_data(ii,:) = {I, bboxes, labels};
    end
    
    theta = theta + 45;
    
end


end