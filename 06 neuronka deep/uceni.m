clear
% https://www.mathworks.com/help/deeplearning/ug/train-network-on-data-set-of-numeric-features.html
szM = 300;
szZ = 300;

VYSKA = [normrnd(176,8,[szM 1])];
M = [VYSKA,(VYSKA/100).^2 .* normrnd(25,2,[szM 1])];

VYSKA = [normrnd(165,8,[szZ 1])];
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
    'MiniBatchSize',80, ...
    'maxEpochs',20, ...
    'Shuffle','every-epoch', ...
    'ValidationData',tblValid, ...
    'ValidationFrequency',2, ...
    'Plots','training-progress', ...
    'Verbose',false);

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
outVysledek = net.predict(tblTest);
outTrid = grp2idx(net.classify(tblTest))==1;

phl = grp2idx(tblTest.pohlavi)==1;
plot(tblTest{phl,'vyska'},tblTest{phl,'vaha'},'r*')
hold on
plot(tblTest{~phl,'vyska'},tblTest{~phl,'vaha'},'g*')

plot(tblTest{outTrid,'vyska'},tblTest{outTrid,'vaha'},'r^')
hold on
plot(tblTest{~outTrid,'vyska'},tblTest{~outTrid,'vaha'},'g^')
hold off