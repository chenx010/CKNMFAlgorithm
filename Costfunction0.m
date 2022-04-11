function[J3] = Costfunction0(K,H,K_sq,B0)
A0 = pinv(K_sq)*B0;
J3 =(1 / 2) * trace(K - 2 * K*A0* H + H' * A0'*K *A0* H);

end
