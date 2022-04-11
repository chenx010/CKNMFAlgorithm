function  [PCAeigenvector,P_train,P_test,rank]=pca1(X_train,X_test,getpercent)
%                        ----PCA algorithm----
%
%   Input:         'X_train'    - Training set matrix
%           
%                  'X_test'     - Test set matrix
%
%                  'getpercent' - Principal Component Proportion
%
%                             
%   Output         'PCAeigenvector'  - eigenvector
% 
%                  'P_train'         - training set after projection
%
%                  'P_test'          - test set after projection
%
%                  'rank'            - dimension after projection
%

%pca normalizes the data
X_train = X_train';
X_test = X_test';
psize=size(X_train);
m=psize(2);
n=psize(1);

R=(X_train'*X_train)/(n-1); %Sample correlation coefficient matrix R

[v,e]=eig(R);

ee=diag(e);%Eigenvalues
v=v';
%Orthogonalize the eigenvector unit to get B
B(1,:)=v(1,:);
for i=2:m  
    for j=1:i-1
        B(i,:)=v(i,:)-(sum(v(i,:).*B(j,:))/sum(B(j,:).*B(j,:)))*B(j,:);
    end
end
for i=1:m
    s=0;
    for j=1:m
       s=s+B(i,j)*B(i,j);
    end
    B(i,:)=B(i,:)/sqrt(s);
end
sign=[ee B]; %Combine the eigenvalues and eigenvectors into a matrix , the first column is the eigenvalue, and each subsequent row corresponds to the eigenvector
[signsort,ix]=sort(sign,1,'descend');
for i=1:m
    for j=2:m+1
        signsort(i,j)=sign(ix(i,1),j);  
    end
end

pp=sum(signsort(:,1));
for i=1:m
    le(i)=signsort(i,1)/pp; %Eigenvalue contribution rate
end
leiji(1)=le(1);
for i=2:m     %Calculate the cumulative contribution rate
    leiji(i)=leiji(i-1)+le(i);   
end
t=1;
for i=1:m
    if leiji(i)>=getpercent
        t=i;
        break;
    end
end
PCAeigenvector=signsort(1:t,2:m+1)';

P_train = (X_train * PCAeigenvector)';
P_test = (X_test * PCAeigenvector)';
rank = size(P_test,1);



    
