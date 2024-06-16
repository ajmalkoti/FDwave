clc; close all; clear all;

%% This part will setup all the FDwave program code_path='F..\FDwave';   % Path of FD code files
global cp wfp
cp= '../FDwave';   % Path of FD code folder 
wfp=pwd;       % where you want to store your data. 
addpath(cp);   
FDwave_initialize('verbose','n');     % do necessary steps for initialization


%% Preprocessing
% create/ modify model

T=5000;     vp=2000;        vs=0;        rho=1700;
FDwave_model_n_layers('WAVE_TYPE','Elastic','DX',10,'DZ',10,'THICKNESS',T,... 
         'HV_RATIO',1,'Vp',vp,'VS',vs,'RHO',rho,'PlotON','y','verbose','n')

%source
FDwave_source_ricker('T',2,'DT',.001,'F0',15,'T0',0.07,'PlotON','y','verbose','n');

%analyse
FDwave_analyse_elastic('verbose','y')

%derived model
FDwave_model_derived_elastic_g1('verbose','n')

%Boundary conditions
FDwave_bc_select('BCTYPE','topABC','NAB',45,'PlotON','y','verbose','n') ;

% source and reciever geometry
FDwave_geometry_src_single('SX',250,'SZ',250,'PlotON','y','verbose','n');  

FDwave_geometry_rec_st_line_surf('DEPTH',50,'FIRST',50,'LAST',450,'DIFF',10,'verbose','n');  

%% Simulation
% Do the time stepping calculations of wavefield
FDwave_calculation_elastic_g1('plotON','y','DN_P',50,'verbose','n');

%% Post processing
str='SS_1.mat';          % this can be changed by user if required
% plotting the seismogram in image form
FDwave_calculation_plot_ss('filename',str)

%%%% plotting the seismogram in wiggle traces form
% FDwave_calculation_wiggle_plot('wfp',wf_path,'SSFileName',str,'scale',3)


%%%%% animating the wave propagation
% FDwave_calculation_animate('WFP',wf_path,'SSFileName','SS_1.mat', 'WaveFieldFileName','wavefield_1')

%% Terminate FDwave program
FDwave_deinitialize(cp)



%%%%% export_fig fig1_1layer_model/homo_ss.fig -pdf