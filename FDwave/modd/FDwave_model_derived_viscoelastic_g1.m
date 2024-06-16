function FDwave_model_derived_viscoelastic_g1( varargin)%fl,fh,L,Q_scaling )
%MODEL_DERIVED_VISCOELSTIC_g1 calculate elastic parameters
% according to grid arrangement stress :
%                   txx,tzz----------v_x--------txx,tzz------>
%                  lbd,mu  |         bh             |
%                          |          .             |
%                          |          .             |
%                          |          .             |
%                      v_z |..........txz           |
%                      bv  |          muvh          |
%                          |                        |
%                          |                        |
%                          |                        |
%                   txx,tzz|------------------------|
%                          |
%                         \|/
%                          |
global wfp
ipdir = [wfp,filesep,'Data_IP',filesep];
opdir = [wfp,filesep,'Data_OP',filesep];


for i=1:2:length(varargin)
    switch lower(varargin{i})
        %case 'wfp';              wfp=varargin{i+1};
        case 'fl';                  fl=varargin{i+1};
        case 'fh';                 fh=varargin{i+1};
        case 'l';                   L=varargin{i+1};
        case 'q_scaling';    Q_scaling=varargin{i+1};
        case 'vp';                vpm=varargin{i+1};
        case 'vs';                 vsm=varargin{i+1};
        case 'rho';               rhom=varargin{i+1};
        case 'qp';                qpm=varargin{i+1};
        case 'qs';                 qsm=varargin{i+1};
        case 'verbose';        verbose=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end

str0='        ';
str1=str0;      str2=str0;      str3=str0;      str4=str0;      str5=str0;      str6=str0;        str7=str0;

%if ~exist('wfp','var');           wfp= pwd;         end
%ipdir = [wfp,filesep,'Data_IP',filesep];
if ~exist('fl','var');            fl = 5;           end
if ~exist('fh','var');            fh = 100;         end
if ~exist('L','var');             L  = 1;           end
if ~exist('Q_scaling','var');     Q_scaling = 1;    end
if ~exist('vpm','var');           load([ipdir ,'model'],'vpm');    str1=[str0,'(Default, stored)'];      end;
if ~exist('vsm','var');           load([ipdir ,'model'],'vsm');    str2=[str0,'(Default, stored)'];      end;
if ~exist('rhom','var');          load([ipdir ,'model'],'rhom');   str3=[str0,'(Default, stored)'];    end;
if ~exist('qpm','var');           load([ipdir ,'model'],'qpm');   str3=[str0,'(Default, stored)'];    end;
if ~exist('qsm','var');           load([ipdir ,'model'],'qsm');   str3=[str0,'(Default, stored)'];    end;

if ~exist('dt','var');            load([ipdir ,'source'],'dt');   str3=[str0,'(Default, stored)'];         end;
if ~exist('verbose','var');       verbose='y';      end

if strcmp(verbose,'y')
    disp('    FUNC: Deriving Elastic Parameter for grid type g1');
    disp([str0,'lower frequency,  fl = ',num2str(fl),str1])
    disp([str0,'higher frequency, fh = ',num2str(fh),str2])
    disp([str0,'No of mechanisms, L  = ',num2str(L),str3])
    disp([str0,'Q scaling factor, Qsc= ',num2str(Q_scaling),str4])
    
    disp([str0,' Vp model supplied',str5])
    disp([str0,' Vs model supplied',str6])
    disp([str0,' Density model supplied',str7])
end

% disp('    FUNC: Estimating Visco-Elastic Parameter for Grid Type g1');
% switch nargin
%     case 0
%         fl=5; fh=60; L=1;  Q_scaling=1;
%         disp('        No input argument. Using the DEFAULT parameters')
%     case {1,2,3}
%         disp('        Partial/Not sufficient parameters')
%     case 4
%         disp('        Using the given parameters')
%     otherwise
%         disp('        Excess parameters will be ignored')
% end
%
% disp(['        lower frequency,  fl = ',num2str(fl)])
% disp(['        higher frequency, fh = ',num2str(fh)])
% disp(['        No of mechanisms, L = ',num2str(L)])
% disp(['        Q scaling factor, Q_scaling  = ',num2str(Q_scaling)])
%
% load('model','nh','nv','vpm','vsm','rhom','qpm','qsm');
% load('source','dt');

[nv,nh]= size(vpm);

[tep3dm,tes3dm,ts3dm] = FDwave_model_derived_viscoelastic_g1_relaxation_time(fl,fh,L,Q_scaling,qpm,qsm,verbose);

[B, P,M,LBD,dP,dM,dLBD, P_r, M_r, temp1, temp2] ...
    = FDwave_model_derived_viscoelastic_g1_const_material2( nh,nv,dt, vpm,vsm,rhom,tep3dm,tes3dm,ts3dm,L);

Bh = 0.5 * (B(:,1:end-1) + B(:,2:end));
Bv = 0.5 * (B(1:end-1,:) + B(2:end,:));

Mxz = 0.25 * ( M(2:end-1,2:end-1) + M(3:end,2:end-1) + M(2:end-1,3:end) + M(3:end,3:end) );            % Mxz =  mu(i+.5, j+.5)
dMxz =  0.25 * ( dM(2:end-1,2:end-1) + dM(3:end,2:end-1) + dM(2:end-1,3:end) + dM(3:end,3:end) );            % Mxz =  mu(i+.5, j+.5)

str= [ipdir,'derived_param'];
save(str,'L','Bh','Bv','P','M','LBD','dP','dM','dLBD','Mxz','dMxz','P_r','M_r','temp1','temp2');

disp('        Derived parameters saved in \Data_IP\derived_param')
end

