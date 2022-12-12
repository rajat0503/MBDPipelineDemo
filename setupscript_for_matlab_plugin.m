%filename : setupscript_for_matlab_plugin%
%% Options To Run Different Jobs
% 1. MIL - Run command : jobName = 'MIL' Before Running Script
% 2. SIL - Run command : jobName = 'SIL' Before Running Script
% 3. CodeGen - Run command : jobName = 'CodeGen' Before Running Script
%% Open Project

jenkinsWorkspace = getenv('WORKSPACE')
projName = fullfile(jenkinsWorkspace,'\ModeLogicDemo.prj');
proj = openProject(projName);
if exist('jobName','var')
    switch jobName
        case 'MIL'
            run('scripts\runTests.m')
        case 'SIL'
            run('scripts\runTests.m')
        case 'CodeGen'
            run('scripts\runCodeGen.m')
        otherwise
            error('Wrong Input Fail')
    end
else
    error('JobName Variable not defined');
end
