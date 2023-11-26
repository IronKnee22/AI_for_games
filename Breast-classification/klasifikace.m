clear
T = readtable("data_cancer.csv");
TN = T;
TN{:,3:end} = (T{:,3:end} - mean(T{:,3:end}))./std(T{:,3:end});
[coef score latent] = pca(TN{:,3:end});


%% Trenovani
DT = TN;
IDX = randperm(height(DT));
DT = DT(IDX,:);
score = score(IDX,:);

DT_train = DT(1:floor(end/2),:);
score_train = score(1:floor(end/2),:);

for k = 1:20
    %Mdl{k} = fitcknn(DT_train(:,2:end),'diagnosis','NumNeighbors',k);
    Mdl{k} = fitcknn(score_train(:,1:k),DT_train.diagnosis,'NumNeighbors',3);
    Mdl{k} = fitcnb(score_train(:,1:k),DT_train.diagnosis);
end
%% Validace
DT_valid = DT(floor(end/2)+1:end,:);
score_valid = score(floor(end/2)+1:end,:);
Acc  = [];
for k = 1:20
    SMdl = Mdl{k};
%   DT_predicted = SMdl.predict(DT_valid);
    DT_predicted = SMdl.predict(score_valid(:,1:k));
    [C go] = confusionmat(DT_valid.diagnosis,DT_predicted, 'order',{'B','M'})    
    %Cm = confusionchart(C,{'B','M'});
    %Acc = (C(1,1)/sum(C(1,:)) + C(2,2)/sum(C(2,:)))/2; 
    Acc(k) = mean(diag(C) ./ sum(C,2));
end
plot(1:20,Acc)
ylim([0.8 1])
grid on
