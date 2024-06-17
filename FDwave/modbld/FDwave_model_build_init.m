function FDwave_model_build_init( varargin )
%MODEL_BUILD_INIT 
% This function can be used to create a single layer of arbitrary shape.
% The shape is defined by a set of points connected linearly.
% It doesn't create a new model but modifies the existing and then saves
% new one.
% Complete Syntax:
%       model_build_start('WFP',path,'WAVE_TYPE','elastic','NX',value,...
%         'NZ',value,'DX',value,'DZ',value,'VP',value,'VS',value,...
%         'RHO',value,'QP',value,'QS',value, 'PlotON',option)
%
%       Description of parametes
%       WFP          :  Path to working directory
%       WAVE_TYPE    : 'acoustic1', 'acoustic2', 'elastic', 'viscoelastic'
%       NX,NZ        : No of grid points along x and z directions
%       DX,DZ        : Grid spacing along x and z
%       VP, VS       : Velocities of P and S wave
%       RHO          : Density of the material
%       QP, QS       : Attenuation values of the material.
%       PlotON       : 'y'/'n'
% Note:
%       acoustic1 requires Vp
%       acoustic2 requires Vp, Rho
%       elastic  requires  Vp, Vs, Rho
%       viscoelastic require Vp, Vs, Rho, Qp, Qs
%       The structure for coordinats can be defined as {[x1,z1],[x2,z2],...}
% Example:
%       model_build_start('WFP',pwd,'WAVE_TYPE','elastic','NX',200,'NZ',200,...
%         'DX',5,'DZ',5,'VP',2200,'VS',1800,'RHO',1800,'PlotON','y')

global wfp
for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wave_type';       wave_type=varargin{i+1};
        %case 'wfp';             wfp=varargin{i+1};
        case 'nx';              nh=varargin{i+1};                     
        case 'nz';              nv=varargin{i+1};
        case 'dx';              dh=varargin{i+1};
        case 'dz';              dv=varargin{i+1};
        case 'vp';              vp=varargin{i+1};
        case 'vs';              vs=varargin{i+1};
        case 'rho';             rho=varargin{i+1};
        case 'qp';              qp=varargin{i+1};
        case 'qs';              qs=varargin{i+1};
        case 'verbose';         verbose=varargin{i+1};
        case 'ploton';          plotON=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end

str0='    ';
str1=str0;      str2=str0;      str3=str0;      str4=str0;
str5=str0;      str6=str0;      str7=str0;  

m_name = 'Build';
% 
% if ~exist('wfp','var');
%     wfp=pwd;                       
% end;
ipdirpath = [wfp,filesep,'Data_IP',filesep];
opdirpath = [wfp,filesep,'Data_OP',filesep];


if ~exist('wave_type','var');       error(' Wave type is not provided');     
else wave_type=lower(wave_type);        end

if ~exist('nh','var');              error(' nx is not provided');               end
if ~exist('nv','var');              error(' nz is not provided');               end
if ~exist('plotON','var');              plotON='n';               end
if ~exist('dh','var');              dh=5;                  str1=[str0,'(Default)'];end
if ~exist('dv','var');              dv=5;                  str2=[str0,'(Default)'];end
if strcmp(wave_type,'acoustic1')
    if ~exist('vp','var');         vp=1500;            str3=[str0,'(Default)'];    end;
elseif strcmp(wave_type,'acoustic2')&&(~exist('vp','var')||~exist('rho','var'))    
    if ~exist('vp','var');         vp=1500;            str3=[str0,'(Default)'];    end;
    if ~exist('rho','var');         rho=1000;           str5=[str0,'(Default)'];    end;
elseif strcmp(wave_type,'elastic')&&(~exist('tl','var')||~exist('vpv','var')||~exist('vsv','var')||~exist('rhov','var'))
    if ~exist('vp','var');         vp=1500;            str3=[str0,'(Default)'];    end;
    if ~exist('vs','var');         vs=0;            str4=[str0,'(Default)'];    end;
    if ~exist('rho','var');         rho=1000;           str5=[str0,'(Default)'];    end;
elseif strcmp(wave_type,'viscoelastic')&&(~exist('tl','var')||~exist('vpv','var')||~exist('vsv','var')||~exist('rhov','var')||~exist('qpv','var')||~exist('qsv','var'))
    if ~exist('vp','var');         vp=1500;            str3=[str0,'(Default)'];    end;
    if ~exist('vs','var');         vs=0;            str4=[str0,'(Default)'];    end;
    if ~exist('rho','var');         rho=1000;           str5=[str0,'(Default)'];    end;
    if ~exist('qp','var');          qp=10000;           str6=[str0,'(Default)'];    end;
    if ~exist('qs','var');          qs=10000;           str7=[str0,'(Default)'];    end;
end
if ~exist('verbose','var');       end

disp('    FUNC: Model Building')
    disp([str0,'Model Selected       : ',m_name])
    disp([str0,str0,'Provided parameters']);
    disp([str0,'Type of wave         : ',wave_type] )
    disp([str0,'No of grids along x  : ',num2str(nh)])
    disp([str0,'No of grids along x  : ',num2str(nv)])
    disp([str0,'Grid spacing x (m)   : ',num2str(dh),str1])
    disp([str0,'Grid spacing z (m)   : ',num2str(dv),str2])

if strcmp(wave_type,'acoustic1');
    disp([str0,'Vp                   : ',num2str(vp),str3])
elseif strcmp(wave_type,'acoustic2');   
    disp([str0,'Vp (m/s)             : ',num2str(vp),str3])
    disp([str0,'Density (g/cc)       : ',num2str(rho),str5])
elseif strcmp(wave_type,'elastic');     
    disp([str0,'Vp (m/s)             : ',num2str(vp),str3])
    disp([str0,'Vs (m/s)             : ',num2str(vs),str4])
    disp([str0,'Density (g/cc)       : ',num2str(rho),str5])
elseif strcmp(wave_type,'viscoelastic');    
    disp([str0,'Vp (m/s)             : ',num2str(vp),str3])
    disp([str0,'Vs (m/s)             : ',num2str(vs),str4])
    disp([str0,'Density (g/cc)       : ',num2str(rho),str5])
    disp([str0,'Qp                   : ',num2str(qp),str6])
    disp([str0,'Qs                   : ',num2str(qs),str7])
end


str=[ipdirpath,'model'];

if strcmp(wave_type,'acoustic1');       
    vpm=vp*ones(nv,nh);           save(str,'dh','dv','nh','nv','vpm','wave_type','m_name');
elseif strcmp(wave_type,'acoustic2');   
    vpm=vp*ones(nv,nh);     rhom=rho*ones(nv,nh);
    save(str,'dh','dv','nh','nv','vpm','rhom','wave_type','m_name');
elseif strcmp(wave_type,'elastic');     
    vpm=vp*ones(nv,nh);     vsm=vs*ones(nv,nh);     rhom=rho*ones(nv,nh);
    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','wave_type','m_name');
elseif strcmp(wave_type,'viscoelastic');    
    vpm=vp*ones(nv,nh);     vsm=vs*ones(nv,nh);     rhom=rho*ones(nv,nh);
    qpm=qp*ones(nv,nh);     qsm=qs*ones(nv,nh);
    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','qpm','qsm','wave_type','m_name');
else        warning('      Wrong Name entered, No model saved')
end

if strcmp(plotON,'y')
    FDwave_model_plot('WFP',wfp)
end

disp([str0,str0,'Final model properties ']);
disp(['        dh =  ',num2str(dh)] )
disp(['        dv =  ',num2str(dv)] )
disp(['        nh =  ',num2str(nh)] )
disp(['        nv =  ',num2str(nv)] )
disp(['        Model saved in',str])
end

