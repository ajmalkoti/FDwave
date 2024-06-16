function FDwave_model_plot(varargin)       %  wave_type,  dh,dv,nh,nv,   vpm,rhom,vsm,qpm,qsm)
% FDWAVE_MODEL_PLOT
% This subroutine simply plots the model
% Example:
%           FDwave_model_plot('wfp',wfp)
%

global wfp

for i=1:2:length(varargin)
    switch varargin{i}
        case 'wave_type';       wave_type=varargin{i+1};
%         case 'wfp';             wfp=varargin{i+1};
    end
end


if ~exist('wfp','var');              wfp=pwd;                   end;    

ipdirpath = [wfp,filesep,'Data_IP',filesep];
opdirpath = [wfp,filesep,'Data_OP',filesep];

str=[ipdirpath,'model'];
load(str);
[nv,nh]=size(vpm);

figure()

if strcmpi(wave_type,'scalar') % acoustic/scaler wave
    plotmat2(1,1,1,dh,dv,nh,nv,vpm,'Vp')
    %     subplot(1,2,1); imagesc(dh*(0:nh-1),dv*(0:nv-1),vpm);axis ij; colormap(flipud(gray)); colorbar;title('Vp');set(gca,'XAxisLocation','top')
    
elseif strcmpi(wave_type,'acoustic') % acoustic wave
    plotmat2(1,2,1,dh,dv,nh,nv,vpm,'Vp')
    plotmat2(1,2,2,dh,dv,nh,nv,rhom,'\rho')
    %     subplot(2,2,1); imagesc(dh*(0:nh-1),dv*(0:nv-1),vpm);axis ij; colormap(flipud(gray)); colorbar;title('Vp');set(gca,'XAxisLocation','top')
    %     subplot(2,2,2); imagesc(dh*(0:nh-1),dv*(0:nv-1),rhom);axis ij; colormap(flipud(gray)); colorbar;title('Rho');set(gca,'XAxisLocation','top')
    
elseif strcmpi(wave_type,'elastic')  % elastic wave
    plotmat2(2,2,1,dh,dv,nh,nv,vpm,'Vp')
    plotmat2(2,2,2,dh,dv,nh,nv,vsm,'Vs')
    plotmat2(2,2,3,dh,dv,nh,nv,rhom,'\rho')
    %subplot(2,2,1);    imagesc(dh*(0:nh-1),dv*(0:nv-1),vpm);axis ij; colormap(flipud(gray)); colorbar;title('Vp');set(gca,'XAxisLocation','top')
    % subplot(2,2,2);   imagesc(dh*(0:nh-1),dv*(0:nv-1),vsm);axis ij; colormap(flipud(gray)); colorbar;title('Vs');set(gca,'XAxisLocation','top')
    % subplot(2,2,3);   imagesc(dh*(0:nh-1),dv*(0:nv-1),rhom);axis ij; colormap(flipud(gray)); colorbar;title('Rho');set(gca,'XAxisLocation','top')
    
elseif strcmpi(wave_type,'viscoelastic') % viscoelastic wave
    plotmat2(2,3,1,dh,dv,nh,nv,vpm,'Vp')
    plotmat2(2,3,2,dh,dv,nh,nv,vsm,'Vs')
    plotmat2(2,3,3,dh,dv,nh,nv,rhom,'\rho')
    plotmat2(2,3,4,dh,dv,nh,nv,qpm,'Qp')
    plotmat2(2,3,5,dh,dv,nh,nv,qsm,'Qs')
    %     subplot(2,3,1); imagesc(dh*(0:nh-1),dv*(0:nv-1),vpm);axis ij; colormap(flipud(gray)); colorbar;title('Vp');set(gca,'XAxisLocation','top')
    %     subplot(2,3,2); imagesc(dh*(0:nh-1),dv*(0:nv-1),vsm);axis ij; colormap(flipud(gray)); colorbar;title('Vs');set(gca,'XAxisLocation','top')
    %     subplot(2,3,3); imagesc(dh*(0:nh-1),dv*(0:nv-1),rhom);axis ij; colormap(flipud(gray)); colorbar;title('Rho');set(gca,'XAxisLocation','top')
    %     subplot(2,3,4); imagesc(dh*(0:nh-1),dv*(0:nv-1),qpm);axis ij; colormap(flipud(gray)); colorbar;title('Qp');set(gca,'XAxisLocation','top')
    %     subplot(2,3,5); imagesc(dh*(0:nh-1),dv*(0:nv-1),qsm);axis ij; colormap(flipud(gray)); colorbar;title('Qs');set(gca,'XAxisLocation','top')
    
else
    warning('    Wrong model selected')
end

end
