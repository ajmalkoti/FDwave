% Please see the instructions for each section in comments

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
% Note: Make sure that the marmousi file in the input folder are unzipped/extracted to "IP folder". Then only proceed. 
FDwave_model_read_segy('M_NAME','marmousi','WAVE_TYPE','Elastic',...
    'CROP_MODEL','y','X1',7000,'Z1',700,'X2',12000,'Z2',4200,...
    'INTERPOLATE','y','DX_NEW',4,'DZ_NEW',4,'PlotON','y')

%source
FDwave_source_ricker('T',2,'DT',.00025,'F0',20,'T0',0.07);

%analyse
FDwave_analyse_elastic()

%derived model
FDwave_model_derived_elastic_g1()

% Boundary Conditions
FDwave_bc_select('BCTYPE','topFS','NAB',50,'PlotON','y') ;

% source and reciever geometry
FDwave_geometry_src_single('SZ',50,'PlotON','n');                 %figure(gcf); axis image
FDwave_geometry_rec_st_line_surf('DEPTH',1,'PlotON','n');            %figure(gcf); axis image

FDwave_geometry_plot('FIGNO',3, 'HOP_S',5, 'HOP_R',4)

%% Simulation
% Do the time stepping calculations of wavefield
FDwave_calculation_elastic_g1('dN_SS',1,'dN_W',20,'dN_P',50,'PlotON','n');


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

