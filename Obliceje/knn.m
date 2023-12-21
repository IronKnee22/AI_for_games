clear
clc

addpath 'faces_cislo';
D_train = dir('faces_cislo/*.jpg');

M_train = [];
[~, reindex] = sort(str2double(regexp({D_train.name}, '\d+', 'match', 'once')));
D_train = D_train(reindex);
for ID = 1:length(D_train)
    D_train(ID).name;
    im = rgb2gray(imread(D_train(ID).name)); % obličeje do šeda
    M_train = cat(2, M_train, im(:));   % dání obličejů do jedné matice
end

M_train = double(M_train');
M_MEAN_train = mean(M_train(:));
M_STD_train = std(M_train(:));
MStd_train = (M_train - M_MEAN_train) / M_STD_train; % Normalizace

% Analýza hlavních komponent pro trénovací data
coef_train = pca(MStd_train);

% Vytvoření prostoru hlavních komponent pro trénovací data
train_space = MStd_train * coef_train;

% Rozdělení trénovacích obličejů do skupin 
num_groups = length(D_train)/10;
group_indices = ceil(((1:length(D_train)) / (length(D_train)) * num_groups));

% Načtení testovacích dat
addpath 'faces-test';
D_test = dir('faces-test/*.jpg');

M_test = [];
[~, reindex] = sort(str2double(regexp({D_test.name}, '\d+', 'match', 'once')));
D_test = D_test(reindex);
for ID = 1:length(D_test)
    D_test(ID).name;
    im = rgb2gray(imread(D_test(ID).name)); % obličeje do šeda
    M_test = cat(2, M_test, im(:));   % dání obličejů do jedné matice
end

M_test = double(M_test');
M_MEAN_test = mean(M_test(:));
M_STD_test = std(M_test(:));
MStd_test = (M_test - M_MEAN_test) / M_STD_test; % Normalizace

% Vytvoření prostoru hlavních komponent pro testovací data
test_space = MStd_test * coef_train;

% Normalizace prostoru hlavních komponent (je-li potřeba)
train_space_norm = (train_space - mean(train_space(:))) / std(train_space(:));
test_space_norm = (test_space - mean(test_space(:))) / std(test_space(:));

% Natrénování k-NN klasifikátoru
knnClassifier = fitcknn(train_space_norm, group_indices', 'NumNeighbors', 10);
predictedGroups = predict(knnClassifier, test_space_norm);

figure('Name','knn')


for i = 1:length(D_test)
    subplot(2,length(D_test), i)
    testovaci_obrazek = fullfile('faces-test', [num2str(i) '.jpg']);
    imshow(testovaci_obrazek)
    
    
    subplot(2,length(D_test), i+length(D_test))
    predictedGroup = predictedGroups(i);
    % Zobrazit nějaký obličej z přiřazené skupiny
    indx = find(group_indices == predictedGroup, 1, 'first');
    prvotni_obrazek = fullfile('faces_cislo', [num2str(indx) '.jpg']);
    imshow(prvotni_obrazek)
    
    
    title([num2str(i) ' =' num2str(predictedGroup)])
end

correctGroups = [2, 7, 9, 10, 4, 18, 11]; 
correctlyClassified = sum(predictedGroups' == correctGroups);
accuracy = correctlyClassified / (length(D_test));
fprintf('Celková přesnost klasifikace: %.2f%%\n', accuracy * 100);


