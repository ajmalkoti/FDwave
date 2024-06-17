function FDwave_calculation_plot_WF(varargin)
% CALCULATION_PLOT
% This function is used for plotting the Wavefield with scaling
% and clipping the amplitudes.
% Complete syntax: 
%   calculation_plotWF('WFP',path, 'FileNameWF',path, 'FileNameMod',path ,...
%                'Overlay', option(y/n), 'dh', value,  'dt',value, 'FigNo', value, 
%                'SnapNo',value)
% Description of Parameters
%       WFP         :   path of current working directory
%       FileNameWF  :   wavefiled file name with path
%       FileNameMOD :   model file name with path
%       SnapNo      :   Which snap to plot
%       FigNo       :  Figure No on which you want to plot
%       SubfigNo    :  Subfigure,k in a n-by-m matrix style i.e. [n,m,k]
%             
% Example
%    calculation_plotWF('WFP',pwd, 'FileNameWF','Data_IP\wavefield', 'SnapNo',4)


for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wfp';                        wfp=varargin{i+1};
        case 'filenamewf';                FileNameWF=varargin{i+1};
        case 'filenamemod';                FileNameMod=varargin{i+1};
        case 'overlay';                      overlay=varargin{i+1};
        case 'dh';                         dh= lower(varargin{i+1});
        case 'dt';                          dt= lower(varargin{i+1});
        case 'figno';                     figNO = varargin{i+1};            
        case 'subfigno';                       sfNO = varargin{i+1};
        case 'snapno';                   snapno= varargin{i+1};
        otherwise
           error('%s is not a valid argument name',varargin{i});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('FileNameWF','var');       error('Please enter the wavefield file path');         end
if exist('overlay','var')&& strcmpi(overlay,'y')
    if ~exist('FileNameMod','var');      error('Please enter the model file path');         end
end
if ~exist('dh','var');      load(FileNameWF,'dh');     end
if ~exist('dt','var');      load(FileNameWF,'dt');     end

if ~exist('figNO','var');       h=figure();             end
if  exist('figNO','var');       h=figure(figNO);        end
if  ~exist('sfNO','var');      sfNO=[1,1,1];        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(FileNameWF,'wavefield','nh','nv','dh','dv','dN_W');             
WF=wavefield(:,:,snapno);
set(0,'CurrentFigure',h);

if exist('FileNameMod','var')
    load(FileNameMod,'vpm')
    vpm2= vpm/max(max(vpm));
    wavefield2= wavefield(:,:,snapno)/max(max(wavefield(:,:,snapno)));
    
    WF=vpm2+wavefield2;
end


figure(figNO)
subplot(sfNO(1),sfNO(2),sfNO(3));

h=imagesc((1:nh-1)*dh,(0:nv-1)*dv,WF);
FS=12;
xlabel('X(m)','FontSize',FS);
ylabel('Z(m)','FontSize',FS);
title(['Wavefield at time =',num2str(dt*dN_W*snapno,'%3.6f'),'sec'],'FontSize',FS+1)
set(gca,'XAxisLocation','Top');
set(gca,'FontSize',FS)
grid on;

end