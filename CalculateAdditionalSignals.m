function DATAadd = CalculateAdditionalSignals(DATA, SimStartTime, SimStopTime)
%% Calculate Additional Signals for SIM results
% Cumulative fuel flow
DATAadd.SIM.TEST.FuelFlow               = DATA.SIM.TEST.ECU_qInjTot_PHY.Data * 1e-6 .* DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Data * 6 / 2 * 60;
DATAadd.SIM.TEST.CumFuelFlow            = cumtrapz(DATA.SIM.TEST.ECU_qInjTot_PHY.Time, DATAadd.SIM.TEST.FuelFlow);
% Cumulative air flow
DATAadd.SIM.TEST.CumAirFlow             = cumtrapz(DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Time, DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Data*3600);
DATAadd.SIM.TEST.CumAirFlowRef          = cumtrapz(DATA.SIM.TEST.ECU_mflChrgdAirDes_PHY.Time, DATA.SIM.TEST.ECU_mflChrgdAirDes_PHY.Data*3600);
% Cumulative exhaust flow
DATAadd.SIM.TEST.CumExhFlow             = DATAadd.SIM.TEST.CumAirFlow + DATAadd.SIM.TEST.CumFuelFlow;
% Cumulative power
DATAadd.SIM.TEST.EngPwr                 = DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Data .* max(DATA.SIM.TEST.EngMdl_trqEngTqOut_PHY.Data, 0) * pi/30 * 1e-3 * 1.35962152; % PS
DATAadd.SIM.TEST.CumEngPwr              = cumtrapz(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATAadd.SIM.TEST.EngPwr);
% Cumulative Nox - Engine Out (ppm)
DATAadd.SIM.TEST.EngOutNoxFlow_ppm     	= max(DATA.SIM.TEST.EngMdl_ratNOx_PHY.Data, 0); % ppm
DATAadd.SIM.TEST.CumEngOutNoxFlow_ppm  	= cumtrapz(DATA.SIM.TEST.EngMdl_ratNOx_PHY.Time, DATAadd.SIM.TEST.EngOutNoxFlow_ppm);
% Cumulative Nox - Scr Out (ppm)
DATAadd.SIM.TEST.ScrOutNoxFlow_ppm     	= max(DATA.SIM.TEST.ExhATSysMdl_ratNoxSnsrDs_PHY.Data, 0); % ppm
DATAadd.SIM.TEST.CumScrOutNoxFlow_ppm  	= cumtrapz(DATA.SIM.TEST.ExhATSysMdl_ratNoxSnsrDs_PHY.Time, DATAadd.SIM.TEST.ScrOutNoxFlow_ppm);
% Cumulative Nox - Engine Out
DATAadd.SIM.TEST.EngOutNoxFlow          = 0.001586 * (DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Data*3600 + DATAadd.SIM.TEST.FuelFlow)/3600 .* max(DATA.SIM.TEST.EngMdl_ratNOx_PHY.Data, 0) * 3600; % ppm to [g/h]
DATAadd.SIM.TEST.CumEngOutNoxFlow    	= cumtrapz(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATAadd.SIM.TEST.EngOutNoxFlow);
% Cumulative Nox - Scr Out
DATAadd.SIM.TEST.ScrOutNoxFlow          = 0.001586 * (DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Data*3600 + DATAadd.SIM.TEST.FuelFlow)/3600 .* max(DATA.SIM.TEST.ExhATSysMdl_ratNoxSnsrDs_PHY.Data, 0) * 3600; % ppm to [g/h]
DATAadd.SIM.TEST.CumScrOutNoxFlow    	= cumtrapz(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATAadd.SIM.TEST.ScrOutNoxFlow);
% Cumulative urea
DATAadd.SIM.TEST.UreaFlow               = DATA.SIM.TEST.ECU_mflUreaDes_PHY.Data*1e6;
DATAadd.SIM.TEST.CumUreaFlow            = cumtrapz(DATA.SIM.TEST.ECU_mflUreaDes_PHY.Time, DATAadd.SIM.TEST.UreaFlow);
% Cumulative Engine Speed
DATAadd.SIM.TEST.CumEngSpd              = cumtrapz(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Data);
% Cumulative Indicated Torque
DATAadd.SIM.TEST.CumIndTrq              = cumtrapz(DATA.SIM.TEST.ECU_trqEngSetInr_PHY.Time, DATA.SIM.TEST.ECU_trqEngSetInr_PHY.Data);
% Cumulative Boost Pressure
DATAadd.SIM.TEST.CumPInMan              = cumtrapz(DATA.SIM.TEST.EngMdl_pIntkMnfld_PHY.Time, DATA.SIM.TEST.EngMdl_pIntkMnfld_PHY.Data*1e-2);
DATAadd.SIM.TEST.CumPInManRef           = cumtrapz(DATA.SIM.TEST.ECU_pIntkMnfldDes_PHY.Time, DATA.SIM.TEST.ECU_pIntkMnfldDes_PHY.Data*1e-2);
%% Calculate Additional Signals for MEAS (Real-World Data)
if ~isempty(DATA.MEAS.TEST.Time) % If MEAS Data exists
    SimIndStart         = find(DATA.MEAS.TEST.InjSys_qTot.Time >= SimStartTime, 1,'first');
    SimIndStop          = find(DATA.MEAS.TEST.InjSys_qTot.Time <= SimStopTime, 1,'last');
    SimIndStopSIM   	= find(DATA.SIM.TEST.ECU_qInjTot_PHY.Time <= SimStopTime, 1,'last');
    
    % Cumulative fuel flow
    DATAadd.MEAS.TEST.FuelFlow              = DATA.MEAS.TEST.InjSys_qTot.Data * 1e-6 .* DATA.MEAS.TEST.EngSpeed.Data * 6 / 2 * 60;
    DATAadd.MEAS.TEST.CumFuelFlow           = cumtrapz(DATA.MEAS.TEST.InjSys_qTot.Time, DATAadd.MEAS.TEST.FuelFlow);
    DATAadd.Metrics.PrcCumFuelFlow          = DATAadd.MEAS.TEST.CumFuelFlow(end) / DATAadd.SIM.TEST.CumFuelFlow(end)*100;
    DATAadd.MEAS.TEST.CumFuelFlow_OnlySim  	= cumtrapz(DATA.MEAS.TEST.InjSys_qTot.Time(SimIndStart:SimIndStop), DATAadd.MEAS.TEST.FuelFlow(SimIndStart:SimIndStop));
    DATAadd.Metrics.PrcCumFuelFlow_OnlySim	= DATAadd.MEAS.TEST.CumFuelFlow_OnlySim(end) / DATAadd.SIM.TEST.CumFuelFlow(SimIndStopSIM)*100;
    % Cumulative air flow
    DATAadd.MEAS.TEST.CumAirFlow            = cumtrapz(DATA.MEAS.TEST.AFS_dm.Time, DATA.MEAS.TEST.AFS_dm.Data);
    DATAadd.Metrics.PrcCumAirFlow           = DATAadd.MEAS.TEST.CumAirFlow(end) / DATAadd.SIM.TEST.CumAirFlow(end)*100;
    DATAadd.MEAS.TEST.CumAirFlowRef         = cumtrapz(DATA.MEAS.TEST.AirCtl_dmAirDesDyn_r32.Time, DATA.MEAS.TEST.AirCtl_dmAirDesDyn_r32.Data);
    DATAadd.Metrics.PrcCumAirFlowRef     	= DATAadd.MEAS.TEST.CumAirFlowRef(end) / DATAadd.SIM.TEST.CumAirFlowRef(end)*100;
    % Cumulative exhaust flow
    DATAadd.MEAS.TEST.CumExhFlow            = DATAadd.MEAS.TEST.CumAirFlow + DATAadd.MEAS.TEST.CumFuelFlow;
    DATAadd.Metrics.PrcCumExhFlow           = DATAadd.MEAS.TEST.CumExhFlow(end) / DATAadd.SIM.TEST.CumExhFlow(end)*100;
    % Cumulative power
    DATAadd.MEAS.TEST.EngPwr                = DATA.MEAS.TEST.EngSpeed.Data .* max(DATA.MEAS.TEST.ActMod_trqCrS.Data, 0) * pi/30 * 1e-3 * 1.35962152; % PS
    DATAadd.MEAS.TEST.CumEngPwr             = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time, DATAadd.MEAS.TEST.EngPwr);
    DATAadd.Metrics.PrcCumEngPwr            = DATAadd.MEAS.TEST.CumEngPwr(end) / DATAadd.SIM.TEST.CumEngPwr(end)*100;
    DATAadd.MEAS.TEST.CumEngPwr_OnlySim 	= cumtrapz(DATA.MEAS.TEST.EngSpeed.Time(SimIndStart:SimIndStop), DATAadd.MEAS.TEST.EngPwr(SimIndStart:SimIndStop));
    DATAadd.Metrics.PrcCumEngPwr_OnlySim	= DATAadd.MEAS.TEST.CumEngPwr_OnlySim(end) / DATAadd.SIM.TEST.CumEngPwr(SimIndStopSIM)*100;
    % Cumulative Nox - Engine Out (ppm)
    DATAadd.MEAS.TEST.EngOutNoxFlow_ppm    	= max(DATA.MEAS.TEST.Exh_rNOxNSCDs.Data, 0); % ppm
    DATAadd.MEAS.TEST.CumEngOutNoxFlow_ppm	= cumtrapz(DATA.MEAS.TEST.Exh_rNOxNSCDs.Time, DATAadd.MEAS.TEST.EngOutNoxFlow_ppm);
    DATAadd.Metrics.PrcCumEngOutNoxFlow_ppm	= DATAadd.MEAS.TEST.CumEngOutNoxFlow_ppm(end) / DATAadd.SIM.TEST.CumEngOutNoxFlow_ppm(end)*100;
    DATAadd.MEAS.TEST.CumEngOutNoxFlow_ppm_OnlySim	= cumtrapz(DATA.MEAS.TEST.Exh_rNOxNSCDs.Time(SimIndStart:SimIndStop), DATAadd.MEAS.TEST.EngOutNoxFlow_ppm(SimIndStart:SimIndStop));
    DATAadd.Metrics.PrcCumEngOutNoxFlow_ppm_OnlySim	= DATAadd.MEAS.TEST.CumEngOutNoxFlow_ppm_OnlySim(end) / DATAadd.SIM.TEST.CumEngOutNoxFlow_ppm(SimIndStopSIM)*100;
    % Cumulative Nox - Scr Out (ppm)
    DATAadd.MEAS.TEST.ScrOutNoxFlow_ppm  	= max(DATA.MEAS.TEST.Exh_rNOxNoCat2Ds.Data, 0); % ppm
    DATAadd.MEAS.TEST.CumScrOutNoxFlow_ppm	= cumtrapz(DATA.MEAS.TEST.Exh_rNOxNoCat2Ds.Time, DATAadd.MEAS.TEST.ScrOutNoxFlow_ppm);
    DATAadd.Metrics.PrcCumScrOutNoxFlow_ppm	= DATAadd.MEAS.TEST.CumScrOutNoxFlow_ppm(end) / DATAadd.SIM.TEST.CumScrOutNoxFlow_ppm(end)*100;
    DATAadd.MEAS.TEST.CumScrOutNoxFlow_ppm_OnlySim	= cumtrapz(DATA.MEAS.TEST.Exh_rNOxNoCat2Ds.Time(SimIndStart:SimIndStop), DATAadd.MEAS.TEST.ScrOutNoxFlow_ppm(SimIndStart:SimIndStop));
    % Cumulative Nox - Engine Out
    DATAadd.MEAS.TEST.EngOutNoxFlow         = 0.001586 * (DATA.MEAS.TEST.AFS_dm.Data + DATAadd.MEAS.TEST.FuelFlow)/3600 .* max(DATA.MEAS.TEST.Exh_rNOxNSCDs.Data, 0) * 3600; % ppm to [g/h]
    DATAadd.MEAS.TEST.CumEngOutNoxFlow    	= cumtrapz(DATA.MEAS.TEST.EngSpeed.Time, DATAadd.MEAS.TEST.EngOutNoxFlow);
    DATAadd.Metrics.PrcCumEngOutNoxFlow     = DATAadd.MEAS.TEST.CumEngOutNoxFlow(end) / DATAadd.SIM.TEST.CumEngOutNoxFlow(end)*100;
    DATAadd.MEAS.TEST.CumEngOutNoxFlow_OnlySim      = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time(SimIndStart:SimIndStop), DATAadd.MEAS.TEST.EngOutNoxFlow(SimIndStart:SimIndStop));
    DATAadd.Metrics.PrcCumEngOutNoxFlow_OnlySim	= DATAadd.MEAS.TEST.CumEngOutNoxFlow_OnlySim(end) / DATAadd.SIM.TEST.CumEngOutNoxFlow(SimIndStopSIM)*100;
    % Cumulative Nox - Scr Out
    DATAadd.MEAS.TEST.ScrOutNoxFlow         = 0.001586 * (DATA.MEAS.TEST.AFS_dm.Data + DATAadd.MEAS.TEST.FuelFlow)/3600 .* max(DATA.MEAS.TEST.Exh_rNOxNoCat2Ds.Data, 0) * 3600; % ppm to [g/h]
    DATAadd.MEAS.TEST.CumScrOutNoxFlow    	= cumtrapz(DATA.MEAS.TEST.EngSpeed.Time, DATAadd.MEAS.TEST.ScrOutNoxFlow);
    DATAadd.Metrics.PrcCumScrOutNoxFlow     = DATAadd.MEAS.TEST.CumScrOutNoxFlow(end) / DATAadd.SIM.TEST.CumScrOutNoxFlow(end)*100;
    DATAadd.MEAS.TEST.CumScrOutNoxFlow_OnlySim      = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time(SimIndStart:SimIndStop), DATAadd.MEAS.TEST.ScrOutNoxFlow(SimIndStart:SimIndStop));
    % Cumulative urea
    DATAadd.MEAS.TEST.UreaFlow              = DATA.MEAS.TEST.DStgy_dmRdcAgAct.Data;
    DATAadd.MEAS.TEST.CumUreaFlow           = cumtrapz(DATA.MEAS.TEST.DStgy_dmRdcAgAct.Time, DATAadd.MEAS.TEST.UreaFlow);
    DATAadd.Metrics.PrcCumUreaFlow          = DATAadd.MEAS.TEST.CumUreaFlow(end) / DATAadd.SIM.TEST.CumUreaFlow(end)*100;
    DATAadd.MEAS.TEST.CumUreaFlow_OnlySim           = cumtrapz(DATA.MEAS.TEST.DStgy_dmRdcAgAct.Time(SimIndStart:SimIndStop), DATAadd.MEAS.TEST.UreaFlow(SimIndStart:SimIndStop));
    % Cumulative Engine Speed
    DATAadd.MEAS.TEST.CumEngSpd             = cumtrapz(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.EngSpeed.Data);
    DATAadd.Metrics.PrcCumEngSpd            = DATAadd.MEAS.TEST.CumEngSpd(end) / DATAadd.SIM.TEST.CumEngSpd(end)*100;
    % Cumulative Indicated Torque
    DATAadd.MEAS.TEST.CumIndTrq             = cumtrapz(DATA.MEAS.TEST.PthSet_trqInrSet.Time, DATA.MEAS.TEST.PthSet_trqInrSet.Data);
    DATAadd.Metrics.PrcCumIndTrq            = DATAadd.MEAS.TEST.CumIndTrq(end) / DATAadd.SIM.TEST.CumIndTrq(end)*100;
    % Cumulative Boost Pressure
    DATAadd.MEAS.TEST.CumPInMan             = cumtrapz(DATA.MEAS.TEST.Air_pIntkVUs.Time, DATA.MEAS.TEST.Air_pIntkVUs.Data);
    DATAadd.Metrics.PrcCumPInMan            = DATAadd.MEAS.TEST.CumPInMan(end) / DATAadd.SIM.TEST.CumPInMan(end)*100;
    DATAadd.MEAS.TEST.CumPInManRef          = cumtrapz(DATA.MEAS.TEST.PCR_pDesVal.Time, DATA.MEAS.TEST.PCR_pDesVal.Data);
    DATAadd.Metrics.PrcCumPInManRef       	= DATAadd.MEAS.TEST.CumPInManRef(end) / DATAadd.SIM.TEST.CumPInManRef(end)*100;
end
%%
DATAadd = orderfields(DATAadd);
DisplayMetrics(DATAadd);
%**************************************************************************
    function DisplayMetrics(DATAadd)
        if isfield(DATAadd, 'Metrics')
            field_DATAadd = fieldnames(DATAadd.Metrics);
            for i = 1:numel(field_DATAadd)
                disp('*************************************************************');
                if isempty(regexp(field_DATAadd{i},'_OnlySim', 'Once'))
                    LabelName   = field_DATAadd{i}(7:end);
                    LabelStr    = [LabelName, ' Real/Sim [%]: ', blanks(36-numel(LabelName))];
                else
                    LabelName = field_DATAadd{i}(7:end-8);
                    LabelStr    = [LabelName, ' Real(only sim inverval)/Sim [%]: ', blanks(17-numel(LabelName))];
                end
                disp(['Cumulative ', LabelStr, num2str(DATAadd.Metrics.(field_DATAadd{i}) , '%10.2f')]);
            end
        else
            disp('There is no Real-World Data information to compare with simulation results.');
        end
    end
end