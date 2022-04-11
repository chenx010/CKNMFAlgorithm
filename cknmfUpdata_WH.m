function [W4,H4,J4] =cknmfUpdata_WH(I_max,epsilon1,W,H,X_train)

%   CKNMF algorithm iteratively updates W,H
%
%   Input:         'I_max'      - The maximum number of iterations
%           
%                  'epsilon1'   - Iteration stop condition
%
%                  'W'          - Initialized W matrix 
%                              
%                  'H'          - Initialized H matrix 
%                                
%                  'X_train'    - Training set matrix
%
%   Output         'W4'         - W matrix after iteration
%                  
%                  'H4'         - H matrix after iteration
%
%                  'J4'         - Loss function value after each iteration 
J_record4 = [];
W4 = W;
X4 = X_train;
H4 = H;
d4 = 0.5;
alpha = 0.95;
sigma = 0.05;
for t=1:I_max
    [K_WW4] = kernelFunction3(W4,W4,d4,alpha,sigma);
    [K_WX4] = kernelFunction3(W4,X4,d4,alpha,sigma);
    [K_XX4] = kernelFunction3(X4,X4,d4,alpha,sigma);
    [K_XW4] = kernelFunction3(X4,W4,d4,alpha,sigma);
    [J4] = Costfunction(H4,K_XX4,K_XW4,K_WW4)
    J_record4 = [J_record4 J4];
    [W4,H4] = cknmfUpdate(X4,W4,H4,K_WX4,K_WW4,d4,alpha,sigma);
    if t>=2 && abs((J_record4(t)-J_record4(t-1)))< epsilon1
        break
    end
end 