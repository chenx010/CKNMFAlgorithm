function[W2,H2,J2] =pknmfupdata_WH(I_max,epsilon1,d2,W,H,X_train)

%   PKNMF algorithm iteratively updates W,H
%
%   Input:         'I_max'      - The maximum number of iterations
%           
%                  'epsilon1'   - Iteration stop condition
%
%                  'd2'         - polynomial Kernel function parameter
%
%                  'W'          - Initialized W matrix 
%                              
%                  'H'          - Initialized H matrix 
%                                
%                  'X_train'    - Training set matrix
%
%   Output         'W2'         - W matrix after iteration
%                  
%                  'H2'         - H matrix after iteration
%
%                  'J2'         - Loss function value after each iteration 

J_record2 = zeros(1,100);
W2 = W;
X2 = X_train;
H2 = H;
for t=1:I_max
    [K_WW2] = kernelFunction1(W2,W2,d2);
    [K_WX2] = kernelFunction1(W2,X2,d2);
    [K_XX2] = kernelFunction1(X2,X2,d2);
    [K_XW2] = kernelFunction1(X2,W2,d2);
    [J2] = Costfunction(H2,K_XX2,K_XW2,K_WW2);
    J_record2(t) = J2;
    [W2,H2] = pknmfUpdate(X2,W2,H2,K_WX2,K_WW2,d2);  
    if t>=2 && abs(J_record2(t)-J_record2(t-1))< epsilon1
        break
    end
    
end 
