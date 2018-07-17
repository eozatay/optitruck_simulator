function AxesHandle = plot_PartialZoom(varargin)
X_Signal        = varargin{1};
Y_Signal        = varargin{2};
SignalName    	= varargin{3};
FigName         = varargin{4};
zoom_interval	= varargin{5};
zoom_factor     = varargin{6};
add_newplot     = 0;
if nargin  > 6
    AxesHandle	= varargin{7};
    add_newplot  = 1;
end
% Size definitions
normX0              = 0.04;
normXsize        	= 0.94;
normY0              = 0.07;
normYsize        	= 0.88;
% Plotting to get ylim
FirstPlotName = 'PrePlot';
figure('WindowStyle','Docked','NumberTitle','off','Name',FirstPlotName);
AxesHandle.(FirstPlotName).AX(1) = subplot('Position', [normX0 normY0, normXsize, normYsize]);
hold on;grid on;%grid minor;
plot(X_Signal, Y_Signal, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
YLim    = AxesHandle.(FirstPlotName).AX.YLim;
YTick   = AxesHandle.(FirstPlotName).AX.YTick;
close(FirstPlotName);
% Set zoom interval
SignalX_interval	= [X_Signal(1), X_Signal(end)];
PartlyZoomed_length	= (zoom_interval(1) - SignalX_interval(1)) + zoom_factor * diff(zoom_interval) + (SignalX_interval(2) - zoom_interval(2));
% Divide plot into 3 part (assumt)
part1_X             = [normX0, normX0+(zoom_interval(1) - SignalX_interval(1))/PartlyZoomed_length*normXsize];
part2_X             = [part1_X(2), part1_X(2)+zoom_factor * diff(zoom_interval)/PartlyZoomed_length*normXsize];
part3_X             = [part2_X(2), part2_X(2)+(SignalX_interval(2) - zoom_interval(2))/PartlyZoomed_length*normXsize];
% Figure
% figure('WindowStyle','Docked','NumberTitle','off','Name',FigName);
if ~add_newplot
    AxesHandle.(FigName).AX(1) = subplot('Position', [part1_X(1) normY0, diff(part1_X), normYsize]);
    hold on;grid on;%grid minor;
    plot(AxesHandle.(FigName).AX(1), X_Signal, Y_Signal, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
    legend(AxesHandle.(FigName).AX(1), strrep(SignalName, '_', '\_'), 'Location','northwest');
else
    %     YTick = get(AxesHandle.(FigName).AX(1), 'YTick');
    plot(AxesHandle.(FigName).AX(1), X_Signal, Y_Signal, 'r', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
    Lgd         = get(AxesHandle.(FigName).AX(1), 'Legend');
    LgdStr      = Lgd.String;
    LgdStr{2}   = strrep(SignalName, '_', '\_');
    legend(AxesHandle.(FigName).AX(1), LgdStr, 'Location','northwest');
end
xlim(AxesHandle.(FigName).AX(1), [SignalX_interval(1), zoom_interval(1)]);
ylim(AxesHandle.(FigName).AX(1), YLim);
set(AxesHandle.(FigName).AX(1), 'YTick', YTick);
set(AxesHandle.(FigName).AX(1), 'FontSize', 12, 'FontWeight', 'Bold');

if ~add_newplot
    AxesHandle.(FigName).AX(2) = subplot('Position', [part2_X(1) normY0, diff(part2_X), normYsize]);
    hold on;grid on;%grid minor;
    plot(AxesHandle.(FigName).AX(2), X_Signal, Y_Signal, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
    set(AxesHandle.(FigName).AX(2), 'Color', [0.9 0.9 1.0], 'YTickLabelMode', 'manual');
else
%     YTick = get(AxesHandle.(FigName).AX(2), 'YTick');
    plot(AxesHandle.(FigName).AX(2), X_Signal, Y_Signal, 'r', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
end
xlim(AxesHandle.(FigName).AX(2), zoom_interval);
ylim(AxesHandle.(FigName).AX(2), YLim);
set(AxesHandle.(FigName).AX(2), 'YTick', YTick);
set(AxesHandle.(FigName).AX(2), 'FontSize', 12, 'FontWeight', 'Bold');

if ~add_newplot
    AxesHandle.(FigName).AX(3) = subplot('Position', [part3_X(1) normY0, diff(part3_X), normYsize]);
    hold on;grid on;%grid minor;
    plot(AxesHandle.(FigName).AX(3), X_Signal, Y_Signal, 'r', 'Color', [0.8 0.1 0.1], 'LineWidth',3);
    set(AxesHandle.(FigName).AX(3), 'YTickLabelMode', 'manual'); 
else
%     YTick = get(AxesHandle.(FigName).AX(3), 'YTick');
    plot(AxesHandle.(FigName).AX(3), X_Signal, Y_Signal, 'r', 'Color', [0.0 0.5 0.8], 'LineWidth',3);
end
xlim(AxesHandle.(FigName).AX(3), [zoom_interval(2), SignalX_interval(2)]);
ylim(AxesHandle.(FigName).AX(3), YLim);
set(AxesHandle.(FigName).AX(3), 'YTick', YTick);
set(AxesHandle.(FigName).AX(3), 'FontSize', 12, 'FontWeight', 'Bold');

linkaxes(AxesHandle.(FigName).AX,'y');