 %"run(fullfile(getenv('Jenkins_workspace'),'\ModelVerification_Pipeline\runtestci.m')); exit"
 
 
 %% Open Project
 
 jWrkspace = getenv('Jenkins_workspace');
%  proj = openProject(fullfile((jWrkspace),'Job - Test Model (Model In Loop Testing)\ModeLogicDemo.prj'));
   proj = openProject(fullfile(pwd,'\ModeLogicDemo.prj'));
 
 