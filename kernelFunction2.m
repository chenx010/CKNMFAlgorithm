function [K] = kernelFunction2(matrix1,matrix2,d)
%   Fractional Power Inner Product Kernel 
%
%   Input:         'matrix1'   - the first matrix input to the kernel function
%           
%                  'matrix2'   - the second matrix input to the kernel function
%
%                  'd'         - Fractional Power Inner Product Kernel 
%                                function parameter 
%
%   Output         'K'         - Kernel matrix
%                  

K = (matrix1 .^ d)' * (matrix2 .^ d);
end