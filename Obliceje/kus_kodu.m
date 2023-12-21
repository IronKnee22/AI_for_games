%% Načtění obličeju
clear
addpath 'pca_ica';
addpath 'faces_cislo';
D = dir('faces_cislo/*.jpg');
M = [];
[~, reindex] = sort( str2double( regexp( {D.name}, '\d+', 'match', 'once' )))
D = D(reindex) ;
for ID = 1:length(D)
   D(ID).name
   im = rgb2gray(imread(D(ID).name)); % obličeje do šeda
   imshow(im)
   M = cat(2,M,im(:));   %dání obličejů do jedné matice
end
M = double(M');
M_MEAN = mean(M(:));
M_STD = std(M(:));
MStd = (M-M_MEAN)/M_STD; % Normalizace
coef = pca(MStd); % provede analýzu hlavních komponent
KT = MStd* coef;
%% Nepodstatné
% 
% Vykreslení 9 hlavních komponent
 
for k = 1:9
    subplot(3,3,k)
    imshow(reshape(coef(:,k),size(im))*100)
end

%% Vykresleni obličeju v 3D prostoru
figure

znak = {'r*','g*','b*','k*','y*','m*','c*','ro','go','bo','ko','yo','mo','co','rs','gs','bs','ks','ys','ms'};

komp = KT(:,1:5)
for id = 1:200
    X = KT(id,1);
    Y = KT(id,5);
    Z = KT(id,3);
    plot3(X,Y,Z,znak{ceil(id/10)})
    hold on
    grid on
end
hold off
