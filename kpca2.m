function [train_kpca,test_kpca,rank] =kpca2(train,test)
%                        ----KPCA agorithm----
%
%   Input:         'train'    - Training set matrix
%           
%                  'test'     - Test set matrix
%                             
%   Output         'train_kpca'      - training set after projection
%
%                  'test_kpca'       - test set after projection
%
%                  'rank'            - dimension after projection
%
train = train'*255;
test = test'*255;
% Function default settings
if nargin <4
% rbf_var=400;%yale
rbf_var=2500;

end

if nargin <3
threshold = 90;
end

% data processing
patterns=zscore(train);
test_patterns=zscore(test);
train_num=size(patterns,1);
test_num=size(test_patterns,1);
cov_size = train_num; 

% Calculate the kernel matrix
for i=1:cov_size
    for j=i:cov_size
        K(i,j) = exp(-norm(patterns(i,:)-patterns(j,:))^2/rbf_var); 
        K(j,i) = K(i,j);
    end
end
unit = ones(cov_size, cov_size)/cov_size;

% Centralized Kernel Matrix
K_n = K - unit*K - K*unit + unit*K*unit;

% Eigenvalue Decomposition
[evectors_1,evaltures_1] = eig(K_n/cov_size);
[x,index]=sort(real(diag(evaltures_1)));
evals=flipud(x) ;
index=flipud(index);

%Sort eigenvectors in order of magnitude of eigenvalues
evectors=evectors_1(:,index);

train_eigval = 100*cumsum(evals)./sum(evals);
index = find(train_eigval >threshold);


train_kpca=(K_n * evectors(:,1:index(1)))';

unit_test =ones(test_num,cov_size)/cov_size;
K_test = zeros(test_num,cov_size); 
for i=1:test_num

    for j=1:cov_size
        K_test(i,j) =exp(-norm(test_patterns(i,:)-patterns(j,:))^2/rbf_var);
    end
end
K_test_n = K_test - unit_test*K - K_test*unit +unit_test*K*unit;

test_kpca = (K_test_n * evectors(:,1:index(1)))';
rank = size(test_kpca,1);

