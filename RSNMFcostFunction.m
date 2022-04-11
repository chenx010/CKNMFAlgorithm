function [J] = RSNMFcostFunction(miu,p,Z,I,V,D)
%   Calculate the cost function 
%
%   Input:         'miu'   - Regularizer parameter
%        
%                  'p'     - the parameters of the L2,p-norm
%                     
%                  'Z'     - Z = X - U * V
% 
%                  'I'     - Indication matrix
%
%                  'D'     - Initialized D matrix D = eye(n);
%
%   Output         'J'     -Loss function value after each iteration
%
subject = (2 / p) * trace(Z * D * Z');
regular = (miu / 2) * trace((I .* V)'* (I .* V));
J = subject + regular;
end