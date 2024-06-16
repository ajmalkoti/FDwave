function geometry_plot_src( varargin)%figno, hop, snh_vec, snv_vec )
% GEOMETRY_PLOT_SRC
%   This function can be used to plot the source over the with/without model.
%   Complete syntax:
%      geometry_plot_src('figno',value,'hop',value,'snh_vec',vector,'snv_vec',vector)
%   Description of parameters:
%      FIGNO    :  Figure no in which to be plotted.
%                  If blank then plotted in new figure.
%      HOP      :  No of object (sources) to be skipped
%      snx_vec  :  A vector containing X location of all sources
%      snz_vec  :  A vector containing Z location of all sources
%      BCPLOT   :  To plot the source with boundries
%      MODELPLOT:  To plot the source with boundaries and model
%   Example:
%       nvpair_geometry_plot_src('figno',3,'hop',5)

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'figno';       figno=varargin{i+1};
        case 'wfp';         wfp=varargin{i+1};
        case 'hop';         hop=varargin{i+1};
        case 'snx_vec';     snh_vec=varargin{i+1};
        case 'snz_vec';     snv_vec=varargin{i+1};
        case 'bcplot';      BCPlot=varargin{i+1};
        case 'modelplot';   ModelPlot=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end
if ~exist('figno','var');        hfig=figure();
else hfig=figure(figno);
end

if ~exist('wfp','var');        wfp=pwd;   end;
ipdirpath = [wfp,filesep,'Data_IP',filesep];
opdirpath = [wfp,filesep,'Data_OP',filesep];

if ~exist('hop','var');          hop=1;                           end
if ~exist('snh_vec','var');      load([ipdirpath, 'geometry_src'],'snh_vec');     end
if ~exist('snv_vec','var');      load([ipdirpath, 'geometry_src'],'snv_vec');     end
if ~exist('BCPlot','var');       BCPlot='n';                           end
if ~exist('ModelPlot','var');    ModelPlot='n';                           end

load([wfp,filesep,'Data_IP',filesep,'model'],'vpm','nh','nv','dh','dv')
load([wfp,filesep,'Data_IP',filesep,'BC'],'BC')

if xor(strcmp(BCPlot,'y'),strcmp(ModelPlot,'y'));
   i1=1; i2=1;  i3=1;
elseif strcmp(BCPlot,'y')&&strcmp(ModelPlot,'y');
    if nh>nv;   i1=2; i2=1;  i3=1;    end
    if nh<=nv;  i1=1; i2=2;  i3=1;      end
end


if verLessThan('matlab','8.4')
    if strcmp(BCPlot,'y')
        h=subplot(i1,i2,i3);  imagesc(0:nh-1,  0:nv-1,BC);hold on;
        plot(snh_vec(1:hop:end),snv_vec(1:hop:end),'r*' ); colormap('gray')
        title('Source with Boundaries Only')
        xlabel('X (m)');    ylabel('Z(m)')
        
        xtk = dh*get(h,'XTick');        set(h,'XTickLabel',xtk)
        ytk = dv*get(h,'YTick');        set(h,'YTickLabel',ytk)
        ax = gca;                       set(ax,'UserData',[dh,dv]);
        h=gcf;                          set(h,'ResizeFcn','axTickUpdate');
    end
    
    if strcmp(ModelPlot,'y')
        vpm=vpm/max(max(vpm));
        test= BC+vpm;
        h=subplot(i1,i2,i3+1);   imagesc(0:nh-1,  0:nv-1,  test); hold on;  colormap('gray')
        plot(snh_vec(1:hop:end),  snv_vec(1:hop:end),'r*' ); colormap('gray')
        title('Source plotted on Boundaries & Model')
        xlabel('X (m)');    ylabel('Z(m)')
        
        xtk = dh*get(h,'XTick');        set(h,'XTickLabel',xtk)
        ytk = dv*get(h,'YTick');        set(h,'YTickLabel',ytk)
        ax = gca;                       set(ax,'UserData',[dh,dv]);
        h=gcf;                          set(h,'ResizeFcn','axTickUpdate');
    end
else
    if strcmp(BCPlot,'y')
        h=subplot(i1,i2,i3);  imagesc(0:nh-1,  0:nv-1,BC);hold on;
        plot(snh_vec(1:hop:end),snv_vec(1:hop:end),'r*' ); colormap('gray')
        title('Reciever with Boundaries Only')
        xlabel('X (m)');    ylabel('Z(m)')
        h.XTickLabel = dh*h.XTick;
        h.YTickLabel = dh*h.YTick;
    end
    
    if strcmp(ModelPlot,'y')
        vpm=vpm/max(max(vpm));
        test= BC+vpm;
        h=subplot(i1,i2,i3+1);   imagesc(0:nh-1,  0:nv-1,  test); hold on;  colormap('gray')
        plot(snh_vec(1:hop:end),  snv_vec(1:hop:end),'r*' ); colormap('gray')
        title('Recievers plotted on Boundaries & Model')
        xlabel('X (m)');    ylabel('Z(m)')
        
        h.XTickLabel = dh*h.XTick;
        h.YTickLabel = dh*h.YTick;
    end
end

