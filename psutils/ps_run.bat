@echo off
set "JOBNAME=%JOB_NAME%" 
set "OPTSPATH=%jenkins_workspace%%JOBNAME%\psutils\ps_options.txt"
echo %OPTSPATH%
set "SRCPATH=%jenkins_workspace%%JOBNAME%\psutils\sources_list.txt"

Set "out=%jenkins_workspace%%JOBNAME%\psutils\"
(
  Echo;%jenkins_workspace%%JOBNAME%\code\Mode_Logic_Ex_ac\Mode_Logic_Ex.c
) > "%out%\sources_list.txt"

SET rpt_name=%JOBNAME%_Report_%date:~0,2%_%date:~3,2%_%date:~6,4%_%time:~0,2%_%time:~3,2%_%time:~6,2%

"C:\Program Files\Polyspace\R2020a\polyspace\bin\polyspace-bug-finder.exe" -options-file "%OPTSPATH%" -sources-list-file "%SRCPATH%" ^
 -report-template "C:\Program Files\Polyspace\R2020a\toolbox\polyspace\psrptgen\templates\bug_finder\CodingStandards.rpt" ^
 -report-output-format pdf -report-output-name %rpt_name% -results-dir .\testmngt\testresults\misraAnalysis\

git add .\testmngt\testresults\misraAnalysis\Polyspace-Doc\%rpt_name%.pdf



