function [src,t] = source_sine(varargin)   %T,dt,f0,t0,src_scale)
% SOURCE_SINE
% This function generates the Sine wavelet signature.
% Complete Syntax:
%       source_sine('WFP',path,'T',value, 'DT',value, 'F0',value, 'T0',value, 'SRC_SCALE',value,'PlotON',option)
% Description of parameters:
%       WFP         :  Path to working directory
%       T           :  Total time duration for simulation.
%       DT          :  Time step
%       F0          :  Central frequency of source
%       T0          :  Zero offset time aka Lag time (optional)
%       SRC_SCALE   :  Scaling of amplitude (optional)
%       PlotON      :  'y'/'n' 
% Example:
%       source_sine('WFP',pwd,'T',2,'DT',.0004,'F0',10)
%       source_sine('T',2,'DT',.0004,'F0',10,'T0',.03,'SRC_SCALE',1,'PlotON','y');

disp('    FUNC: Source parameters')

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wfp';             wfp=varargin{i+1};
        case 't';       T=varargin{i+1};
        case 'dt';      dt=varargin{i+1};
        case 'f0';      f0=varargin{i+1};
        case 't0';      t0=varargin{i+1};
        case 'src_scale'; src_scale=varargin{i+1};
        case 'ploton';  plotON='y';
        otherwise;      error('%s is not a valid argument name',varargin{i});
            
    end
end

if ~exist('wfp','var');              wfp=pwd;                   end;    
if ~exist('T','var');       error('Provide total time duration, T, for simulation');  end
if ~exist('dt','var');      error('Provide time step, dt, for simulation');  end
if  ~exist('f0','var');     error('Provide source frequency, f0, for simulation ');  end

str0='        ';   
str1=str0;          str2=str0;      

if  ~exist('t0','var')||strcmp(num2str(t0),'-9999');    t0 = 0;    str1=[str0,'(Default)'];    end
if ~exist('src_scale','var')||strcmp(num2str(src_scale),'-9999');   src_scale=1;          str2=[str0,'(Default)'];   end
if  ~exist('plotON','var');     plotON='n';   end;

disp([str0,'Source type                :    Sine Wavelet'])
disp([str0,'Source Frequency,       f0 =  ',num2str(f0)] )
disp([str0,'Time step size,         dt =  ',num2str(dt)] )
disp([str0,'Total time duration,     T =  ',num2str(T)] )
disp([str0,'Time shift,             t0 =  ',num2str(t0),str1] )
disp([str0,'Source amplitude scaling   =  ',num2str(src_scale),str2] )

N = round(T/dt);    % No of total time steps


t = dt*(0:N-1);
tau = t-t0;     % Create the wavelet and shift in time

src = src_scale*sin(2*pi*f0*tau);

% used for plotting the wavelet. td is time difference between side lobes of Sine.
tdn =round(2/(f0*dt));  
src_name='Sine';
str = strcat(wfp,'\Data_IP\source');
save(str,'src_name','T','dt','f0','t0','src_scale','src','t','N','tdn');

if strcmp(plotON,'y')
    FDwave_source_plot('wfp',wfp)
end

