function [K] = kernelFunction4(matrix1,matrix2,t)
n = size(matrix1,2);
n2 = size(matrix2,2);
K = zeros(n,n2);
for i = 1:n
    for j = 1:n2
        K(i,j) = exp( -sqrt((matrix1(:,i) - matrix2(:,j))' * (matrix1(:,i) - matrix2(:,j))) / t);
    end
end
end