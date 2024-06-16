function FDwave_model_derived_elastic_g1(varargin)
%MODEL_DERIVED_ELASTIC
% This function calculate elastic (lame's) parameters
% Complete Syntax:
%       model_derived_elastic_g1('VP',value, 'VS',value, 'RHO',value)
% Description of parameters:
%       VP           : Total time duration for simulation.
%       VS           : Time step
%       RHO          : Central frequency of source
%
%       Note: All parameters are mandatory.
%       In case any parameter is not provided the program will try to use the values stored in input folder.
%       If it cannot find any stored value then it shows error.
% Example:
%       model_derived_elastic_g1('vp',2300,'vs',2100,'rho',1600)
%       model_derived_elastic_g1();
% The assumed grid arrangement stress and velocity is :
%                   txx,tzz----------vx----------txx,tzz------>
%                  lbd,mu  |         bh             |
%                          |          .             |
%                          |          .             |
%                          |          .             |
%                      vz  |..........txz           |
%                      bv  |          muvh          |
%                          |                        |
%                          |                        |
%                          |                        |
%                   txx,tzz|------------------------|
%                          |
%                         \|/
%                          |

global wfp
for i=1:2:length(varargin)
    switch lower(varargin{i})
%         case 'wfp';        wfp=varargin{i+1};
        case 'vp';                  vpm=varargin{i+1};
        case 'vs';                  vsm=varargin{i+1};
        case 'rho';                 rhom=varargin{i+1};
        case 'verbose';             verbose=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end

str0='        ';
str1=str0;          str2=str0;      str3=str0;
% if ~exist('wfp','var');        wfp=pwd;      end

ipdirpath = [wfp,filesep,'Data_IP',filesep];
opdirpath = [wfp,filesep,'Data_OP',filesep];

if ~exist('vpm','var');        load([ipdirpath,'model'],'vpm');    str1=[str0,'(Default, stored)'];      end;
if ~exist('vsm','var');        load([ipdirpath,'model'],'vsm');    str2=[str0,'(Default, stored)'];      end;
if ~exist('rhom','var');       load([ipdirpath,'model'],'rhom');   str3=[str0,'(Default, stored)'];       end;
if ~exist('verbose','var');    verbose='y';     end

if strcmp(verbose,'y')
    disp('    FUNC: Deriving Elastic Parameter for grid type g1');
    disp([str0,' Vp model supplied',str1] )
    disp([str0,' Vs model supplied',str2] )
    disp([str0,' Density model supplied',str3] )
end

mu = vsm.^2.*rhom;
lamu = vpm.^2.*rhom;
lam = lamu-2*mu;

b=1./rhom;
bh=.5*(b(:,1:end-1)+b(:,2:end));
bv= .5*(b(1:end-1,:)+b(2:end,:));
muhv = 0.25*( mu(2:end-1,2:end-1) + mu(3:end,2:end-1) + mu(2:end-1,3:end) + mu(3:end,3:end) );

str=[ipdirpath,'derived_param'];
save(str,'lam','lamu','mu','b','bh','bv','muhv')

if strcmp(verbose,'y')
    disp([str0,' Derived parameters generated successfully'])
    disp([str0,' Derived parameters are saved in "',str])
end
end

