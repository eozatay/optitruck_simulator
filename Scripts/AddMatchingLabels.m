function [MEAStest, UNITmeas] = AddMatchingLabels(MEAStest, UNITmeas)
%% Additional (matching) Labels
%     % stOpModeAct
%     0 -> 'Normal' > EOM0
%     1 -> 'PFlt_Rgn1' > EOM1
%     2 -> 'PFlt_Rgn2' > EOM2
%     3 -> 'PHC'
%     4 -> 'NSC_Rgn'
%     5 -> 'DeSOx'
%     6 -> 'CldStrt' > EOM3
%     7 -> 'EGTM' > EOM4
%     8 -> 'EngStrt'
%     9 -> 'OCM'
%     10 -> 'HCI'
%     11 -> 'EngBrk' EOM5
if isfield(MEAStest, 'CoEOM_numOpModeAct')
    MEAStest.ECU_numOperModAct_PHY	= MEAStest.CoEOM_numOpModeAct;
    ind = find((MEAStest.ECU_numOperModAct_PHY.Data < 0.5));
    MEAStest.ECU_numOperModAct_PHY.Data(ind)	= 0; % 'Normal'
    ind = find((MEAStest.ECU_numOperModAct_PHY.Data > 0.5) & (MEAStest.ECU_numOperModAct_PHY.Data < 1.5));
    MEAStest.ECU_numOperModAct_PHY.Data(ind)  = 1; % 'PFlt_Rgn1'
    ind = find((MEAStest.ECU_numOperModAct_PHY.Data > 1.5) & (MEAStest.ECU_numOperModAct_PHY.Data < 2.5));
    MEAStest.ECU_numOperModAct_PHY.Data(ind)  = 2; % 'PFlt_Rgn2'
    ind = find((MEAStest.ECU_numOperModAct_PHY.Data > 5.5) & (MEAStest.ECU_numOperModAct_PHY.Data < 6.5));
    MEAStest.ECU_numOperModAct_PHY.Data(ind)  = 3; % 'CldStrt'
    ind = find((MEAStest.ECU_numOperModAct_PHY.Data > 6.5) & (MEAStest.ECU_numOperModAct_PHY.Data < 7.5));
    MEAStest.ECU_numOperModAct_PHY.Data(ind)  = 4; % 'EGTM'
    ind = find((MEAStest.ECU_numOperModAct_PHY.Data > 7.5) & (MEAStest.ECU_numOperModAct_PHY.Data < 8.5));
    MEAStest.ECU_numOperModAct_PHY.Data(ind)  = 0; % ??? 'EngStrt'
    ind = find((MEAStest.ECU_numOperModAct_PHY.Data > 10.5));
    MEAStest.ECU_numOperModAct_PHY.Data(ind)  = 5; % 'EngBrk'
    UNITmeas.ECU_numOperModAct_PHY	= '[-]';
    MEAStest.stOpModeAct            = MEAStest.ECU_numOperModAct_PHY;
    UNITmeas.ECU_numOperModAct_PHY	= '[-]';
end
% Eng Speed
if isfield(MEAStest, 'Epm_nEng')
    MEAStest.TrsmMdl_nCrksft_PHY            = MEAStest.Epm_nEng;
    UNITmeas.TrsmMdl_nCrksft_PHY            = 'Rpm';
    if ~isfield(MEAStest, 'EngSpeed')
        MEAStest.EngSpeed            = MEAStest.Epm_nEng;
        UNITmeas.EngSpeed            = 'Rpm';
    end
elseif isfield(MEAStest, 'EngSpeed')
    MEAStest.TrsmMdl_nCrksft_PHY            = MEAStest.EngSpeed;
    UNITmeas.TrsmMdl_nCrksft_PHY            = 'Rpm';
end
% Veh Speed
if isfield(MEAStest, 'VehV_v')
    MEAStest.LgtVehMdl_vVehSpd_PHY          = MEAStest.VehV_v;
    UNITmeas.LgtVehMdl_vVehSpd_PHY          = 'km/h';
elseif isfield(MEAStest, 'WheelBasedVehicleSpeed_CCVS_ECM')
    MEAStest.LgtVehMdl_vVehSpd_PHY          = MEAStest.WheelBasedVehicleSpeed_CCVS_ECM;
    UNITmeas.LgtVehMdl_vVehSpd_PHY          = 'km/h';
else
    MEAStest.VehV_v                         = MEAStest.TrsmMdl_nCrksft_PHY*0;
    UNITmeas.VehV_v                         = 'km/h';
    MEAStest.WheelBasedVehicleSpeed_CCVS_ECM	= MEAStest.VehV_v;
    UNITmeas.WheelBasedVehicleSpeed_CCVS_ECM	= 'km/h';
    MEAStest.LgtVehMdl_vVehSpd_PHY          = MEAStest.VehV_v;
    UNITmeas.LgtVehMdl_vVehSpd_PHY          = 'km/h';
end
% Gear
if isfield(MEAStest, 'Tra_numGear')
    MEAStest.TCU_numGear_PHY                = MEAStest.Tra_numGear;
    UNITmeas.TCU_numGear_PHY                = '-';
elseif isfield(MEAStest, 'TransCurrentGear')
    MEAStest.TCU_numGear_PHY                = MEAStest.TransCurrentGear;
    UNITmeas.TCU_numGear_PHY                = '-';
else
    MEAStest.Tra_numGear                    = MEAStest.TrsmMdl_nCrksft_PHY*0;
    UNITmeas.Tra_numGear                    = '-';
    MEAStest.TCU_numGear_PHY                = MEAStest.Tra_numGear;
    UNITmeas.TCU_numGear_PHY                = '-';
end
% Indicated torque
if isfield(MEAStest, 'PthSet_trqInrSet')
    MEAStest.ECU_trqEngSetInr_PHY           = MEAStest.PthSet_trqInrSet;
    UNITmeas.ECU_trqEngSetInr_PHY           = 'Nm';
end
% InjQty
if isfield(MEAStest, 'InjCrv_qSetUnBal')
    MEAStest.ECU_qInjTot_PHY                = MEAStest.InjCrv_qSetUnBal;
    UNITmeas.ECU_qInjTot_PHY                = 'mg/str';
elseif isfield(MEAStest, 'InjSys_qTot')
    MEAStest.ECU_qInjTot_PHY                = MEAStest.InjSys_qTot;
    UNITmeas.ECU_qInjTot_PHY                = 'mg/str';
end
% AccPdl
if isfield(MEAStest, 'APP_r')
    MEAStest.DrvrMdl_prcAccrPedlPosn_PHY	= MEAStest.APP_r;
    UNITmeas.DrvrMdl_prcAccrPedlPosn_PHY	= '%';
elseif isfield(MEAStest, 'AccelPedalPos1')
    MEAStest.DrvrMdl_prcAccrPedlPosn_PHY	= MEAStest.AccelPedalPos1;
    UNITmeas.DrvrMdl_prcAccrPedlPosn_PHY	= '%';
end
% Eng torque
if isfield(MEAStest, 'ActMod_trqCrS')
    MEAStest.EngMdl_trqEngTqOut_PHY         = MEAStest.ActMod_trqCrS;
    UNITmeas.EngMdl_trqEngTqOut_PHY         = 'Nm';
end
% VGT pos
if isfield(MEAStest, 'TrbCh_rAct')
    MEAStest.ECU_prcTrbVlvDes_PHY           = MEAStest.TrbCh_rAct;
    UNITmeas.ECU_prcTrbVlvDes_PHY           = '%';
elseif isfield(MEAStest, 'TrbCh_rActB1')
    MEAStest.TrbCh_rAct                     = MEAStest.TrbCh_rActB1;
    UNITmeas.TrbCh_rAct                     = '%';
    MEAStest.ECU_prcTrbVlvDes_PHY           = MEAStest.TrbCh_rAct;
    UNITmeas.ECU_prcTrbVlvDes_PHY           = '%';
end
% EGR pos
if isfield(MEAStest, 'EGRVlv_rAct')
    MEAStest.ECU_prcEgrVlvDes_PHY           = MEAStest.EGRVlv_rAct;
    UNITmeas.ECU_prcEgrVlvDes_PHY           = '%';
end
% THR pos
if isfield(MEAStest, 'ThrVlv_rAct')
    MEAStest.ECU_prcThrVlvDes_PHY           = MEAStest.ThrVlv_rAct;
    UNITmeas.ECU_prcThrVlvDes_PHY           = '%';
end
% MAF
if isfield(MEAStest, 'AFS_dm')
    MEAStest.EngMdl_mflChrgdAir_PHY         = MEAStest.AFS_dm/3600;
    UNITmeas.EngMdl_mflChrgdAir_PHY         = 'kg/sec';
end
% MAP
if isfield(MEAStest, 'Air_pIntkVUs')
    MEAStest.EngMdl_pIntkMnfld_PHY          = MEAStest.Air_pIntkVUs*100;
    UNITmeas.EngMdl_pIntkMnfld_PHY          = 'Pa';
end
% MAFref
if isfield(MEAStest, 'AirCtl_dmAirDesDyn_r32')
    MEAStest.ECU_mflChrgdAirDes_PHY         = MEAStest.AirCtl_dmAirDesDyn_r32/3600;
    UNITmeas.ECU_mflChrgdAirDes_PHY         = 'kg/sec';
elseif isfield(MEAStest, 'AirCtl_mAirPerCylDesDyn_r32')
    MEAStest.AirCtl_dmAirDesDyn_r32         = MEAStest.AirCtl_mAirPerCylDesDyn_r32 * 1e-6 .* MEAStest.EngSpeed * 6 / 2 * 60;
    UNITmeas.AirCtl_dmAirDesDyn_r32         = 'kg/h';
    MEAStest.ECU_mflChrgdAirDes_PHY         = MEAStest.AirCtl_dmAirDesDyn_r32/3600;
    UNITmeas.ECU_mflChrgdAirDes_PHY         = 'kg/sec';
end
% MAPref
if isfield(MEAStest, 'PCR_pDesVal')
    MEAStest.ECU_pIntkMnfldDes_PHY          = MEAStest.PCR_pDesVal*100;
    UNITmeas.ECU_pIntkMnfldDes_PHY          = 'Pa';
end
% TurSpd
if isfield(MEAStest, 'TrbCh_n')
    MEAStest.EngMdl_nTrbn_PHY               = MEAStest.TrbCh_n;
    UNITmeas.EngMdl_nTrbn_PHY               = 'rpm';
end
% T2
if isfield(MEAStest, 'Air_tCACDs')
    MEAStest.EngMdl_tIntkMnfld_PHY          = MEAStest.Air_tCACDs;
    UNITmeas.EngMdl_tIntkMnfld_PHY          = 'degC';
end
% T3 (mdl)
if isfield(MEAStest, 'T3LimCL_tTrbnUs_mp')
    MEAStest.EngMdl_tExhMnfld_PHY           = MEAStest.T3LimCL_tTrbnUs_mp;%  MEAStest.Exh_tTrbnUs;
    UNITmeas.EngMdl_tExhMnfld_PHY           = 'degC';
end
% T4
if isfield(MEAStest, 'Exh_tOxiCatUs')
    MEAStest.EngMdl_tTrbDs_PHY              = MEAStest.Exh_tOxiCatUs;
    UNITmeas.EngMdl_tTrbDs_PHY              = 'degC';
end
% T5
if isfield(MEAStest, 'Exh_tPFltUs')
    MEAStest.ExhATSysMdl_tPMFilUs_PHY       = MEAStest.Exh_tPFltUs;
    UNITmeas.ExhATSysMdl_tPMFilUs_PHY       = 'degC';
end
% pDPFdiff
if isfield(MEAStest, 'Exh_pAdapPPFltDiff')
    MEAStest.ExhATSysMdl_pDifPMFil_PHY     = MEAStest.Exh_pAdapPPFltDiff*100;
    UNITmeas.ExhATSysMdl_pDifPMFil_PHY     = 'Pa';
end
% pRail Ref
if isfield(MEAStest, 'Rail_pSetPoint')
    MEAStest.ECU_pFuRailDes_PHY             = MEAStest.Rail_pSetPoint*100;
    UNITmeas.ECU_pFuRailDes_PHY             = 'Pa';
end
% pRail Ref
if isfield(MEAStest, 'Rail_pSetPoint')
    MEAStest.ECU_pFuRailDes_PHY             = MEAStest.Rail_pSetPoint*100;
    UNITmeas.ECU_pFuRailDes_PHY             = 'Pa';
end
% pRail
if isfield(MEAStest, 'RailP_pFlt')
    MEAStest.EngMdl_pFuRail_PHY             = MEAStest.RailP_pFlt*100;
    UNITmeas.EngMdl_pFuRail_PHY             = 'Pa';
end
% pEnv
if isfield(MEAStest, 'EnvP_p')
    MEAStest.EnvMdl_pEnv_PHY                = MEAStest.EnvP_p*100;
    UNITmeas.EnvMdl_pEnv_PHY                = 'Pa';
end
% tEnv
if isfield(MEAStest, 'EnvT_t')
    MEAStest.EnvMdl_tEnv_PHY                = MEAStest.EnvT_t;
    UNITmeas.EnvMdl_tEnv_PHY                = 'Pa';
end
% Nox1
if isfield(MEAStest, 'Exh_rNOxNSCDs')
    MEAStest.EngMdl_ratNOx_PHY              = MEAStest.Exh_rNOxNSCDs;
    UNITmeas.EngMdl_ratNOx_PHY              = 'ppm';
elseif isfield(MEAStest, 'EM_NOX_1')
    MEAStest.Exh_rNOxNSCDs                  = MEAStest.EM_NOX_1;
    UNITmeas.Exh_rNOxNSCDs                  = 'ppm';
    MEAStest.EngMdl_ratNOx_PHY              = MEAStest.Exh_rNOxNSCDs;
    UNITmeas.EngMdl_ratNOx_PHY              = 'ppm';
end
% Nox2
if isfield(MEAStest, 'Exh_rNOxNoCat2Ds')
    MEAStest.ExhATSysMdl_ratNoxSnsrDs_PHY	= MEAStest.Exh_rNOxNoCat2Ds;
    UNITmeas.ExhATSysMdl_ratNoxSnsrDs_PHY	= 'ppm';
elseif isfield(MEAStest, 'EM_NOX_2')
    MEAStest.Exh_rNOxNoCat2Ds           	= MEAStest.EM_NOX_2;
    UNITmeas.Exh_rNOxNoCat2Ds             	= 'ppm';
    MEAStest.ExhATSysMdl_ratNoxSnsrDs_PHY	= MEAStest.Exh_rNOxNoCat2Ds;
    UNITmeas.ExhATSysMdl_ratNoxSnsrDs_PHY	= 'ppm';
end
% tSCR
if isfield(MEAStest, 'SCR_tUCatUsT')
    MEAStest.ExhATSysMdl_tPMFilDs_PHY       = MEAStest.SCR_tUCatUsT;
    UNITmeas.ExhATSysMdl_tPMFilDs_PHY       = 'degC';
end
% tSCR (alternative)
if isfield(MEAStest, 'SCRT_tAvrg')
    MEAStest.ExhATSysMdl_tASCDs_PHY         = MEAStest.SCRT_tAvrg;
    UNITmeas.ExhATSysMdl_tASCDs_PHY         = 'degC';
end
% AuxTrq
if isfield(MEAStest, 'CoVeh_trqAcs')
    MEAStest.AuxMdl_trqAcs_PHY              = MEAStest.CoVeh_trqAcs;
    UNITmeas.AuxMdl_trqAcs_PHY              = 'Nm';
end
% FanSpd Ref
if isfield(MEAStest, 'Fan_nFlt')
    MEAStest.ECU_nFanDes_PHY                = MEAStest.Fan_nFlt;
    UNITmeas.ECU_nFanDes_PHY                = 'rpm';
elseif isfield(MEAStest, 'FanSpeed')
    MEAStest.ECU_nFanDes_PHY                = MEAStest.FanSpeed;
    UNITmeas.ECU_nFanDes_PHY                = 'rpm';
end
% UreaFlow
if isfield(MEAStest, 'DStgy_dmRdcAgAct') % UDC_dmRdcAgAct
    MEAStest.ECU_mflUreaDes_PHY             = MEAStest.DStgy_dmRdcAgAct/1e6;
    UNITmeas.ECU_mflUreaDes_PHY             = 'kg/sec';
end
% Slope
if isfield(MEAStest, 'PreCru_Ctrl_PresentGrade') % UDC_dmRdcAgAct
    MEAStest.EnvMdl_phiRoadSlop_PHY       	= MEAStest.PreCru_Ctrl_PresentGrade;
    UNITmeas.EnvMdl_phiRoadSlop_PHY     	= '[-]';
end
% Distance
if isfield(MEAStest, 'LgtVehMdl_vVehSpd_PHY')
    MEAStest.LgtVehMdl_lDstTrvld_PHY       	= MEAStest.LgtVehMdl_vVehSpd_PHY;
    MEAStest.LgtVehMdl_lDstTrvld_PHY.Data  	= cumtrapz(MEAStest.LgtVehMdl_vVehSpd_PHY.Time, MEAStest.LgtVehMdl_vVehSpd_PHY.Data/3600)*1e3;
    UNITmeas.LgtVehMdl_lDstTrvld_PHY     	= '[-]';
end