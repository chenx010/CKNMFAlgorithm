function [score,l] = LPPTeststage(LPP_test,LPP_train,training_number,rank,C,c,pn)
n_j = training_number;
r = rank;

M = zeros(r,c);
for i = 1:c
    M(:,i) =sum( LPP_train(:,(i - 1) * n_j + 1 : (i - 1) * n_j + n_j),2) / n_j;
end
H = LPP_test;
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