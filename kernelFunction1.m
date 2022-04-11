function [K] = kernelFunction1(matrix1,matrix2,d)
%   polynomial kernel 
%
%   Input:         'matrix1'   - the first matrix input to the kernel function
%           
%                  'matrix2'   - the second matrix input to the kernel function
%
%                  'd'         - polynomial kernel function parameter 
%
%   Output         'K'         - Kernel matrix
K = (matrix1' * matrix2) .^ d;

end

