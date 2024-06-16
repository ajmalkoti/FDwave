function FDwave_model_basalt(varargin)
%MODEL_SHANTANU
%     uses: model_Shantanu(acoustic1)
%           model_Shantanu(elastic)
%           model_Shantanu(viscoelastic)
global wfp

for i=1:2:length(varargin)
    switch lower(varargin{i})
        % case 'wfp';        wfp=varargin{i+1};
        case 'wave_type';  wave_type=varargin{i+1};
        case 'vp';         lwvp=varargin{i+1};    
        case 'vs';         lwvs=varargin{i+1};    
        case 'rho';        lwrho=varargin{i+1};                
        case 'qp';         lwqp=varargin{i+1};    
        case 'qs';         lwqs=varargin{i+1};    
        
        case 'rhoa';       a=varargin{i+1};
        case 'rhob';       b=varargin{i+1};                
        case 'verbose';    verbose=varargin{i+1};
        case 'ploton';     plotON=varargin{i+1};
    end
end

ipdir = [wfp,filesep,'Data_IP',filesep];
opdir = [wfp,filesep,'Data_OP',filesep];

dh= 5;     dv= 5;     % Horizontal , Vertical grid spacing
lwvp0=[1500, 2000,2150,2300,2500,2700,4500,2800,3100,3500,3700];

if (~exist('a','var') || isempty(a));           a=0.31;       end
if (~exist('b','var') || isempty(b));           b=0.25;       end
if (~exist('lwvp','var') || isempty(lwvp));     lwvp=lwvp0;       end    
if (~exist('lwvs','var') || isempty(lwvs));     lwvs=.7*lwvp0;       end    
if (~exist('lwrho','var') || isempty(lwrho));   lwrho=a*lwvp0.^b;       end    
if (~exist('lwqp','var') || isempty(lwqp));     lwqp=80*ones(1,11);       end    
if (~exist('lwqs','var') || isempty(lwqp));     lwqs=50*ones(1,11);       end    
if (~exist('verbose','var') || isempty(verbose));   verbose='y';       end
if (~exist('plotON','var')  || isempty(plotON));     plotON='n';       end

load([ipdir,'model_basalt.mat'])
% interploate here if req.


%%
nh=size(vp,2);    nv=size(vp,1);      % No of points or nodes along x AND depth,z (Including absorbing boundary nodes)

vpm=vp;                 vsm=zeros(nv,nh);
rhom=zeros(nv,nh);
qpm=zeros(nv,nh);       qsm=zeros(nv,nh);

%figure(1);          imagesc(vpm)

for k=1:11
    vpm(vpm==lwvp0(k))=lwvp(k);
    vsm(vpm==lwvp0(k))=lwvs(k);
    rhom(vpm==lwvp0(k))=lwrho(k);
    qpm(vpm==lwvp0(k))=lwqp(k);
    qsm(vpm==lwvp0(k))=lwqs(k);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str=strcat(ipdir,'model');
m_name='basalt';

if strcmpi(wave_type,'Acoustic1')
     disp(['    Model selected:    ',wave_type,' -',m_name, ' model'])
    save(str,'dh','dv','nh','nv','vpm','wave_type','m_name');
    
elseif strcmpi(wave_type,'Acoustic2')
    disp(['    Model selected:    ',wave_type,' -',m_name, ' model'])
    save(str,'dh','dv','nh','nv','vpm','rhom','wave_type','m_name');
    
elseif strcmpi(wave_type,'Elastic')
    disp(['    Model selected:    ',wave_type,' -',m_name, ' model'])
    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','wave_type','m_name');
    
elseif strcmpi(wave_type,'Viscoelastic')
    %m_name='Homogeneous Viscoelastic';
    disp(['    Model selected:    ',wave_type,' -',m_name, ' model'])
    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','qpm','qsm','wave_type','m_name');
else
    warning('      Wrong Name entered, No model saved')
end

if verbose=='y'
    disp(['        dh =  ',num2str(dh)] )
    disp(['        dv =  ',num2str(dv)] )
    disp(['        nh =  ',num2str(nh)] )
    disp(['        nv =  ',num2str(nv)] )
    disp('        Model saved in "\Data_IP" ')
end


if strcmpi(plotON,'y')
    FDwave_model_plot('wfp',wfp)
end