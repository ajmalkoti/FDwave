%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Simple example for Homogeneous-Elastic model 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% This part will setup all the FDwave program
clc; close all; clear all;
global cp wfp verbose ploton
cp = '../FDwave/';      % Path of FD code folder.
wfp = pwd;
verbose = 'n';
ploton = 'y';
                                                                    
addpath('../FDwave');    % Path of FD code files % Add the code folder to the current command space
FDwave_initialize();     % do necessary steps for initialization

%% Preprocessing
% create/ modify model
% We assume following relations vs=.7*vp;      rho=0.31*(vp).^0.25;   
FDwave_model_n_layers('WAVE_TYPE','Elastic','DX',5,'DZ',5,'THICKNESS',2000,...
          'HV_RATIO',1,'VP',3500,'VS',2450,'RHO',2384.4,'PlotON','y');          

%source      
FDwave_source_ricker('T',1,'DT',0.0001,'F0',25,'T0',0.04,'PlotON','y'); 

% analyse
FDwave_analyse_elastic()          

% derived model
FDwave_model_derived_elastic_g1('verbose','n') 

% Boundary Conditions
FDwave_bc_select('BCTYPE','topFS','NAB',50,'PlotON','y'); 


% source and reciever geometry 
FDwave_geometry_src_single('SZ',200,'PlotON','n');  
FDwave_geometry_rec_st_line_surf('DEPTH',1,'PlotON','n'); 

FDwave_geometry_plot('FIGNO',3, 'HOP_S',5, 'HOP_R',4)


%% Simulation
FDwave_calculation_elastic_g1('dN_W',50,'dN_P',50,'PlotON','y');

%% Post processing
str='SS_1.mat';                                                              % this should be changed by user if required
% plotting the seismogram in image form
FDwave_calculation_plot_ss('FileName',str)

% plotting the seismogram in wiggle traces form
FDwave_calculation_wiggle_plot('SSFileName',str)

% animating the wave propagation
% FDwave_calculation_animate('SSFileName','SS_1.mat', 'WFFileName','wavefield_1')
wffile = ['Data_OP',filesep,'wavefield_1'];
mfile  = ['Data_IP',filesep,'model'];
FDwave_calculation_animate2('WFFile',wffile, 'mfile',mfile, 'prct',99.9)

%% Terminate FDwave program

FDwave_deinitialize(cp)


% Save data to a separate directory, if you want to  
% compare between elastic and viscoleastic wavfield. 
% mkdir homogeneous_elastic
% copyfile Data_IP\*.mat homogeneous_elastic
% copyfile Data_OP\*.mat homogeneous_elastic


%str='Data_OP\SS_1.mat';                                                              
%?? calculation_plot('WFP',wf_path,'FileName',str,'scale',1);    % plot seismogram as image 
%?? calculation_wiggle_plot('wfp',wf_path,'SSFileName',str,'scale',5);   % plot seismogram as wiggles 
%?? FDWave_calculation_animate('WFP',wf_path,'SSFileName','SS_1.mat', 'WaveFieldFileName','wavefield__1');  % animating the wave propagation


 
 




















