function [B3,H8,K_sq,K] = initial_BH(X_train,r,sigma)
%   Randomly initialize B and H matrices of GNMF algorithm
%
%   Input:      'X_train'    - Training set matrix
%          
%                  'r'       - Dimensionality after dimensionality 
%                              reduction
%
%                  'sigma'   - Gaussian kernel function parameter ¦Ò
%
%   Output         'B3'       - Initialized B matrix
%                  
%                  'H8'       - Initialized H matrix
%
%                  'K_sq'    - Kernel matrix under the square root  
%
%                  'K'       - Kernel matrix


K =  kernelFunction6(X_train,X_train,sigma);
[U,S,V]=svd(K);
K_sq0 = U*sqrt(S)*V';
K_sq = max(K_sq0,0);
[~,n] = size(X_train);
B3 = abs(rand(n,r));
for i = 1:r
    B3(:,i) = B3(:,i) ./ sum(B3(:,i));
end
H8 = abs(rand(r,n));