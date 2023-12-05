% Načtení trénovacích dat
clear

addpath 'faces_cislo';
D_train = dir('faces_cislo/*.jpg');

M_train = [];
[~, reindex] = sort(str2double(regexp({D_train.name}, '\d+', 'match', 'once')));
D_train = D_train(reindex);
for ID = 1:length(D_train)
    D_train(ID).name
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

% Načtení testovacích dat

num_groups = length(D_train)/10;
group_indices = ceil((1:length(D_train)) / (length(D_train) / num_groups));

addpath 'faces-test';
D_test = dir('faces-test/*.jpg');

M_test = [];
[~, reindex] = sort(str2double(regexp({D_test.name}, '\d+', 'match', 'once')));
D_test = D_test(reindex);
for ID = 1:length(D_test)
    D_test(ID).name
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





% Natrénování ecoc klasifikátoru
svm_classifier = fitcecoc(train_space_norm, group_indices');
predictedClasses = predict(svm_classifier, test_space_norm);

figure('Name','ecoc')

j = 1;
for i = 1:length(D_test)
    subplot(4, 2, j)
    testovaci_obrazek = fullfile('faces-test', [num2str(i) '.jpg']);
    imshow(testovaci_obrazek)
    
    j = j + 1;
    subplot(4, 2, j)
    predictedGroup = predictedClasses(i);
    % Zobrazit nějaký obličej z přiřazené skupiny
    indx = find(group_indices == predictedGroup, 1, 'first');
    prvotni_obrazek = fullfile('faces_cislo', [num2str(indx) '.jpg']);
    imshow(prvotni_obrazek)
    j = j + 1;
    
    title(['Testovací obličej ' num2str(i) ' patří do skupiny ' num2str(predictedGroup)])
end