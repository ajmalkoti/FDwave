function FDwave_calculation_plot_ss(varargin)
% CALCULATION_PLOT
% This function is used for plotting the synthetic seimogram with scaling
% and clipping the amplitudes.
% Complete syntax: 
%   calculation_plot('Wave_Type',option,'ShotGather',matrix,'FigNo',value,...
%        'ShotNo',value,'clip',value,'Scale')
% Description of Parameters
%       ShotGather  :  The synthetic seimogram (Optional)
%       Wave_Type   :  'Acoustic', 'Elastic', etc.
%       FigNo       :  Figure No on which you want to plot
%       SubfigNo    :  Subfigure,k in a n-by-m matrix style i.e. [n,m,k]
%       ShotNo      :  Source No, if there are more than one (e.g. for an array)
%       Clip        :  To remove very high amplitudes
%       Scale       :  To enhance deeper/later reflections.
% Example
%    calculation_plot('wave_type','elastic','shotno',5)
%    calculation_plot('wave_type','elastic','shotno',5, 'clip',.95,'scale',6)

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wfp';                         wfp = varargin{i+1};
        case 'filename';               FileName = varargin{i+1};
        case 'wave_type';             wave_type = lower(varargin{i+1});
        case 'geometry_type';      geometry_type= lower(varargin{i+1});
        case 'dh';                            dh= lower(varargin{i+1});
        case 'dt';                            dt= lower(varargin{i+1});
        case 'figno';                     figNO = varargin{i+1};
        case 'subfigno';                   sfNO = varargin{i+1};
        case 'clip';                       clip = varargin{i+1};
        case 'prct';                       prct = varargin{i+1};
        case 'scale';                     scale = varargin{i+1};
        otherwise
           error('%s is not a valid argument name',varargin{i});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('FileName','var')
    error('Please enter the file name');         
end

if ~exist('geometry_type','var')
    geometry_type='surface';     
end

if ~exist('wfp','var')                  
    wfp=pwd;                       
end

ipdirpath = [wfp,filesep,'Data_IP',filesep];
opdirpath = [wfp,filesep,'Data_OP',filesep];

if ~exist('dh','var');      load([opdirpath,FileName],'dh');     end
if ~exist('dt','var');      load([opdirpath,FileName],'dt');     end

if ~exist('figNO','var');       h=figure();             end
if  exist('figNO','var');       h=figure(figNO);        end
if  ~exist('sfNO','var');      sfNO=[1,1,1];        end

if ~exist('prct','var')     
    prct=99;       
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load([opdirpath,FileName],'SS');             
set(0,'CurrentFigure',h);
load([ipdirpath,'geometry_rec'],'geometry_rec_type');
[N,rec_n]=size(SS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('clip','var')
    if isnumeric(clip)
        SS_max=clip*max(max(SS));
        [r,c]=find(SS>SS_max);
        SS(r,c)=SS(r,c)*clip;
    else
        error('Error: Parameter "clip" should be a number. ')
    end
end


if exist('prct','var')
    if isnumeric(prct)
        temp = SS(:);
        val = prctile(temp,prct);
        
        idx = SS>val;
        SS(idx) = val;
        
        idx = SS< -val;
        SS(idx) = -val;
    else
        error('Error: Parameter "prct" should be a number. ')
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('scale','var')
    if isnumeric(scale)
        scaling= linspace(1,scale,N);
        for j=1:rec_n
            SS(:,j)=SS(:,j).*(2.^scaling');
        end
    else
       error('Parameter "scale" is not a number. ') 
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure(figNO)
subplot(sfNO(1),sfNO(2),sfNO(3));

if  strcmp(geometry_rec_type,'VSP')
    imagesc(dt*(0:N-1),dh*(0:rec_n-1),SS');
    title('Synthetic Seismogram (VSP)'); ylabel('X (m)'); xlabel('t (s)');
elseif strcmp(geometry_rec_type,'surface')
    imagesc(dh*(0:rec_n-1),dt*(0:N-1),SS);
    title('Synthetic Seismogram'); xlabel('X (m)'); ylabel('t (s)');
end

colormap(flipud(gray)); 
set(gca,'xaxislocation','top');
grid on;

end