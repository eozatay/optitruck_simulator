%% Cumulative Fuel
FigName = 'SIMsummary';
figure('WindowStyle','Docked','NumberTitle','off','Name',FigName);
AxesHandle.(FigName).AX(1) = subplot('Position', [0.04 0.54, 0.28, 0.43]);
hold on;grid minor;
pltLabel = 'CumFuelFlow';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend(['Real ', pltLabel], ['Sim ', pltLabel]);
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');

AxesHandle.(FigName).AX(2) = subplot('Position', [0.37 0.54, 0.28, 0.43]);
hold on;grid minor;
pltLabel = 'CumEngPwr';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend(['Real ', pltLabel], ['Sim ', pltLabel]);
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');

subplot('Position', [0.70 0.54, 0.28, 0.43]);
hold on;grid minor;
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Data, DATA.MEAS.TEST.PthSet_trqInrSet.Data, 'r*', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Data, DATA.SIM.TEST.ECU_trqEngSetInr_PHY.Data, 'b.','Color', [0.0 0.5 0.8], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real', 'Sim');
xlabel('Engine Speed', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('Indicated Torque', 'FontSize', 12, 'FontWeight', 'Bold');
xlim([0 2500]);
ylim([0 3000]);

AxesHandle.(FigName).AX(3) = subplot('Position', [0.04 0.07, 0.28, 0.40]);
hold on;grid minor;
if Options.ena_comparison
    plot(DATA.MEAS.TEST.WheelBasedVehicleSpeed_CCVS_ECM.Time, DATA.MEAS.TEST.WheelBasedVehicleSpeed_CCVS_ECM.Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.LgtVehMdl_vVehSpd_PHY.Time, DATA.SIM.TEST.LgtVehMdl_vVehSpd_PHY.Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',2);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real vVeh', 'Sim vVeh');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('Vehicle Speed', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([0 100]);

AxesHandle.(FigName).AX(4) = subplot('Position', [0.37 0.07, 0.28, 0.40]);
hold on;grid minor;
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.EngSpeed.Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',2);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real nEng', 'Sim nEng');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('Engine Speed', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([0 2500]);

AxesHandle.(FigName).AX(5) = subplot('Position', [0.70 0.07, 0.28, 0.40]);
hold on;grid minor;
if Options.ena_comparison
    plot(DATA.MEAS.TEST.Tra_numGear.Time, DATA.MEAS.TEST.Tra_numGear.Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TCU_numGear_PHY.Time, DATA.SIM.TEST.TCU_numGear_PHY.Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',2);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real numGear', 'Sim numGear');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('Gear', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([0 15]);
linkaxes(AxesHandle.(FigName).AX,'x');
%% Cumulative fuel rate
if Options.ena_comparison
    CumFuel_sim_CommonTime	= interp1(DATA.SIM.TEST.ECU_qInjTot_PHY.Time, DATA.SIM.TEST.CumFuelFlow.Data, DATA.MEAS.TEST.InjSys_qTot.Time);
    FigName = 'CumFuelFlowRate';
    figure('WindowStyle','Docked','NumberTitle','off','Name',FigName);
    AxesHandle.(FigName).AX(1) = subplot('Position', [0.06 0.07, 0.90, 0.90]);
    hold on;grid minor;
    plot(DATA.MEAS.TEST.InjSys_qTot.Time, DATA.MEAS.TEST.CumFuelFlow.Data./CumFuel_sim_CommonTime*100, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
    plot(DATA.MEAS.TEST.InjSys_qTot.Time, DATA.MEAS.TEST.InjSys_qTot.Time*0+100, 'b:', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
    set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
    legend('Real/Sim cumFuel [%]', 'Ideal Rate [%]');
    xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
    ylabel('Cumulative Fuel Rate [%]', 'FontSize', 12, 'FontWeight', 'Bold');
    ylim([80 120]);
end
%% APctrl
FigName = 'APctrl';
figure('WindowStyle','Docked','NumberTitle','off','Name',FigName);
AxesHandle.(FigName).AX(1) = subplot('Position', [0.06 0.54, 0.43, 0.43]);
hold on;grid minor;
if Options.ena_comparison
    plot(DATA.MEAS.TEST.PCR_pDesVal.Time, DATA.MEAS.TEST.PCR_pDesVal.Data, 'r', 'Color', [0.8 0.0 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.ECU_pIntkMnfldDes_PHY.Time, DATA.SIM.TEST.ECU_pIntkMnfldDes_PHY.Data/100, 'b', 'Color', [0.0 0.3 0.5], 'LineWidth',3);
if Options.ena_comparison
    plot(DATA.MEAS.TEST.Air_pIntkVUs.Time, DATA.MEAS.TEST.Air_pIntkVUs.Data, 'b', 'Color', [0.0 0.7 0.5], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.0 0.7 0.5], 'LineWidth',3);
end
plot(DATA.SIM.TEST.EngMdl_pIntkMnfld_PHY.Time, DATA.SIM.TEST.EngMdl_pIntkMnfld_PHY.Data/100, 'b', 'Color', [1.0 0.6 0.0], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real pIntkMnfldDes', 'Sim pIntkMnfldDes', 'Real pIntkMnfld', 'Sim pIntkMnfld');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('pIntkMnfld', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([1000 4000]);

AxesHandle.(FigName).AX(2) = subplot('Position', [0.54 0.54, 0.43, 0.43]);
hold on;grid minor;
if Options.ena_comparison
    plot(DATA.MEAS.TEST.AirCtl_dmAirDesDyn_r32.Time, DATA.MEAS.TEST.AirCtl_dmAirDesDyn_r32.Data, 'r', 'Color', [0.8 0.0 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.ECU_mflChrgdAirDes_PHY.Time, DATA.SIM.TEST.ECU_mflChrgdAirDes_PHY.Data*3600, 'b', 'Color', [0.0 0.3 0.5], 'LineWidth',3);
if Options.ena_comparison
    plot(DATA.MEAS.TEST.AFS_dm.Time, DATA.MEAS.TEST.AFS_dm.Data, 'b', 'Color', [0.0 0.7 0.5], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.0 0.7 0.5], 'LineWidth',3);
end
plot(DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Time, DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Data*3600, 'b', 'Color', [1.0 0.6 0.0], 'LineWidth',3);
% plot(DATA.MEAS.TEST.ASMod_dmIntMnfDs.Time, DATA.MEAS.TEST.ASMod_dmIntMnfDs.Data, 'm', 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real mflChrgdAirDes', 'Sim mflChrgdAirDes', 'Real mflChrgdAir', 'Sim mflChrgdAir');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('mflChrgdAir', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([0 2000]);

AxesHandle.(FigName).AX(3) = subplot('Position', [0.06 0.07, 0.43, 0.40]);
hold on;grid minor;
if Options.ena_comparison
    plot(DATA.MEAS.TEST.TrbCh_rAct.Time, DATA.MEAS.TEST.TrbCh_rAct.Data, 'r', 'Color', [0.8 0.0 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.ECU_prcTrbVlvDes_PHY.Time, DATA.SIM.TEST.ECU_prcTrbVlvDes_PHY.Data, 'b', 'Color', [0.0 0.3 0.5], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real prcTrbVlv', 'Sim prcTrbVlv');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('prcTrbVlv', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([0 100]);

AxesHandle.(FigName).AX(4) = subplot('Position', [0.54 0.07, 0.43, 0.40]);
hold on;grid minor;
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EGRVlv_rAct.Time, DATA.MEAS.TEST.EGRVlv_rAct.Data, 'r', 'Color', [0.8 0.0 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.ECU_prcEgrVlvDes_PHY.Time, DATA.SIM.TEST.ECU_prcEgrVlvDes_PHY.Data, 'b', 'Color', [0.0 0.3 0.5], 'LineWidth',3);
if Options.ena_comparison
    plot(DATA.MEAS.TEST.ThrVlv_rAct.Time, DATA.MEAS.TEST.ThrVlv_rAct.Data, 'r', 'Color', [0.0 0.7 0.5], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.0 0.7 0.5], 'LineWidth',3);
end
plot(DATA.SIM.TEST.ECU_prcThrVlvDes_PHY.Time, DATA.SIM.TEST.ECU_prcThrVlvDes_PHY.Data, 'b', 'Color', [1.0 0.6 0.0], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real prcEgrVlv', 'Sim prcEgrVlv', 'Real prcThrVlv', 'Sim prcThrVlv');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('prcEgr&ThrVlv', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([0 100]);
linkaxes(AxesHandle.(FigName).AX,'x');
xlim([DATA.SIM.TEST.Time.TimeInfo.Start, DATA.SIM.TEST.Time.TimeInfo.End]);
%% APctrl_SIM
FigName = 'APctrl_Sim';
figure('WindowStyle','Docked','NumberTitle','off','Name',FigName);
AxesHandle.(FigName).AX(1) = subplot('Position', [0.06 0.54, 0.43, 0.43]);
hold on;grid minor;
plot(DATA.SIM.TEST.ECU_pIntkMnfldDes_PHY.Time, DATA.SIM.TEST.ECU_pIntkMnfldDes_PHY.Data/100, 'r', 'Color', [0.8 0.0 0.1], 'LineWidth',3);
plot(DATA.SIM.TEST.EngMdl_pIntkMnfld_PHY.Time, DATA.SIM.TEST.EngMdl_pIntkMnfld_PHY.Data/100, 'b', 'Color', [0.0 0.3 0.5], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Sim pIntkMnfldDes', 'Sim pIntkMnfld');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('pIntkMnfld', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([1000 4000]);

AxesHandle.(FigName).AX(2) = subplot('Position', [0.54 0.54, 0.43, 0.43]);
hold on;grid minor;
plot(DATA.SIM.TEST.ECU_mflChrgdAirDes_PHY.Time, DATA.SIM.TEST.ECU_mflChrgdAirDes_PHY.Data*3600, 'r', 'Color', [0.8 0.0 0.1], 'LineWidth',3);
plot(DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Time, DATA.SIM.TEST.EngMdl_mflChrgdAir_PHY.Data*3600, 'b', 'Color', [0.0 0.3 0.5], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Sim mflChrgdAirDes', 'Sim mflChrgdAir');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('mflChrgdAir', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([0 2000]);

AxesHandle.(FigName).AX(3) = subplot('Position', [0.06 0.07, 0.43, 0.40]);
hold on;grid minor;
plot(DATA.SIM.TEST.ECU_prcTrbVlvDes_PHY.Time, DATA.SIM.TEST.ECU_prcTrbVlvDes_PHY.Data, 'r', 'Color', [0.8 0.0 0.1], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real prcTrbVlv', 'Sim prcTrbVlv');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('prcTrbVlv', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([0 100]);

AxesHandle.(FigName).AX(4) = subplot('Position', [0.54 0.07, 0.43, 0.40]);
hold on;grid minor;
plot(DATA.SIM.TEST.ECU_prcEgrVlvDes_PHY.Time, DATA.SIM.TEST.ECU_prcEgrVlvDes_PHY.Data, 'r', 'Color', [0.8 0.0 0.1], 'LineWidth',3);
plot(DATA.SIM.TEST.ECU_prcThrVlvDes_PHY.Time, DATA.SIM.TEST.ECU_prcThrVlvDes_PHY.Data, 'b', 'Color', [0.0 0.3 0.5], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Sim prcEgrVlv', 'Sim prcThrVlv');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('prcEgr&ThrVlv', 'FontSize', 12, 'FontWeight', 'Bold');
ylim([0 100]);
linkaxes(AxesHandle.(FigName).AX,'x');
xlim([DATA.SIM.TEST.Time.TimeInfo.Start, DATA.SIM.TEST.Time.TimeInfo.End]);
%% AirPath References
FigName = 'APctrl_Ref';
figure('WindowStyle','Docked','NumberTitle','off','Name',FigName);
AxesHandle.(FigName).AX(1) = subplot('Position', [0.04 0.54, 0.28, 0.43]);
hold on;grid minor;
pltLabel = 'CumAirFlow';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
pltLabel = 'CumExhFlow';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.0 0.8 0.1], 'LineWidth',2);
else
    plot(0, 0, 'r', 'Color', [0.0 0.8 0.1], 'LineWidth',2);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b', 'Color', [1.0 0.4 0.0], 'LineWidth',2);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
% legend(['Real ', pltLabel], ['Sim ', pltLabel]);
legend('Real cumAirFlow', 'Sim cumAirFlow', 'Real CumExhFlow', 'Sim CumExhFlow');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
% ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('Cumulative Flow', 'FontSize', 12, 'FontWeight', 'Bold');

AxesHandle.(FigName).AX(2) = subplot('Position', [0.37 0.54, 0.28, 0.43]);
hold on;grid minor;
pltLabel = 'CumFuelFlow';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend(['Real ', pltLabel], ['Sim ', pltLabel]);
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');

AxesHandle.(FigName).AX(3) = subplot('Position', [0.70 0.54, 0.28, 0.43]);
hold on;grid minor;
pltLabel = 'CumEngSpd';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend(['Real ', pltLabel], ['Sim ', pltLabel]);
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');

AxesHandle.(FigName).AX(4) = subplot('Position', [0.04 0.07, 0.28, 0.40]);
hold on;grid minor;
pltLabel = 'CumPInManRef';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r-.', 'Color', [1.0 0.4 0.0], 'LineWidth',3);
else
    plot(0, 0, 'r-.', 'Color', [1.0 0.4 0.0], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b-.', 'Color', [0.0 0.8 0.1], 'LineWidth',3);
pltLabel = 'CumPInMan';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',2);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',2);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'Color', [0.0 0.5 0.8], 'LineWidth',2);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real CumPInMan Ref', 'Sim CumPInMan Ref','Real CumPInMan', 'Sim CumPInMan');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');

AxesHandle.(FigName).AX(5) = subplot('Position', [0.37 0.07, 0.28, 0.43]);
hold on;grid minor;
pltLabel = 'CumAirFlowRef';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r-.', 'Color', [1.0 0.4 0.0], 'LineWidth',3);
else
    plot(0, 0, 'r-.', 'Color', [1.0 0.4 0.0], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b-.', 'Color', [0.0 0.8 0.1], 'LineWidth',3);
pltLabel = 'CumAirFlow';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',2);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',2);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'Color', [0.0 0.5 0.8], 'LineWidth',2);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real CumAirFlow Ref', 'Sim CumAirFlow Ref','Real CumAirFlow', 'Sim CumAirFlow');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');

AxesHandle.(FigName).AX(6) = subplot('Position', [0.70 0.07, 0.28, 0.43]);
hold on;grid minor;
pltLabel = 'CumIndTrq';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend(['Real ', pltLabel], ['Sim ', pltLabel]);
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');

linkaxes(AxesHandle.(FigName).AX,'x');
xlim([DATA.SIM.TEST.Time.TimeInfo.Start, DATA.SIM.TEST.Time.TimeInfo.End]);
%% Cumulative Airpath Ref Rate
if Options.ena_comparison
    CumAirFlowRef_sim_CommonTime	= interp1(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.CumAirFlowRef.Data, DATA.MEAS.TEST.CumAirFlowRef.Time);
    CumPInManRef_sim_CommonTime     = interp1(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.CumPInManRef.Data, DATA.MEAS.TEST.CumPInManRef.Time);
    FigName = 'APctrl_RefRate';
    figure('WindowStyle','Docked','NumberTitle','off','Name',FigName);
    AxesHandle.(FigName).AX(1) = subplot('Position', [0.06 0.56, 0.90, 0.42]);
    hold on;grid minor;
    plot(DATA.MEAS.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.MEAS.TEST.CumAirFlowRef.Data./CumAirFlowRef_sim_CommonTime*100, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
    plot(DATA.MEAS.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.MEAS.TEST.TrsmMdl_nCrksft_PHY.Time*0+100, 'b:', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
    set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
    legend('Real/Sim CumAirFlowRef [%]', 'Ideal Rate [%]');
    xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
    ylabel('Cumulative Airflow Ref Rate [%]', 'FontSize', 12, 'FontWeight', 'Bold');
    ylim([80 120]);
    AxesHandle.(FigName).AX(2) = subplot('Position', [0.06 0.07, 0.90, 0.42]);
    hold on;grid minor;
    plot(DATA.MEAS.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.MEAS.TEST.CumPInManRef.Data./CumPInManRef_sim_CommonTime*100, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
    plot(DATA.MEAS.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.MEAS.TEST.TrsmMdl_nCrksft_PHY.Time*0+100, 'b:', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
    set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
    legend('Real/Sim CumPInManRef [%]', 'Ideal Rate [%]');
    xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
    ylabel('Cumulative PInMan Ref Rate [%]', 'FontSize', 12, 'FontWeight', 'Bold');
    ylim([80 120]);
    linkaxes(AxesHandle.(FigName).AX,'x');
    xlim([DATA.SIM.TEST.Time.TimeInfo.Start, DATA.SIM.TEST.Time.TimeInfo.End]);
end
%% VGT_EGR
FigName = 'AirPath_Vlv';
figure('WindowStyle','Docked','NumberTitle','off','Name',FigName);
AxesHandle.(FigName).AX(1) = subplot('Position', [0.04 0.07, 0.90, 0.88]);
hold on;grid minor;
if Options.ena_comparison
    plot(DATA.MEAS.TEST.TrbCh_rAct.Data, DATA.MEAS.TEST.EGRVlv_rAct.Data, 'r.', 'Color', [0.8 0.1 0.1], 'LineWidth',1);
else
    plot(0, 0, 'r.', 'Color', [0.8 0.1 0.1], 'LineWidth',1);
end
plot(DATA.SIM.TEST.ECU_prcTrbVlvDes_PHY.Data, DATA.SIM.TEST.ECU_prcEgrVlvDes_PHY.Data, 'b.', 'Color', [0.0 0.5 0.8], 'LineWidth',1);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real ', 'Sim ');
xlabel('VGTpos [%]', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('EGRpos [%]', 'FontSize', 12, 'FontWeight', 'Bold');
xlim([0 100]);
ylim([0 100]);
%% Cumulative Nox
FigName = 'NoxFlow';
figure('WindowStyle','Docked','NumberTitle','off','Name',FigName);
AxesHandle.(FigName).AX(1) = subplot('Position', [0.06 0.54, 0.43, 0.43]);
hold on;grid minor;
pltLabel = 'CumEngOutNoxFlow';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend(['Real ', pltLabel], ['Sim ', pltLabel]);
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');

AxesHandle.(FigName).AX(2) = subplot('Position', [0.54 0.54, 0.43, 0.43]);
hold on;grid minor;
pltLabel = 'CumScrOutNoxFlow';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend(['Real ', pltLabel], ['Sim ', pltLabel]);
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');

AxesHandle.(FigName).AX(3) = subplot('Position', [0.06 0.07, 0.43, 0.40]);
hold on;grid minor;
pltLabel = 'CumUreaFlow';
if Options.ena_comparison
    plot(DATA.MEAS.TEST.EngSpeed.Time, DATA.MEAS.TEST.(pltLabel).Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.TrsmMdl_nCrksft_PHY.Time, DATA.SIM.TEST.(pltLabel).Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend(['Real ', pltLabel], ['Sim ', pltLabel]);
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel(['Cumulative ', pltLabel(4:end)], 'FontSize', 12, 'FontWeight', 'Bold');

AxesHandle.(FigName).AX(4) = subplot('Position', [0.54 0.07, 0.43, 0.40]);
hold on;grid minor;
if Options.ena_comparison
    plot(DATA.MEAS.TEST.SCRT_tAvrg.Time, DATA.MEAS.TEST.SCRT_tAvrg.Data, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
else
    plot(0, 0, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
end
plot(DATA.SIM.TEST.ExhATSysMdl_tPMFilDs_PHY.Time, DATA.SIM.TEST.ExhATSysMdl_tPMFilDs_PHY.Data, 'b', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
plot(DATA.SIM.TEST.ExhATSysMdl_tASCDs_PHY.Time, DATA.SIM.TEST.ExhATSysMdl_tASCDs_PHY.Data, 'b', 'Color', [0.0 0.7 0.5], 'LineWidth',3);
set(gca, 'FontSize', 12, 'FontWeight', 'Bold');
legend('Real Scr Avr Temp', 'Sim Scr In Temp', 'Sim Scr (ASC Out) Temp');
xlabel('Time', 'FontSize', 12, 'FontWeight', 'Bold');
ylabel('Scr Temperature', 'FontSize', 12, 'FontWeight', 'Bold');

linkaxes(AxesHandle.(FigName).AX,'x');
xlim([DATA.SIM.TEST.Time.TimeInfo.Start, DATA.SIM.TEST.Time.TimeInfo.End]);