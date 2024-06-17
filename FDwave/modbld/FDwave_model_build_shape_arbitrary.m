function FDwave_model_build_shape_arbitrary(varargin)%nhvec,nvvec,value)
% MODEL_BUILD_SHAPE_ARBITRARY
% This function can be used to create a shape/object of arbitrary shape.
% The shape is defined by a set of points connected linearly.
% It doesn't create a new model but modifies the existing and then saves
% new one.
% Complete Syntax:
%       model_build_shape('WFP',path,'COORD',struc,'VP',value,'VS',value,...
%             'RHO',value,'QP',value,'QS',value,'PlotON',option)
% Description of the parameters:
%       WFP             :  Path to working directory
%       COORD           :  A structure of coordinates of shape vertices
%       VP,VS           :  P and S Velocities of the structure/object
%       RHO             :  Density of the structure/object
%       QP, QS          :  P and S Attenuations of the structure/object
%       PlotON          :  'y'/'n'
% Note:
%       acoustic1 requires Vp
%       acoustic2 requires Vp, Rho
%       elastic  requires  Vp, Vs, Rho
%       viscoelastic require Vp, Vs, Rho, Qp, Qs
%       The structure for coordinats can be defined as {[x1,z1],[x2,z2],...}
% Example:
%    model_build_shape_arbitrary('coordinates',CVec,'Vp',2800,'Vs',2200,...
%          'Rho',1800,'PlotON','y');

global wfp

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'coord';         CVec=varargin{i+1};
        %case 'wfp';             wfp=varargin{i+1};
        case 'vp';                  vp=varargin{i+1};
        case 'vs';                  vs=varargin{i+1};
        case 'rho';              rho=varargin{i+1};
        case 'qp';                  qp=varargin{i+1};
        case 'qs';                  qs=varargin{i+1};
            
        case 'ploton';              plotON=lower(varargin{i+1});
        case 'verbose';             verbose=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end

if ~exist('plotON','var');  plotON='y'; end
% if ~exist('wfp','var');
%     wfp=pwd;                       
% end;
ipdirpath = [wfp,filesep,'Data_IP',filesep];
opdirpath = [wfp,filesep,'Data_OP',filesep];



load([ipdirpath,'model']);
disp(['wave type : ',wave_type]);

H=[];       V=[];
for i=1:length(CVec)
    H= [H,CVec{i}(1)];
    V= [V,CVec{i}(2)];
end

if strcmp(plotON,'y');
    figure();imagesc(zeros(nv,nh)); hold on
    plot(H,V)
    title('Current layer');
    xlabel('X Node No');
    ylabel('Z Node No');
end

if sum(H>nh)>0; error('Provided X point(s) lies outside the model'); end
if sum(V>nv)>0; error('Provided Z point(s) lies outside the model'); end

indh=[]; indv=[];

% for ind_v=1:nv %min(nvvec):max(nvvec)
%     for ind_h=1:nh %min(nhvec):max(nhvec)
%         check_in = inpolygon(ind_h,ind_v,H,V);
%         if check_in==1;
%             indh=[indh,ind_h];
%             indv=[indv,ind_v];
%         end;
%     end
% end

% if strcmp(plotON,'y');
%    plot(indh,indv,'ro')
% end

str=[ipdirpath,'model'];

if strcmp(wave_type,'acoustic1');
    %     vpm(indv,indh)= vp;
    vpm=fill_in(vpm,H,V,nh,nv,vp);
    save(str,'dh','dv','nh','nv','vpm','wave_type','m_name');
elseif strcmp(wave_type,'acoustic2');
    %     vpm(indv,indh)=vp;     rhom(indv,indh)=rho;
    vpm=fill_in(vpm,H,V,nh,nv,vp);
    rhom=fill_in(rhom,H,V,nh,nv,rho);
    save(str,'dh','dv','nh','nv','vpm','rhom','wave_type','m_name');
elseif strcmp(wave_type,'elastic');
    %     vpm(indv,indh)=vp;       vsm(indv,indh)=vs;         rhom(indv,indh)=rho;
    vpm=fill_in(vpm,H,V,nh,nv,vp);      % imagesc(vpm)
    vsm=fill_in(vsm,H,V,nh,nv,vs);
    rhom=fill_in(rhom,H,V,nh,nv,rho);
    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','wave_type','m_name');
elseif strcmp(wave_type,'viscoelastic');
    %     vpm(indv,indh)=vp;     vsm(indv,indh)=vs;     rhom(indv,indh)=rho;
    %     qpm(indv,indh)=qp;     qsm(indv,indh)=qs;
    vpm=fill_in(vpm,H,V,nh,nv,vp);      % imagesc(vpm)
    vsm=fill_in(vsm,H,V,nh,nv,vs);
    rhom=fill_in(rhom,H,V,nh,nv,rho);
    qpm=fill_in(qpm,H,V,nh,nv,qp);
    qsm=fill_in(qsm,H,V,nh,nv,qs);
    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','qpm','qsm','wave_type','m_name');
else        warning('      Wrong Name entered, No model saved')
end

disp(['        Model saved in',str])
end


function A=fill_in(A,H,V,nh,nv,value)
for ind_v=1:nv %min(nvvec):max(nvvec)
    for ind_h=1:nh %min(nhvec):max(nhvec)
        check_in = inpolygon(ind_h,ind_v,H,V);
        if check_in==1;
            A(ind_v,ind_h)=value;
        end;
    end
end
end