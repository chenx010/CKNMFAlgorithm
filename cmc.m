function [sum_cmc_count] = cmc(l,rank,C1,training_number,c,pn)
%Calculate the cmc value 
%
%	Input:           'l'      - The distance between the feature vector 
%                               of the test sample and the center feature
%
%                  'rank'     - A rank value of 5 indicates the correct
%                               rate of classification within five guesses
%
%                  'C1'       - Class labeles
%      
%           'training_number' - The number of training samples selected 
%                               by each individual
%
%                  'c'        - Number of classes per dataset
%                  
%                  'pn'       - Number of photos per classes
%
%   Output:        'sum_cmc_count'   - cmc value matrix
%



CMC = zeros(size(l));
for i = 1:size(l,1)
    [~,cmc_index] = sort(l(i,:));
    CMC(i,:) = cmc_index;
end

n_j = training_number;
k=(pn - n_j) * c;


cmc_count = zeros(k,rank);
for j = 1:k
    for i = 1:rank
        if ismember(C1(j),CMC(j,1:i)) == 1
            cmc_count(j,i) = 1;
        end
    end
end
sum_cmc_count = (sum(cmc_count) / k) * 100;
end