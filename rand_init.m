function [X_test,X_train,A,B,B2,C]=rand_init(X,training_number,c,pn)
%   Randomly assign training and test sets:

%   Input:         'X'       - Data matrix
%           
%           'training_number'- The number of training samples selected 
%                              by each individual
%
%                  'c'       - Number of classes per dataset
%                  
%                  'pn'      - Number of photos per classes
%
%	Output:     'X_test'     -Test set matrix
%             
%               'X_train'    -Training set matrix
%
%                  'A'       - The label matrix corresponding to the test set
%
%                  'B'       - The selected training set corresponds to the columns of the matrix
%
%                 'B2'       - Class labels corresponding to the training set
%
%                 'C'        - Class labeles

n_j = training_number;

A = 1:(c * pn);
A = reshape(A,pn,c);

[m,n] = size(A);
B = zeros(n_j,n);

for i = 1:n
    B(:,i) = A(randperm(m,n_j),i);
end
B2=B;

X_train = X(:,B(:));
A(B) = [];
X_test = X(:,A);

C=reshape(A,pn - n_j,[]);
for i = 1:c
    C(:,i) = i;
end 
C = C(:);
for i = 1:c
    B2(:,i) = i;
end
B2 = B2(:);
end

