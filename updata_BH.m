function [A0,B3,H8] =updata_BH(I_max,epsilon1,K_sq,K,B3,H8)

%                        ----GNMF algorithm update B,H----
%

%   Input:         'I_max'      - The maximum number of iterations
%           
%                  'epsilon1'   - Iteration stop condition
%
%                  'K_sq'       - Kernel matrix under the square root
%        
%                  'K'          - Kernel matrix 
%                                
%                  'X_train'    - Training set matrix
%
%   Output         'A0'         - W matrix after iteration
%                  
%                  'B3'         - the new  auxiliary matrix
%
%                  'H8'          - the new eigencoefficient matrix
%
J_record0 = [];

for t=1:I_max
    
    [J0] = Costfunction0(K,H8,K_sq,B3);
    J_record0 = [J_record0 J0];
    
    [A0,B3,H8] = gnmfUpdate(B3,H8,K_sq);
    if t>=2 && abs((J_record0(t)-J_record0(t-1)))< epsilon1
        break
    end   
end 