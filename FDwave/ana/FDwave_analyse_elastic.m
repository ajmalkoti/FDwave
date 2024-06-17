function FDwave_analyse_elastic(varargin)%dt,f0,dh,dv,vpm,vsm)
% ANALYSE_ELASTIC
%       This function is used to check if parameters are satisfying CFL and dispersion condition.
%       In case the conditions does not satisfy, this program will show a warning and continue exectuion.
% Complete Syntax:
%       analyse_elastic('WFP',path,'DT',value, 'F0',value, 'DX',value, 'DZ',value, 'VP',value,'VS',value)
% Description of parameters:
%       WFP : Path to working directory
%       DT  : Time step
%       F0  : Central frequency of source
%       DX  : Grid spacing along x
%       DZ  : Grid spacing along z
%       VP  : Velocity of P wave
%       VS  : Velocity of S wave
%
%       Note: All parameters are mandatory.
%       In case any parameter is not provided the program will try to use the values present in input folder.
%       If it cannot find any stored value then it shows error.
% Example:
%       analyse_elastic('WFP',pwd,'DT',.0002,'F0',20,'DX',5,'DZ',5,'VP',2300,'VS',2100)
%       analyse_elastic()


global wfp
global verbose

for i=1:2:length(varargin)
    switch lower(varargin{i})
        %case 'wfp';                 wfp=varargin{i+1};
        case 'dt';                  dt=varargin{i+1};
        case 'f0';                  f0=varargin{i+1};
        case 'dx';                  dh=varargin{i+1};
        case 'dz';                  dv=varargin{i+1};
        case 'vp';                  vpm=varargin{i+1};
        case 'vs';                  vsm=varargin{i+1};
        case 'verbose';             verbose=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end

str0='        ';
str1=str0;          str2=str0;      str3=str0;      str4=str0;      str5=str0;      str6=str0;

%if ~exist('wfp','var');                                    wfp=pwd;                end;

ipdirpath = [wfp,filesep,'Data_IP',filesep];
opdirpath = [wfp,filesep,'Data_OP',filesep];

if ~exist('dt','var')||strcmp(num2str(dt),'-9999');        load([ipdirpath,'source'],'dt');         str1=[str0,'(Default, stored)'];         end;
if ~exist('f0','var')||strcmp(num2str(f0),'-9999');        load([ipdirpath,'source'],'f0');         str2=[str0,'(Default, stored)'];         end;
if ~exist('dh','var')||strcmp(num2str(dh),'-9999');        load([ipdirpath,'model'],'dh');          str3=[str0,'(Default, stored)'];         end;
if ~exist('dv','var')||strcmp(num2str(dv),'-9999');        load([ipdirpath,'model'],'dv');          str4=[str0,'(Default, stored)'];         end;
if ~exist('vpm','var')||strcmp(num2str(vpm),'-9999');      load([ipdirpath,'model'],'vpm');         str5=[str0,'(Default, stored)'];         end;
if ~exist('vsm','var')||strcmp(num2str(vsm),'-9999');      load([ipdirpath,'model'],'vsm');         str6=[str0,'(Default, stored)'];         end;
if ~exist('verbose','var');    verbose='y';     end

if strcmp(verbose,'y')
    disp('    FUNC: Analysis for Elastic wave')
    disp([str0,'Time step size,         dt =  ',num2str(dt),str1] )
    disp([str0,'Source Frequency,       f0 =  ',num2str(f0),str2] )
    disp([str0,'Grid spacing Taken,     dx =  ',num2str(dh),str3] )
    disp([str0,'Total time duration,    dz =  ',num2str(dv),str4] )
    disp([str0,'Vp model supplied',str5] )
    disp([str0,'Vs model supplied',str6] )
    disp([str0,str0,'Analysis Results:'])
end
%%%%%%%%%%%%%%%%%%%%%%
p=min(dh,dv); 
check=0.606*p/max(max(vpm));

if strcmp(verbose,'y')
    if(dt<=check)
        fprintf('        Given time step: ok;        "dt" Present value( %f) < Required( %f). \n',dt,check)
    else
        error('        Revise time step...!!!      "dt" Present value( %f) > Required( %f). \n',dt,check)
        %     temp= input('');
    end
end
%%%%%%%%%%%%%%%%%%%
p=max(dh,dv);
vsm_min=min(min(vsm));
if vsm_min~=0
    check = vsm_min/6/f0;
else
    if strcmp(verbose,'y');        disp('        Since, min(Vs)=0 so using the min(Vp)') ; end
    vpm_min=min(min(vpm));
    check = vpm_min/6/f0;
end
%%%%%%%%%%%%%%%%%%%
if strcmp(verbose,'y')
    if (p<=check )
        fprintf('        Given grid spacing:  ok;      "dh" Present value( %f) < Required( <%f). \n',p,check)
    else
        warning('        Revise grid spacing...!!!!      "dh" Present value( %f) > Required( <%f). \n',p,check)
        %     temp= input('');
    end
    
    fprintf('        CFL and Grid size requirement analysis done.  \n \n')
end
end