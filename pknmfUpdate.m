function[W_new,H_new] = pknmfUpdate(X,W,H,K_WX,K_WW,d)
%     Calculate for each iteration of the basis matrix and the
%     eigencoefficient matrix by the pknmf algorithm
%
%   Input:         'X'          - Data matrix
%           
%                  'W'          - Initialized W matrix
%
%                  'H'          - Initialized H matrix
%
%                  'K_WX'       - kernel matrix K_WX
%
%                  'K_WW'       - kernel matrix K_WW 
%
%                  'd'          - polynomial Kernel function parameter
%
%                             
%   Output         'W_new'  - the new basis matrix
% 
%                  'H_new'  - the new eigencoefficient matrix
%

H_new = H .* (K_WX ./ (K_WW * H));

diff_K_XW = d * (X' * W) .^(d - 1) ;

diff_K_WW = d * (W' * W) .^(d - 1);


W_new = W .* ((X * (diff_K_XW .* H_new') ./ (W * (diff_K_WW .* (H_new * H_new')))));

s = sum(W_new);
m = length(s);
S = zeros(size(W_new));
for j = 1:m
    S(:,j) = s(j);
end


W_new = W_new ./ S;
end