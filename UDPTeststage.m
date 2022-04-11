function [score,l] = UDPTeststage(w_test,w_train,training_number,rank3,C,c,pn)
%        --- Calculate UDP algorithm classification accuracy---
%
%	Input:         'w_train'         - training set after projection
%
%                  'w_test'          - test set after projection
%
%               'training_number'    - The number of training samples 
%                                      selected by each individual
%
%                  'rank3'            - dimension after projection
%
%                  'C'               - Class labeles
%     
%                  'c'               - Number of classes per dataset
%                  
%                  'pn'              - Number of photos per classes
%
%   Output:        'l'       -The distance between the feature vector 
%                             of the test sample and the center feature
%
%                 'score'    -Classification accuracy
n_j = training_number;
r = rank3;

M = zeros(r,c);
for i = 1:c
    M(:,i) =sum( w_train(:,(i - 1) * n_j + 1 : (i - 1) * n_j + n_j),2) / n_j;
end
H = w_test;
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
end