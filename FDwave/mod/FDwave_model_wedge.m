function FDwave_model_wedge(varargin)
% MODEL_MARMOUSI_FINESCALE
% This function can load the segy file of marmousi model which is 
% originally a fine scaled model with dx=dz=1.5m.
% This func can CROP as well as INTERPOLATE the model to form a coarse/finer model
% Complete Syntax:
%       model_marmousi_FineScale('wave_type','options',...
%         'crop_model','option', 'x1',value, 'z1',value, 'x2',value, 'z2',value,...
%          'interpolate','option', 'dx_new',value,'dz_new',value )
%
%       Description of parameters:
%       wave_type    : 'acoustic1', 'acoustic2', 'elastic', 'viscoelastic'
%
% Example:
%       model_marmousi_FineScale('wave_type','Elastic',)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('    FUNC: Model Building')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:2:length(varargin)
    switch varargin{i}
        case 'wave_type';                   wave_type=varargin{i+1};
        case 'bgmodel';                     bgmodel=varargin{i+1};
        case 'vertex';                      vertex=varargin{i+1};
        case 'param';                       param = varargin{i+1};
        case 'verbose';                     verbose=varargin{i+1};
        case 'plotON';                      plotON=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end

str0='        ';        str1=str0;          str2=str0;      str3=str0;            
%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('wave_type','var');        wave_type='Elastic';          str1=[str0,'(Default)'];     end;    
if ~exist('use_bg_model','var');          bgmodel='n';                  str1=[str0,'(Default)'];     end;
if ~exist('parameters','var');       error('Parameters are not provided');                      end;

if ~exist('parameters.vertexX','var');       p.vertexx=nh/2;      end
if ~exist('parameters.vertexZ','var');       p.vertexz=nv/2;      end
if ~exist('parameters.updip','var');        p.updip=0;      end
if ~exist('parameters.downdip','var');      p.downdip=30;   end

if ~exist('parameters.wvp','var');      p.wvp=2200;       end
if ~exist('parameters.wvs','var');      p.wvs=2000;       end
if ~exist('parameters.wrho','var');     p.wrho=1700;      end
if ~exist('parameters.wqp','var');      p.wqp=150;        end
if ~exist('parameters.wqs','var');      p.wqs=100;        end

if strcmp(bgmodel,'y'); load('model');
     p.dh=dh;        p.dv=dv;
     p.nh=nh;        p.nv=nv;   
elseif ~strcmp(bgmodel,'y'); 
    if strcmp(wave_type,'Acoustic1');           
        vpm=zeros(nv,nh);
    elseif strcmp(wave_type,'Acoustic2');
        vpm=zeros(nv,nh);        rhom=zeros(nv,nh);
    elseif strcmp(wave_type,'Elastic');         
        vpm=zeros(nv,nh);        vsm=zeros(nv,nh);        rhom=zeros(nv,nh);
    elseif strcmp(wave_type,'Viscoelastic');    
        vpm=zeros(nv,nh);        vsm=zeros(nv,nh);        rhom=zeros(nv,nh);        qpm=zeros(nv,nh);        qsm=zeros(nv,nh);        
    end
    if ~exist('parameters.dh','var');       p.dh=dh;      end
    if ~exist('parameters.dv','var');       p.dv=dv;      end
    if ~exist('parameters.nh','var');       p.nh=nh;      end
    if ~exist('parameters.nv','var');       p.nv=nv;      end   
    if ~exist('parameters.bgvp','var');      p.bgvp=2200;   end
    if ~exist('parameters.bgvs','var');      p.bgvs=30;     end
    if ~exist('parameters.bgrho','var');     p.bgrho=30;    end
    if ~exist('parameters.bgqp','var');      p.bgqp=30;     end
    if ~exist('parameters.bgqs','var');      p.bgqs=30;     end
end

if ~exist('plotON','var')||strcmp('wave_type','-9999');            plotON='n';                  end;
if ~exist('verbose','var')||strcmp('verbose','-9999');             verbose='n';                 end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str=strcat(pwd,'\Data_IP\model');
m_name='Wedge';

if strcmp(wave_type,'Acoustic1');           save(str,'dh','dv','nh','nv','vpm','wave_type','m_name');
elseif strcmp(wave_type,'Acoustic2');       save(str,'dh','dv','nh','nv','vpm','rhom','wave_type','m_name');    
elseif strcmp(wave_type,'Elastic');         save(str,'dh','dv','nh','nv','vpm','vsm','rhom','wave_type','m_name');
elseif strcmp(wave_type,'Viscoelastic');    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','qpm','qsm','wave_type','m_name');
else                                        warning('      Wrong Name entered, No model saved')
end


if strcmp(verbose,'y')
    if strcmp(wave_type,'acoustic1')||strcmp(wave_type,'acoustic2')||strcmp(wave_type,'elastic')||strcmp(wave_type,'viscoelastic')
        disp(['        dh =  ',num2str(dh)] )
        disp(['        dv =  ',num2str(dv)] )
        disp(['        nh =  ',num2str(nh)] )
        disp(['        nv =  ',num2str(nv)] )
        disp(['        Model saved in',str])
        
        if strcmp(plotON,'y')
            FDwave_model_plot('wfp',wfp)
        end
    end
end


end