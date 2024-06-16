function FDwave_geometry_src_single(varargin)  %sv,shn,dh,dv,BCtype,nAB )
% FDWAVE_GEOMETRY_SRC_SINGLE 
% It places a single source at the given location
% Check is applied so that no reciever is placed in absorbing boundary.
% Complete Syntax:
%     FDwave_geometry_src_Single('WFP',path,'SX',value, 'SZ',value,'DX',value,'DZ',value,
%          'NX',value,'NZ',value,'BCTYPE',value, 'NAB',value)
% Description of parameters:
%         WFP   :  Path to working directory
%         SX    :  Node Location of source (x-position)
%         SZ    :  Node Location of source (z-position)
%         DX    :  Grid size in x direction
%         DZ    :  Grid size in y direction
%         NX    :  No of nodes in model along X axis
%         NZ    :  No of nodes in model along Z axis
%         BCTYPE:  Type of boundary used
%         NAB   :  Number of grid nodes used for boundaries.
%         PlotON:  'y'      to plot the source positions
% Note: 
% 1) Do not place source very close to surface.
% 2) Give all the position after adding/subtracting the ABC layer thickness 
%    according to side where they are added. 
%    e.g. if you want to place source at some depth then grid location for
%         topABC is then, Sz = nAB + dept/dz 
% 3) All parameters are mandatory.
%       In case any parameter is not provided the program will try to use 
%       the values stored in input folder. 
%       If it cannot find any stored value then it shows error.
% Example:
%       FDwave_geometry_src_Single('WFP',pwd,'Sx',2000,'Sz',300,'dx',5,'dz',5,'BCtype','topABC','nAB',50,'PlotON','Y');
%       FDwave_geometry_src_Single('Sx',2000,'Sz',300)
%       FDwave_geometry_src_Single()

global wfp
ipdir = [wfp,filesep,'Data_IP',filesep];
opdir = [wfp,filesep,'Data_OP',filesep];


for i=1:2:length(varargin)
    switch lower(varargin{i})        
        case 'sx';                  snh=varargin{i+1};
        case 'sz';                  snv=varargin{i+1};
        case 'dx';                  dh=varargin{i+1};
        case 'dz';                  dv=varargin{i+1};
        case 'nx';                  nh=varargin{i+1};
        case 'nz';                  nv=varargin{i+1};
        case 'bctype';              BCtype=varargin{i+1};
        case 'nab';                 nAB=varargin{i+1};
        case 'ploton';              plotON=varargin{i+1};
        case 'verbose';             verbose=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end

str0='        ';   str1=str0;      str2=str0;      str3=str0;      str4=str0;      str5=str0;      str6=str0;      str7=str0;      str8=str0;      

if ~exist('dh','var')||strcmp(num2str(dh),'-9999');     load([ipdir,'model'],'dh');            str3=[str0,'(Default, stored) '];          end
if ~exist('dv','var')||strcmp(num2str(dv),'-9999');     load([ipdir,'model'],'dv');            str4=[str0,'(Default, stored) '];          end
if ~exist('nh','var')||strcmp(num2str(nh),'-9999');     load([ipdir,'model'],'nh');            str5=[str0,'(Default, stored) '];          end
if ~exist('nv','var')||strcmp(num2str(nv),'-9999');     load([ipdir,'model'],'nv');            str6=[str0,'(Default, stored) '];          end
if ~exist('BCtype','var')||strcmp(BCtype,'-9999');      load([ipdir,'BC'],'BCtype');           str7=[str0,'(Default, stored) '];          end
if ~exist('nAB','var')||strcmp(num2str(nAB),'-9999');   load([ipdir,'BC'],'nAB');              str8=[str0,'(Default, stored) '];          end
if ~exist('verbose','var');        verbose='n';              end;

if ~exist('snh','var')||strcmp(num2str(snh),'-9999');         snh = round(.5*nh);             str1=[str0,'(Default) '];        end;
if ~exist('snv','var')||strcmp(num2str(snv),'-9999');         snv= 6;                       str2=[str0,'(Default) '];        end;
if ~exist('plotON','var');   plotON='n'; end

% if strcmp(BCtype,'topABC');    
%  snv= snv+nAB;
% end
if ~exist('verbose','var');    verbose='y';     end

if strcmp(verbose,'y')
disp('    FUNC: Source geometry (Single at surface)')
disp([str0,'Source location along x(m)       :  ', num2str(snh*dh),str1])
disp([str0,'Source location along z(m)       :  ', num2str(snv*dv),str2])
disp([str0,'Source node location along x     :  ', num2str(snh),str1])
disp([str0,'Source node location along z     :  ', num2str(snv),str2])
disp([str0,'Note: the program take care of absorbing boundary nodes (if present).'])
if strcmp(verbose,'y')
    disp([str0,'Used parameters are'])
    disp([str0,str0,'Model dx     :  ' , num2str(dh),str3])
    disp([str0,str0,'Model dz     :  ' , num2str(dv),str4])
    disp([str0,str0,'Model nx     :  ' , num2str(nh),str5])
    disp([str0,str0,'Model nz     :  ' , num2str(nv),str6])
    disp([str0,str0,'BCtype       :  ' , BCtype,str7])
    disp([str0,str0,'nAB          :  ' , num2str(nAB),str8])
end

end 

snh_vec= snh;    % source location in horizontal direction
snv_vec= snv;

geometry_src=sub2ind([nv,nh],snv_vec,snh_vec);
src_n=length(geometry_src);
geometry_src_type = 'single';

str=[ipdir,'geometry_src'];
save(str,'geometry_src','snv_vec','snh_vec','src_n','geometry_src_type')

if strcmp(verbose,'y')
    disp(['        Source geometry saved in "',str,'"'])
end

if strcmp(plotON,'y')
     geometry_plot_src('BCPlot','y');
end

