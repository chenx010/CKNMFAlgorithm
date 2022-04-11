function [W,H] = initial_WH(X_train,r)

%   Randomly initialize W and H matrices
%
%   Input:      'X_train'    - Training set matrix
%           
%                  'r'       - Dimensionality after dimensionality 
%                              reduction
%
%   Output         'W'       - Initialized W matrix
%                  
%                  'H'       - Initialized H matrix
%

[m,n] = size(X_train);
W = abs(rand(m,r));
for i = 1:r
    W(:,i) = W(:,i) ./ sum(W(:,i));
end
H = abs(rand(r,n));