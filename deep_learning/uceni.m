clear
% https://www.mathworks.com/help/deeplearning/ug/train-network-on-data-set-of-numeric-features.html
szM = 300;
szZ = 300;

VYSKA = [normrnd(176,5,[szM 1])];
M = [VYSKA,(VYSKA/100).^2 .* normrnd(25,2,[szM 1])];

VYSKA = [normrnd(165,5,[szZ 1])];
Z = [VYSKA,(VYSKA/100).^2 .* normrnd(25,2,[szZ 1])];

tbl = array2table(cat(1,M,Z),"VariableNames",{'vyska','vaha'});
tbl.pohlavi = categorical(cat(1,zeros(szM,1),ones(szZ,1)));
%%
idx = randperm(size(tbl,1));
tblTrain = tbl(idx(1:400),:);
tblValid = tbl(idx(401:500),:);
tblTest = tbl(idx(501:600),:);
%%
options = trainingOptions('adam', ...
    'MiniBatchSize',64, ...
    'maxEpochs',28, ...
    'Shuffle','every-epoch', ...
    'ValidationData',tblValid, ...
    'ValidationFrequency',2, ...
    'Plots','training-progress', ...
    'Verbose',true);

%%
layers = [
    featureInputLayer(2,"Name","featureinput","Normalization","zscore")
    fullyConnectedLayer(30,"Name","fc_1")
    reluLayer("Name","relu")
    fullyConnectedLayer(2,"Name","fc_2")
    softmaxLayer("Name","softmax")
    classificationLayer()
 ];

%%
net = trainNetwork(tblTrain,'pohlavi',layers,options);


%%
tvlVysledek = net.predict(tblTest);
tvlTrid = net.classify(tblTest);

plot(tbltrain.vyska{tbltrain.pohlavy},tbltrain.vaha{tbltrain.pohlavy},'r*')
hold on
plot(tbltrain.vyska{tbltrain.pohlavy},tbltrain.vaha{tbltrain.pohlavy},'b*')
hold off
