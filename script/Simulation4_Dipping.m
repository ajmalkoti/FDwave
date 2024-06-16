% Please see the instructions for each section in comments
clc; close all; clear all;

%% This part will setup all the FDwave program
global cp wfp
cp= '../FDwave';   % Path of FD code folder 
wfp=pwd;       % where you want to store your data. 
addpath(cp);   
FDwave_initialize('verbose','n');     % do necessary steps for initialization


%% Preprocessing
% A dipping-layer model
% Initialize a model with a homogeneous background.
FDwave_model_build_init('Wave_Type','Elastic','NX',500,'NZ',400,'DX',5,'DZ',5,'vp',2200, 'VS',...
    1800,'RHO',1600,'plotON','n');
% Create first dipping layer (at shallow depth).
CVec={[1,100],[500,200],[500,400],[1,400],[1,200]};
FDwave_model_build_shape_arbitrary('coord',CVec,'VP',2500,'VS',2000,'RHO',1800,'plotON','n');
% Create second dipping layer (at greater depth).
CVec={[1,200],[500,400],[500,400],[1,400],[1,200]};
FDwave_model_build_shape_arbitrary('coord',CVec,'VP',2800,'VS',2200,'RHO',2000,'plotON','n');
% Plot the final model.
FDwave_model_plot('WFP',wfp)

%source
FDwave_source_ricker('T',1.5,'DT',.00025,'F0',20,'T0',0.07,'PlotON','y');

%analyse
FDwave_analyse_elastic()

%derived model
FDwave_model_derived_elastic_g1()

% Boundary Conditions
FDwave_bc_select('BCTYPE','topFS','NAB',50,'PlotON','y') ;


% source and reciever geometry
FDwave_geometry_src_single('SZ',40,'PlotON','n');                 %figure(gcf); axis image
FDwave_geometry_rec_st_line_surf('DEPTH',1,'PlotON','n');            %figure(gcf); axis image
FDwave_geometry_plot('FIGNO',3, 'HOP_S',5, 'HOP_R',4)

%% Simulation
% Do the time stepping calculations of wavefield
FDwave_calculation_elastic_g1('dN_SS',20,'dN_W',20,'dN_P',50,'PlotON','n');


%% Post processing
str='SS_1.mat';                                                              % this should be changed by user if required
% plotting the seismogram in image form
FDwave_calculation_plot_ss('FileName',str,'scale',2)

% % plotting the seismogram in wiggle traces form
% FDWave_calculation_wiggle_plot('wfp',wf_path,'FileName',str,'scale',3)
% 
% % animating the wave propagation
% FDwave_calculation_animate('WFP',wf_path,'SSFileName','SS_1.mat', 'WaveFieldFileName','wavefield_1')

%% Terminate FDwave program
FDWave_deinitialize(cp)

% 
% export_fig fig4_dipping_layer_model/dipping_model.fig -pdf
% export_fig fig4_dipping_layer_model/dipping_SS.fig -pdf
