function[A0,B3,H8] = gnmfUpdate(B3,H8,K_sq)
%     Calculate for each iteration of the basis matrix and the
%     eigencoefficient matrix by the cknmf agorithm
%
%   Input:         'B3'          - The auxiliary matrix
%           
%                  'H8'          - the eigencoefficient matrix
%
%                  'K_sq'       - Kernel matrix under the square root
%
%                             
%   Output         'A0'  -A0 =( K^(1/2))^(-1)* B0
%
%                  'B3'  -the new  auxiliary matrix
%
%                  'H8'  - the new eigencoefficient matrix
%
B3 = B3 .* ((K_sq * H8') ./ ((B3*H8)* H8'));


H8 = H8 .* (B3'*K_sq  ./ (B3'*B3* H8));


A0 = pinv(K_sq)*B3;
end