function geometry_plot_rec(varargin)%figno, hop, rnh_vec, rnv_vec,plots)
% GEOMETRY_PLOT_REC
%      This function can be used to plot the recievers over the with/without model.
% Complete syntax:
%      geometry_plot_rec('WFP',path,'FIGNO',value,'HOP',value,'RNX_VEC',vector,'RNZ_VEC',vector)
%   Description of parameters:
%           WFP      :  Path to working directory
%           FIGNO    :  Figure no in which to be plotted.
%                       If blank then plotted in new figure.
%           HOP      :  No of object (receivers) to be skipped
%           RNX_VEC  :  A vector containing X location of all sources
%           RNZ_VEC  :  A vector containing Z location of all sources
%   Example:
%           nvpair_geometry_plot_rec('WFP',pwd,'figno',3,'hop',5)
global wfp
ipdir = [wfp,filesep,'Data_IP',filesep];
opdir = [wfp,filesep,'Data_OP',filesep];

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'figno';       figno=varargin{i+1};        
        case 'hop';         hop=varargin{i+1};
        case 'rnx_vec';     rnh_vec=varargin{i+1};
        case 'rnz_vec';     rnv_vec=varargin{i+1};
        case 'bcplot';      BCPlot=varargin{i+1};
        case 'modelplot';   ModelPlot=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end

if ~exist('figno','var');        hfig=figure();
else hfig=figure(figno);
end


if ~exist('hop','var');          hop=1;                             end
if ~exist('rnh_vec','var');      load([ipdir,'geometry_rec'],'rnh_vec');    end
if ~exist('rnv_vec','var');      load([ipdir,'geometry_rec'],'rnv_vec');    end
if ~exist('BCPlot','var');       BCPlot='n';                           end
if ~exist('ModelPlot','var');    ModelPlot='n';                           end



load([ipdir,'model'],'vpm','dh','dv','nh','nv')
load([ipdir,'BC'],'BC')

if xor(strcmp(BCPlot,'y'),strcmp(ModelPlot,'y'));
    i1=1; i2=1;  i3=1;
elseif strcmp(BCPlot,'y')&&strcmp(ModelPlot,'y');
    if nh>nv;   i1=2; i2=1;  i3=1;    end
    if nh<=nv;  i1=1; i2=2;  i3=1;      end
end

if verLessThan('matlab','8.4')
    if strcmp(BCPlot,'y')
        h=subplot(i1,i2,i3);  imagesc(0:nh-1, 0:nv-1, BC);hold on;
        plot(rnh_vec(1:hop:end),rnv_vec(1:hop:end),'bv' ); colormap('gray')
        title('Reciever with Boundaries Only')
        xlabel('X (m)');    ylabel('Z(m)')
        
        xtk = dh*get(h,'XTick');        set(h,'XTickLabel',xtk)
        ytk = dv*get(h,'YTick');        set(h,'YTickLabel',ytk)
        ax = gca;                       set(ax,'UserData',[dh,dv]);
        h=gcf;                          set(h,'ResizeFcn','axTickUpdate');
    end
    
    if strcmp(ModelPlot,'y')
        vpm=vpm/max(max(vpm));
        test= BC+vpm;
        h=subplot(i1,i2,i3+1);   imagesc(0:nh-1,  0:nv-1,test); hold on;  colormap('gray')
        plot(rnh_vec(1:hop:end), rnv_vec(1:hop:end),'bv' );
        title('Recievers plotted on Boundaries & Model')
        xlabel('X (m)');    ylabel('Z(m)')
        
        xtk = dh*get(h,'XTick');        set(h,'XTickLabel',xtk)
        ytk = dv*get(h,'YTick');        set(h,'YTickLabel',ytk)
        ax = gca;                       set(ax,'UserData',[dh,dv]);
        h=gcf;                          set(h,'ResizeFcn','axTickUpdate');
    end
else
    if strcmp(BCPlot,'y')
        h=subplot(i1,i2,i3);  imagesc(0:nh-1, 0:nv-1, BC);hold on;
        plot(rnh_vec(1:hop:end),rnv_vec(1:hop:end),'bv' ); colormap('gray')
        title('Reciever with Boundaries Only')
        xlabel('X (m)');    ylabel('Z(m)')
        h.XTickLabel = dh*h.XTick;
        h.YTickLabel = dv*h.YTick;
    end
    
    if strcmp(ModelPlot,'y')
        vpm=vpm/max(max(vpm));
        test= BC+vpm;
        h=subplot(i1,i2,i3+1);   imagesc(0:nh-1,  0:nv-1,test); hold on;  colormap('gray')
        plot(rnh_vec(1:hop:end), rnv_vec(1:hop:end),'bv' );
        title('Recievers plotted on Boundaries & Model')
        xlabel('X (m)');    ylabel('Z(m)')
        h.XTickLabel = dh*h.XTick;
        h.YTickLabel = dv*h.YTick;
    end
end

end

