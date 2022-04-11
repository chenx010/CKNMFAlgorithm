function [W3,H3,J3] =updata_WH(I_max,epsilon1,d3,W,H,X_train)
%   FPKNMF algorithm iteratively updates W,H
%
%   Input:         'I_max'      - The maximum number of iterations
%           
%                  'epsilon1'   - Iteration stop condition
%
%                  'd3'         - Fractional Power Inner Product Kernel 
%                                 function parameter 
%
%                  'W'          - Initialized W matrix 
%                              
%                  'H'          - Initialized H matrix 
%                                
%                  'X_train'    - Training set matrix
%
%   Output         'W3'         - W matrix after iteration
%                  
%                  'H3'         - H matrix after iteration
%
%                  'J3'         - Loss function value after each iteration 



J_record3 = [];
W3 = W;
X3 = X_train;
H3 = H;
for t=1:I_max
    [K_WW3] = kernelFunction2(W3,W3,d3);
    [K_WX3] = kernelFunction2(W3,X3,d3);
    [K_XX3] = kernelFunction2(X3,X3,d3);
    [K_XW3] = kernelFunction2(X3,W3,d3);
    [J3] = Costfunction(H3,K_XX3,K_XW3,K_WW3);
    J_record3 = [J_record3 J3];
    [W3,H3] = fpknmfUpdate(X3,W3,H3,K_WX3,K_WW3,d3);
    if t>=2 && abs((J_record3(t)-J_record3(t-1)))< epsilon1
        break
    end   
end 