function  FDwave_calculation_wiggle_plot( varargin)%ipstr,    xF,xL,xD,    tF,tL,tD,  figNo, shotno )
%CALCULATION_WIGGLE_PLOT Summary of this function goes here
%   This function is under testing
%   Detailed explanation goes here

for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'wfp';                       wfp=varargin{i+1};
        case 'ssfilename';           FileName=varargin{i+1};
        case 'wave_type';           wave_type = lower(varargin{i+1});
        case 'geometry_type';    geometry_type= lower(varargin{i+1});
        case 'dh';                        dh= lower(varargin{i+1});
        case 'dt';                         dt= lower(varargin{i+1});
        case 'figno';                    figNO = varargin{i+1};
        case 'rnf';                          rnF = varargin{i+1};
        case 'rnd';                         rnD = varargin{i+1};
        case 'rnl';                          rnL = varargin{i+1};
        case 'tf';                          tF = varargin{i+1};
        case 'tl';                          tL = varargin{i+1};
        case 'td';                          tD = varargin{i+1};
        case 'prct';                       prct = varargin{i+1};
        case 'clip';                      clip = varargin{i+1};
        case 'scale';                   scale = varargin{i+1};
        otherwise
           error('%s is not a valid argument name',varargin{i});
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('wfp','var')
    wfp=pwd;
end

ipdirpath = [wfp,filesep,'Data_IP',filesep];
opdirpath = [wfp,filesep,'Data_OP',filesep];
fname = [opdirpath,FileName];

if ~exist('FileName','var');        error('Please enter the file name');    end
if ~exist('geometry_type','var');   geometry_type='surface';                end
if ~exist('dh','var');              load(fname,'dh');        end
if ~exist('dt','var');              load(fname,'dt');        end


if ~exist('figNO','var');       h=figure();             end
if  exist('figNO','var');       h=figure(figNO);        end

load(fname,'SS'); 
if ~exist('rnF','var');      rnF=1;       end
if ~exist('rnL','var');      rnL=size(SS,2);       end
if ~exist('rnD','var');      rnD=1;       end

if ~exist('tF','var');      tF=1;       end
if ~exist('tL','var');      tL= size(SS,1) ;       end
if ~exist('tD','var');      tD=1;       end

if ~exist('prct','var')     
    prct=99;       
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
xvecn =  rnF:rnD:rnL;

tvec = (tF:tD:tL) + dt;
tvecn = round(tvec/dt);

if  strcmp(geometry_type,'VSP')
    wiggle(tvec,xvecn,SS(tvecn,xvecn))
    title('Synthetic Seismogram (VSP)'); xlabel('Reciever Number'); ylabel('t (seconds)');
else
    wiggle(xvecn,tvec,SS,'VA');
    title('Synthetic Seismogram'); xlabel('Reciever Number'); ylabel('t (seconds)');
end

end

