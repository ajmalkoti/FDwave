function bc_plot(wfp )
%BC_PLOT Summary of this function goes here
%   Detailed explanation goes here

if ~exist('cpath','var'); wfp=pwd; 
end

load([wfp,'\Data_IP\model'],'dh','dv','nh','nv');
load([wfp,'\Data_IP\BC'],'BC','nAB');

load([wfp,'\Data_IP\model'],'vpm');
vpm=vpm/max(max(vpm));
test= BC+vpm;


if nh>nv;
figure();
plotmat2(2,1,1,dh,dv,nh,nv,BC,'Boundaries Only')
axis image;  colormap(flipud(jet))

plotmat2(2,1,2,dh,dv,nh,nv,test,'Boundaries on Model')
axis image;  colormap(flipud(jet))

else nh<nv;

figure();
plotmat2(1,2,1,dh,dv,nh,nv,BC,'Boundaries Only')
axis image;  colormap(flipud(jet))

plotmat2(1,2,2,dh,dv,nh,nv,test,'Boundaries on Model')
axis image;  colormap(flipud(jet))

end

