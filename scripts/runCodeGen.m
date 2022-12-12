jWrkspace = [getenv('WORKSPACE')]
cd(jWrkspace)
ModelName = 'Mode_Logic_Ex';
proj = currentProject;
load_system(ModelName);

rtwbuild(ModelName);
load(fullfile(pwd,[ModelName,'_ert_rtw'],...
    '\buildInfo.mat'));
packNGo(buildInfo,'minimalHeaders',true,'packType','flat');
%Code Files packing


unzip(fullfile(pwd,[ModelName,'.zip']),...
    [pwd,'\code\',[ModelName,'_ac']]);


%Add folder to code in project
projectFile = addFolderIncludingChildFiles(proj,...
    ['code\',[ModelName,'_ac']]);

