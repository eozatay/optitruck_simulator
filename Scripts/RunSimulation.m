clear
clc
%% Generate simulink model
RemovePreviousOptiTruckPaths;
Options.ena_MdlGen             = 1; % Write 0 - if user have generated environment from previous Run
if Options.ena_MdlGen
    % Generate Model Environment
    mgt.generateEnvironment('Environment_Specification');
    matlab.io.saveVariablesToScript('Load_OptiTruckPar.m', 'MaximumArraySize', 1e4);
else
    Load_OptiTruckPar;
end
SimModelName        = ['optiTruck_Base_Sim_Environment_',getenv('username'), '.slx'];
open_system(SimModelName);
mi                  = Simulink.SimulationData.ModelLoggingInfo(SimModelName);
mi.LoggingMode      = 'LogAllAsSpecifiedInModel';
set_param(SimModelName(1:end-4), 'DataLoggingOverride', mi);
%% Load Reference Cycle
Options.LoadRefCycle	= 1;
if Options.LoadRefCycle
    [RefCycle_fname, RefCycle_path] = uigetfile({'*.mat';'*.xlsx'}, 'Load Reference Cycle Data File');
    if strcmp(RefCycle_fname(end-4:end), '.xlsx')
        [ndata, headertext]             = xlsread(fullfile(RefCycle_path,RefCycle_fname));
        [data_size variable_size]       = size(headertext);
        for i = 1:variable_size
            field_name              = headertext{1,i};
            field_name              = strrep(field_name, ' ', '_');
            REFcycle.(field_name)	= ndata(:,i);
        end
    elseif strcmp(RefCycle_fname(end-3:end), '.mat')
        DUMMY       = load(fullfile(RefCycle_path,RefCycle_fname));
        REFcycle    = DUMMY.TEST;
    end
    % Overwrite to gui_data
    gui_data.RoadGradeInfo.Indx         = 3;
    gui_data.RouteInfo.Filetype         = 2; % 1: Distance Based (vVeh_Ref), 2: Time Based (vVeh_Ref) (if starts with 1 - shifted vVeh_Ref trace) 
    gui_data.RouteInfo.Distance         = REFcycle.Distance;
    gui_data.RouteInfo.Speed            = REFcycle.Velocity;
    gui_data.RouteInfo.Grade            = REFcycle.Grade;
    gui_data.RouteInfo.Time             = REFcycle.Time;
    gui_data.RouteInfo.Wind             = 0*gui_data.RouteInfo.Speed;
    gui_data.RouteInfo.Total_Distance	= gui_data.RouteInfo.Distance(end);
    gui_data.RouteInfo.Total_Duration   = REFcycle.Time(end);
    gui_data.RouteInfo.Speed(1)         = max(gui_data.RouteInfo.Speed(1), 1); % !!!  Critial (if starts with 0 - delayed launch)  
end
%% Run Simulation
% SimStart&FinishTime
open_system(SimModelName);
SimStartTime 	= 0;
SimStopTime     = SimStartTime+100;
if SimStartTime > 0
    [RefModels,RefModelBlks] = find_mdlrefs(SimModelName(1:end-4),'AllLevels',true,'IncludeProtectedModels',false,'IncludeCommented','on');
    for i = 1:numel(RefModels)
        open_system(RefModels{i});
        set_param(RefModels{i}, 'StartTime', num2str(SimStartTime));
        save_system(RefModels{i});
        close_system(RefModels{i});
    end
end
open_system(SimModelName);
% Initial Conditions
if SimStartTime > 0 % Needs manual setting initial values
    % Delay4:  init vehspeed
    set_param([SimModelName(1:end-4), '/DataBus/Delay4'], 'InitialCondition', '90');
    % Delay44: geardmd
    set_param([SimModelName(1:end-4), '/DataBus/Delay44'], 'InitialCondition', '12');
    % Delay45: gear
    set_param([SimModelName(1:end-4), '/DataBus/Delay45'], 'InitialCondition', '12');
else
    % Delay4:  init vehspeed
    set_param([SimModelName(1:end-4), '/DataBus/Delay4'], 'InitialCondition', '1');
    % Delay44: geardmd
    set_param([SimModelName(1:end-4), '/DataBus/Delay44'], 'InitialCondition', '1');
    % Delay45: gear
    set_param([SimModelName(1:end-4), '/DataBus/Delay45'], 'InitialCondition', '1');
end
% Setting of initial values of Delay blocks inside DataBus subsystem ('Test_Configuration.slx' model outputs) (tIniUreaCat & mIniNh3LoadUreaCat)
open_system('Test_Configuration.slx');
TstCfgOutElements   = find_system('Test_Configuration', 'LookUnderMasks', 'on', 'FindAll', 'on','Regexp', 'on', 'IncludeCommented', 'on', 'BlockType', 'Outport');
for i = 1:numel(TstCfgOutElements)
    TstCfgOut.Names{i,1}    = get_param(TstCfgOutElements(i), 'Name');
    OutHandle               = get(TstCfgOutElements(i),'PortConnectivity');
    TstCfgOut.Values{i,1}   = get(OutHandle.SrcBlock, 'Value');
end
DelayElements    = find_system([SimModelName(1:end-4), '/DataBus'], 'Regexp', 'on','BlockType', 'Delay');
for i = 1:numel(DelayElements)
    Out_SignalName = get_param(DelayElements(i),'OutputSignalNames');
    Out_SignalName = Out_SignalName{1};
    for j = 1:numel(TstCfgOutElements)
        if strcmp(Out_SignalName, TstCfgOut.Names{j,1})
            set_param(DelayElements{i}, 'InitialCondition', TstCfgOut.Values{j,1});
        end
    end
end
close_system('Test_Configuration.slx');
% Sim Mode
SimModeInd      = 2;
if SimModeInd ==  1
    SimMode  	= 'normal';
elseif SimModeInd ==  2
    SimMode   	= 'accelerator';
elseif SimModeInd ==  3
    SimMode  	= 'rapid-accelerator';
end
HandleWaitBar        	= waitbar(0,'Please wait...');
TimerObj                = timer;
TimerObj.Period         = 10; % Display every 10 seconds
TimerObj.ExecutionMode	= 'fixedRate';
TimerObj.TimerFcn       = @(mytimerObj, thisEvent)waitbar(get_param(SimModelName(1:end-4), 'SimulationTime')/SimStopTime, HandleWaitBar);
start(TimerObj);
tic;
if SimStartTime > 0
    simOut = sim(SimModelName,'SimulationMode', SimMode, 'StartTime', num2str(SimStartTime), 'StopTime', num2str(SimStopTime));
else
    simOut = sim(SimModelName,'SimulationMode', SimMode, 'StopTime', num2str(SimStopTime));
end
toc
stop(TimerObj); delete(TimerObj); close(HandleWaitBar);
%% Plotting LOG signals
Options.ena_logsave             = 1;
Options.ena_log2dat             = 0;
Options.ena_comparison          = 0; % 0: plot only sim data, 1: plot simulation & measurement data together
Options.test_type               = 0; % 0: transient testing, 1: for Steady State testing
Options.load_previousSimData	= 0; % !!! Critical (1: using previous SIM data instead of raw simOut data)
if Options.load_previousSimData
    simOut                  = [];
    optiTruck_physical_Bus  = [];
end
[SIMtest, UNITsim, MEAStest, UNITmeas] = CollectSimulationData(simOut, optiTruck_physical_Bus, Options);
DATA        = PreProcess_PlotGUI(SIMtest, UNITsim, MEAStest, UNITmeas);
Plot_GUI	= GeneratePlotGUI(DATA, Options.test_type);
METRICS     = CalculateMetrics(DATA);
DATAadd     = CalculateAdditionalSignals(DATA, SimStartTime, SimStopTime);
save(['OptiTruck_Simulation_',datestr(now,'yyyymmdd'),'.mat'], 'DATA', 'DATAadd','SimStartTime', 'SimStopTime', 'Options', 'optiTruck_physical_Bus', 'optiTruck_Cloud_Bus','optiTruck_Vehicle_Bus', '-v7.3');
%% Plot Results
PlotDefaultSimResults;