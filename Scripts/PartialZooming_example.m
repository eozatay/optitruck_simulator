zoom_interval       = [2000, 2400];
zoom_factor         = 8;
FigName             = 'Noxppm';
figure('WindowStyle','Docked','NumberTitle','off','Name',FigName);
meas_label  = 'Exh_rNOxNSCDs';
sim_label   = 'EngMdl_ratNOx_PHY';
% Plot meas
X_Signal    = DATA.MEAS.TEST.(meas_label).Time;
Y_Signal    = DATA.MEAS.TEST.(meas_label).Data;
AxesHandle  = plot_PartialZoom(X_Signal, Y_Signal, meas_label, FigName, zoom_interval, zoom_factor);
% Plot sim
X_Signal    = DATA.SIM.TEST.(sim_label).Time;
Y_Signal    = DATA.SIM.TEST.(sim_label).Data;
AxesHandle  = plot_PartialZoom(X_Signal, Y_Signal, sim_label, FigName, zoom_interval, zoom_factor, AxesHandle);