% This code is for generating the synthetics for 2 layer case
clc; close all; clear all;

%% This part will setup all the FDwave program
global cp wfp
cp= '../FDwave';   % Path of FD code folder 
wfp=pwd;       % where you want to store your data. 
addpath(cp);   
FDwave_initialize('verbose','n');     % do necessary steps for initialization

%% Preprocessing
% create/ modify model
T=[600,600];
vp=linspace(1800,3500,2);
vs=linspace(1600,3000,2);
rho=linspace(1600,2200,2);
FDwave_model_n_layers('WAVE_TYPE','Elastic','DX',5,'DZ',5,'THICKNESS',T,... 
         'HV_RATIO',1,'Vp',vp,'VS',vs,'RHO',rho,'PlotON','y')

%source     
FDwave_source_ricker('T',2,'DT',.0005,'F0',15,'T0',0.07,'PlotON','y','verbose','n');

%analyse
FDwave_analyse_elastic('verbose','y')

%derived model
FDwave_model_derived_elastic_g1('verbose','n')

%Boundary conditions
FDwave_bc_select('BCTYPE','topFS','NAB',50,'PlotON','y','verbose','n') ;

%Source and reciever geometry
FDwave_geometry_src_single('SX',121,'SZ',10,'PlotON','y','verbose','n');  
FDwave_geometry_rec_st_line_surf('DEPTH',1,'DIFF',1,'verbose','n');  

FDwave_geometry_plot('FIGNO',3, 'HOP_S',5, 'HOP_R',10)


%% Simulation
% Do the time stepping calculations of wavefield
FDwave_calculation_elastic_g1('dN_SS',1,'dN_W',200,'dN_P',50,'PlotON','n');


%% Post processing
str='SS_1.mat';          % this can be changed by user if required

% plotting the seismogram in image form
FDwave_calculation_plot_ss('filename',str) % FDwave_calculation_plot_ss('wfp',wf_path,'SSFileName',str,'scale',4)

% plotting the seismogram in wiggle traces form
% FDwave_calculation_wiggle_plot('wfp',wf_path,'SSFileName',str,'scale',4)

% animating the wave propagation
% FDwave_calculation_animate('WFP',wf_path,'SSFileName','SS_1.mat', 'WaveFieldFileName','wavefield_1')

%% Terminate FDwave program
FDwave_deinitialize(cp)



% export_fig fig2_2layer_model/twolayer_model.fig -pdf
% export_fig fig2_2layer_model/twolayer_ss.fig -pdf