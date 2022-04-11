function [Z_new,U_new,V_new,D_new] = rsnmfUpdate(miu,X,U,V,D,I,~,n,p)

%     Calculate for each iteration of the basis matrix and the
%     eigencoefficient matrix by the rsnmf agorithm
%
%   Input:         'miu'   - Regularizer parameter
%           
%                  'X'     - Data matrix
%
%                  'U'     - Initialized U matrix
%
%                  'V'      - Initialized V matrix
%
%                  'D'      - Initialized D matrix D = eye(n);
%
%                  'I'      - Indication matrix
%
%                  'n'      - column dimension of matrix X
%                             
%                  'p'      - the parameters of the L2,p-norm
%                             
%   Output         'Z_new'  - Z_new = X - U_new * V_new
% 
%                  'U_new'  - the new basis matrix
%
%                  'V_new'  - the new eigencoefficient matrix
%
%                  'D_new'  - D(i,i) =p / (2 * (Z_new(:,i)'
%                             * (Z_new(:,i))).^((2 - p) / 2))
%
U_new = U .* ((X * D * V')./(U * V * D * V'));

V_new = V .* ((U' * X * D) ./ ((U' * U * V * D ) +(miu * (I .* V))));

Z_new = X - U_new * V_new;
for i = 1:n
    D(i,i) =p / (2 * (Z_new(:,i)' * (Z_new(:,i))).^((2 - p) / 2));
end    
D_new = D;


U_new = U_new ./ sum(U_new);
V_new = V_new .* (sum(U_new))';
