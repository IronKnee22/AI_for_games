clear
T = readtable("data_cancer.csv");
TN = T;
TN{:,3:end} = (T{:,3:end} - mean(T{:,3:end}))./std(T{:,3:end});
% T{:,3:end} = normalize(T{:,3:end} );
figure(1)
for id = 3:size(T,2) 
   subplot(6,6,id)
   histogram(T{:,id})  
   title(T.Properties.VariableNames{id})
end
%%
figure(2)
D = tsne(TN{:,3:end});
gscatter(D(:,1),D(:,2),T.diagnosis)
%%
[coef score latent] = pca(TN{:,3:end});
TData = TN{:,3:end}

figure(3)
H = TN{38,3:end} + (rand()-0.5);
NH = H*coef;

gscatter(score(:,1),score(:,2),T.diagnosis)
hold on
plot(NH(1),NH(2),'b*')
plot(score(38,1),score(38,2),'k*')
hold off
%%
predNames = TN(:,3:end).Properties.VariableNames;
[B, FI] = lasso(TN{:,3:end},double(strcmp(TN.diagnosis,'B')),'CV',10,'PredictorNames',predNames);
lassoPlot(B,FI,'PlotType','Lambda','XScale','log');
lam = FI.Index1SE;
isImportant = B(:,lam) ~= 0;
disp(predNames(isImportant)) 

%%
