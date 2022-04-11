
figure
hold on
box on
training_number = 3:10;%yale
% training_number = 2:6;%pe
% training_number = 2:5;%feret
% training_number = 3:2:9;%orl
% training_number=7:6:37;%CMU PIE
%training_number=7:14;%GT
% axis([2,5,20,90])
% axis([7,37,10,90])
% set(gca,'xtick',7:6:37)
set(gca,'xtick',3:10)
% set(gca,'xtick',7:14)
% set(gca,'xtick',7:6:37)

%pca
plot(training_number,score555,'y-o')
%kpca
plot(training_number,score666,'c-o')

%UDP
plot(training_number,score777,'-o','color',[255 127 0] / 255)

%DLDA
plot(training_number,score999,'-o','color',[0 104 155] / 255)

%LPP
plot(training_number,scoreaaa,'-o','color',[55 0 55] / 255)

%RSNMF
plot(training_number,score101010,'-o','color',[255 0 155] / 255)
%PNMF
plot(training_number,score333,'-o','color',[0 155 0] / 255)
%PKNMF
plot(training_number,score222,'m-o')
%GNMF
plot(training_number,score888,'b-o')
%FPKNMF
plot(training_number,score111,'g-o')
%CKNMF
plot(training_number,score444,'r-o')

xlabel('{\itn}')
ylabel('Classification accuracy (%)')
% title('^¡Á^6^8')
% title('^¡Á^5^0')
% title('^¡Á^1^5')
% title('^¡Á^1^2^0')
% title('^¡Á^4^0')
% legend('FPKNMF','PKNMF','PNMF','FPKGNMF','PCA','Location','southeast');
h1 = legend('PCA','KPCA','UDP','DLDA','LPP','RSNMF','PNMF','PKNMF','GNMF','FPKNMF','CKNMF','Location','southeast');
h1.FontSize = 6;
h1.NumColumns = 1;
hold off