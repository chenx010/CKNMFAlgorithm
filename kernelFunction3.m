function [K] = kernelFunction3(matrix1,matrix2,d,alpha,sigma)
%   Combined Kernel Function
%
%   Input:         'matrix1'   - the first matrix input to the kernel function
%           
%                  'matrix2'   - the second matrix input to the kernel function
%
%                  'd'£¬'sigma'£¬'alpha' - Combined Kernelfunction parameter 
%
%   Output         'K'         - Kernel matrix
%                  
K1 = alpha * (matrix1 .^ d)' * matrix2 .^ d ;
D = bsxfun(@plus,dot(matrix1.^d,matrix1.^d,1)',dot(matrix2.^d,matrix2.^d,1) - 2 * (matrix1'.^d * matrix2.^d));
K2 = exp( - D ./ (2 * sigma * sigma));
% for i =1:n2
%         K2(:,i) = (1 - alpha) * exp(-diag((matrix1 .^ d - matrix2(:,i) .^ d)' * (matrix1 .^ d - matrix2(:,i) .^ d) / (2 * sigma * sigma)));
% end  
K = K1 +(1 - alpha) * K2;
end
