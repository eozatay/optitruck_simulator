function DATA = CalculateCumulativeSignals(DATA, SimStartTime, SimStopTime)
%% Calculate Cumulative Signals to SIM results
% Cumulative fuel flow
DATA.SIM.TEST.FuelFlow                  = DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.TEST.CumFuelFlow             	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.FuelFlow                  = '[kg/h]';
DATA.SIM.UNIT.CumFuelFlow             	= 'int([kg/h])';
DATA.SIM.TEST.FuelFlow.Data          	= DATA.SIM.TEST.ECU_qInjTot_PHY.Data * 1e-6 .* DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Data * 6 / 2 * 60;
DATA.SIM.TEST.CumFuelFlow.Data       	= cumtrapz(DATA.SIM.TEST.ECU_qInjTot_PHY.Time, DATA.SIM.TEST.FuelFlow.Data);
% Cumulative air flow
DATA.SIM.TEST.CumAirFlow            	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.TEST.CumAirFlowRef           	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.CumAirFlow             	= 'int([kg/h])';
DATA.SIM.UNIT.CumAirFlowRef           	= 'int([kg/h])';
DATA.SIM.TEST.CumAirFlow.Data           = cumtrapz(DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Time, DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Data*3600);
DATA.SIM.TEST.CumAirFlowRef.Data      	= cumtrapz(DATA.SIM.TEST.ECU_mflChrgdAirDes_PHY.Time, DATA.SIM.TEST.ECU_mflChrgdAirDes_PHY.Data*3600);
% Cumulative exhaust flow
DATA.SIM.TEST.CumExhFlow            	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.CumExhFlow             	= 'int([kg/h])';
DATA.SIM.TEST.CumExhFlow.Data       	= DATA.SIM.TEST.CumAirFlow.Data + DATA.SIM.TEST.CumFuelFlow.Data;
% Cumulative power
DATA.SIM.TEST.EngPwr                    = DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.TEST.CumEngPwr                 = DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.EngPwr                    = '[PS]';
DATA.SIM.UNIT.CumEngPwr                 = 'int([PS])';
DATA.SIM.TEST.EngPwr.Data             	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Data .* max(DATA.SIM.TEST.EngMdl_trqEngTqOut_PHY.Data, 0) * pi/30 * 1e-3 * 1.35962152; % PS
DATA.SIM.TEST.CumEngPwr.Data          	= cumtrapz(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.EngPwr.Data);
% Cumulative Nox - Engine Out (ppm)
DATA.SIM.TEST.EngOutNoxFlow_ppm      	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.TEST.CumEngOutNoxFlow_ppm     	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.EngOutNoxFlow_ppm      	= '[ppm]';
DATA.SIM.UNIT.CumEngOutNoxFlow_ppm    	= 'int([ppm])';
DATA.SIM.TEST.EngOutNoxFlow_ppm.Data  	= max(DATA.SIM.TEST.EngMdl_ratNOx_PHY.Data, 0); % ppm
DATA.SIM.TEST.CumEngOutNoxFlow_ppm.Data	= cumtrapz(DATA.SIM.TEST.EngMdl_ratNOx_PHY.Time, DATA.SIM.TEST.EngOutNoxFlow_ppm.Data);
% Cumulative Nox - Scr Out (ppm)
DATA.SIM.TEST.ScrOutNoxFlow_ppm      	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.TEST.CumScrOutNoxFlow_ppm     	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.ScrOutNoxFlow_ppm      	= '[ppm]';
DATA.SIM.UNIT.CumScrOutNoxFlow_ppm    	= 'int([ppm])';
DATA.SIM.TEST.ScrOutNoxFlow_ppm.Data  	= max(DATA.SIM.TEST.ExhATSysMdl_ratNoxSnsrDs_PHY.Data, 0); % ppm
DATA.SIM.TEST.CumScrOutNoxFlow_ppm.Data	= cumtrapz(DATA.SIM.TEST.ExhATSysMdl_ratNoxSnsrDs_PHY.Time, DATA.SIM.TEST.ScrOutNoxFlow_ppm.Data);
% Cumulative Nox - Engine Out
DATA.SIM.TEST.EngOutNoxFlow             = DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.TEST.CumEngOutNoxFlow          = DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.EngOutNoxFlow             = '[g/h]';
DATA.SIM.UNIT.CumEngOutNoxFlow          = 'int([g/h])';
DATA.SIM.TEST.EngOutNoxFlow.Data     	= 0.001586 * (DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Data*3600 + DATA.SIM.TEST.FuelFlow.Data)/3600 .* max(DATA.SIM.TEST.EngMdl_ratNOx_PHY.Data, 0) * 3600; % ppm to [g/h]
DATA.SIM.TEST.CumEngOutNoxFlow.Data    	= cumtrapz(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.EngOutNoxFlow.Data);
% Cumulative Nox - Scr Out
DATA.SIM.TEST.ScrOutNoxFlow             = DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.TEST.CumScrOutNoxFlow          = DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.ScrOutNoxFlow             = '[g/h]';
DATA.SIM.UNIT.CumScrOutNoxFlow          = 'int([g/h])';
DATA.SIM.TEST.ScrOutNoxFlow.Data      	= 0.001586 * (DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Data*3600 + DATA.SIM.TEST.FuelFlow.Data)/3600 .* max(DATA.SIM.TEST.ExhATSysMdl_ratNoxSnsrDs_PHY.Data, 0) * 3600; % ppm to [g/h]
DATA.SIM.TEST.CumScrOutNoxFlow.Data    	= cumtrapz(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.ScrOutNoxFlow.Data);
% Cumulative urea
DATA.SIM.TEST.UreaFlow                  = DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.TEST.CumUreaFlow               = DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.UreaFlow                  = '[kg/sec]';
DATA.SIM.UNIT.CumUreaFlow               = 'int([kg/sec])';
DATA.SIM.TEST.UreaFlow.Data          	= DATA.SIM.TEST.ECU_mflUreaDes_PHY.Data*1e6;
DATA.SIM.TEST.CumUreaFlow.Data        	= cumtrapz(DATA.SIM.TEST.ECU_mflUreaDes_PHY.Time, DATA.SIM.TEST.UreaFlow.Data);
% Cumulative Engine Speed
DATA.SIM.TEST.CumEngSpd              	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.CumEngSpd                 = 'int([Rpm])';
DATA.SIM.TEST.CumEngSpd.Data        	= cumtrapz(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Data);
% Cumulative Indicated Torque
DATA.SIM.TEST.CumIndTrq              	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.CumIndTrq                 = 'int([Nm])';
DATA.SIM.TEST.CumIndTrq.Data            = cumtrapz(DATA.SIM.TEST.ECU_trqEngSetInr_PHY.Time, DATA.SIM.TEST.ECU_trqEngSetInr_PHY.Data);
% Cumulative Boost Pressure
DATA.SIM.TEST.CumPInMan              	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.TEST.CumPInManRef            	= DATA.SIM.TEST.TrsmMdl_nCrksft_PHY; % timeseries definition
DATA.SIM.UNIT.CumPInMan              	= '[hPa]';
DATA.SIM.UNIT.CumPInManRef          	= 'int([hPa])';
DATA.SIM.TEST.CumPInMan.Data          	= cumtrapz(DATA.SIM.TEST.EngMdl_pIntkMnfld_PHY.Time, DATA.SIM.TEST.EngMdl_pIntkMnfld_PHY.Data*1e-2);
DATA.SIM.TEST.CumPInManRef.Data       	= cumtrapz(DATA.SIM.TEST.ECU_pIntkMnfldDes_PHY.Time, DATA.SIM.TEST.ECU_pIntkMnfldDes_PHY.Data*1e-2);
%% Calculate Cumulative Signals to MEAS (Real-World Data)
if ~isempty(DATA.MEAS.TEST.Time) % If MEAS Data exists
    SimIndStart         = find(DATA.MEAS.TEST.InjSys_qTot.Time >= SimStartTime, 1,'first');
    SimIndStop          = find(DATA.MEAS.TEST.InjSys_qTot.Time <= SimStopTime, 1,'last');
    SimIndStopSIM   	= find(DATA.SIM.TEST.ECU_qInjTot_PHY.Time <= SimStopTime, 1,'last');
    Time_OnlySim    	= DATA.MEAS.TEST.EngSpeed.Time(SimIndStart:SimIndStop); % time definition
    
    % Cumulative fuel flow
    DATA.MEAS.TEST.FuelFlow                     = DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumFuelFlow                  = DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.FuelFlow                     = '[kg/h]';
    DATA.MEAS.UNIT.CumFuelFlow                  = 'int([kg/h])';
    DATA.MEAS.UNIT.CumFuelFlow_OnlySim        	= 'int([kg/h])';
    DATA.MEAS.TEST.FuelFlow.Data                = DATA.MEAS.TEST.InjSys_qTot.Data * 1e-6 .* DATA.MEAS.TEST.EngSpeed.Data * 6 / 2 * 60;
    DATA.MEAS.TEST.CumFuelFlow.Data             = cumtrapz(DATA.MEAS.TEST.InjSys_qTot.Time, DATA.MEAS.TEST.FuelFlow.Data);
    DATA.Metrics.PrcCumFuelFlow                 = DATA.MEAS.TEST.CumFuelFlow.Data(end) / DATA.SIM.TEST.CumFuelFlow.Data(end)*100;
    Data                                        = cumtrapz(DATA.MEAS.TEST.InjSys_qTot.Time(SimIndStart:SimIndStop), DATA.MEAS.TEST.FuelFlow.Data(SimIndStart:SimIndStop));
    DATA.MEAS.TEST.CumFuelFlow_OnlySim          = timeseries(Data, Time_OnlySim);
    DATA.Metrics.PrcCumFuelFlow_OnlySim         = DATA.MEAS.TEST.CumFuelFlow_OnlySim.Data(end) / DATA.SIM.TEST.CumFuelFlow.Data(SimIndStopSIM)*100;
    % Cumulative air flow
    DATA.MEAS.TEST.CumAirFlow                	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumAirFlowRef              	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.CumAirFlow                   = 'int([kg/h])';
    DATA.MEAS.UNIT.CumAirFlowRef                = 'int([kg/h])';
    DATA.MEAS.UNIT.CumAirFlowRef_OnlySim        = 'int([kg/h])';
    DATA.MEAS.TEST.CumAirFlow.Data              = cumtrapz(DATA.MEAS.TEST.AFS_dm.Time, DATA.MEAS.TEST.AFS_dm.Data);
    DATA.Metrics.PrcCumAirFlow                  = DATA.MEAS.TEST.CumAirFlow.Data(end) / DATA.SIM.TEST.CumAirFlow.Data(end)*100;
    DATA.MEAS.TEST.CumAirFlowRef.Data           = cumtrapz(DATA.MEAS.TEST.AirCtl_dmAirDesDyn_r32.Time, DATA.MEAS.TEST.AirCtl_dmAirDesDyn_r32.Data);
    Data                                        = cumtrapz(DATA.MEAS.TEST.InjSys_qTot.Time(SimIndStart:SimIndStop), DATA.MEAS.TEST.AirCtl_dmAirDesDyn_r32.Data(SimIndStart:SimIndStop));
    DATA.MEAS.TEST.CumAirFlowRef_OnlySim      	= timeseries(Data, Time_OnlySim);
    DATA.Metrics.PrcCumAirFlowRef               = DATA.MEAS.TEST.CumAirFlowRef.Data(end) / DATA.SIM.TEST.CumAirFlowRef.Data(end)*100;
    DATA.Metrics.PrcCumAirFlowRef_OnlySim     	= DATA.MEAS.TEST.CumAirFlowRef_OnlySim.Data(end) / DATA.SIM.TEST.CumAirFlowRef.Data(SimIndStopSIM)*100;
    % Cumulative exhaust flow
    DATA.MEAS.TEST.CumExhFlow                	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.CumExhFlow                   = 'int([kg/h])';
    DATA.MEAS.TEST.CumExhFlow.Data              = DATA.MEAS.TEST.CumAirFlow.Data + DATA.MEAS.TEST.CumFuelFlow.Data;
    DATA.Metrics.PrcCumExhFlow                  = DATA.MEAS.TEST.CumExhFlow.Data(end) / DATA.SIM.TEST.CumExhFlow.Data(end)*100;
    % Cumulative power
    DATA.MEAS.TEST.EngPwr                       = DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumEngPwr                    = DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumEngPwr_OnlySim            = DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.EngPwr                       = '[PS]';
    DATA.MEAS.UNIT.CumEngPwr                    = 'int([PS])';
    DATA.MEAS.UNIT.CumEngPwr_OnlySim          	= 'int([PS])';
    DATA.MEAS.TEST.EngPwr.Data                  = DATA.MEAS.TEST.EngSpeed.Data .* max(DATA.MEAS.TEST.ActMod_trqCrS.Data, 0) * pi/30 * 1e-3 * 1.35962152; % PS
    DATA.MEAS.TEST.CumEngPwr.Data               = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.EngPwr.Data);
    DATA.Metrics.PrcCumEngPwr                   = DATA.MEAS.TEST.CumEngPwr.Data(end) / DATA.SIM.TEST.CumEngPwr.Data(end)*100;
    Data                                        = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time(SimIndStart:SimIndStop), DATA.MEAS.TEST.EngPwr.Data(SimIndStart:SimIndStop));
    DATA.MEAS.TEST.CumEngPwr_OnlySim            = timeseries(Data, Time_OnlySim);
    DATA.Metrics.PrcCumEngPwr_OnlySim           = DATA.MEAS.TEST.CumEngPwr_OnlySim.Data(end) / DATA.SIM.TEST.CumEngPwr.Data(SimIndStopSIM)*100;
    % Cumulative Nox - Engine Out (ppm)
    DATA.MEAS.TEST.EngOutNoxFlow_ppm                 	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumEngOutNoxFlow_ppm              	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumEngOutNoxFlow_ppm_OnlySim       	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.EngOutNoxFlow_ppm                    = '[ppm]';
    DATA.MEAS.UNIT.CumEngOutNoxFlow_ppm                 = 'int([ppm])';
    DATA.MEAS.UNIT.CumEngOutNoxFlow_ppm_OnlySim        	= 'int([ppm])';
    DATA.MEAS.TEST.EngOutNoxFlow_ppm.Data               = max(DATA.MEAS.TEST.Exh_rNOxNSCDs.Data, 0); % ppm
    DATA.MEAS.TEST.CumEngOutNoxFlow_ppm.Data            = cumtrapz(DATA.MEAS.TEST.Exh_rNOxNSCDs.Time, DATA.MEAS.TEST.EngOutNoxFlow_ppm.Data);
    DATA.Metrics.PrcCumEngOutNoxFlow_ppm                = DATA.MEAS.TEST.CumEngOutNoxFlow_ppm.Data(end) / DATA.SIM.TEST.CumEngOutNoxFlow_ppm.Data(end)*100;
    Data                                                = cumtrapz(DATA.MEAS.TEST.Exh_rNOxNSCDs.Time(SimIndStart:SimIndStop), DATA.MEAS.TEST.EngOutNoxFlow_ppm.Data(SimIndStart:SimIndStop));
    DATA.MEAS.TEST.CumEngOutNoxFlow_ppm_OnlySim      	= timeseries(Data, Time_OnlySim);
    DATA.Metrics.PrcCumEngOutNoxFlow_ppm_OnlySim        = DATA.MEAS.TEST.CumEngOutNoxFlow_ppm_OnlySim.Data(end) / DATA.SIM.TEST.CumEngOutNoxFlow_ppm.Data(SimIndStopSIM)*100;
    % Cumulative Nox - Scr Out (ppm)
	DATA.MEAS.TEST.ScrOutNoxFlow_ppm                 	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumScrOutNoxFlow_ppm              	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumScrOutNoxFlow_ppm_OnlySim       	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.ScrOutNoxFlow_ppm                    = '[ppm]';
    DATA.MEAS.UNIT.CumScrOutNoxFlow_ppm                 = 'int([ppm])';
    DATA.MEAS.UNIT.CumScrOutNoxFlow_ppm_OnlySim        	= 'int([ppm])';
    DATA.MEAS.TEST.ScrOutNoxFlow_ppm.Data               = max(DATA.MEAS.TEST.Exh_rNOxNoCat2Ds.Data, 0); % ppm
    InitNoxSnsInd                                       = find(DATA.MEAS.TEST.ScrOutNoxFlow_ppm.Data > 0, 1, 'First');
    InitNoxSnsTime                                      = DATA.MEAS.TEST.ScrOutNoxFlow_ppm.Time(InitNoxSnsInd);
    % Disabling Simulation Nox & Urea Values to be able to compare real world data (due Nox senor behaviour)
    EnaNoxSnsInit                                       = 1;
    if EnaNoxSnsInit
        InitNoxSnsSimInd                                = find(DATA.SIM.TEST.ScrOutNoxFlow_ppm.Time >= InitNoxSnsTime, 1, 'First');
        DATA.SIM.TEST.ScrOutNoxFlow_ppm.Data(1:InitNoxSnsSimInd-1)	= 0; % Due to Sensor behaviour
        DATA.SIM.TEST.CumScrOutNoxFlow_ppm.Data         = cumtrapz(DATA.SIM.TEST.ExhATSysMdl_ratNoxSnsrDs_PHY.Time, DATA.SIM.TEST.ScrOutNoxFlow_ppm.Data);
    end
    DATA.MEAS.TEST.CumScrOutNoxFlow_ppm.Data            = cumtrapz(DATA.MEAS.TEST.Exh_rNOxNoCat2Ds.Time, DATA.MEAS.TEST.ScrOutNoxFlow_ppm.Data);
    DATA.Metrics.PrcCumScrOutNoxFlow_ppm                = DATA.MEAS.TEST.CumScrOutNoxFlow_ppm.Data(end) / DATA.SIM.TEST.CumScrOutNoxFlow_ppm.Data(end)*100;
    Data                                                = cumtrapz(DATA.MEAS.TEST.Exh_rNOxNoCat2Ds.Time(SimIndStart:SimIndStop), DATA.MEAS.TEST.ScrOutNoxFlow_ppm.Data(SimIndStart:SimIndStop));
    DATA.MEAS.TEST.CumScrOutNoxFlow_ppm_OnlySim         = timeseries(Data, Time_OnlySim);
    % Cumulative Nox - Engine Out
    DATA.MEAS.TEST.EngOutNoxFlow                 	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumEngOutNoxFlow              	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumEngOutNoxFlow_OnlySim       	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.EngOutNoxFlow                    = '[g/h]';
    DATA.MEAS.UNIT.CumEngOutNoxFlow                 = 'int([g/h])';
    DATA.MEAS.UNIT.CumEngOutNoxFlow_OnlySim       	= 'int([g/h])';
    DATA.MEAS.TEST.EngOutNoxFlow.Data               = 0.001586 * (DATA.MEAS.TEST.AFS_dm.Data + DATA.MEAS.TEST.FuelFlow.Data)/3600 .* max(DATA.MEAS.TEST.Exh_rNOxNSCDs.Data, 0) * 3600; % ppm to [g/h]
    DATA.MEAS.TEST.CumEngOutNoxFlow.Data            = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.EngOutNoxFlow.Data);
    DATA.Metrics.PrcCumEngOutNoxFlow                = DATA.MEAS.TEST.CumEngOutNoxFlow.Data(end) / DATA.SIM.TEST.CumEngOutNoxFlow.Data(end)*100;
    Data                                            = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time(SimIndStart:SimIndStop), DATA.MEAS.TEST.EngOutNoxFlow.Data(SimIndStart:SimIndStop));
    DATA.MEAS.TEST.CumEngOutNoxFlow_OnlySim         = timeseries(Data, Time_OnlySim);
    DATA.Metrics.PrcCumEngOutNoxFlow_OnlySim        = DATA.MEAS.TEST.CumEngOutNoxFlow_OnlySim.Data(end) / DATA.SIM.TEST.CumEngOutNoxFlow.Data(SimIndStopSIM)*100;
    % Cumulative Nox - Scr Out
    DATA.MEAS.TEST.ScrOutNoxFlow                 	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumScrOutNoxFlow              	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumScrOutNoxFlow_OnlySim       	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.ScrOutNoxFlow                    = '[g/h]';
    DATA.MEAS.UNIT.CumScrOutNoxFlow                 = 'int([g/h])';
    DATA.MEAS.UNIT.CumScrOutNoxFlow_OnlySim       	= 'int([g/h])';
    DATA.MEAS.TEST.ScrOutNoxFlow.Data               = 0.001586 * (DATA.MEAS.TEST.AFS_dm.Data + DATA.MEAS.TEST.FuelFlow.Data)/3600 .* max(DATA.MEAS.TEST.Exh_rNOxNoCat2Ds.Data, 0) * 3600; % ppm to [g/h]
    if EnaNoxSnsInit
        DATA.SIM.TEST.ScrOutNoxFlow.Data(1:InitNoxSnsSimInd-1)	= 0; % Due to Sensor behaviour
        DATA.SIM.TEST.CumScrOutNoxFlow.Data         = cumtrapz(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.ScrOutNoxFlow.Data);
    end
    DATA.MEAS.TEST.CumScrOutNoxFlow.Data            = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.ScrOutNoxFlow.Data);
    DATA.Metrics.PrcCumScrOutNoxFlow                = DATA.MEAS.TEST.CumScrOutNoxFlow.Data(end) / DATA.SIM.TEST.CumScrOutNoxFlow.Data(end)*100;
    Data                                            = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time(SimIndStart:SimIndStop), DATA.MEAS.TEST.ScrOutNoxFlow.Data(SimIndStart:SimIndStop));
    DATA.MEAS.TEST.CumScrOutNoxFlow_OnlySim         = timeseries(Data, Time_OnlySim);
    % Cumulative urea
    DATA.MEAS.TEST.UreaFlow                 	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumUreaFlow              	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumUreaFlow_OnlySim       	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.UreaFlow                     = '[kg/sec]';
    DATA.MEAS.UNIT.CumUreaFlow                  = 'int([kg/sec])';
    DATA.MEAS.UNIT.CumUreaFlow_OnlySim      	= 'int([kg/sec])';
    if isfield(DATA.MEAS.TEST, 'DStgy_dmRdcAgAct')
        UreaFlowLabel                           = 'DStgy_dmRdcAgAct';
    else
        UreaFlowLabel                           = 'UDC_dmRdcAgAct';
    end
    DATA.MEAS.TEST.UreaFlow.Data                = DATA.MEAS.TEST.(UreaFlowLabel).Data;
    if 0%EnaNoxSnsInit
        DATA.SIM.TEST.UreaFlow.Data(1:InitNoxSnsSimInd-1)	= 0; % Due to Sensor behaviour
        DATA.SIM.TEST.CumUreaFlow.Data        	= cumtrapz(DATA.SIM.TEST.ECU_mflUreaDes_PHY.Time, DATA.SIM.TEST.UreaFlow.Data);
    end
    DATA.MEAS.TEST.CumUreaFlow.Data             = cumtrapz(DATA.MEAS.TEST.(UreaFlowLabel).Time, DATA.MEAS.TEST.UreaFlow.Data);
    DATA.Metrics.PrcCumUreaFlow                 = DATA.MEAS.TEST.CumUreaFlow.Data(end) / DATA.SIM.TEST.CumUreaFlow.Data(end)*100;
    Data                                        = cumtrapz(DATA.MEAS.TEST.(UreaFlowLabel).Time(SimIndStart:SimIndStop), DATA.MEAS.TEST.UreaFlow.Data(SimIndStart:SimIndStop));
    DATA.MEAS.TEST.CumUreaFlow_OnlySim          = timeseries(Data, Time_OnlySim);
    % Cumulative Engine Speed
    DATA.MEAS.TEST.CumEngSpd                 	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.CumEngSpd                    = 'int([Rpm])';
    DATA.MEAS.TEST.CumEngSpd.Data               = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.EngSpeed.Data);
    DATA.Metrics.PrcCumEngSpd                   = DATA.MEAS.TEST.CumEngSpd.Data(end) / DATA.SIM.TEST.CumEngSpd.Data(end)*100;
    % Cumulative Indicated Torque
    DATA.MEAS.TEST.CumIndTrq                 	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.CumIndTrq                    = 'int([Nm])';
    DATA.MEAS.TEST.CumIndTrq.Data               = cumtrapz(DATA.MEAS.TEST.PthSet_trqInrSet.Time, DATA.MEAS.TEST.PthSet_trqInrSet.Data);
    DATA.Metrics.PrcCumIndTrq                   = DATA.MEAS.TEST.CumIndTrq.Data(end) / DATA.SIM.TEST.CumIndTrq.Data(end)*100;
    % Cumulative Boost 
    DATA.MEAS.TEST.CumPInMan                 	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.TEST.CumPInManRef             	= DATA.MEAS.TEST.EngSpeed; % timeseries definition
    DATA.MEAS.UNIT.CumPInMan                    = '[hPa]';
    DATA.MEAS.UNIT.CumPInManRef                 = 'int([hPa])';
    DATA.MEAS.UNIT.CumPInManRef_OnlySim      	= 'int([hPa])';
    DATA.MEAS.TEST.CumPInMan.Data               = cumtrapz(DATA.MEAS.TEST.Air_pIntkVUs.Time, DATA.MEAS.TEST.Air_pIntkVUs.Data);
    DATA.Metrics.PrcCumPInMan                   = DATA.MEAS.TEST.CumPInMan.Data(end) / DATA.SIM.TEST.CumPInMan.Data(end)*100;
    DATA.MEAS.TEST.CumPInManRef.Data            = cumtrapz(DATA.MEAS.TEST.PCR_pDesVal.Time, DATA.MEAS.TEST.PCR_pDesVal.Data);
    Data                                        = cumtrapz(DATA.MEAS.TEST.PCR_pDesVal.Time(SimIndStart:SimIndStop), DATA.MEAS.TEST.PCR_pDesVal.Data(SimIndStart:SimIndStop));
    DATA.MEAS.TEST.CumPInManRef_OnlySim        	= timeseries(Data, Time_OnlySim);
    DATA.Metrics.PrcCumPInManRef                = DATA.MEAS.TEST.CumPInManRef.Data(end) / DATA.SIM.TEST.CumPInManRef.Data(end)*100;
    DATA.Metrics.PrcCumPInManRef_OnlySim     	= DATA.MEAS.TEST.CumPInManRef_OnlySim.Data(end) / DATA.SIM.TEST.CumPInManRef.Data(SimIndStopSIM)*100;
end
%%
% DATA                        = orderfields(DATA);
DATA.SIM.FieldNames         = fieldnames(DATA.SIM.TEST);
DATA.MEAS.FieldNames        = fieldnames(DATA.MEAS.TEST);
DATA.MEAS_SIM.FieldNames	= intersect(DATA.MEAS.FieldNames, DATA.SIM.FieldNames);
DisplayMetrics(DATA);
%**************************************************************************
    function DisplayMetrics(DATA)
        if isfield(DATA, 'Metrics')
            field_DATA = fieldnames(DATA.Metrics);
            for i = 1:numel(field_DATA)
                disp('*************************************************************');
                if isempty(regexp(field_DATA{i},'_OnlySim', 'Once'))
                    LabelName   = field_DATA{i}(7:end);
                    LabelStr    = [LabelName, ' Real/Sim [%]: ', blanks(36-numel(LabelName))];
                else
                    LabelName = field_DATA{i}(7:end-8);
                    LabelStr    = [LabelName, ' Real(only sim inverval)/Sim [%]: ', blanks(17-numel(LabelName))];
                end
                disp(['Cumulative ', LabelStr, num2str(DATA.Metrics.(field_DATA{i}) , '%10.2f')]);
            end
        else
            disp('There is no Real-World Data information to compare with simulation results.');
        end
    end
end