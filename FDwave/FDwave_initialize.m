function FDwave_initialize(varargin)%code_path,current_path,clean)
% INITIALIZATION
% Basic set up of the code and working folder and other tasks.
% complete syntax :
%       initialization('CP', path,'WFP',path,'CLEAN','y/n')
% Description of parameters
%       CP      :   path of FDwave folder   (default: current directory)
%       WFP     :   path of working folder  (default: current directory)
%       CLEAN   :   Start a clean working environment (delete all previous data).
%                       (default: 'n')

clc; close all;


for i=1:2:length(varargin)
    switch lower(varargin{i})
%         case 'cp';         cpi=varargin{i+1};
%         case 'wfp';        wfpi=varargin{i+1};
        case 'clean';      clean=varargin{i+1};
        case 'verbose';    verbose=varargin{i+1};
        otherwise;      error('%s is not a valid argument name',varargin{i});
    end
end


global wfp
% if ~exist('wfp','var')    
%     wfp=pwd;   
% else
%     wfp=wfpi;
% end


global cp
% if ~exist('cp','var')    
%     cp=pwd;      
% else
%     cp = cpi;
% end

if ~exist('clean','var')
    clean ='n';         
end

if ~exist('verbose','var')
    verbose ='y';         
end

if strcmp(verbose,'y')
    disp('    FUNC: Setting up the code and other settings.')
end

% addpath([code_path,filesep,'Data_IP'])
% addpath([code_path,filesep,'Data_OP'])

addpath([cp,filesep,'ana'])
% addpath([cp,filesep,'asol'])
addpath([cp,filesep,'bc'])
addpath([cp,filesep,'cal'])

addpath([cp,filesep,'geo'])
addpath([cp,filesep,'mod'])
addpath([cp,filesep,'modbld'])
addpath([cp,filesep,'modd']);
addpath([cp,filesep,'src'])

%%%%%%%%%%% for GUI %%%%%%%%%%%%%%%%
% addpath([cp,filesep,'gui'])

%%%%%%%%% for extra Package %%%%%%%%%
addpath(genpath([cp,filesep,'other_packages']));

%%%%%%%%%  for output %%%%%%%%%%%%%%%
if ~exist([wfp,filesep,'Data_IP'],'dir');
    mkdir([wfp,filesep,'Data_IP']);
else
    if strcmp(clean,'y');
        delete([wfp,filesep,'Data_IP',filesep,'*.mat']);
        delete([wfp,filesep,'Data_IP',filesep,'*.m']);
    end
end

if ~exist([wfp,filesep,'Data_OP'],'dir');
    mkdir([wfp,filesep,'Data_OP']);
else
    if strcmp(clean,'y')
        delete([wfp,filesep,'Data_OP',filesep,'*.mat']);
        delete([wfp,filesep,'Data_OP',filesep,'*.m']);
    end
end

end