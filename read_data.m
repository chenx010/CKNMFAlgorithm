function [X,training_number,r,c,pn] = read_data(idx)
%   read database:
%
%	Input:  idx =1;id = 2;represents the corresponding dataset yale,pe...
%
%   Output:        'X'       - data matrix
%           
%           'training_number'- The number of training samples selected 
%                              by each individual
%
%                  'r'       - Dimensionality after dimensionality 
%                              reduction
%
%                  'c'       - Number of classes per dataset
%                  
%                  'pn'      - Number of photos per classes


            

a1 = load('yale.mat');
a2 = load('pe.mat');
a3 = load('feret.mat');
a4 = load('cmu.mat');
a5 = load('gt.mat');
a6 = load('orl.mat');

b1 = a1.yale;
b2 = a2.pe;
b3 = a3.feret;
b4 = a4.cmu;
b5 = a5.gt;
b6 = a6.orl;
a = cell(6,1);
a{1} = b1;
a{2} = b2;
a{3} = b3;
a{4} = b4;
a{5} = b5;
a{6} = b6;

% data matrix
X = a{idx};

% The number of training samples selected by each individual
TN = cell(6,1);
TN{1} = 3:10;
TN{2} = 2:6;
TN{3} = 2:5;
TN{4} = 7:2:17;
TN{5} = 7:14;
TN{6} = 3:2:9;
training_number = TN{idx};

% Feature dimension selection
feature =cell(6,1);
feature{1} = [300,300,300,300,300,300,300,300];
feature{2} = [300,300,300,300,300];
feature{3} = [300,300,300,300];
feature{4} = [300,300,300,300,300,300,300,300,300,300,300];
feature{5} = [300,300,300,300,300,300,300,300];
feature{6} = [300,300,300,300];
r = feature{idx};

% classes
class_num = [15,12,120,68,50,40]; 
c = class_num(idx);

% Number of photos per classes
photo_num = [11,7,6,56,15,10];
pn = photo_num(idx);
end