function[W1,H1,J1] =pnmfupdata_WH(I_max,epsilon1,d1,W,H,X_train)
%   PNMF algorithm iteratively updates W,H
%
%   Input:         'I_max'      - The maximum number of iterations
%           
%                  'epsilon1'   - Iteration stop condition
%
%                  'd1'         - polynomial Kernel function parameter
%
%                  'W'          - Initialized W matrix 
%                              
%                  'H'          - Initialized H matrix 
%                                
%                  'X_train'    - Training set matrix
%
%   Output         'W1'         - W matrix after iteration
%                  
%                  'H1'         - H matrix after iteration
%
%                  'J1'         - Loss function value after each iteration 

J_record1 = zeros(1,I_max);
W1 = W;
X1 = X_train;
H1 = H;
for t=1:400
    [K_WW1] = kernelFunction1(W1,W1,d1);
    [K_WX1] = kernelFunction1(W1,X1,d1);
    [K_XX1] = kernelFunction1(X1,X1,d1);
    [K_XW1] = kernelFunction1(X1,W1,d1);
    [J1] = Costfunction(H1,K_XX1,K_XW1,K_WW1);    
    J_record1(t) = J1;
    [W1,H1] = pnmfUpdate(X1,W1,H1,K_WX1,K_WW1,d1);
    if t>=2 && abs(J_record1(t)-J_record1(t-1))< epsilon1
        break
    end
    
end 