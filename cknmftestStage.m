function [l,score] = cknmftestStage(A,B,C,W3,X3,d3,training_number,alpha,sigma,c,pn)
%        --- Calculate cknmf algorithm classification accuracy---
%
%	Input:         'A'       - The label matrix corresponding to the test set
%
%                  'B'       - The selected training set corresponds to the columns of the matrix
%
%                  'C'       - Class labeles
%      
%                  'W3'      - the new basis matrix calculated by cknmf algorithm 
%   
%                  'X3'      - Data matrix
%
%                  'd3'      - Combined Kernel function parameter
%
%           'training_number'- The number of training samples selected 
%                              by each individual
%
%                  'alpha'   - Combined Kernel function parameter 
%                             
%                  'sigma'   - Combined Kernel function parameter
%
%                  'c'       - Number of classes per dataset
%                  
%                  'pn'      - Number of photos per classes
%
%   Output:        'l'       -The distance between the feature vector 
%                             of the test sample and the center feature
%
%                 'score'    -Classification accuracy

n_j = training_number;


[K_WW4] = kernelFunction3(W3,W3,d3,alpha,sigma);

L = ones(n_j,1);


M=zeros(size(W3,2),1);

for j=1:c
    [K_WX4] = kernelFunction3(W3,X3(:,B(:,j)),d3,alpha,sigma);
    M(:,j)= (1 / n_j) * pinv(K_WW4) * K_WX4 * L;
end

%º∆À„h_j

k=(pn - n_j) * c;


H4 = zeros(size(W3,2),k);
for i = 1:k
    K_Wy = kernelFunction3(W3,X3(:,A(i)),d3,alpha,sigma);
    H4(:,i) = pinv(K_WW4) * K_Wy;
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