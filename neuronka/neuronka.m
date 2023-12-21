clearszM = 200;
szZ = 200;

VYSKA = [normrnd(176,5,[szM 1])];
M = [VYSKA,(VYSKA/100).^2 .* normrnd(25,2,[szM 1])];

VYSKA = [normrnd(165,5,[szZ 1])];
Z = [VYSKA,(VYSKA/100).^2 .* normrnd(25,2,[szZ 1])];

MN = (M - mean(cat(1,M,Z)))./std(cat(1,M,Z));
ZN = (Z - mean(cat(1,M,Z)))./std(cat(1,M,Z));

x_train = cat(1,MN,ZN);
y_train = cat(1,zeros([size(MN,1),1]),ones([size(ZN,1),1]));
y_train_druhy = ~y_train;
y_train_new = [y_train, y_train_druhy];


ID = randperm(size(x_train,1));
x_train = x_train(ID,:);
y_train_new = y_train_new(ID,:);
x_train = [x_train,ones([size(x_train,1),1])];


x = x_train';
t = y_train_new';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 20;
net = patternnet(hiddenLayerSize, trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 60/100;
net.divideParam.valRatio = 20/100;
net.divideParam.testRatio = 20/100;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotconfusion(t,y)
%figure, plotroc(t,y)

