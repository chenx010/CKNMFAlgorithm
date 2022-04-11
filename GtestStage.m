function [l,score] = GtestStage(A,B,C,A0,B3,X3,K,X_train,training_number,sigma,pn,c)

%                         -----gnmf algorithm test-----
%
%	Input:         'A'       - The label matrix corresponding to the test set
%
%                  'B'       - The selected training set corresponds to the columns of the matrix
%
%                  'C'       - Class labeles
%      
%                  'A0'       - A0 =( K^(1/2))^(-1)* B0
%  
%                  'B3'       - updated matrix of B3
%  
%                  'K'        -  Kernel matrix
%
%                  'X_train'  - Training set matrix
%
%           'training_number'- The number of training samples selected 
%                               by each individual
%
%                  'c'        - Number of classes per dataset
%                  
%                  'pn'       - Number of photos per classes
%
%                  'sigma'   - Gaussian kernel function parameter ¦Ò
%
%   Output:        'l'       - The distance between the feature vector 
%                              of the test sample and the center feature
%
%                 'score'    - Classification accuracy

n_j = training_number;

L = ones(n_j,1);

M=zeros(size(B3,2),1);

for j=1:c
    [K_XX4] = kernelFunction6(X_train,X3(:,B(:,j)),sigma);
    M(:,j)= (1 / n_j) * pinv(A0)*pinv(K) * K_XX4 * L;
end


k=(pn - n_j) * c;

H4 = zeros(size(B3,2),k);
for i = 1:k
    K_Wy = kernelFunction6(X_train,X3(:,A(i)),sigma);
    H4(:,i) = pinv(A0) *pinv(K) * K_Wy;
end
l = zeros(k,c);
for i = 1:k
    for j = 1:c 
        l(i,j) = (sqrt((H4(:,i) - M(:,j))' * (H4(:,i) - M(:,j))));
    end
end
[~,index] = min(l,[],2);
count=sum(C==index);
score = (count / k) * 100;