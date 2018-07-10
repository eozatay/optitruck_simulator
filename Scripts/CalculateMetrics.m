function METRICS = CalculateMetrics(DATA)
speed_violation_thres	= 3;%+/- speed violation threshold as km/hr (added by etekin)
%% PostProcess
data_type               = 'SIM';
desired_time            = DATA.(data_type).TEST.RefSpdGenr_vRefSpd_CLD.Time;
desired_speed           = interp1(DATA.(data_type).TEST.RefSpdGenr_vRefSpd_CLD.Time, DATA.(data_type).TEST.RefSpdGenr_vRefSpd_CLD.Data, desired_time);
vehicle_speed           = interp1(DATA.(data_type).TEST.LgtVehMdl_vVehSpd_PHY.Time, DATA.(data_type).TEST.LgtVehMdl_vVehSpd_PHY.Data, desired_time);

DATA.(data_type).TEST.FB_VAL_kgps           = DATA.(data_type).TEST.TrsmMdl_nCrksft_PHY; % Initial definition
DATA.(data_type).TEST.FB_VAL_kgps.Data      = 1e-6/120 * DATA.(data_type).TEST.ECU_qInjTot_PHY.Data .* DATA.(data_type).TEST.TrsmMdl_nCrksft_PHY.Data * 6;
Dummy1                                      = cumtrapz(DATA.(data_type).TEST.FB_VAL_kgps.Time, DATA.(data_type).TEST.FB_VAL_kgps.Data)/0.835;
Dummy2                                      = cumtrapz(DATA.(data_type).TEST.LgtVehMdl_vVehSpd_PHY.Time, DATA.(data_type).TEST.LgtVehMdl_vVehSpd_PHY.Data/3600);
METRICS.(data_type).FuelPerDistance         = Dummy1(end) ./ Dummy2(end) * 100;
METRICS.(data_type).SpeedViolation          = trapz(desired_time,(vehicle_speed > (desired_speed + speed_violation_thres)) | (vehicle_speed < (desired_speed - speed_violation_thres)));
METRICS.(data_type).Mean_EngSpd          	= mean(DATA.(data_type).TEST.TrsmMdl_nCrksft_PHY.Data);
METRICS.(data_type).Mean_IndTrq          	= mean(DATA.(data_type).TEST.ECU_trqEngSetInr_PHY.Data);
METRICS.(data_type).Mean_CrsTrq         	= mean(DATA.(data_type).TEST.EngMdl_trqEngTqOut_PHY.Data);
disp('******SIMULATION*********************************************');
disp(['fuel_per_distance:           ' num2str(METRICS.(data_type).FuelPerDistance, '%10.2f')]);
disp(['speed_violation:             ' num2str(METRICS.(data_type).SpeedViolation, '%10.2f')]);
disp(['Engine Speed (mean):         ' num2str(METRICS.(data_type).Mean_EngSpd, '%10.2f')]);
disp(['Indicated Torque (mean):     ' num2str(METRICS.(data_type).Mean_IndTrq, '%10.2f')]);
disp(['CrankShaft Torque(mean):     ' num2str(METRICS.(data_type).Mean_CrsTrq, '%10.2f')]);
%%
data_type               = 'MEAS';
if ~isempty(DATA.(data_type).TEST.Time)
    if ~isfield(DATA.(data_type).TEST, 'Epm_nEng')
        DATA.(data_type).TEST.Epm_nEng       	= DATA.(data_type).TEST.TrsmMdl_nCrksft_PHY;
    end
    
    if ~isfield(DATA.(data_type).TEST, 'InjCrv_qSetUnBal')
        DATA.(data_type).TEST.InjCrv_qSetUnBal	= DATA.(data_type).TEST.ECU_qInjTot_PHY;
    end
    if ~isfield(DATA.(data_type).TEST, 'VehV_v')
        DATA.(data_type).TEST.VehV_v        	= DATA.(data_type).TEST.LgtVehMdl_vVehSpd_PHY;
    end
    if ~isfield(DATA.(data_type).TEST, 'EngMdl_trqEngTqOut_PHY')
        DATA.(data_type).TEST.EngMdl_trqEngTqOut_PHY	= DATA.(data_type).TEST.ActMod_trqCrS;
    end
    if ~isfield(DATA.(data_type).TEST, 'TrsmMdl_nCrksft_PHY')
        DATA.(data_type).TEST.TrsmMdl_nCrksft_PHY	= DATA.(data_type).TEST.Epm_nEng;
    end
    if ~isfield(DATA.(data_type).TEST, 'ECU_qInjTot_PHY')
        DATA.(data_type).TEST.ECU_qInjTot_PHY       = DATA.(data_type).TEST.InjCrv_qSetUnBal;
    end
    if ~isfield(DATA.(data_type).TEST, 'LgtVehMdl_vVehSpd_PHY')
        DATA.(data_type).TEST.LgtVehMdl_vVehSpd_PHY	= DATA.(data_type).TEST.VehV_v;
    end
    if ~isfield(DATA.(data_type).TEST, 'ActMod_trqCrS')
        DATA.(data_type).TEST.ActMod_trqCrS         = DATA.(data_type).TEST.EngMdl_trqEngTqOut_PHY;
    end
    if ~isfield(DATA.(data_type).TEST, 'ECU_trqEngSetInr_PHY')
        DATA.(data_type).TEST.ECU_trqEngSetInr_PHY	= DATA.(data_type).TEST.PthSet_trqInrSet;
    end
    DATA.(data_type).TEST.FB_VAL_kgps       	= DATA.(data_type).TEST.Epm_nEng; % Initial definition
    DATA.(data_type).TEST.FB_VAL_kgps.Data      = 1e-6/120 * DATA.(data_type).TEST.InjCrv_qSetUnBal.Data .* DATA.(data_type).TEST.Epm_nEng.Data * 6;
    Dummy1                                      = cumtrapz(DATA.(data_type).TEST.FB_VAL_kgps.Time, DATA.(data_type).TEST.FB_VAL_kgps.Data)/0.835;
    Dummy2                                      = cumtrapz(DATA.(data_type).TEST.VehV_v.Time, DATA.(data_type).TEST.VehV_v.Data/3600);
    METRICS.(data_type).FuelPerDistance     	= Dummy1(end) ./ Dummy2(end) * 100;
    METRICS.(data_type).Mean_EngSpd             = mean(DATA.(data_type).TEST.TrsmMdl_nCrksft_PHY.Data);
    METRICS.(data_type).Mean_IndTrq           	= mean(DATA.(data_type).TEST.ECU_trqEngSetInr_PHY.Data);
    METRICS.(data_type).Mean_CrsTrq           	= mean(DATA.(data_type).TEST.EngMdl_trqEngTqOut_PHY.Data);
    disp('******REAL**************************************************');
    disp(['fuel_per_distance (Real):        '	num2str(METRICS.(data_type).FuelPerDistance, '%10.2f')]);
    disp(['Engine Speed (mean-Real):        '   num2str(METRICS.(data_type).Mean_EngSpd, '%10.2f')]);
    disp(['Indicated Torque (mean-Real):	 '  num2str(METRICS.(data_type).Mean_IndTrq, '%10.2f')]);
    disp(['CrankShaft Torque(mean-Real):	 '  num2str(METRICS.(data_type).Mean_CrsTrq, '%10.2f')]);
else
    disp('There is no information to calculate Real-World metrics.');
end