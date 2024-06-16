function [B, P,M,LBD,dP,dM,dLBD, P_r, M_r, temp1,temp2] = const_material2( nh,nv,dt, vp,vs,rho,tep3dm,tes3dm,ts3dm,L)

%CALCULATION_CONST provieds the material constants required for FD time stepping
%   Detailed explanation goes here

w0=2*pi*20;
iota =  sqrt(-1);
temp1 = sum(((1+iota*w0*tep3dm)./(1+iota*w0*ts3dm)),3);
temp2 = sum(((1+iota*w0*tes3dm)./(1+iota*w0*ts3dm)),3);
% 
P_r = (vp.^2) .*rho.*real(L./temp1);
M_r = (vs.^2) .*rho.*real(L./temp2);

%P_r= (vp.^2) .*rho.*(L./sum(tep3dm./ts3dm,3));
%M_r = (vs.^2).*rho.*(L./sum(tes3dm./ts3dm,3));

temp1 = 1/L*(1-tep3dm./ts3dm);
temp2 = 1/L*(1-tes3dm./ts3dm);

P = P_r.*(1-sum(temp1,3));
M = M_r.*(1-sum(temp2,3));
LBD = P-2*M;

for i=1:L
    dP = P_r.*temp1(:,:,i);
    dM= M_r.*temp2(:,:,i);
end
dLBD=dP-2*dM;
B= 1./rho;

temp1= (1-dt./(2*ts3dm))./(1+dt./(2*ts3dm));
temp2= (dt./ts3dm)./(1+dt./(2*ts3dm));

end

