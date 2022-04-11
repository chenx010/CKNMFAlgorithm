
idx =1;
[X,training_number,r,c,pn] = read_data(idx);

for i = 1:length(training_number)
    figure
    hold on
    box on
    set(gca,'xtick',1:5)
    p = 1:5;  
    
    plot(p,sum_cmc_count555(i,:),'y-o')
    plot(p,sum_cmc_count666(i,:),'c-o')
    plot(p,sum_cmc_count777(i,:),'-o','color',[255 127 0] / 255)
    plot(p,sum_cmc_count999(i,:),'-o','color',[0 104 155] / 255)


    plot(p,sum_cmc_countaaa(i,:),'-o','color',[55 0 55] / 255)

    plot(p,sum_cmc_count101010(i,:),'-o','color',[255 0 155] / 255)

    plot(p,sum_cmc_count333(i,:),'-o','color',[0 155 0] / 255)

    plot(p,sum_cmc_count222(i,:),'m-o')
    plot(p,sum_cmc_count888(i,:),'b-o')
    plot(p,sum_cmc_count111(i,:),'g-o')
    plot(p,sum_cmc_count444(i,:),'r-o')

    
    xlabel('Rank')
    ylabel('Classification accuracy (%)')
    h1 = legend('PCA','KPCA','UDP','DLDA','LPP','RSNMF','PNMF','PKNMF','GNMF','FPKNMF','CKNMF','Location','southeast');
    h1.FontSize = 6;
    h1.NumColumns = 1;
end
