function [eigvector, eigvalue, Y] = LPP(X, W, options)
% LPP: Locality Preserving Projections
%
%       [eigvector, eigvalue] = LPP(X, W, options)
% 
%             Input:
%               X       - Data matrix. Each row vector of fea is a data point.
%               W       - Affinity matrix. You can either call "constructW"
%                         to construct the W, or construct it by yourself.
%                         options = [];
%                         options.Metric = 'Euclidean';
%                         options.NeighborMode = 'KNN';
%                         options.k = 3;
%                         options.WeightMode = 'HeatKernel';
%                         options.t = 1;
%                         options.PCARatio = 0.96;
%             Output:
%               eigvector - Each column is an embedding function, for a new
%                           data point (row vector) x,  y = x*eigvector
%                           will be the embedding result of x.
%               eigvalue  - The eigvalue of LPP eigen-problem. sorted from
%                           smallest to largest. 
% 



if (~exist('options','var'))
   options = [];
else
   if ~strcmpi(class(options),'struct') 
       error('parameter error!');
   end
end

if ~isfield(options,'PCARatio')
    [eigvector_PCA, eigvalue_PCA, meanData, new_X] = PCA(X);
else
    PCAoptions = [];
    PCAoptions.PCARatio = options.PCARatio;
    [eigvector_PCA, eigvalue_PCA, meanData, new_X] = PCA(X,PCAoptions);
end
    
old_X = X;
X = new_X;


[nSmp,nFea] = size(X);

if nFea > nSmp
    error('X is not of full rank in column!!');
end

if ~isfield(options,'ReducedDim')
    ReducedDim = nFea; 
else
    ReducedDim = options.ReducedDim; 
end

if ReducedDim > nFea
    ReducedDim = nFea; 
end


D = diag(sum(W));
%L = D - W;
L = W;

DPrime = X'*D*X;
DPrime = max(DPrime,DPrime');
LPrime = X'*L*X;
LPrime = max(LPrime,LPrime');    

dimMatrix = size(DPrime,2);
if dimMatrix > 1000 & ReducedDim < dimMatrix/10  % using eigs to speed up!
    option = struct('disp',0);
    [eigvector, eigvalue] = eigs(LPrime,DPrime,ReducedDim,'la',option);
    eigvalue = diag(eigvalue);
else
    [eigvector, eigvalue] = eig(LPrime,DPrime);
    eigvalue = diag(eigvalue);
    
    [junk, index] = sort(-eigvalue);
    eigvalue = eigvalue(index);
    eigvector = eigvector(:,index);
end

eigvalue = ones(length(eigvalue),1) - eigvalue;

if ReducedDim < size(eigvector,2)
    eigvector = eigvector(:, 1:ReducedDim);
    eigvalue = eigvalue(1:ReducedDim);
end

for i = 1:size(eigvector,2)
    eigvector(:,i) = eigvector(:,i)./norm(eigvector(:,i));
end

eigvector = eigvector_PCA*eigvector;


if nargout == 3
    Y = old_X * eigvector;
end

