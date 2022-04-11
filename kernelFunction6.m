function [K] = kernelFunction6(matrix1,matrix2,sigma)
%   Guassian Kernel Function
%
%   Input:         'matrix1'   - the first matrix input to the kernel function
%           
%                  'matrix2'   - the second matrix input to the kernel function
%
%                  'sigma'     - parameter ¦Ò of Guassian Kernel Function 
%
%   Output         'K'         - Kernel matrix
%                  
D = bsxfun(@plus,dot(matrix1,matrix1,1)',dot(matrix2,matrix2,1) - 2 * (matrix1' * matrix2));
K2 = exp( - D ./ (2 * sigma * sigma));

K =  K2;
end