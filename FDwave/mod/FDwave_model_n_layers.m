function FDwave_model_n_layers(varargin)  % wave_type,   dh,dv,HV_ratio,tl,  vpv,vsv,rhov,qpv,qsv)
% FDWAVE_MODEL_N_LAYERS
% This function can create a model consisting of 'n' horizontal layers.
% Complete Syntax:
%     model_N_layers('WFP',path,'WAVE_TYPE',options,'DX',value,'DZ',value,'THICKNESS',value,...
%         'HV_RATIO',value,'VP',value,'VS',value,'RHO',value,'QP',value,'QS',value,'PlotON',option )
%
%       Description of parameters:
%       WFP          :  Path to working folder
%       Rheology     :  'acoustic1', 'acoustic2', 'elastic', 'viscoelastic'
%       DX, DZ       :  Grid size in horizontal and vertical direction in meters
%       THICKNESS    :  Thickness of each layer in form of vector
%       HV_RATIO     :  Total size of the model in respect to
%       VP, VS       :  Velocity of P and S wave in form of vector
%       RHO          :  Density of medium in form of vector
%       QP, QS       :  Attenutation of P and S value in form of vector
%       PlotON       :  'y'/'n' for plotting
% Note:
%       acoustic1 - requires VP
%       acoustic2 - requires VP, RHO
%       Elastic   - requires VP, VS, RHO
%       viscoelastic - require VP, VS, RHO, QP, QS
%       The vector is in the form of e.g. [600,700,800,1000]
% Example:
%     model_n_layers('WFP',pwd,'WAVE_TYPE','Elastic','DX',4,'DZ',4,'THICKNESS',[80,50,60,40,90],...
%          'HV_RATIO',1,'VP',2000:250:3000,'VS',1700:250:2700,'RHO',2300:100:2700)

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wave_type';        wave_type=varargin{i+1};
        case 'wfp';             wfp=varargin{i+1};
        case 'dx';              dh=varargin{i+1};
        case 'dz';              dv=varargin{i+1};
        case 'hv_ratio';        HV_ratio=varargin{i+1};
        case 'thickness';       tl=varargin{i+1};
        case 'vp';              vpv=varargin{i+1};
        case 'vs';              vsv=varargin{i+1};
        case 'rho';             rhov=varargin{i+1};
        case 'qp';              qpv=varargin{i+1};
        case 'qs';              qsv=varargin{i+1};
        case 'verbose';         verbose=varargin{i+1};
        case 'ploton';          plotON=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end

str0='        ';
str1=str0;      str2=str0;      str3=str0;      str4=str0;
str5=str0;      str6=str0;      str7=str0;      str8=str0;
str9=str0;      str10=str0;

if ~exist('wfp','var');             wfp=pwd;                  end;

if ~exist('wave_type','var');       wave_type = 'elastic';      str1=[str0,'(Default)'];
else;        wave_type=lower(wave_type);    end

if ~exist('dh','var');              dh= 4;                      str2=[str0,'(Default)'];  end
if ~exist('dv','var');              dv= 4;                      str3=[str0,'(Default)'];  end
if ~exist('XY_ratio','var');        HV_ratio=1;                 str4=[str0,'(Default)'];  end

if strcmp(wave_type,'scalar')&&(~exist('tl','var')||~exist('vpv','var'))
    tl  = [100,46,30,43,100];    str5=[str0,'(Default)'];
    vpv = 2000:250:3000;        str6=[str0,'(Default)'];
elseif strcmp(wave_type,'acoustic')&&(~exist('tl','var')||~exist('vpv','var')||~exist('rhov','var'))
    tl  = [100,46,30,43,100];    str5=[str0,'(Default)'];
    vpv = 2000:250:3000;        str6=[str0,'(Default)'];
    rhov= 2300:100:2700;       str8=[str0,'(Default)'];
elseif strcmp(wave_type,'elastic')&&(~exist('tl','var')||~exist('vpv','var')||~exist('vsv','var')||~exist('rhov','var'))
    tl   = [100,46,30,43,100];    str5=[str0,'(Default)'];
    vpv  = 2000:250:3000;        str6=[str0,'(Default)'];
    vsv  = 1700:250:2700;        str7=[str0,'(Default)'];
    rhov = 2300:100:2700;       str8=[str0,'(Default)'];

elseif strcmp(wave_type,'viscoacoustic')&&(~exist('tl','var')||~exist('vpv','var')||~exist('rhov','var')||~exist('qpv','var'))
    tl   = [100,46,30,43,100];    str5=[str0,'(Default)'];
    vpv  = 2000:250:3000;        str6=[str0,'(Default)'];    
    rhov = 2300:100:2700;       str8=[str0,'(Default)'];
    qpv  = 80:5:100;             str9=[str0,'(Default)'];    
    
elseif strcmp(wave_type,'viscoelastic')&&(~exist('tl','var')||~exist('vpv','var')||~exist('vsv','var')||~exist('rhov','var')||~exist('qpv','var')||~exist('qsv','var'))
    tl   = [100,46,30,43,100];    str5=[str0,'(Default)'];
    vpv  = 2000:250:3000;        str6=[str0,'(Default)'];
    vsv  = 1700:250:2700;        str7=[str0,'(Default)'];
    rhov = 2300:100:2700;       str8=[str0,'(Default)'];
    qpv  = 80:5:100;             str9=[str0,'(Default)'];
    qsv  = 60:5:80 ;             str10=[str0,'(Default)'];
end

if ~exist('verbose','var');         verbose='y';                end
if ~exist('plotON','var');          plotON='n';                 end

if strcmp(verbose,'y')
    disp('    FUNC: Model Building')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp([str0,'Model Selected: N-Layers'])
    disp([str0,str0,'Provided parameters']);
    disp([str0,'Type of wave         : ',wave_type,str1] )
    disp([str0,'Grid spacing along x : ',num2str(dh),str2] )
    disp([str0,'Grid spacing along x : ',num2str(dv),str3])
    disp([str0,'X/Y dimension Ratio  : ',num2str(HV_ratio),str4])
    
    if strcmp(wave_type,'scalar')
        disp([str0,'Thickness of layer(s): ',num2str(tl),str5])
        disp([str0,'Vp of layer(s): ',num2str(vpv),str6])
    
    elseif strcmp(wave_type,'acoustic')
        disp([str0,'Thickness of layer(s): ',num2str(tl),str5])
        disp([str0,'Vp of layer(s): ',num2str(vpv),str6])
        disp([str0,'Density of layer(s)  : ',num2str(rhov),str8])
    
    elseif strcmp(wave_type,'elastic')
        disp([str0,'Thickness of layer(s): ',num2str(tl),str5])
        disp([str0,'Vp of layer(s)       : ',num2str(vpv),str6])
        disp([str0,'Vs of layer(s)       : ',num2str(vsv),str7])
        disp([str0,'Density of layer(s)  : ',num2str(rhov),str8])
    
    elseif strcmp(wave_type,'viscoacoustic')
        disp([str0,'Thickness of layer(s): ',num2str(tl),str5])
        disp([str0,'Vp of layer(s)       : ',num2str(vpv),str6])        
        disp([str0,'Density of layer(s)  : ',num2str(rhov),str8])
        disp([str0,'Qp of layer(s)       : ',num2str(qpv),str9])
        
    
    elseif strcmp(wave_type,'viscoelastic')
        disp([str0,'Thickness of layer(s): ',num2str(tl),str5])
        disp([str0,'Vp of layer(s)       : ',num2str(vpv),str6])
        disp([str0,'Vs of layer(s)       : ',num2str(vsv),str7])
        disp([str0,'Density of layer(s)  : ',num2str(rhov),str8])
        disp([str0,'Qp of layer(s)       : ',num2str(qpv),str9])
        disp([str0,'Qs of layer(s)       : ',num2str(qsv),str10])
    end
end

tln = round(tl/dv);
nv = sum(tln)+1;
nh=round(HV_ratio*nv);      % No of points or nodes along x AND depth,z (Including absorbing boundary nodes)

zn = [1,cumsum(tln)+1];
vpm=zeros(nv,nh);   vsm=zeros(nv,nh);   qpm=zeros(nv,nh);   qsm=zeros(nv,nh);   rhom=zeros(nv,nh);
%
% for i=1:length(vpv)
%     vpm(zn(i):zn(i+1),:) = vpv(i);
%     vsm(zn(i):zn(i+1),:) = vsv(i);
%     qpm(zn(i):zn(i+1),:) = qpv(i);
%     qsm(zn(i):zn(i+1),:) = qsv(i);
%     rhom(zn(i):zn(i+1),:)= rhov(i);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ipdirpath = [wfp,filesep,'Data_IP',filesep];
opdirpath = [wfp,filesep,'Data_OP',filesep];

str=[ipdirpath,'model'];
m_name='N_layers';

if strcmp(wave_type,'scalar')
    for i=1:length(vpv);        vpm(zn(i):zn(i+1),:) = vpv(i);          end
    save(str,'dh','dv','nh','nv','vpm','wave_type','m_name');
    
elseif strcmp(wave_type,'acoustic')
    for i=1:length(vpv)
        vpm(zn(i):zn(i+1),:) = vpv(i);
        rhom(zn(i):zn(i+1),:)= rhov(i);
    end
    save(str,'dh','dv','nh','nv','vpm','rhom','wave_type','m_name');
    
elseif strcmp(wave_type,'elastic')
    for i=1:length(vpv)
        vpm(zn(i):zn(i+1),:) = vpv(i);
        vsm(zn(i):zn(i+1),:) = vsv(i);
        rhom(zn(i):zn(i+1),:)= rhov(i);
    end
    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','wave_type','m_name');

    
elseif strcmp(wave_type,'viscoacoustic')
    for i=1:length(vpv)
        vpm(zn(i):zn(i+1),:) = vpv(i);
        vsm(zn(i):zn(i+1),:) = vsv(i);
        qpm(zn(i):zn(i+1),:) = qpv(i);
        qsm(zn(i):zn(i+1),:) = qsv(i);
        rhom(zn(i):zn(i+1),:)= rhov(i);
    end
    save(str,'dh','dv','nh','nv','vpm','rhom','qpm','wave_type','m_name');    
    
elseif strcmp(wave_type,'viscoelastic')
    for i=1:length(vpv)
        vpm(zn(i):zn(i+1),:) = vpv(i);
        vsm(zn(i):zn(i+1),:) = vsv(i);
        qpm(zn(i):zn(i+1),:) = qpv(i);
        qsm(zn(i):zn(i+1),:) = qsv(i);
        rhom(zn(i):zn(i+1),:)= rhov(i);
    end
    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','qpm','qsm','wave_type','m_name');
else
    warning('      Wrong name for model entered, No model saved')
    return
end

if strcmp(verbose,'y')
    if strcmp(wave_type,'scalar')||strcmp(wave_type,'acoustic')||strcmp(wave_type,'elastic')||strcmp(wave_type,'viscoelastic')
        disp(['        dh =  ',num2str(dh)] )
        disp(['        dv =  ',num2str(dv)] )
        disp(['        nh =  ',num2str(nh)] )
        disp(['        nv =  ',num2str(nv)] )
        disp(['        Model saved in',str])                
    end
end

if strcmp(plotON,'y')
    FDwave_model_plot('wfp',wfp)
end
