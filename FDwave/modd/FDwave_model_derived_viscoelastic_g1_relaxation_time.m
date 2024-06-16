function [tep3dm,tes3dm,ts3dm] = model_derived_visco_g1_relaxation_time(fl,fh,L,Q_scaling,qp,qs,verbose)
%fl=10;      fh=60;     L=3;       q_scaling=1;    qp=1*ones(10,10); qs=2*ones(10,10);

%%%%%%%%%%%%%%%%    Estimation of tau_sigma  %%%%%%%%%%%%%%%
omega1= 2*pi*fl;        omega2=2*pi*fh;
temp=linspace(log2(omega1),log2(omega2),L+2);
ts1d=1./(2.^temp(2:end-1));

%%%%%%%%%%%%%%%%   Estimation of tau   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
I0=0; I1=0; I2=0;

for i=1:L
    coff=(0.5/ts1d(i));
    I0 = I0 + coff*(log(1+omega2^2*ts1d(i)^2)...
                  - log(1+omega1^2*ts1d(i)^2));
    
    I1 = I1 + coff*(...
        (atan(omega2*ts1d(i))-omega2*ts1d(i)/(1+omega2^2*ts1d(i)^2))...
       -(atan(omega1*ts1d(i))-omega1*ts1d(i)/(1+omega1^2*ts1d(i)^2)));
end

for i=1:L-1
    for k=i+1:L
        coff = ts1d(i)*ts1d(k) / ( ts1d(k)^2-ts1d(i)^2 );
        I2 = I2 + coff*(...
            (atan(omega2*ts1d(i))/ts1d(i) - atan(omega2*ts1d(k))/ts1d(k))...
           -(atan(omega1*ts1d(i))/ts1d(i) - atan(omega1*ts1d(k))/ts1d(k))...
            );
    end
end

tau_int_part = I0/(I1 + 2*I2);

qp_s=qp*Q_scaling;
qs_s=qs*Q_scaling;

taup = (1./qp_s )* tau_int_part;
taus = (1./qs_s )* tau_int_part;

[nh,nv]=size(qp);
ts3dm= zeros(nh,nv,L);      tep3dm=zeros(nh,nv,L);      tes3dm=zeros(nh,nv,L);

for i=1:L;
    ts3dm(:,:,i)=ts1d(i);               
end

for i=1:L;
    tep3dm(:,:,i)=  ts1d(i).*(taup+1);
    tes3dm(:,:,i)=  ts1d(i).*(taus+1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(verbose,'y')
    sprintf('    L=%i',L)
    for i =1:L
        disp(unique(tep3dm))
    end
end
% disp('        Determination of relaxation constants--> Done')



