% Read current MatlabPath
MatlabPath  = path;
PathInd  	= strfind(MatlabPath, ';');
PathInd  	= [0, PathInd];
for i = 1:numel(PathInd)-1
    MatlabPathList{i,1} = MatlabPath(PathInd(i)+1:PathInd(i+1));
end
MatlabPathList{i+1,1} = MatlabPath(PathInd(i+1):end);

SearchPath = {'optitruck_simulator-master\Model_Library';...
    'optitruck_simulator-master\Model_Generation_Tool';...
    'optitruck_simulator-master\GUIFiles';...
    'optitruck_simulator-master\Scripts'};

for i = 1:numel(MatlabPathList)
    for j = 1:numel(SearchPath)
        ind = strfind(MatlabPathList{i}, SearchPath{j});
        if ~isempty(ind)
            disp(['Removing MatlabPath : ', MatlabPathList{i}]);
            rmpath(MatlabPathList{i});
        end
    end
end
% Search current path and add new path
UpperFolderName = pwd;
indUpper        = strfind(UpperFolderName, '\');
UpperFolderName = UpperFolderName(1:indUpper(end)-1);
for j = 1:numel(SearchPath)
    ind1 = strfind(SearchPath{j}, '\');
    if ~isempty(ind1)
        ind2 = ls([UpperFolderName, '\*',SearchPath{j}(ind1+1:end)]);
        if ~isempty(ind2)
            AddNewPath = [UpperFolderName, '\', SearchPath{j}(ind1+1:end)];
            disp(['Adding MatlabPath : ', AddNewPath]);
            addpath(AddNewPath);
        end
    end
end
cd(UpperFolderName);