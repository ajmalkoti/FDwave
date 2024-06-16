function [SS,wavefield,simtime]=FDwave_calculation_elastic_g1(varargin) %src_i,dN_W,dN_SS,plotON)
% CALCULATION_ELASTIC
% The solution of wave equation is done here using follownig grid.
% Complete Syntax:
%        calculation_elastic_g1('SRC_I',value, 'DN_W',value, 'DN_SS',value, 'PlotON',value)
% Description of parameters:
%        SRC_I    :  Source No for which the simulation will be carried out.
%        DN_W     :  No time steps of wavefield to skip
%        DN_SS    :  No time steps of synthetic seismogram to skip
%        PlotON   :  Show wave propagation while simulation
%        DN_P     :  No of time steps to skip plotting.
% Example:
%        calculation_elastic_g1('SRC_I',1, 'DN_W',1, 'dN_SS',1, 'PlotON','y','dN_P',10)
%        calculation_elastic_g1('SRC_I',1, 'DN_W',10000, 'dN_SS',4, 'PlotON','y')
%        calculation_elastic_g1()
% Note:
% 1) It is advised to keep dN_W to very large value if you don't want to save entire wavefield
% 2) Plotting itself takes much time so it is advisable to skip few steps in case of very fine steps.
% 3) All other parameters are taken from the input folder.
% 4) The grid arrangement used in calculation is given following
%
%%%%%%%%%%%%%%%%%%%%%% Grid arrangement%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                        txx,tzz__________ vx ___________ txx,tzz------>
%                lbd,mu  |                        bh                            |
%                             |                         |                             |
%                             |                         |                             |
%                             |                         |                             |
%                        vz  |____________txz                           |
%                       bv  |                       muvh                        |
%                             |                                                        |
%                             |                                                        |
%                             |                                                        |
%                 txx,tzz  |____________________________|
%                          |
%                         \|/
%

global wfp

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'src_i';       src_i=varargin{i+1};
        %case 'wfp';         wfp=varargin{i+1};
        case 'dn_w';        dN_W=varargin{i+1};
        case 'dn_ss';       dN_SS=varargin{i+1};
        case 'dn_p';        dN_P=varargin{i+1};
        case 'ploton';      plotON=varargin{i+1};
        case 'verbose';     verbose=varargin{i+1};
        case 'filename';    FileName=varargin{i+1};                  %WITH PATH
        case 'opname';      opname=varargin{i+1};
        otherwise
            error('%s is not a valid argument name',varargin{i});
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%Check IP parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('src_i','var')
    src_i=1;             
end

%if ~exist('wfp','var');    wfp=pwd;             end;

ipdirpath = [wfp,filesep,'Data_IP',filesep];
opdirpath = [wfp,filesep,'Data_OP',filesep];

if ~exist('dN_W','var')
    load([ipdirpath,'source'],'N')
    dN_W=N+1;
end

if ~exist('dN_SS','var')
    dN_SS=1;             
end

if ~exist('dN_P','var')         
    dN_P=1;              
end

if ~exist('plotON','var')
    plotON='y';          
end

if ~exist('verbose','var')
    verbose='y';         
end

if ~exist('opname','var')
    opname='';    
else
    opname=[opname,'_'];
end

if strcmp(verbose,'y')
    disp('    FUNC: FD calculation begins (Elastic)')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load([ipdirpath,'model'],'dh','dv','nh','nv');

load([ipdirpath,'derived_param'],'mu','muhv','lam','lamu', 'bh','bv')

load([ipdirpath,'source'],'dt','T','N','src')

load([ipdirpath,'BC'],'BC','BCtype')

load([ipdirpath,'geometry_src'],'geometry_src','snv_vec','snh_vec')

load([ipdirpath,'geometry_rec'],'geometry_rec','rec_n')


vh= zeros(nv,nh);   
vv= zeros(nv,nh);
thh= zeros(nv,nh);    
tvv=zeros(nv,nh);     
thv=zeros(nv,nh);


nframes=length(1:dN_W:N);      
wavefield=zeros(nv,nh,nframes);
nsteps=length(1:dN_SS:N);        
SS = zeros(nsteps,rec_n);

g1=9/8;    
g2=1/24;

%%%%%%%%%%%%%%
Dxfm=@(a,nh,nv)( (1/24)*( 27*(a((3:nv-2),(3:nh-2)+1)-a((3:nv-2),(3:nh-2)))  -  (a((3:nv-2),(3:nh-2)+2)-a((3:nv-2),(3:nh-2)-1)) ) );

Dzfm=@(a,nh,nv)( (1/24)*( 27*(a((3:nv-2)+1,(3:nh-2))-a((3:nv-2),(3:nh-2)))  -  (a((3:nv-2)+2,(3:nh-2))-a((3:nv-2)-1,(3:nh-2))) ) );

Dxbm=@(a,nh,nv)( (1/24)*( 27*(a((3:nv-2),(3:nh-2))-a((3:nv-2),(3:nh-2)-1))  -  (a((3:nv-2),(3:nh-2)+1)-a((3:nv-2),(3:nh-2)-2)) ) );

Dzbm=@(a,nh,nv)( (1/24)*( 27*(a((3:nv-2),(3:nh-2))-a((3:nv-2)-1,(3:nh-2)))  -  (a((3:nv-2)+1,(3:nh-2))-a((3:nv-2)-2,(3:nh-2))) ) );

%%%%%%%%%%
Dxfv=@(a,n)( (1/24)*( 27*(a((3:n-2)+1)-a(3:n-2))  -  (a((3:n-2)+2)-a((3:n-2)-1)) ) );

Dxbv=@(a,n)( (1/24)*( 27*(a(3:n-2)-a((3:n-2)-1))  -  (a((3:n-2)+1)-a((3:n-2)-2)) ) );

%Dzfv=@(a,n)( (1/24)*( 27*(a((3:n-2)+1)-a(3:n-2))  -  (a((3:n-2)+2)-a((3:n-2)-1)) ) );

%Dzbv=@(a,n)( (1/24)*( 27*(a(3:n-2)-a((3:n-2)-1))  -  (a((3:n-2)+1)-a((3:n-2)-2)) ) );

%%%%%%%%%%

%Dxfp=@(a)( (1/24)*( 27*(a(3,3+1)-a(3,3))  -  (a(3,3+2)-a(3,3-1)) ) );

%Dzfp=@(a)( (1/24)*( 27*(a(3+1,3)-a(3,3))  -  (a(3+2,3)-a(3-1,3)) ) );

%Dxbp=@(a)( (1/24)*( 27*(a(3,3)-a(3,3-1))  -  (a(3,3+1)-a(3,3-2)) ) );

%Dzbp=@(a)( (1/24)*( 27*(a(3,3)-a(3-1,3))  -  (a(3+1,3)-a(3-2,3)) ) );

FScoeff=4*mu.*(lam+ mu)./(lam+2*mu);

h=3;     

srcnv= snv_vec(src_i);
srcnh= snh_vec(src_i);

tic
h_wt = waitbar(0,' completed...','Name','FDwave');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Simulation starts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for t=1:N -3              
    
    %     thh(srcnv-3: srcnv+3,srcnh-3:srcnh+3) = thh(srcnv-3: srcnv+3,srcnh-3:srcnh+3) + source_box( src(t:t+3) );
    %     tvv(srcnv-3: srcnv+3,srcnh-3:srcnh+3) = tvv(srcnv-3: srcnv+3,srcnh-3:srcnh+3) + source_box( src(t:t+3) );
    %
    %     thh((srcnv-2: srcnv+2),(srcnh-2:srcnh+2))=thh((srcnv-2:srcnv+2),(srcnh-2:srcnh+2))  +  src(t);
    %     tvv(srcnv-2: srcnv+2,srcnh-2:srcnh+2)=tvv(srcnv-2:srcnv+2,srcnh-2:srcnh+2)+src(t);
    %
    %     thh(srcnv-1: srcnv+1,srcnh-1:srcnh+1)=thh(srcnv-1:srcnv+1,srcnh-1:srcnh+1)+src(t+1);
    %     tvv(srcnv-1: srcnv+1,srcnh-1:srcnh+1)=tvv(srcnv-1:srcnv+1,srcnh-1:srcnh+1)+src(t+1);
    
    thh(srcnv,srcnh)=thh(srcnv,srcnh)+src(t);
   
    tvv(srcnv,srcnh)=tvv(srcnv,srcnh)+src(t);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dxvx = Dxbm(vh,nh,nv)/dh;
    
    dzvz = Dzbm(vv,nh,nv)/dv;
    
    thh(3:nv-2, 3:nh-2) = thh(3:nv-2, 3:nh-2)  +  dt*( lamu(3:nv-2, 3:nh-2).*dxvx + lam(3:nv-2, 3:nh-2).*dzvz );
    
    tvv(3:nv-2, 3:nh-2) = tvv(3:nv-2, 3:nh-2)  +  dt*( lam(3:nv-2, 3:nh-2).*dxvx + lamu(3:nv-2, 3:nh-2).*dzvz );
    
    thv(3:nv-2, 3:nh-2) = thv(3:nv-2, 3:nh-2)  +  dt*muhv(3:nv-2, 3:nh-2).*(  Dzfm(vh,nh,nv)/dv + Dxfm(vv,nh,nv)/dh   );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(BCtype,'topFS')
        
        tvv(h,:)=0;
        thv(h-1,:)=-thv(h,:);
        thv(h-2,:)=-thv(h+1,:);
        thh(h,3:nh-2)= thh(h,3:nh-2) + dt*FScoeff(h, 3:nh-2).*Dxbv(vh(h,:),nh);
        
        %  ( (1/24)*( 27*(vh(3,(3:nh-2))-vh(3,(3:nh-2)-1))  -  (vh(3,(3:nh-2)+1)-vh(3,(3:nh-2)-2)) ) )/dh;
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    thh=BC.*thh;        
    tvv=BC.*tvv;         
    thv=BC.*thv;        
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    vh(3:nv-2, 3:nh-2) = vh(3:nv-2, 3:nh-2) +  dt*bh(3:nv-2, 3:nh-2).*( Dxfm(thh,nh,nv)/dh + Dzbm(thv,nh,nv)/dv  );
    
    vv(3:nv-2, 3:nh-2) = vv(3:nv-2, 3:nh-2) +  dt*bv(3:nv-2, 3:nh-2).*( Dxbm(thv,nh,nv)/dh + Dzfm(tvv,nh,nv)/dv  );
    
    if strcmp(BCtype,'topFS')
    
        vv(h-1,3:nh-2) = vv(h,3:nh-2) + (dv/dh)*(lam(h,3:nh-2)/lamu(h,3:nh-2)).*Dxbv(vh(h,:),nh);
        
        vh(h-1,3:nh-2) = vh(h+1,3:nh-2) + (dv/dh)*(Dxfv(vv(h-1,:),nh)+Dxfv(vv(h,:),nh)) ;
        
        vv(h-2,3:nh-2) = vv(h-1,3:nh-2) - vv(h,3:nh-2) + vv(h+1,3:nh-2) + ...
            (dv/dh)*(lam(h,3:nh-2)/lamu(h,3:nh-2)).*(Dxbv(vh(h-1,:),nh)+ Dxbv(vh(h+1,:),nh));
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    vh=BC.*vh;   		  
    vv=BC.*vv;       
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(plotON,'y')&&(mod(t-1,dN_P)==0)
        subplot(2,1,1);     
		imagesc((0:nh-1)*dh,(0:nv-1)*dv,vv);
        xlabel('X(m)');  
		ylabel('Z(m)'); 
		title(['Velocities at time =',num2str(dt*(t-1),'%3.6f'),'sec'])
        set(gca,'XAxisLocation','Top');
        
        subplot(2,1,2);     
		imagesc(1:rec_n,(1:(N-1))*dt,SS);
        xlabel('Receiver Number');  
		ylabel('Time(sec)');
        title(['Synthetic seimogram at time =',num2str(dt*(t-1),'%3.6f'),'sec'])
        set(gca,'XAxisLocation','Top')
        colormap('jet');
    end
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (mod(t-1,dN_W)==0)
        dN_Wi = round(t/dN_W);
        wavefield(:,:,dN_Wi+1)= vv;
    end
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (mod(t-1,dN_SS)==0)
        dN_SSi = round(t/dN_SS);
        SS(dN_SSi+1,:)= vv(geometry_rec);
    end
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    perc=round(t/N*100);
    waitbar(perc/100,h_wt,sprintf('%d%% completed...',perc));
    
end

close(h_wt)
simtime=toc;
str=[opdirpath,'SS_',opname,num2str(src_i)];
save(str,'SS','dN_SS','dt','dN_SS','N','dh','dv','nh','nv','-v7.3');

str=[opdirpath,'wavefield_',opname,num2str(src_i)];
if dN_W<N
    save(str,'wavefield','dN_W','dt','N','dh','dv','nh','nv','-v7.3')
end






