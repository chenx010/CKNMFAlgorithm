
function [Y_train,Y_test,rank3] = DLDA(X_train,X_test,c)
%                        ----UDP algorithm----
%
%   Input:         'X_train'    - Training set matrix
%           
%                  'X_test'     - Test set matrix
%
%                  'c'          - number of classes
%
%                             
%   Output         'Y_train'         - training set after projection
%
%                  'Y_test'          - test set after projection
%
%                  'rank3'            - dimension after projection
%
[m,n] = size(X_train);
X_average = (1 / n) * sum(X_train,2);

x_average = zeros(m,c);

k = n / c;
for i = 1: c
    x_average(:,i) = (1 / k) * sum(X_train(:,(i - 1) * k + 1:(i - 1) * k + k),2);
end  


S_b = (1/n) * (k * (x_average - X_average) * (x_average - X_average)');

S_w = zeros(m,m);
for i = 1:c
    S_w = S_w + 1 / n  * (X_train -x_average(:,i)) * ...
    (X_train -x_average(:,i))';
end

[U,V] = svd(S_b);

V = diag(V);

 % filter eigenvalues and eigenvectors 
[~, index] = sort(V, 'descend');  
V = V(index);  
U = U(:, index);  
rank = 0;  
for i = 1 : size(U, 2)  
    if V(i) < 1e-03  
        break;  
    else  
        U(:, i) = U(:, i) ./ sqrt(V(i));  
    end  
    rank = rank + 1 ;
end  
U = U(:, 1 : rank);
V = diag(V(1:rank,:));
M =zeros(rank,rank);
for i = 1:rank
    M(i,i) = V(i,i).^(-1/2); 
end
H = U * M;

Z = H' * S_w * H ;
[U_b,V_b,~] = svd(Z);
V_b = diag(V_b);
  
[~, index] = sort(V_b);  
V_b = V_b(index);  
U_b = U_b(:, index);  
rank = 0;  
for i = 1 : size(U_b, 2)  
    if V_b(i)  > 2000000
        break;  
    else  
        U_b(:, i) = U_b(:, i) ./ sqrt(V_b(i));  
    end  
    rank = rank + 1 ;
end  
rank = rank -1;
U_b = U_b(:, 1 : rank);
V_b = diag(V_b(1:rank,:));
T =zeros(rank,rank);
for i = 1:rank
    T(i,i) = V_b(i,i).^(-1/2); 
end
P = H * U_b;
P2 = P * T;

Y_train =P2' * X_train;
Y_test =P2' * X_test;
rank3 =size(Y_train,1);




