function [obj] = OMP_method(obj)

global Ns Nrf H Vn W_mopt Codebook_v Codebook_w;
t1 = clock;
n = 1;   %number of iterCodebook_vion
MSE =zeros(1,11);
W_D = W_mopt;  %initializCodebook_vion
W_RF = 1;
tw = trace(W_D'*(W_RF)'*W_RF*W_D);
[~,N_t] = size(H);
V_RF = exp( 1i*unifrnd(0,2*pi,N_t,Nrf) );
while(n<3 || (MSE(n-2)-MSE(n-1))>1e-4 &&n<=10)
    H_u = H'*W_RF*W_D;          %effective downlink channel
    Vn1 = tw*Vn;
    [V_RF,V_D] = MSEOMP (Nrf,H_u,Codebook_v,Vn1);
    tv = trace(V_RF*(V_D)*V_D'*V_RF');
    %%UEside
    H_d = H*V_RF*V_D;
    Vn2 = tv*Vn;
    [W_RF,W_D] = MSEOMP (Nrf,H_d,Codebook_w,Vn2); %the same formulCodebook_vion
    He = W_D'*W_RF'*H*V_RF*V_D;
    tw = trace(W_D'*(W_RF)'*W_RF*W_D);
    MSE(n) = trace(He * He'- He- He'+ eye(Ns)) + Vn2*tw;
    n = n + 1;
end
V_D = V_D/sqrt(tv);
%W_B = W_D*sqrt(tv);
t2 = clock;
runtime  = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = V_D;
obj.W_B = W_D;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj = get_metric(obj);

