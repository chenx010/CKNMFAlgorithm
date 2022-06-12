%-----This is the main test file used to record 
%    the classification results of each algorithm------
%----change idx to run different dataset------
clc
clear
% read data idx=1,2,3,4,5,6 corresponds to: yale,pe,feret,cmu,gt,orl
idx = 1; 
[X,training_number,r,c,pn] = read_data(idx);
X = X ./ 255;
X3 = X;

% Iterative update W, H, number of iterations I_max = 400% 
%d = 0.5% of FPKNMF defines the epsilon of the iteration

I_max = 400;
epsilon1 = 1 * 10 ^ (-3);
d3 = 0.5;
rank = 5;

% Determine fpkgnmf parameters
alpha = 0.95;
sigma = 0.05;
d4 = 0.5;

% Determine pknmf parameters
d2 = 2;
d1 = 2;

% Determine pca principal components
getpercent = 0.96;

% Determine udp parameters
knn = 3;

% Determine LPP parameters
options = [];
options.Metric = 'Euclidean';
options.NeighborMode = 'KNN';
options.k = 3;
options.WeightMode = 'HeatKernel';
options.t = 1;
options.PCARatio = 0.96;


% Determine GNMF parameters
sigma00 = 2;


scoreaa = zeros(10,length(training_number));
score11 = zeros(10,length(training_number));
score22 = zeros(10,length(training_number));
score33 = zeros(10,length(training_number));
score44 = zeros(10,length(training_number));
score55 = zeros(10,length(training_number));
score66 = zeros(10,length(training_number));
score77 = zeros(10,length(training_number));
score88 = zeros(10,length(training_number));
score99 = zeros(10,length(training_number));
score1010 = zeros(10,length(training_number));

for i = 1:length(training_number)
    
    for j = 1:10
        % Initialize data and split into training matrices X_train, X_test
        [X_test,X_train,A,B,B2,C]=rand_init(X,training_number(i),c,pn);
        
        %Initialize W,H
        [W,H] = initial_WH(X_train,r(i));
        
        %Initialize B0,H0 of GNMF 
        [B3,H8,K_sq,K] = initial_BH(X_train,r(i),sigma00);
        [A0,B3,H8] =updata_BH(I_max,epsilon1,K_sq,K,B3,H8);
        
        %fpknmf update W,H
        [W3,H3,J3] =updata_WH(I_max,epsilon1,d3,W,H,X_train);
        
        %cknmf update W,H
        
        [W4,H4,J4] =cknmfUpdata_WH(I_max,epsilon1,W,H,X_train);
        
        %pknmf update W,H
        [W2,H2,J2] =pknmfupdata_WH(I_max,epsilon1,d2,W,H,X_train);
        
        %pnmf update W,H
        [W1,H1,J1] =pnmfupdata_WH(I_max,epsilon1,d1,W,H,X_train);
        
        %pca
        [PCAeigenvector,P_train,P_test,rank1] = pca1(X_train,X_test,getpercent);
        
        %kpca
        [PV_train,PV_test,rank2] = kpca2(X_train,X_test);
        
        %UDP
        [w_test,w_train,rank3] = UDP(X_train,X_test,knn);
        
        %DLDA
        [Y_train,Y_test,rank5] = DLDA(X_train,X_test,c);
        
        %LPP
        X_train = X_train';
        X_test = X_test';
        rehe = constructW(X_train,options);
        [eigvector] = LPP(X_train,rehe, options);
        LPP_train = (X_train * eigvector)'  ;
        LPP_test =  (X_test * eigvector)' ;
        rank4 = size(eigvector,2);
        X_train = X_train';
        X_test = X_test';
        
        % Calculate LPP algorithm classification accuracy
        
        [scorea,la] = LPPTeststage(LPP_test,LPP_train,training_number(i),rank4,C,c,pn)
        scoreaa(j,i) = scorea
        % Calculate fpknmf algorithm classification accuracy
        [l1,score1] = testStage(A,B,C,W3,X,d3,training_number(i),pn,c);
        score11(j,i) = score1
        
        % Calculate pknmf algorithm classification accuracy
        [l2,score2] = pknmftestStage(A,B,C,W2,X,d2,training_number(i),c,pn);
        score22(j,i) = score2
        
        % Calculate pnmf algorithm classification accuracy
        [l3,score3] = pknmftestStage(A,B,C,W1,X,d2,training_number(i),c,pn);
        score33(j,i) = score3
        
        % Calculate cknmf algorithm classification accuracy
        [l4,score4] = cknmftestStage(A,B,C,W4,X,d4,training_number(i),alpha,sigma,c,pn);
        score44(j,i) = score4
        
        % Calculate PCA algorithm classification accuracy
        [score5,l5] = pcaTeststage(P_test,P_train,training_number(i),rank1,C,c,pn);
        score55(j,i) = score5
        
        % Calculate KPCA algorithm classification accuracy
        [score6,l6] = kpcaTeststage(PV_test,PV_train,training_number(i),rank2,C,c,pn);
        score66(j,i) = score6
        
        % Calculate UDP algorithm classification accuracy
        [score7,l7] = UDPTeststage(w_test,w_train,training_number(i),rank3,C,c,pn);
        score77(j,i) = score7
        
        [l8,score8] = GtestStage(A,B,C,A0,B3,X3,K,X_train,training_number(i),sigma00,pn,c);
        score88(j,i) = score8
        % Calculate DLDA algorithm classification accuracy
        [score9,l9] = DLDATeststage(Y_test,Y_train,training_number(i),rank5,C,c,pn);
        score99(j,i) = score9
        
        % Calculate RSNMF algorithm classification accuracy
        [score10,l10] = rsnmfTest(training_number(i),X_test,X_train,C,c,pn);
        score1010(j,i) = score10
        
        [sum_cmc_counta] = cmc(la,rank,C,training_number(i),c,pn);
        sum_cmc_countaa(j,:) = sum_cmc_counta;
        [sum_cmc_count1] = cmc(l1,rank,C,training_number(i),c,pn);
        sum_cmc_count11(j,:) = sum_cmc_count1;
        [sum_cmc_count2] = cmc(l2,rank,C,training_number(i),c,pn);
        sum_cmc_count22(j,:) = sum_cmc_count2;
        [sum_cmc_count3] = cmc(l3,rank,C,training_number(i),c,pn);
        sum_cmc_count33(j,:) = sum_cmc_count3;
        [sum_cmc_count4] = cmc(l4,rank,C,training_number(i),c,pn);
        sum_cmc_count44(j,:) = sum_cmc_count4;
        [sum_cmc_count5] = cmc(l5,rank,C,training_number(i),c,pn);
        sum_cmc_count55(j,:) = sum_cmc_count5;
        [sum_cmc_count6] = cmc(l6,rank,C,training_number(i),c,pn);
        sum_cmc_count66(j,:) = sum_cmc_count6;
        [sum_cmc_count7] = cmc(l7,rank,C,training_number(i),c,pn);
        sum_cmc_count77(j,:) = sum_cmc_count7;   
        [sum_cmc_count8] = cmc(l8,rank,C,training_number(i),c,pn);
        sum_cmc_count88(j,:) = sum_cmc_count8; 
        [sum_cmc_count9] = cmc(l9,rank,C,training_number(i),c,pn);
        sum_cmc_count99(j,:) = sum_cmc_count9;
        [sum_cmc_count10] = cmc(l10,rank,C,training_number(i),c,pn);
        sum_cmc_count1010(j,:) = sum_cmc_count10;
    end
    sum_cmc_countaaa(i,:) = sum(sum_cmc_countaa) / 10;
    sum_cmc_count111(i,:) = sum(sum_cmc_count11) / 10;
    sum_cmc_count222(i,:) = sum(sum_cmc_count22) / 10;
    sum_cmc_count333(i,:) = sum(sum_cmc_count33) / 10;
    sum_cmc_count444(i,:) = sum(sum_cmc_count44) / 10;
    sum_cmc_count555(i,:) = sum(sum_cmc_count55) / 10;
    sum_cmc_count666(i,:) = sum(sum_cmc_count66) / 10;
    sum_cmc_count777(i,:) = sum(sum_cmc_count77) / 10; 
    sum_cmc_count888(i,:) = sum(sum_cmc_count88) / 10; 
    sum_cmc_count999(i,:) = sum(sum_cmc_count99) / 10;
    sum_cmc_count101010(i,:) = sum(sum_cmc_count1010) / 10;
  
end
scoreaaa = sum(scoreaa) / 10;
score111 = sum(score11) / 10;
score222 = sum(score22) / 10;
score333 = sum(score33) / 10;
score444 = sum(score44) / 10;
score555 = sum(score55) / 10;
score666 = sum(score66) / 10;
score777 = sum(score77) / 10;
score888 = sum(score88) / 10;
score999 = sum(score99) / 10;
score101010 = sum(score1010) / 10;








