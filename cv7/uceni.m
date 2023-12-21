clear

digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', ...
    'nndatasets','DigitDataset');
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

idx = randperm(10000);
for k=1:20
    subplot(4,5,k)
    imshow(imds.Files{idx(k)})
    title(imds.Labels(idx(k)))
end
%%
[ds_train,ds_valid,ds_test ] = splitEachLabel(imds,0.01,0.25,0.25,0.49,'randomize');
augmenter = imageDataAugmenter( ...
    'RandRotation',[0 360], ...
    'RandXTranslation',[-5 5], ...
    'RandYTranslation',[-5 5] ,...
    'RandScale',[0.5 1])
ds_trainAG = augmentedImageDatastore([28 28],ds_train,'DataAugmentation',augmenter);



%%
layers = [
    imageInputLayer([28 28 1],"Name","imageinput")
    fullyConnectedLayer(128,"Name","fc_1")
    reluLayer("Name","relu")
    fullyConnectedLayer(10,"Name","fc_2")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];

layers = [
    imageInputLayer([28 28 1],"Name","imageinput")
    convolution2dLayer([3 3],8,"Name","conv_1","Padding","same")
    batchNormalizationLayer("Name","batchnorm_1")
    reluLayer("Name","relu_1")
    maxPooling2dLayer([2 2],"Name","maxpool_1","Stride",[2 2])
    convolution2dLayer([3 3],16,"Name","conv_2","Padding","same")
    batchNormalizationLayer("Name","batchnorm_2")
    reluLayer("Name","relu_2")
    maxPooling2dLayer([2 2],"Name","maxpool_2","Stride",[2 2])
    convolution2dLayer([3 3],32,"Name","conv_3","Padding","same")
    batchNormalizationLayer("Name","batchnorm_3")
    reluLayer("Name","relu_3")
    fullyConnectedLayer(10,"Name","fc")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];

%%
options = trainingOptions('adam', ...
    'MiniBatchSize',256, ...
    'maxEpochs',200, ...
    'Shuffle','every-epoch', ...
    'ValidationData',ds_valid, ...
    'ValidationFrequency',10, ...
    'Plots','training-progress', ...
    'Verbose',false);


%%
net = trainNetwork(ds_trainAG,layers,options);
%%
ypred= net.classify(ds_test);

%%
err_idx = find(ypred ~= ds_test.Labels);
idx = err_idx( randperm(length(err_idx)) );
presnost = sum(ypred == ds_test.Labels) / length(ypred)
for k=1:9
    subplot(3,3,k)
    imshow(ds_test.Files{idx(k)})
    title(ypred(idx(k)))
end