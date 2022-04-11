function[W_new,H_new] = cknmfUpdate(X,W,H,K_WX,K_WW,d,alpha,sigma)
%     Calculate for each iteration of the basis matrix and the
%     eigencoefficient matrix by the cknmf agorithm
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
%                  'd'          - Combined Kernel function parameter
%
%                  'alpha'      - Combined Kernel function parameter 
%                             
%                  'sigma'      - Combined Kernel function parameter
%                             
%   Output         'W_new'  - the new basis matrix
% 
%                  'H_new'  -the new eigencoefficient matrix
%
H_new = H .* (K_WX ./ (K_WW * H));


P1 = bsxfun(@plus,dot(X.^d,X.^d,1)',dot(W.^d,W.^d,1) - 2 * (X'.^d * W.^d));
P = exp( - P1 ./ (2 * sigma * sigma));
% for i =1:r
%      P(:,i) = exp(-diag((X .^ d - W(:,i) .^ d)' * (X .^ d - W(:,i) .^ d)) / (2 * sigma * sigma))
% end

Q1 = bsxfun(@plus,dot(W.^d,W.^d,1)',dot(W.^d,W.^d,1) - 2 * (W'.^d * W.^d));
Q = exp( - Q1 ./ (2 * sigma * sigma));
% for i = 1:r
%      Q(:,i) = exp(-diag((W.^ d - W(:,i) .^ d)' * (W .^ d - W(:,i) .^ d)) / (2 * sigma * sigma))
% end

numerator = alpha * (X .^ d) *  H_new' + ((1 - alpha) / sigma ^ 2) *...
X.^d * (H_new' .* P) + ((1 - alpha) / sigma ^ 2)  * W.^d * diag(diag(((H_new * H_new') * Q)));
denominator = alpha * W .^ d * (H_new * H_new')...
+((1 - alpha) / sigma ^ 2) * W .^ d * diag(diag(H_new * P))  ...
+((1 - alpha) / sigma ^ 2) * W .^ d * ((H_new * H_new') .* Q);
        
W_new = W .* (numerator ./ denominator);


s = sum(W_new);
m = length(s);
S = zeros(size(W_new));
for j = 1:m
    S(:,j) = s(j);
end
W_new = W_new ./ S;
end