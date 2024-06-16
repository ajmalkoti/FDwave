function q=plot_q_spectrum(varargin)% (qp,L,fl,fh,Q_scaling,N,verbose)
%PLOT_Q_SPECTRUM 
% This function generates the Q specturm for the SLS MODEL.
% Complete Syntax:
%       plot_q_spectrum('WFP',path,'Q',value,'L',value,'FL',value,'FH',value,'N',value,'SRC_SCALE',value,'PlotON','y');
% Description of parameters:
%       WFP         :  Path to working directory
%       Q           : Value of Qulaity factor
%       L           : No of relexation mechanisms
%       FL          : Lower frequency range
%       FH          : Higher frequency range
%       N           : No of point to be sampled between FL and FH
%       SCALING     : Scaling of Q (optional), default=1
%       PlotON      : 'y' / 'n' 
% Example:
%       plot_q_spectrum('WFP',path,'Q',value,'L',value,'FL',value,'FH',value,'N',value,'SRC_SCALE',value,'PlotON','y');
%       source_ricker('T',2,'DT',.0004,'F0',10,'T0',.03,'SRC_SCALE',1,'PlotON','y');

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wfp';     wfp=varargin{i+1};
        case 'q';       qp=varargin{i+1};
        case 'l';       L=varargin{i+1};
        case 'fl';      fl=varargin{i+1};
        case 'fh';      fh=varargin{i+1};
        case 'n';       N=varargin{i+1};
        case 'scaling'; Q_scaling=varargin{i+1};
        case 'ploton';  plotON=varargin{i+1};
        case 'verbose'; verbose=varargin{i+1};
        otherwise;      error('%s is not a valid argument name',varargin{i});    
    end
end 

if ~exist('wfp','var');       wfp=pwd;      end
if ~exist('q','var');         q=80;         end
if ~exist('L','var');         L=.1;          end
if ~exist('fl','var');        fl=5;         end
if ~exist('fh','var');        fh=100;       end
if ~exist('N','var');         N=100;        end
if ~exist('Q_scaling','var'); Q_scaling=1;  end
if ~exist('ploton','var');    plotON='y';   end 
if ~exist('verbose','var');   verbose='n';  end

[tep3dm,~,ts3dm]= nvpair_model_derived_viscoelastic_g1_relaxation_time(fl,fh,L,Q_scaling,qp,1,verbose);
te=squeeze(tep3dm);
ts=squeeze(ts3dm);

w= linspace(fl,fh,N);
q_const = qp*ones(size(w));
plot(w,q_const); hold on

%%%%%%%%%%%%%%%%
q=zeros(size(w));
for i=1:N
    q(i)= estimate_Q_spec_bohlen(te,ts, w(i),L);
end
plot(w,q); 
ylim([qp*0.3, 2*qp])
xlabel('Frequency, f \rightarrow','fontsize',12)
ylabel('Q(f) \rightarrow','fontsize',12)
str1=['Q for L=', num2str(L)];
hl=legend('Q=const',str1);
set(hl,'fontsize',12)
set(gca,'fontsize',11)
grid on
% te=[2,2,2];
% ts=[1,1,1];
% w=1;
% estimate_Q_spec_bohlen(te,ts, w,L)
end

function [Q] = estimate_Q_spec_bohlen(te,ts, w,L)
%Based upon the expression given in Bohlen(2002)
w2=w^2;             %single value
ts2=ts.^2;          % single value/vector
num=0;
den=0;
for l=1:L
    num= num + (1+ w2*ts(l)*te(l))/(1 + w2*ts2(l));
    den= den + (w*(te(l)-ts(l)))/(1 + w2*ts2(l));
end
num=1-L+num;
Q=num/den;
end


% function [Q] = estimate_Q_spec_jafar(te,ts, w,L)
% %Based upon the expression given in Jafar (2007)
% w2=w^2;             %single value
% ts2=ts.^2;          % single value/vector
% num=0;
% den=0;
% for l=1:L
%     num= num + (1+ w2*ts(l)*te(l))/(1 + w2*ts2(l));
%     den= den + (w*(te(l)-ts(l)))/(1 + w2*ts2(l));
% end
% Q=num/den;
% end