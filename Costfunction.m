%Cost function
function [J] = Costfunction(H,K_XX,K_XW,K_WW)

%   Calculate the cost function 
%
%   Input:         'H'      - Initialized H matrix
%           
%                  'K_XX'   - kernel matrix K_XX
%
%                  'K_XW'   - kernel matrix K_XW
%
%                  'K_WW'   - kernel matrix K_WW 
%
%   Output         'J'      -Loss function value after each iteration
%

J =(1 / 2) * trace(K_XX - 2 * K_XW * H + H' * K_WW * H);

end