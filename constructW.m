function W = constructW(fea,options)
%	Usage:
%	W = constructW(fea,options)
%
%	fea: Rows of vectors of data points. Each row is x_i
%   options: Struct value in Matlab. The fields in options that can be set:
%           Metric -  Choices are:
%               'Euclidean' - Will use the Euclidean distance of two data 
%                             points to evaluate the "closeness" between 
%                             them. [Default One]
%                  
%           NeighborMode -  Indicates how to construct the graph. Choices
%                           are: 
%                'KNN'            -  Put an edge between two nodes if and
%                                    only if they are among the k nearst
%                                    neighbors of each other. You are
%                                    required to provide the parameter k in
%                                    the options. [Default One]                                         
%           WeightMode   -  Indicates how to assign weights for each edge
%                           in the graph. Choices are:
%               'HeatKernel'   - If nodes i and j are connected, put weight
%                                W_ij = exp(-norm(x_i - x_j)/t). This
%                                weight mode can only be used under
%                                'Euclidean' metric and you are required to
%                                provide the parameter t.%             
%            k         -   The parameter needed under 'KNN' NeighborMode.
%                          Default will be 3.



if (~exist('options','var'))
   options = [];
else
   if ~strcmpi(class(options),'struct') 
       error('parameter error!');
   end
end

%=================================================
if ~isfield(options,'Metric')
    options.Metric = 'Euclidean';
end

switch lower(options.Metric)
    case {lower('Euclidean')}
        ;
    case {lower('Cosine')}
        if ~isfield(options,'bNormalized')
            options.bNormalized = 0;
        end
    otherwise
        error('Metric does not exist!');
end

%=================================================
if ~isfield(options,'NeighborMode')
    options.NeighborMode = 'KNN';
end

switch lower(options.NeighborMode)
    case {lower('KNN')}  %For simplicity, we include the data point itself in the kNN
        if ~isfield(options,'k')
            options.k = 5;
        end
        if options.k < 1
            options.k = 1;
        end
    case {lower('epsilonNeighbor')}
        if ~isfield(options,'epsilon')
            options.epsilon = 0.5;
        end
    case {lower('Supervised')}
        if ~isfield(options,'bLDA')
            options.bLDA = 0;
        end
        if options.bLDA
            options.bSelfConnected = 1;
        end
        if ~isfield(options,'gnd')
            error('Label(gnd) should be provided under ''Supervised'' NeighborMode!');
        end
        if length(options.gnd) ~= size(fea,1)
            error('gnd doesn''t match with fea!');
        end
    otherwise
        error('NeighborMode does not exist!');
end

%=================================================

if ~isfield(options,'WeightMode')
    options.WeightMode = 'Binary';
end

switch lower(options.WeightMode)
    case {lower('Binary')}
        ;
    case {lower('HeatKernel')}
        if ~strcmpi(options.Metric,'Euclidean')
            warning('''HeatKernel'' WeightMode should be used under ''Euclidean'' Metric!');
            options.Metric = 'Euclidean';
        end
        if ~isfield(options,'t')
            options.t = 1;
        end
    case {lower('Cosine')}
        if ~strcmpi(options.Metric,'Cosine')
            warning('''Cosine'' WeightMode should be used under ''Cosine'' Metric!');
            options.Metric = 'Cosine';
        end
        if ~isfield(options,'bNormalized')
            options.bNormalized = 0;
        end
    otherwise
        error('WeightMode does not exist!');
end

%=================================================

if ~isfield(options,'bSelfConnected')
    options.bSelfConnected = 1;
end

%=================================================
[nSmp, nFea] = size(fea);


if strcmpi(options.NeighborMode,'Supervised') & (options.bLDA | strcmpi(options.WeightMode,'Binary'))
    ;
else
    bDistance = 0;
    if strcmpi(options.Metric,'Euclidean')
        D = zeros(nSmp);
        for i=1:nSmp-1
            for j=i+1:nSmp
                D(i,j) = norm(fea(i,:) - fea(j,:));
            end
        end
        D = D+D';
        bDistance = 1;
    else
        if options.bNormalized
            D = fea * fea';
        else
            feaNorm = sum(fea.^2,2).^.5;
            fea = fea ./ repmat(max(1e-10,feaNorm),1,size(fea,2));
            D = fea * fea';
        end
    end
end


switch lower(options.NeighborMode)
    case {lower('KNN')}
        if options.k >= nSmp
            G = ones(nSmp,nSmp);
        else
            G = zeros(nSmp,nSmp);
            if bDistance
                [dump idx] = sort(D, 2); % sort each row
            else
                [dump idx] = sort(-D, 2); % sort each row
            end
            for i=1:nSmp
                G(i,idx(i,1:options.k+1)) = 1;
            end
        end
    case {lower('epsilonNeighbor')}
        if bDistance
            [i,j] = find(D < options.epsilon);
        else
            [i,j] = find(D > options.epsilon);
        end
        G = sparse(i,j,1);
    case {lower('Supervised')}
        G = zeros(nSmp,nSmp);

        Label = unique(options.gnd);
        nLabel = length(Label);
        if options.bLDA
            for idx=1:nLabel
                classIdx = find(options.gnd==Label(idx));
                G(classIdx,classIdx) = 1/length(classIdx);
            end
            W = sparse(G);
            return;
        else
            for idx=1:nLabel
                classIdx = find(options.gnd==Label(idx));
                G(classIdx,classIdx) = 1;
            end
        end
        
        if strcmpi(options.WeightMode,'Binary')
            if ~options.bSelfConnected
                G  = G - diag(diag(G));
            end
            W = sparse(G);
            return;
        end
    otherwise
        error('NeighborMode does not exist!');
end

if ~options.bSelfConnected
    G  = G - diag(diag(G));
end

switch lower(options.WeightMode)
    case {lower('Binary')}
        W = max(G,G');
        W = sparse(W);
    case {lower('HeatKernel')}
        D = exp(-D.^2/options.t);
        W = D.*G;
        W = max(W,W');
        W = sparse(W);
    case {lower('Cosine')}
        W = D.*G;
        W = max(W,W');
        W = sparse(W);
    otherwise
        error('WeightMode does not exist!');
end



