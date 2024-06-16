function FDwave_geometry_rec_st_line_vsp(varargin)%H,DF,DL,DD)
% FDWAVE_GEOMETRY_REC_ST_LINE_VSP
% It places recievers vertically along the depth at some given x.
% The configration is similar to the VSP configration of receivers.
%   Complete Syntax:
%       FDwave_geometry_rec_st_line_vsp('HLOC',value,'FIRST',value,'LAST',value,'DIFF',value...
%                'DX',value,'DZ',value,'BCTYPE',option,'NAB',value,'PlotON',option)
% Description of parameters:
%                HLOC   :  Horizontal location in terms of nodes
%                FIRST  :  Location of first Receiver along x in terms of nodes
%                LAST   :  Location of last Receiver  along x in terms of nodes
%                DIFF   :  Difference in consecutive Receiver along x in terms of nodes
%                DX     :  Grid size in x direction
%                DZ     :  Grid size in y direction
%                BCTYPE :  Type of boundary used
%                NAB    :  Number of grid nodes used for boundaries.
%                PlotON :  'y'/'n'
% Note: 
% 1) Give all the position after adding/subtracting the ABC layer thickness according to side where they are added.
%    Node position in grid(N) & distances(X) related by (N= nAB + X/h), due to ABC layer.'
% 2) In case of free surface two topmost node layers are ignored (imaging technique for Free surface)
%    Hence a node vertical position is given by  N= (X/h)-2;
%
% 3) All parameters are mandatory.
%       In case any parameter is not provided the program will try to use the values stored in input folder. 
%       If it cannot find any stored value then it shows error.
% Example:
%       FDwave_geometry_rec_st_line_vsp('HLOC',500,'FIRST',5,'LAST',1000,'Diff',5,'DX',5,'DZ',5,'BCTYPE','topABC','NAB',50,'PlotON','y')
%       FDwave_geometry_rec_st_line_vsp('HLOC',500,'FIRST',5,'LAST',1000,'DIFF',5,'PlotON','y')
%       FDwave_geometry_rec_st_line_vsp()

disp('    FUNC: Receiver geometry Along Depth (or VSP type)')

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wfp';                    wfp=varargin{i+1};
        case 'hloc';                   Hn=varargin{i+1};
        case 'first';                  DFn=varargin{i+1};
        case 'last';                   DLn=varargin{i+1};
        case 'diff';                   DDn=varargin{i+1};
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
str5=str0;          str6=str0;      str7=str0;      str8=str0;      str9=str0;      str10=str0;      

if ~exist('wfp','var');                                     wfp=pwd;                       end;
if ~exist('dh','var')||strcmp(num2str(dh),'-9999');         load([wfp,'\Data_IP\model'],'dh');            str1=[str0,'(Default, stored) '];          end;
if ~exist('dv','var')||strcmp(num2str(dv),'-9999');         load([wfp,'\Data_IP\model'],'dv');            str2=[str0,'(Default, stored) '];          end;
if ~exist('nh','var')||strcmp(num2str(nh),'-9999');         load([wfp,'\Data_IP\model'],'nh');            str3=[str0,'(Default, stored) '];          end;
if ~exist('nv','var')||strcmp(num2str(nv),'-9999');         load([wfp,'\Data_IP\model'],'nv');            str4=[str0,'(Default, stored) '];          end;
if ~exist('BCtype','var')||strcmp(BCtype,'-9999');          load([wfp,'\Data_IP\BC'],'BCtype');           str5=[str0,'(Default, stored) '];          end;
if ~exist('nAB','var')||strcmp(num2str(nAB),'-9999');       load([wfp,'\Data_IP\BC'],'nAB');              str6=[str0,'(Default, stored) '];          end;
if ~exist('Hn','var')||strcmp(num2str(Hn),'-9999');         Hn=round(nh/2);                str7=[str0,'(Default) '];                  end;
if ~exist('DFn','var')||strcmp(num2str(DFn),'-9999');        
    if strcmp(BCtype,'topFS');              DFn = 3;
    elseif strcmp(BCtype, 'topABC');        DFn = 1+nAB;
    end
    str8=[str0,'(Default) '];        
end;
if ~exist('DLn','var')||strcmp(num2str(DLn),'-9999');        DLn=nv-nAB;          str9=[str0,'(Default) '];          end;
if ~exist('DDn','var')||strcmp(num2str(DDn),'-9999');        DDn=1;               str10=[str0,'(Default) '];          end;
if ~exist('verbose','var');                                  verbose='n';              end;
if ~exist('plotON','var');   plotON='y';  end;

% fprintf('\n')
    disp([str0,'Horizontal position of receiver (m)        :  ', num2str(Hn*dh),str2])
if strcmp(BCtype,'topFS')
    disp([str0,'First receiver depth (m)                   :  ', num2str((DFn-2)*dh),str2])
    disp([str0,'Last receiver depth (m)                    :  ' ,num2str((DLn-2)*dh),str3])
    disp([str0,'Distance between two consecutive receivers :  ' , num2str((DDn)*dh),str4])
elseif strcmp(BCtype,'topABC')
    disp([str0,'First receiver depth (m)                   :  ', num2str((DFn-nAB)*dh),str2])
    disp([str0,'Last receiver depth (m)                    :  ' ,num2str((DLn-nAB)*dh),str3])
    disp([str0,'Distance between two consecutive receivers :  ' , num2str((DDn)*dh),str4])
end

fprintf('\n')

disp([str0,'Position of source on grid'])
disp([str0,'Horizontal position of all receivers (in terms of node)     :  ', num2str(Hn),str1])
disp([str0,'First receiver location (in terms of node)                  :  ', num2str(DFn),str2])
disp([str0,'Last receiver location (in terms of node)                   :  ', num2str(DLn),str3])
disp([str0,'Distance between two consecutive receiver (in terms of node):  ' , num2str(DDn),str4])
fprintf('\n')

% fprintf('\n')

if strcmp(verbose,'y')
    disp([str0,'Used parameters are: '])
    disp([str0,str0,'dh     :  ' , num2str(dh),str5])
    disp([str0,str0,'dv     :  ' , num2str(dv),str6])
    disp([str0,str0,'nh     :  ' , num2str(nh),str7])
    disp([str0,str0,'nv     :  ' , num2str(nv),str8])
    disp([str0,str0,'BCtype :  ' , BCtype,str9])
    disp([str0,str0,'nAB    :  ' , num2str(nAB),str10])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if strcmp(BCtype,'topFS')
%     rnv_vec= 1:nv-nAB;         % all recievers location in vertical direction for VSP
% elseif strcmp(BCtype,'topABC')
%     rnv_vec= 1+nAB:nv-nAB;         % all recievers location in vertical direction for VSP
% end
rnv_vec= DFn:DDn:DLn;
rnh_vec= Hn*ones(size(rnv_vec));    % all recievers location in horizontal direction for VSP (constant)



geometry_rec=sub2ind([nv,nh],rnv_vec,rnh_vec);
rec_n=length(geometry_rec);

geometry_rec_type = 'VSP';

str=strcat(wfp,'\Data_IP\geometry_rec');
save(str,'geometry_rec','rnv_vec','rnh_vec','rec_n','geometry_rec_type')

if strcmp(plotON,'y')
     geometry_plot_rec('BCplot','y');
end
end

