function[w_test,w_train,rank] = UDP(X_train,X_test,knn)

%                        ----UDP algorithm----
%
%   Input:         'X_train'    - Training set matrix
%           
%                  'X_test'     - Test set matrix
%
%                  'knn' - number of neighbors
%
%                             
%   Output         'w_train'         - training set after projection
%
%                  'w_test'          - test set after projection
%
%                  'rank'            - dimension after projection
%
[~,n] =size(X_train);
H = zeros(n,n);
dis = zeros(n,n);
for i = 1:n
    for j = 1:n
        dis(i,j) = (X_train(:,i) - X_train(:,j))' * (X_train(:,i) - X_train(:,j));
    end
end
for i = 1:n
    [~,index(i,:)] = sort(dis(i,:));
end
index = index(:,1:knn);
o = zeros(n,n-knn);
index = [index o];

for i = 1:n
    for j = 1:n
        if index(i,j) ~= 0
               H(i,index(i,j)) = 1;
               H(index(i,j),i) = 1;      
        end
    end
end
S1 = sum(H,2);
D = zeros(n,n);
for i =1:n
    D(i,i) = S1(i);
end
L = D - H;
X_mean = mean(X_train,2);
S_T = (X_train -X_mean) * (X_train -X_mean)' / n;
[U, S] = eig(S_T');
S = diag(S);
[~, index] = sort(S, 'descend');  
S = S(index);  
U = U(:, index) ;
rank1 = 0;  
for i = 1 : size(U,2)  
    if S(i) < 1e-3  
        break;  
    else
        U(:, i) = U(:, i) ./ sqrt(S(i));
    end  
    rank1 = rank1 + 1;  
end  
K = rank1;
S_T =diag(S(1:K));
Z = projectData(X_train', U, K);
Z = Z';
S_L = (Z * L * Z') /(n * n);
S_N = S_T - S_L;

[U2,~] = eig(S_N,S_L);

w_train = (U (:,1:K) * U2)' * X_train;
w_test = (U (:,1:K) * U2)' * X_test;
rank = K;
end