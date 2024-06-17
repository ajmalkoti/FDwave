function FDwave_calculation_animate2(varargin)
% CALCULATION_PLOT_ANIMATE
% To animate the wave propagation in given model and visualizing the
% evolution wavefield as well as seismogram simultaneously.
% It can produce four types of outputs
% 1) wavepropagation
% 2) wavepropagation + model
% 3) wavepropagation + synthetic seismogram
% 4) wavepropagation + model + synthetic seismogram
%
% Complete Syntax:
%        FDwave_calculation_animate('WFP',path, 'ssfilename',path,...
%            'wffilename',path, 'mfilename',path, 'dx', value, 'dz', value,'dt',value)
% Description of parameters:
%         wfp       :   path to working folder
%         ssfilename:   Name of seismogram file with path
%         wffilename:   Name of wavefield file with path
%         mfilename :   Name of model file with path
%         figno     :
%         dx        :   Spacing along x
%         dz        :   Spacing along z
%         dt        :   Time stepping
%         shotno    :   Not used
%         wavetype  :   Not used
%         time_vec  :   Not used
%         clip      :   Not used
%         scale     :   Not used
% Example:
%      FDwave_calculation_animate('WFP',wf_path,'dx',5,'dz',5,'dt',0.0005,...
%         'WFFileName','Data_OP\wavefield_1',  'mFileName','Data_IP\model');
%
global wfp verbose ploton
ipdir = [wfp,filesep,'Data_IP',filesep];
opdir = [wfp,filesep,'Data_OP',filesep];


for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wffile';  wffnwp=varargin{i+1};
        case 'mfile';   mfnwp=varargin{i+1};
        case 'ssfile';  ssfnwp=varargin{i+1};
        case 'xvec';    xvec=varargin{i+1};
        case 'zvec';    zvec=varargin{i+1};
        case 'tvec';    tvec=varargin{i+1};    
            
        case 'prct';    prct = varargin{i+1};
        case 'figno';   figNo = varargin{i+1};
        case 'clip';    clip = varargin{i+1};
        case 'scale';   scale = varargin{i+1};
            
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('figNo','var');   figNo = 1;      end
if ~exist('prct','var');    prct  = 99.5;   end
if ~exist('clip','var');    clip  = 1;      end
if ~exist('scale','var');   scale = 1;      end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load data according to requirements %%%%%%

PlotWF='y';     PlotSS='n';     PlotM='n';

%%%% check whether wfdata is provided, if not then raise error
if ~exist('wffnwp','var')
    error('Error: wffile does not exist.') 
end    
wfdata = load(wffnwp);    
wfN = size(wfdata.wavefield);
if isnumeric(prct)
    temp = wfdata.wavefield(:);
    val = prctile(temp,prct);        
    idx = wfdata.wavefield>val;       wfdata.wavefield(idx) = val;        
    idx = wfdata.wavefield<-val;      wfdata.wavefield(idx) = -val;
end
            
%%%% check whether model file (optional) is provided or not?
if exist('mfnwp','var')  
    PlotM='y';    mdata = load(mfnwp);      
end

%%%% check whether ss file (optional) is provided or not?
if exist('ssfnwp','var')
    PlotSS='y';   ssdata = load(ssfnwp);
    if isnumeric(prct)
        temp = ssdata.SS(:);
        val = prctile(temp,prct);        
        idx = ssdata.SS>val;       ssdata.SS(idx) = val;
        idx = ssdata.SS<-val;      ssdata.SS(idx) = -val;
    end
end


%%%% check whether tvec (optional) is provided or not?
if exist('tvec','var')    
    if ~(len(tvec) == wfN(3))
        error('Length of tvec and wfdatasize(3) are not equal')
    end
else        
    tvec=(0:wfN-1)*(wfdata.dN_W * wfdata.dt);
end

%%%% check whether xvec (optional) is provided or not?
if exist('xvec','var')    
    if ~(len(xvec) == wfN(2))
        error('Length of xvec and wfdatasize(2) are not equal')
    end
else        
    xvec= (0: (wfN(2)-1) )* wfdata.dh;
end


%%%% check whether xvec (optional) is provided or not?
if exist('zvec','var')    
    if ~(len(zvec) == wfN(2))
        error('Length of zvec and wfdatasize(2) are not equal')
    end
else        
    zvec= (0: (wfN(1)-1) )* wfdata.dv;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PlotWF == 'y' && PlotM =='n'
    data11 = wfdata.wavefield;
elseif PlotWF == 'y' && PlotM =='y'
    wfN = size(wfdata.wavefield);
    data11 = zeros(wfN);
    for i = 1:wfN(3)        
        data11(:,:,i) = wfdata.wavefield(:,:,i)/max(max(wfdata.wavefield(:,:,i))) ...
                + mdata.vpm/max(max(mdata.vpm));
    end
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp = split(wffnwp,'/') ;
vfname = [temp{end},'.mp4'];
v = VideoWriter (vfname );
v.Quality = 95;

open (v);

figure()
set(gcf,'Position',[100 100 900 600])

for iframe = 1:wfN(3)  
    imagesc(zvec,xvec,data11(:,:,iframe))
    axis ij
    % axis equal
    xlabel('x [m]')
    ylabel('z [m]')
    set(gca,'XAxisLocation','top')
    
    hold on
    drawnow;
    frame = getframe (gcf);
    writeVideo (v, frame);
    hold off;
end
close (v)

% %%%%%%%%%%%%%%%%%%%%%%%
%
% h=figure(figNo);
% title('Stretch window to set size of the figure')
% subplot(if1,1,1); axis equal
% subplot(if1,1,if3);
%
% choosedialog()
%
% i1=1; i2=1;
% if strcmp(PlotSS,'y');
%     i1=2;
%     SS_plot=zeros(size(SS));
% end
%
% if ((PlotSS=='n')&&(PlotWF=='n'))
%     warning('Neigher Wave Field nor Synthetic seismogram is provided')
%     return
% end
%
% save_path=[opdir,'snap'];
%
% %%%%%%%%%%%%%%%%%%%%%%%%%
% nFrames = nw-1;
% Frames(1:nFrames) = struct('cdata',[], 'colormap',[]);
%
%
%
% for i=1:nFrames;
%     disp(['i = ',num2str(i)]);
%     %%% wavefield
%     if((PlotWF=='y')&&(PlotM=='n'))
%         subplot(i1,i2,1);
%         imagesc(dv*(0:nv-1),dh*(0:nh-1),wavefield(:,:,i));
%         cmax=max(max(wavefield(:,:,i)));
%         cmin=min(min(wavefield(:,:,i)));
%         caxis([cmin cmax]);     %colormap(flipud(gray));
%
%         title(['Time = ',num2str(TVec(i)),'sec']);    xlabel('x (meters)'); ylabel('z (meters)');
%         axis image;     set(gca,'XAxisLocation','top');
%         grid on;
%         axis image
%
%     elseif((PlotWF=='y')&&(PlotM=='y'))
%         clf
%         cmax1= max(max(wavefield(:,:,i)));
%         cmin1= min(min(wavefield(:,:,i)));
%         cmax2= max(max(vpm));
%         cmin2= min(min(vpm));
%         temp= 8*(wavefield(:,:,i)-cmin1)/(cmax1-cmin1) ...
%               + (vpm-cmin2)/(cmax2-cmin2);
%         subplot(i1,i2,1);        imagesc(temp)
%         title(['Time = ',num2str(TVec(i)),'sec']);
%         xlabel('x (meters)'); ylabel('z (meters)');
%         axis image;     set(gca,'XAxisLocation','top');
%         colormap('gray')
%         grid on;
%         ha=annotation('textbox', [0.7, 0.9, 0.1, 0.1], 'String', 'FDwave, Malkoti et. al. 2018');
%         set(ha,'LineStyle','none')
%     end
%
%     %
%     if strcmp(PlotSS,'y')
%         %subplot(i1,i2,2);          imagesc(dh*(0:nh-1),dv*(0:nv-1),wavefield(:,:,i));
%         %         title(['Time = ',int2str(TVec(i))]);
%         %SS_plot(1:i*dN_W,:)=SS(1:i*dN_W,:);
%
%         % as the dN_SS and dN_W are different so bring them to same scale
%         scale_frame=round(dN_W/dN_SS);
%
%         %Now selection of the portion
%         SS_plot(1:scale_frame*i,:)=SS(1:scale_frame*i,:);
%         subplot(i1,i2,2);          imagesc(dh*(0:nh-1),dt*(0:nt-1),SS_plot);
%         ylabel('Time(sec)');
%         xlabel('Reciever Number')
%         caxis([cmin cmax]);        %colormap(flipud(gray));
%     end
%
%     pause(.1)
%     Frames(i) = getframe(h);
% end
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% https://in.mathworks.com/matlabcentral/answers/426314-movie2avi-has-been-removed
%
% str=[wfp,'/Data_OP/wave_',num2str(shotNo),'.avi'];
% movie2avi(Frames, str, 'compression', 'none');



end


function choice = choosedialog

d = dialog('Position',[300 300 250 150],'Name','Select One','WindowStyle', 'normal');
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 80 210 40],...
    'String','Click close when you are done with figure resizing');

%     popup = uicontrol('Parent',d,...
%            'Style','popup',...
%            'Position',[75 70 100 25],...
%            'String',{'I have done resizing figure'},...
%            'Callback',@popup_callback);

btn = uicontrol('Parent',d,...
    'Position',[89 20 70 25],...
    'String','Done Resizing',...
    'Callback','delete(gcf)');

choice = 'Red';

% Wait for d to close before running to completion
uiwait(d);

    function popup_callback(popup,callbackdata)
        idx = popup.Value;
        popup_items = popup.String;
        % This code uses dot notation to get properties.
        % Dot notation runs in R2014b and later.
        % For R2014a and earlier:
        % idx = get(popup,'Value');
        % popup_items = get(popup,'String');
        choice = char(popup_items(idx,:));
    end
end
