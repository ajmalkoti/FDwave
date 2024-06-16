function FDwave_geometry_src_st_line_surf( varargin)%Dn,HFn,HLn,HDn )
% FDWAVE_GEOMETRY_SRC_ST_LINE_SURF 
% It places sources along the surface at a given depth.
% Complete Syntax:
%       FDwave_geometry_src_StLine_Surf('WFP',path,'Depth',value,'FIRST',value,'LAST',value,...
%          'DIFF',value,'DX',value,'DZ',value,'BCTYPE',value,'NAB',value,'PlotON',option)
% Description of parameters:
%       WFP   :  Path to working directory
%       DEPTH :  Depth in terms of nodes
%       FIRST :  Location of first Source along x in terms of nodes
%       LAST  :  Location of last Source  along x in terms of nodes
%       DIFF  :  Difference in consecutive Source  along x in terms of nodes
%       DX    :  Grid size in x direction
%       DZ    :  Grid size in y direction
%       BCTYPE:  Type of boundary used
%       NAB   :  Number of grid nodes used for boundaries.
%       PlotON:  'y'      to plot the source positions
% Note: 
% 1) Give all the position after adding/subtracting the ABC layer thickness according to side where they are added.
% 2) All parameters are mandatory.
%       In case any parameter is not provided the program will try to use the values stored in input folder. 
%       If it cannot find any stored value then it shows error.
% Example:
%       FDwave_geometry_src_StLine_Surf('DEPTH',300,'FIRST',260,'LAST',4400,'DIFF',20,'DX',5,'DZ',5,'BCTYPE','topABC','NAB',50);
%       FDwave_geometry_src_StLine_Surf('WFP',path,'DEPTH',300,'FIRST',260,'LAST',4400,'DIFF',20)
%       FDwave_geometry_src_StLine_Surf()


disp('    FUNC: Source geometry (Along surface)')

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wfp';                    wfp=varargin{i+1};
        case 'depth';                  Dn=varargin{i+1};
        case 'first';                  HFn=varargin{i+1};
        case 'last';                   HLn=varargin{i+1};
        case 'diff';                   HDn=varargin{i+1};
        case 'dx';                     dh=varargin{i+1};
        case 'dz';                     dv=varargin{i+1};
        case 'nx';                     nh=varargin{i+1};
        case 'nz';                     nv=varargin{i+1};
        case 'bctype';                 BCtype=varargin{i+1};
        case 'nab';                    nAB=varargin{i+1};
        case 'ploton';                 plotON=varargin{i+1};
        case 'verbose';                verbose=varargin{i+1};
        otherwise;  error('%s is not a valid argument name',varargin{i});
    end
end

str0='        ';    str1=str0;      str2=str0;      str3=str0;      str4=str0;      
str5=str0;      str6=str0;      str7=str0;      str8=str0;      str9=str0;      str10=str0;      
if ~exist('wfp','var');                                     wfp=pwd;                       end;
if ~exist('plotON','var');                                     plotON='y';                       end;
if ~exist('dh','var')||strcmp(num2str(dh),'-9999');         load([wfp,'\Data_IP\model'],'dh');            str1=[str0,'(Default, stored) '];          end;
if ~exist('dv','var')||strcmp(num2str(dv),'-9999');         load([wfp,'\Data_IP\model'],'dv');            str2=[str0,'(Default, stored) '];          end;
if ~exist('nh','var')||strcmp(num2str(nh),'-9999');         load([wfp,'\Data_IP\model'],'nh');            str3=[str0,'(Default, stored) '];          end;
if ~exist('nv','var')||strcmp(num2str(nv),'-9999');         load([wfp,'\Data_IP\model'],'nv');            str4=[str0,'(Default, stored) '];          end;
if ~exist('BCtype','var')||strcmp(BCtype,'-9999');          load([wfp,'\Data_IP\BC'],'BCtype');           str5=[str0,'(Default, stored) '];          end;
if ~exist('nAB','var')||strcmp(num2str(nAB),'-9999');       load([wfp,'\Data_IP\BC'],'nAB');              str6=[str0,'(Default, stored) '];          end;

if ~exist('Dn','var')||strcmp(num2str(Dn),'-9999');
    Dn=10;
    if  strcmp(BCtype,'topABC');     Dn=Dn+nAB;    end
    str7=[str0,'(Default) '];
end;

if ~exist('HFn','var')||strcmp(num2str(HFn),'-9999');        HFn=1+nAB;           str8=[str0,'(Default) '];        end;
if ~exist('HLn','var')||strcmp(num2str(HLn),'-9999');        HLn=nh-nAB;          str9=[str0,'(Default) '];          end;
if ~exist('HDn','var')||strcmp(num2str(HDn),'-9999');        HDn=2;           str10=[str0,'(Default) '];          end;
if ~exist('verbose','var');        verbose='n';              end;

fprintf('\n')
if strcmp('BCtype','topFS')
    disp([str0,'Depth of all source (m)   :  ' , num2str(Dn*dv),str1])
elseif strcmp('BCtype','topABC')
    disp([str0,'Depth of all source (m)   :  ' , num2str((Dn-nAB)*dv),str1])
end

disp([str0,'First source location (m) :  ', num2str(HFn*dh),str2])
disp([str0,'Last source location (m)  :  ' ,num2str(HLn*dh),str3])
disp([str0,'Distance between two consecutive source :  ' , num2str(HDn*dh),str4])

fprintf('\n')
disp([str0,'Position of source on grid'])
disp([str0,'Depth of all source (in terms of node)   :  ' , num2str(Dn),str1])
disp([str0,'First source location (in terms of node) :  ', num2str(HFn),str2])
disp([str0,'Last source location (in terms of node)  :  ' ,num2str(HLn),str3])
disp([str0,'Distance between two consecutive source (in terms of node):  ' , num2str(HDn),str4])
fprintf('\n')
disp('        Note: Node position in grid(N) & distances(X) related by (N= nAB + X/h), due to ABC layer.');
fprintf('\n')
if strcmp(verbose,'y')
    disp([str0,'Used parameters are: '])
    disp([str0,str0,'dh     :  ' , num2str(dh),str5])
    disp([str0,str0,'dv     :  ' , num2str(dv),str6])
    disp([str0,str0,'nh     :  ' , num2str(nh),str7])
    disp([str0,str0,'nv     :  ' , num2str(nv),str8])
    disp([str0,str0,'BCtype :  ' , BCtype,str9])
    disp([str0,str0,'nAB    :  ' , num2str(nAB),str10])
end

snh_vec = HFn:HDn:HLn;

snv_vec= Dn*ones(size(snh_vec));

geometry_src=sub2ind([nv,nh],snv_vec,snh_vec);
src_n = length(geometry_src);

str=strcat(wfp,'\Data_IP\geometry_src');
save(str,'geometry_src','snv_vec','snh_vec','src_n');

if strcmp(plotON,'y')
     geometry_plot_src('BCPlot','y');
end
end

