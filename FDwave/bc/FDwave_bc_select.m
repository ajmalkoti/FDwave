function FDwave_bc_select(varargin)     %BCname,BCtype,nAB  )
% SELECT_BC
% It generate the necessary data for different BC
% Complete Syntax:
%       select_bc('WFP',path,'BCNAME',value,'BCTYPE',value,'NAB',value,'PlotON',option)
% Description of parameters:
%       WFP    :  Path to working directory
%       BCNAME = 'ABC1'   for Englist & Clayton EnglistClayton (acoustic wave eqn)
%                'ABC2'   for Raynold EnglistClayton (acoustic wave eqn)
%                'ABL'    for Damping EnglistClayton, after Cerjan
%       BCTYPE = 'topFS'    for free surface at top
%              = 'topABC'   for absorbing type boundary at surface
%       NAB    =  no of layers to be used (for damping BC only)
%       PlotON = 'y',  To plot the boundaries
% Example:
%       select_bc('WFP',pwd,'BCNAME','ABL','BCTYPE','topABC','NAB',40)

global wfp
ipdir = [wfp,filesep,'Data_IP',filesep];
opdir = [wfp,filesep,'Data_OP',filesep];

for i=1:2:length(varargin)
    switch lower(varargin{i})
        % case 'wfp';        wfp=varargin{i+1};
        case 'bcname';     BCname=varargin{i+1};
        case 'bctype';     BCtype=varargin{i+1};
        case 'nab';        nAB=varargin{i+1};
        case 'verbose';    verbose=varargin{i+1};
        case 'ploton';     plotON=varargin{i+1};
    end
end

str0='        ';
str1=str0;          str2=str0;      str3=str0;
% if ~exist('wfp','var');           wfp=pwd;              end;
if ~exist('BCname','var');        BCname='ABL';         str1=[str0,'(Default)'];    end
if ~exist('nAB','var');           nAB= 40;              str2=[str0,'(Default)'];    end
if ~exist('BCtype','var');        BCtype='topABC';      str3=[str0,'(Default)'];    end
if ~exist('verbose','var');       verbose='n'  ;       end
if ~exist('plotON','var');        plotON='n';          end
if ~exist('verbose','var');    verbose='y';     end

if strcmpi(verbose,'y')
    disp('    FUNC: Select the boundary types');
end

if strcmpi(BCname,'ABC1')||strcmpi(BCname,'ABC2');           nAB = 2;         end


if strcmpi(BCname,'ABL')
    if strcmpi(verbose,'y')
        disp([str0,'BC Method    :  Damping Layer (Cerjan)']);
    end
    BC = bc_damp(wfp, BCtype,nAB );  % options: topFS, allABC
    
elseif strcmpi(BCname,'ABC1')
    disp([str0,'BC Method    :  Absorbing BC (EnglistClayton)']);
    load('model','nh','nv');
    BC = ones(nv,nh);
    tmp=ceil(.01*nv);
    if strcmpi(BCtype,'topFS')
        BC(1:nv-tmp,1+tmp:nh-tmp)= 0;
    elseif strcmpi(BCtype,'topABC')
        BC(1+tmp:nv-tmp,1+tmp:nh-tmp)= 0;
    end
    
elseif strcmpi(BCname,'ABC2')
    disp([str0,'BC Method    :  TransparantBC(Cerjan)']);
    load('model','nh','nv');
    BC = ones(nv,nh);
    tmp=ceil(.01*nv);
    if strcmpi(BCtype,'topFS')
        BC(1:nv-tmp,1+tmp:nh-tmp)= 0;
    elseif strcmpi(BCtype,'topABC')
        BC(1+tmp:nv-tmp,1+tmp:nh-tmp)= 0;
    end
end

str=[ipdir,'BC'];
save(str,'BC','nAB','BCtype','BCname');

if strcmpi(verbose,'y')
    disp([str0,'No of Layers :  ', num2str(nAB),str1]);
    disp([str0,'BC type      :  ', BCtype,str2]);
    disp([str0,'BC name      :  ',BCname,str3])
    disp(['       Boundaries data is saved in "',str,'"'])
end


if strcmpi(plotON,'y')
    [nv,nh]=size(BC);
    load([ipdir,'model'],'dh','dv')
    figure();  
    plotmat2(1,1,1,dh,dv,nh,nv,BC,'Damp.Coeff')
    axis image;  
    colormap(flipud(jet))
end

