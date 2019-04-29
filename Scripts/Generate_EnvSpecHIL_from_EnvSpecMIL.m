clear;
clc;
%% Select MIL EnvSpec File & copy to HIL folder
[EnvSpecMIL_fname, EnvSpecMIL_path] = uigetfile({'*.xlsm'}, 'Please select Environment_Specification (MIL) file');
copyfile(fullfile(EnvSpecMIL_path, EnvSpecMIL_fname), fullfile(pwd, [EnvSpecMIL_fname(1:end-5), '_MIL.xlsm']));
copyfile(fullfile(pwd, [EnvSpecMIL_fname(1:end-5), '_MIL.xlsm']), fullfile(pwd, EnvSpecMIL_fname));
%% Excel- actxserver
objXLS 	= actxserver('Excel.Application');
wkbk    = objXLS.Workbooks;
file    = wkbk.Open(fullfile(pwd,EnvSpecMIL_fname)); % Open the sheet that you want to change, and retrieve the current values in the range of interest:
sheets	= objXLS.ActiveWorkBook.Sheets;
%% Read EnvSpec File
disp('Read EnvSpec File');
SheetNameList = {'Signal Definition';...
    'Signal Connections';...
    'Abbreviation';...
    'Simulink'};

for i = 1:numel(SheetNameList)
    Sheetname   = SheetNameList{i};
    SheetName	= strrep(Sheetname, ' ', '_');
    [ndata.(SheetName), headertext.(SheetName), raw.(SheetName)]	= xlsread(EnvSpecMIL_fname, Sheetname);
    ActiveSheet	= sheets.Item(Sheetname);
    ActiveSheet.Unprotect('optiTruck');
end
%% Find models for 'Engine Control Unit' component and delete except 'Real ECU' from 'Simulink' sheet
disp('Find models for ''Engine Control Unit'' component and delete except ''Real ECU'' from ''Simulink'' sheet');
Sheetname   = 'Simulink';
SheetName	= strrep(Sheetname, ' ', '_');
    
j	= 1;
for i = 1:size(raw.(SheetName),1)
    if strcmp(raw.(SheetName){i,2}, 'Engine Control Unit')
        if ~strcmp(raw.(SheetName){i,3}, 'Real ECU')
            ECUmdl_Del.Ind(j,1)        = i;
            ECUmdl_Del.MdlName{j,1}    = raw.(SheetName){i,3};
            j = j  + 1;
        end
    end
end
% Delete from 'Simulink' sheet
ActiveSheet	= sheets.Item(Sheetname);
for i = numel(ECUmdl_Del.Ind):-1:1
    ActiveSheet.Rows.Item(ECUmdl_Del.Ind(i)).Delete;
end

objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
%% Find models for 'Rapid Prototyping Unit' component and delete except 'Real RPU' from 'Simulink' sheet
disp('Find models for ''Rapid Prototyping Unit'' component and delete except ''Real RPU'' from ''Simulink'' sheet');
Sheetname   = 'Simulink';
SheetName	= strrep(Sheetname, ' ', '_');
[ndata.(SheetName), headertext.(SheetName), raw.(SheetName)]	= xlsread(EnvSpecMIL_fname, Sheetname);
j	= 1;
for i = 1:size(raw.(SheetName),1)
    if strcmp(raw.(SheetName){i,2}, 'Rapid Prototyping Unit')
        if ~strcmp(raw.(SheetName){i,3}, 'Real RPU')
            RPUmdl_Del.Ind(j,1)        = i;
            RPUmdl_Del.MdlName{j,1}    = raw.(SheetName){i,3};
            j = j  + 1;
        end
    end
end
% Delete from 'Simulink' sheet
ActiveSheet	= sheets.Item(Sheetname);
for i = numel(RPUmdl_Del.Ind):-1:1
    ActiveSheet.Rows.Item(RPUmdl_Del.Ind(i)).Delete;
end

objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
%% Delete 'Prediction Horizon Generator & PCCM RPU Interface' model from 'Simulink' sheet
disp('Delete ''Prediction Horizon Generator & PCCM RPU Interface'' model from ''Simulink'' sheet');
Sheetname   = 'Simulink';
SheetName	= strrep(Sheetname, ' ', '_');
[ndata.(SheetName), headertext.(SheetName), raw.(SheetName)]	= xlsread(EnvSpecMIL_fname, Sheetname);
j	= 1;
for i = 1:size(raw.(SheetName),1)
    if strcmp(raw.(SheetName){i,2}, 'Predictive Cruise Control Module')
        if strcmp(raw.(SheetName){i,3}, 'Prediction Horizon Generator') || strcmp(raw.(SheetName){i,3}, 'PCCM RPU Interface')
            PHGmdl_Del.Ind(j,1)        = i;
            PHGmdl_Del.MdlName{j,1}    = raw.(SheetName){i,3};
            j = j  + 1;
        end
    end
end
% Delete from 'Simulink' sheet
ActiveSheet	= sheets.Item(Sheetname);
for i = numel(PHGmdl_Del.Ind):-1:1
    ActiveSheet.Rows.Item(PHGmdl_Del.Ind(i)).Delete;
end

objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
%% Find models which use ECU (MIL) model outputs as input and add (replace) corresponding RealECU (HIL) model outputs
disp('Find models which use ECU (MIL) model outputs as input and add (replace) corresponding RealECU (HIL) model outputs');
Sheetname   = 'Signal Connections';
SheetName	= strrep(Sheetname, ' ', '_');
ActiveSheet	= sheets.Item(Sheetname);

searchSourceFunctionList 	= {'ECU'};
searchDestFunction          = 'Real ECU';

for i = 1:numel(searchSourceFunctionList)
    % Find sourcemodel(ECU) and destination model(Real ECU) columns
    for j = 1:size(raw.(SheetName),2)
        if strcmp(raw.(SheetName){2,j}, searchSourceFunctionList{i})
            searchSourceFunctionInd = j;
        elseif strcmp(raw.(SheetName){2,j}, searchDestFunction)
            searchDestFunctionInd   = j;
        end
    end
    %
    for j = 3:size(raw.(SheetName),1)
        % Find sourcemodel(ECU) outputs
        if strcmp(raw.(SheetName){j,searchSourceFunctionInd}, 'output')
            if raw.(SheetName){j,2} > 0 % if it is used by other models
                for k = 4:size(raw.(SheetName),2)
                    if strcmp(raw.(SheetName){j,k}, 'input') % Find model column which uses specific sourcemodel(ECU) output
                        % Convert indexes to Letter
                        if k <= 26
                            columnLetter	= char(64 + k);
                        else
                            columnLetter	= ['A', char(64 + mod(k,26))];
                        end
                        searchDestSgn = strrep(raw.(SheetName){j,1}, 'ECU', 'RealECU');
                        for m = 3:size(raw.(SheetName),1)
                            if strcmp(raw.(SheetName){m,1}, searchDestSgn)
                                rangeStr        	= [columnLetter, num2str(m)];
                                % Correponding destinationmodel(RealECU) output will be input of finded model
                                ActiveSheet.Range(rangeStr).Value = 'input';
                                break;
                            end
                        end
                    end
                end
            end
        end
    end
end

objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
%% Renaming ECU model with ECUmil & RealECU model with ECU at 'Abbreviation' sheet - Then delete ECUmil model abbreviation
disp('Renaming ECU model with ECUmil & RealECU model with ECU at ''Abbreviation'' sheet - Then delete ECUmil model abbreviation');
Sheetname   = 'Abbreviation';
SheetName	= strrep(Sheetname, ' ', '_');
ActiveSheet	= sheets.Item(Sheetname);

% Find lines for ECU component
for i = 1:50 % max 50 model assumption
    if strcmp(raw.(SheetName){i,4}, 'ECU')
        % Rename ECU model with ECUmil
        orgECUline	= i;
        rangeStr    = ['D', num2str(i)];
        ActiveSheet.Range(rangeStr).Value = 'ECUmil';
        rangeStr    = ['E', num2str(i)];
        ActiveSheet.Range(rangeStr).Value = 'ECUmil';
    end
end

% Find lines for Real ECU component
for i = 1:50 % max 50 model assumption
    if strcmp(raw.(SheetName){i,4}, 'Real ECU')
        % Rename "Real ECU" model with ECU
        realECUline  = i;
        rangeStr    = ['D', num2str(i)];
        ActiveSheet.Range(rangeStr).Value = 'ECU';
        rangeStr    = ['E', num2str(i)];
        ActiveSheet.Range(rangeStr).Value = 'ECU';
    end
end
% Delete original ECU(mil)
if 0
rangeStr    = ['D', num2str(orgECUline), ':E',num2str(orgECUline)];
ActiveSheet.Range(rangeStr).Delete;
end
objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
%% Find ECU (MIL) signals from 'Signal Definition' sheet and delete - Then delete corresponding raws from 'Signal Connections' sheet
disp('Find ECU (MIL) signals from ''Signal Definition'' sheet and delete - Then delete corresponding raws from ''Signal Connections'' sheet');
Sheetname   = 'Signal Definition';
SheetName	= strrep(Sheetname, ' ', '_');
% Find signals (raw number) for ECU (MIL) model
j = 1;
for i = 1:size(raw.(SheetName),1)
    if strcmp(raw.(SheetName){i,4}, 'Engine Control Unit')
        if ~strcmp(raw.(SheetName){i,5}, 'Real ECU')
            ECUsgn_Del.Ind(j,1)        = i;
            ECUsgn_Del.MdlName{j,1}    = raw.(SheetName){i,5};
            ECUsgn_Del.SgnName{j,1}    = raw.(SheetName){i,10};
            j = j  + 1;
        end
    end
end
% Delete ECU Component (Signal) rows except Real ECU - from 'Signal Definition' sheet
ActiveSheet	= sheets.Item(Sheetname);
for i = numel(ECUsgn_Del.Ind):-1:1
    ActiveSheet.Rows.Item(ECUsgn_Del.Ind(i)).Delete;
end

objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
% Delete ECU Component (Signal) rows except Real ECU - from 'Signal Connections' sheet
if 1
Sheetname   = 'Signal Connections';
SheetName	= strrep(Sheetname, ' ', '_');
ActiveSheet	= sheets.Item(Sheetname);
for i = numel(ECUsgn_Del.Ind):-1:1
    ActiveSheet.Rows.Item(ECUsgn_Del.Ind(i)).Delete;
end
end
objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
%% Find RPU (MIL) signals from 'Signal Definition' sheet and delete - Then delete corresponding raws from 'Signal Connections' sheet
disp('Find RPU (MIL) signals from ''Signal Definition'' sheet and delete - Then delete corresponding raws from ''Signal Connections'' sheet');
Sheetname   = 'Signal Definition';
SheetName	= strrep(Sheetname, ' ', '_');
[ndata.(SheetName), headertext.(SheetName), raw.(SheetName)]	= xlsread(EnvSpecMIL_fname, Sheetname);
% Find signals (raw number) for RPU (MIL) model
j = 1;
for i = 1:size(raw.(SheetName),1)
    if strcmp(raw.(SheetName){i,4}, 'Rapid Prototyping Unit')
        if ~strcmp(raw.(SheetName){i,5}, 'Real RPU')
            RPUsgn_Del.Ind(j,1)        = i;
            RPUsgn_Del.MdlName{j,1}    = raw.(SheetName){i,5};
            RPUsgn_Del.SgnName{j,1}    = raw.(SheetName){i,10};
            j = j  + 1;
        end
    end
end
% Delete RPU Component (Signal) rows except Real RPU - from 'Signal Definition' sheet
ActiveSheet	= sheets.Item(Sheetname);
for i = numel(RPUsgn_Del.Ind):-1:1
    ActiveSheet.Rows.Item(RPUsgn_Del.Ind(i)).Delete;
end

objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
% Delete RPU Component (Signal) rows except Real RPU - from 'Signal Connections' sheet
if 1
Sheetname   = 'Signal Connections';
SheetName	= strrep(Sheetname, ' ', '_');
ActiveSheet	= sheets.Item(Sheetname);
for i = numel(RPUsgn_Del.Ind):-1:1
    ActiveSheet.Rows.Item(RPUsgn_Del.Ind(i)).Delete;
end
end
objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
%% Find PCCM (MIL) signals from 'Signal Definition' sheet and delete - Then delete corresponding raws from 'Signal Connections' sheet
disp('Find PCCM (MIL) signals from ''Signal Definition'' sheet and delete - Then delete corresponding raws from ''Signal Connections'' sheet');
Sheetname   = 'Signal Definition';
SheetName	= strrep(Sheetname, ' ', '_');
[ndata.(SheetName), headertext.(SheetName), raw.(SheetName)]	= xlsread(EnvSpecMIL_fname, Sheetname);
% Find signals (raw number) for PCCM (MIL) model
j = 1;
for i = 1:size(raw.(SheetName),1)
    if strcmp(raw.(SheetName){i,4}, 'Predictive Cruise Control Module')
        if strcmp(raw.(SheetName){i,5}, 'Prediction Horizon Generator') || strcmp(raw.(SheetName){i,5}, 'PCCM RPU Interface') %if ~(strcmp(raw.(SheetName){i,5}, 'Real PCCM'))
            PCCMsgn_Del.Ind(j,1)    	= i;
            PCCMsgn_Del.MdlName{j,1}	= raw.(SheetName){i,5};
            PCCMsgn_Del.SgnName{j,1}	= raw.(SheetName){i,10};
            j = j  + 1;
        end
    end
end
% Delete PCCM Component (Signal) rows except Real PCCM - from 'Signal Definition' sheet
ActiveSheet	= sheets.Item(Sheetname);
for i = numel(PCCMsgn_Del.Ind):-1:1
    ActiveSheet.Rows.Item(PCCMsgn_Del.Ind(i)).Delete;
end

objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
% Delete PCCM Component (Signal) rows except Real PCCM - from 'Signal Connections' sheet
if 1
Sheetname   = 'Signal Connections';
SheetName	= strrep(Sheetname, ' ', '_');
ActiveSheet	= sheets.Item(Sheetname);
for i = numel(PCCMsgn_Del.Ind):-1:1
    ActiveSheet.Rows.Item(PCCMsgn_Del.Ind(i)).Delete;
end
end
objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
%% Renaming RealECU signals with starting with ECU
disp('Renaming RealECU signals with starting with ECU');
Sheetname   = 'Signal Definition';
SheetName	= strrep(Sheetname, ' ', '_');
[ndata.(SheetName), headertext.(SheetName), raw.(SheetName)]	= xlsread(EnvSpecMIL_fname, Sheetname);
ActiveSheet	= sheets.Item(Sheetname);
% Find lines for Real ECU component
for i = 1:size(raw.(SheetName),1)
    if strcmp(raw.(SheetName){i,4}, 'Engine Control Unit')
        if strcmp(raw.(SheetName){i,5}, 'Real ECU')
            % Rename Real ECU model with ECU
            realECUline	= i;
            rangeStr    = ['E', num2str(i)];
            ActiveSheet.Range(rangeStr).Value = 'ECU';
            % Rename Real ECU model-Bus Signal Name-with ECU model-Bus Signal Name
            rangeStr    = ['J', num2str(i)];
            curStr      = ActiveSheet.Range(rangeStr).Value;
            ActiveSheet.Range(rangeStr).Value = strrep(curStr, 'RealECU', 'ECU');
            % EnableLogging
            rangeStr    = ['Q', num2str(i)];
            ActiveSheet.Range(rangeStr).Value = 'yes';
            rangeStr    = ['R', num2str(i)];
            ActiveSheet.Range(rangeStr).Value = 'yes';
        end
    end
end

objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
%% Enabling logging for IO signals
disp('Enabling logging for IO signals');
Sheetname   = 'Signal Definition';
SheetName	= strrep(Sheetname, ' ', '_');
[ndata.(SheetName), headertext.(SheetName), raw.(SheetName)]	= xlsread(EnvSpecMIL_fname, Sheetname);
ActiveSheet	= sheets.Item(Sheetname);
% Find lines for IO component
for i = 1:size(raw.(SheetName),1)
    if strcmp(raw.(SheetName){i,4}, 'Input Output Model')
        if strcmp(raw.(SheetName){i,5}, 'Input Output')
            % EnableLogging
            rangeStr    = ['Q', num2str(i)];
            ActiveSheet.Range(rangeStr).Value = 'yes';
            rangeStr    = ['R', num2str(i)];
            ActiveSheet.Range(rangeStr).Value = 'yes';
        end
    end
end

objXLS.ActiveWorkbook.Save;
%objXLS.ActiveWorkbook.Close;
%% Renaming Real ECU model with ECU at 'Simulink' sheet
disp('Renaming Real ECU model with ECU at ''Simulink'' sheet');
Sheetname   = 'Simulink';
SheetName	= strrep(Sheetname, ' ', '_');
[ndata.(SheetName), headertext.(SheetName), raw.(SheetName)]	= xlsread(EnvSpecMIL_fname, Sheetname);
ActiveSheet	= sheets.Item(Sheetname);
j	= 1;
for i = 1:size(raw.(SheetName),1)
    if strcmp(raw.(SheetName){i,3}, 'Real ECU')
        % Rename Real ECU model with ECU model
        rangeStr    = ['C', num2str(i)];
        ActiveSheet.Range(rangeStr).Value = 'ECU';
    end
end

objXLS.ActiveWorkbook.Save;
%% ActiveX Save, close and clean up.
disp('ActiveX Save, close and clean up.')
wkbk.Close;
objXLS.Quit;
objXLS.delete;