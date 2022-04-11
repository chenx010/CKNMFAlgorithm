function [score,l] = rsnmfTest(training_number,X_test,X_train,C,c,pn)
%        --- Calculate rsnmf algorithm classification accuracy---
%
%	Input:     'training_number'- The number of training samples selected 
%                              by each individual   
%                  'X_train'         - training set 
%
%                  'X_test'          -  test set 

%                  'C'       - Class labeles
%     
%                  'c'       - Number of classes per dataset
%                  
%                  'pn'      - Number of photos per classes
%
%   Output:        'l'       -The distance between the feature vector 
%                             of the test sample and the center feature
%
%                 'score'    -Classification accuracy
n_j = training_number;
X = [X_train X_test];
[d,n] = size(X);
r =300;
U = abs(rand(d,r));
for i = 1:r
    U(:,i) = U(:,i) ./ sum(U(:,i));
end
V = abs(rand(r,n));


[~,l] = size(X_train);
[~,u] = size(X_test);

m = floor(r / c);
  
O_matrix = ones(m,n_j);

for i = 1:c
    I1((i - 1) * m + 1:(i - 1) * m + m,(i - 1) * n_j + 1:(i - 1) * n_j + n_j) = O_matrix;
end
        
for i = 1:r
    for j = 1:l
        if I1(i,j) == 0
            I1(i,j) = 1;
        else 
            I1(i,j) = 0;
        end
    end
end
O = zeros(r,u);
I = [I1 O];

miu = 0.1;
p = 0.5;
D = eye(n);

I_max = 400;
J_record5 = [];
for i = 1:I_max
    [Z,U,V,D] = rsnmfUpdate(miu,X,U,V,D,I,d,n,p);
    [J5] = RSNMFcostFunction(miu,p,Z,I,V,D);
    J_record5 = [J_record5 J5];
end    

n_j = training_number;
M = zeros(r,c);
for i = 1:c
    M(:,i) =sum( V(:,(i - 1) * n_j + 1 : (i - 1) * n_j + n_j),2) / n_j;
end
H = V(:,l+1:end);

k=(pn - n_j) * c;
l = zeros(k,c);
for i = 1:k
    for j = 1:c 
        l(i,j) = (sqrt((H(:,i) - M(:,j))' * (H(:,i) - M(:,j))));
    end
end
[~,index] = min(l,[],2);
count=sum(C==index);
score = (count / k) * 100;
