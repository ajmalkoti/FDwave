function model_read_segy(varargin)%plotON,  crop_model,h1,v1,h2,v2,    interpolate,dh_new,dv_new )
% MODEL_READ_SEGY
% This function can load the segy file of marmousi model which is 
% originally a fine scaled model with dx=dz=1.5m.
% This func can CROP as well as INTERPOLATE the model to form a coarse/finer model
% Complete Syntax:
%       model_read_segy('WFP',path,'M_NAME',name,'WAVE_TYPE',options,...
%         'CROP_MODEL',option, 'X1',value, 'Z1',value, 'X2',value, 'Z2',value,...
%          'INTERPOLATE',option, 'DX_NEW',value,'DZ_NEW',value,...
%         PAD,option,PADN,value,PADSIDE,option,'PlotON',option )
%
%       Description of parameters:
%       WFP          :  Path of the folder where model should be saved.
%       M_NAME       :  Name of the model (string)
%       WAVE_TYPE    :  'acoustic1', 'acoustic2', 'elastic', 'viscoelastic'
%
%       CROP_MODEL   :  'y/n'   ( If selected yes then following parameters must be provided:  
%                       X1, Z1 represent the left upper corner of selected model
%                       X2, Z2  represent the right lower corner of selected model
%
%       INTERPOLATE  : 'y'/'n'   ( If selected yes then following parameters must be provided: 
%                       DX_NEW, DZ_NEW: new grid spacing(in meters) along x and z direction
%
%       PAD          :  'y'/'n' ( If selected yes then following parameters must be provided: 
%                       PADN    : No of layers to be placed outside extra
%                       PADSIDE : 'tblr'/'blr'
%       PlotON       :  'y'/'n'
% Example:
%       model_read_segy('WAVE_TYPE','elastic',...
%         'CROP_MODEL','y', 'X1',7000, 'Z1',600, 'X2',15000, 'Z2',4200,...
%         'INTERPOLATE','Y', 'DX_NEW',12.5,'DZ_NEW',12.5)
%
% Note: Initialization must have been performed.  
%       acoustic1 - requires VP
%       acoustic2 - requires VP, RHO
%       elastic   - requires VP, VS, RHO
%       viscoelastic - require VP, VS, RHO, QP, QS
%       The vector is in the form of e.g. [600,700,800,1000]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('    FUNC: Model Building')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wave_type';                wave_type=varargin{i+1};
        case 'wfp';                      wfp=varargin{i+1};
        case 'm_name';                   m_name=varargin{i+1};
        
        case 'crop_model';                  crop_model=varargin{i+1};
        case 'x1';                          h1=varargin{i+1};
        case 'z1';                          v1=varargin{i+1};
        case 'x2';                          h2=varargin{i+1};
        case 'z2';                          v2=varargin{i+1};
        
        case 'interpolate';                 interpolate=varargin{i+1};
        case 'dx_new';                      dh_new=varargin{i+1};
        case 'dz_new';                      dv_new=varargin{i+1};
            
        case 'pad';                         pad_model=varargin{i+1};
        case 'padn';                        padN=varargin{i+1};
        case 'padside';                     padSide=varargin{i+1};
            
        case 'verbose';                     verbose=varargin{i+1};
        case 'ploton';                      plotON=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end
str0='        ';   
str1=str0;          str2=str0;      str3=str0;            

disp([str0,'Model Selected: MARMOUSI'])
disp([str0,'Note: This function require the SegyMAT package installed'])
disp([str0,str0,'Provided parameters']);

if ~exist('wfp','var');              wfp=pwd;                   end;    

if ~exist('wave_type','var');        wave_type='elastic';       str1=[str0,'(Default)'];     
else        wave_type=lower(wave_type);             end;    

if ~exist('m_name','var');           m_name='marmousi';         str1=[str0,'(Default)'];     end;    
%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('crop_model','var');
    crop_model='n';     
    str2=['No',str0,'(Default)'];
else
    str2='Yes';
    if (~exist('h1','var')||~exist('h2','var')||~exist('v1','var')||~exist('v2','var'));
        error('Not sufficient parameters to crop model')
    end
end

%%%%%%%%%%%%%%%%%%%%%
if ~exist('interpolate','var');
    interpolate='n';
    str3=['No',str0,'(Default)'];
else
    str3='Yes';
    if (~exist('dh_new','var')||~exist('dv_new','var'));
        error('Not sufficient parameters to interpolate the model')
    end
end

%%%%%%%%%%%%%%%%%%%%
disp([str0,'Type of wave    : ',wave_type,str1] )
disp([str0,'Cropped         : ',str2] )
disp([str0,'Interpolated    : ',str3])

if ~exist('pad_model','var');                      pad_model='n';         str3=['No',str0,'(Default)'];          end 
if  exist('pad_model','var')&&strcmp(pad_model,'y');     str3='Yes';
    if ~exist('padN','var')||~exist('padSide','var');            error('Not sufficient parameters to pad model');        end;
 end

if ~exist('plotON','var')||strcmp('wave_type','-9999');           plotON='n';                  end;
if ~exist('verbose','var')||strcmp('wave_type','-9999');          verbose='n';                 end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dh= 1.5;     dv= 1.5;     % Horizontal , Vertical grid spacing

str=[wfp,'\Data_IP\',m_name,'_vp.segy'];
if ~exist(str,'file');   error(['Velocity (Vp) file does not exists in input folder (',str,')']);   
else                     vpm  = 1000*ReadSegy(str);
end

if strcmp(wave_type,'acoustic2')
    str=[wfp,'\Data_IP\',m_name,'_rho.segy'];
    if ~exist(str,'file');      error(['Density (dens) file does not exists in input folder (',str,')']); 
    else                        rhom =1000* ReadSegy(str);        
    end
    
elseif strcmp(wave_type,'elastic')
    str=[wfp,'\Data_IP\',m_name,'_vs.segy'];
    if ~exist(str,'file');    error(['Velocity (Vs) file does not exists in input folder (',str,')']);   
    else vsm  = 1000*ReadSegy(str);
    end
    
    str=[wfp,'\Data_IP\',m_name,'_rho.segy'];
    if ~exist(str,'file');    error(['Density (dens) file does not exists in input folder (',str,')']);   
    else rhom = 1000*ReadSegy(str);
    end
   
elseif strcmp(wave_type,'viscoelastic')
     str=[wfp,'\Data_IP\',m_name,'_vs.segy'];
    if ~exist(str,'file');    error(['Velocity (Vs) file does not exists in input folder (',str,')']);   
    else vsm  = 1000*ReadSegy(str);
    end
    
    str=[wfp,'\Data_IP\',m_name,'_rho.segy'];
    if ~exist(str,'file');    error(['Density (dens) file does not exists in input folder (',str,')']);   
    else rhom = 1000*ReadSegy(str);
    end
    
    str=[wfp,'\Data_IP\',m_name,'_qp.segy'];
    if ~exist(str,'file');    error(['Qp file does not exists in input folder (',str,')']);  
    else qpm  = ReadSegy(str);
    end
    
    str=[wfp,'\Data_IP\',m_name,'_qs.segy'];
    if ~exist(str,'file');    error(['Qs file does not exists in input folder (',str,')']);  
    else  qsm = ReadSegy(str);
    end
end

[nv,nh] = size(vpm);

% if strcmp(plotON,'y')
%     if strcmp(crop_model,'y')&& strcmp(interpolate,'y')
%         sp1=3;   sp2=1; sp3=1;
%         figure();subplot(sp1,sp2,sp3); imagesc(dh*(0:nh-1),dv*(0:nv-1),vpm);axis ij; title('Original')
%         xlabel('X(m)'); zlabel('Z(m)');
%     elseif xor(strcmp(crop_model,'y'),strcmp(interpolate,'y'))
%         sp1=2;   sp2=1; sp3=1;
%         figure(20);subplot(sp1,sp2,sp3); imagesc(dh*(0:nh-1),dv*(0:nv-1),vpm);axis ij; title('Original')
%         xlabel('X(m)'); zlabel('Z(m)');
%     end
% end

if strcmp(plotON,'y')
    test=1;
    if strcmp(crop_model,'y');      test=test+1;    end
    if strcmp(interpolate,'y');     test=test+1;    end
    if strcmp(pad_model,'y');             test=test+1;    end
    
    if test==1;     sp1=1;   sp2=1; sp3=1;      end
    if test==2;     sp1=2;   sp2=1; sp3=1;      end
    if test>=3;     sp1=2;   sp2=2; sp3=1;      end
end

figh= figure();
subplot(sp1,sp2,sp3); imagesc(dh*(0:nh-1),dv*(0:nv-1),vpm);axis ij; title('Original')
xlabel('X(m)'); ylabel('Z(m)');



if strcmp(crop_model,'y')
    h1n= round(h1/dh);    v1n= round(v1/dv);
    h2n= round(h2/dh);    v2n= round(v2/dv);
    if strcmp(wave_type,'acoustic1')
        vpm = vpm( v1n:v2n ,h1n:h2n );
    elseif strcmp(wave_type,'acoustic2')
        vpm = vpm( v1n:v2n ,h1n:h2n );
        rhom = rhom( v1n:v2n ,h1n:h2n );
    elseif strcmp(wave_type,'elastic')
        vpm = vpm( v1n:v2n ,h1n:h2n );
        vsm = vsm( v1n:v2n ,h1n:h2n );
        rhom = rhom( v1n:v2n ,h1n:h2n );
    elseif strcmp(wave_type,'viscoelastic')
        vpm = vpm( v1n:v2n ,h1n:h2n );
        vsm = vsm( v1n:v2n ,h1n:h2n );
        rhom = rhom( v1n:v2n ,h1n:h2n );
        qpm = qpm( v1n:v2n ,h1n:h2n );
        qsm = qsm( v1n:v2n ,h1n:h2n );
    end
    [nv,nh] = size(vpm);
    
    if strcmp(plotON,'y')
        sp3=sp3+1;
        figh=figure(figh);subplot(sp1,sp2,sp3); imagesc(dh*(0:nh-1),dv*(0:nv-1),vpm);axis ij; title('Cropped')
        xlabel('X(m)'); ylabel('Z(m)');
    end
end



if strcmp(interpolate,'y')
    h = dh*(0: (nh-1)); % original axis for the vpm
    v = dv*(0: (nv-1));
    [H,V] = meshgrid(h,v);
    h_IP = 0:dh_new:dh*(nh-1);  % interpolated
    v_IP = 0:dv_new:dv*(nv-1);
    [H_IP,V_IP] = meshgrid(h_IP,v_IP);
    if strcmp(wave_type,'acoustic1')
        vpm = interp2(H,V,vpm,H_IP,V_IP);
    elseif strcmp(wave_type,'acoustic2')
        vpm = interp2(H,V,vpm,H_IP,V_IP);
        rhom = interp2(H,V,rhom,H_IP,V_IP);
    elseif strcmp(wave_type,'elastic')
        vpm = interp2(H,V,vpm,H_IP,V_IP);
        vsm = interp2(H,V,vsm,H_IP,V_IP);
        rhom = interp2(H,V,rhom,H_IP,V_IP);
    elseif strcmp(wave_type,'viscoelastic')
        vpm = interp2(H,V,vpm,H_IP,V_IP);
        vsm = interp2(H,V,vsm,H_IP,V_IP);
        rhom = interp2(H,V,rhom,H_IP,V_IP);
        qpm = interp2(H,V,qpm,H_IP,V_IP);
        qsm = interp2(H,V,qsm,H_IP,V_IP);
    end
    dh=dh_new;
    dv=dv_new;
    [nv,nh] = size(vpm);
    if strcmp(plotON,'y')
        sp3=sp3+1;
        figh=figure(figh); subplot(sp1,sp2,sp3); imagesc(dh*(0:nh-1),dv*(0:nv-1),vpm);axis ij; title('Interpolated')
        xlabel('X(m)'); ylabel('Z(m)');
    end
end



if strcmp(pad_model,'y') 
    if strcmp(padSide,'tblr')
         if strcmp(wave_type,'acoustic1')
             vpm = padarray_TB_LR(vpm,padN);
         elseif strcmp(wave_type,'acoustic2')
             vpm = padarray_TB_LR(vpm,padN);
             rhom = padarray_TB_LR(rhom,padN);
         elseif strcmp(wave_type,'elastic')
             vpm = padarray_TB_LR(vpm,padN);
             vsm = padarray_TB_LR(vsm,padN);
             rhom = padarray_TB_LR(rhom,padN);
         elseif strcmp(wave_type,'viscoelastic')
             vpm = padarray_TB_LR(vpm,padN);
             vsm = padarray_TB_LR(vsm,padN);
             rhom = padarray_TB_LR(rhom,padN);
             qpm = padarray_TB_LR(qpm,padN);
             qsm = padarray_TB_LR(qsm,padN);
         end
    elseif strcmp (padSide,'blr')
        if strcmp(wave_type,'acoustic1')
             vpm = padarray_B_LR(vpm,padN);
         elseif strcmp(wave_type,'acoustic2')
             vpm = padarray_B_LR(vpm,padN);
             rhom = padarray_B_LR(rhom,padN);
         elseif strcmp(wave_type,'elastic')
             vpm = padarray_B_LR(vpm,padN);
             vsm = padarray_B_LR(vsm,padN);
             rhom = padarray_B_LR(rhom,padN);
         elseif strcmp(wave_type,'viscoelastic')
             vpm = padarray_B_LR(vpm,padN);
             vsm = padarray_B_LR(vsm,padN);
             rhom = padarray_B_LR(rhom,padN);
             qpm = padarray_B_LR(qpm,padN);
             qsm = padarray_B_LR(qsm,padN);
        end
    else 
        error('The name provided for "padSide" did not met to existing database.')
    end
    [nv,nh] = size(vpm);
     if strcmp(plotON,'y')
        sp3=sp3+1;
        figh=figure(figh); subplot(sp1,sp2,sp3); imagesc(dh*(0:nh-1),dv*(0:nv-1),vpm);axis ij; title('Padded')
        xlabel('X(m)'); ylabel('Z(m)');
    end
end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str=strcat(wfp,'\Data_IP\model');
% m_name='Marmousi_FineScale';

if strcmp(wave_type,'acoustic1')
    %m_name='Homogeneous Acoustic 1 (scaler)';
%     disp(['    Model selected:    ',wave_type,' -',m_name, ' model'])
    save(str,'dh','dv','nh','nv','vpm','wave_type','m_name');
    
elseif strcmp(wave_type,'acoustic2')
    %m_name='Homogeneous Acoustic 1 (scaler)';
%     disp(['    Model selected:    ',wave_type,' -',m_name, ' model'])
    save(str,'dh','dv','nh','nv','vpm','rhom','wave_type','m_name');    
    
elseif strcmp(wave_type,'elastic')
    %m_name='Homogeneous elastic';
%     disp(['    Model selected:    ',wave_type,' -',m_name, ' model'])
    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','wave_type','m_name');
    
elseif strcmp(wave_type,'viscoelastic')
    %m_name='Homogeneous viscoelastic';
%     disp(['    Model selected:    ',wave_type,' -',m_name, ' model'])
    save(str,'dh','dv','nh','nv','vpm','vsm','rhom','qpm','qsm','wave_type','m_name');
else
    warning('      Wrong Name entered, No model saved')
end

disp([str0,str0,'Final model properties ']);
disp(['        dh =  ',num2str(dh)] )
disp(['        dv =  ',num2str(dv)] )
disp(['        nh =  ',num2str(nh)] )
disp(['        nv =  ',num2str(nv)] )
disp(['        Model saved in "',str])

if strcmp(plotON,'y')
    FDwave_model_plot('wfp',wfp)
end

end