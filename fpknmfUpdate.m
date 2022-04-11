function[W_new,H_new] = fpknmfUpdate(X,W,H,K_WX,K_WW,d)
%  Calculate for each iteration of the basis matrix and the eigencoefficient matrix
%
%   Input:         'X'      - Data matrix
%           
%                  'W'      - Initialized W matrix
%
%                  'H'      - Initialized H matrix
%
%                  'K_WX'   - kernel matrix K_WX
%
%                  'K_WW'   - kernel matrix K_WW 
%
%                  'd'      - Fractional Power Inner Product Kernel 
%                             function parameter
%
%   Output         'W_new'  - the new basis matrix
% 
%                  'H_new'  -the new eigencoefficient matrix
%

H_new = H .* (K_WX ./ (K_WW * H));

W_new = W .* ((((X .^ d) *  H_new') ./ ((W .^ d) * (H_new * H_new'))) .^ (1 / d));

s = sum(W_new);
m = length(s);
S = zeros(size(W_new));
for j = 1:m
    S(:,j) = s(j);
end


W_new = W_new ./ S;
end