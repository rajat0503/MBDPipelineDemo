import matlab.unittest.TestRunner % Package for running test suite 
import matlab.unittest.plugins.TAPPlugin
import matlab.unittest.plugins.ToFile
import matlab.unittest.plugins.XMLPlugin
import sltest.plugins.ModelCoveragePlugin
import sltest.plugins.coverage.CoverageMetrics
import sltest.plugins.coverage.ModelCoverageReport
import matlab.unittest.plugins.codecoverage.CoberturaFormat


try
    sltest.testmanager.clearResults;
    sltest.testmanager.clear;
    siltfpath = fullfile(proj.RootFolder,'/testmngt/Mode_Logic_B2B.mldatx');
    miltfpath = fullfile(proj.RootFolder,'/testmngt/Mode_Logic_TC.mldatx');
        
    if strcmp(jobName,'SIL')
        mode = 'Code';
        %Generate SIL Test File
        if isfile(siltfpath)
            delete(siltfpath);
        end
        mtf = sltest.testmanager.TestFile(miltfpath);       
        stf = sltest.testmanager.TestFile(siltfpath);
        remove(stf.getTestSuites());
        cov = getCoverageSettings(stf);
        cov.RecordCoverage = true;
        cov.MetricSettings = "dcm";
        % Copy testsuite from MIL file to B2B file
        tsMIL = mtf.getTestSuiteByName('Mode_Logic_MIL');
        tsSIL = sltest.testmanager.copyTests(tsMIL,stf);
        close(mtf);
        tsSIL.Name = 'B2B_Tests';
        tc = tsSIL.getTestCases;
        for ii = 1:length(tc)
            tc(ii).convertTestType(sltest.testmanager.TestCaseTypes.Equivalence)
            tc(ii).setProperty('SimulationMode','Normal','SimulationIndex',1)
            tc(ii).setProperty('SimulationMode','' ,'SimulationIndex',2)
            tc(ii).setProperty('OverrideSILPILMode',false,'SimulationIndex',2)
            % Capture equivalence criteria
            %eq(ii) = captureEquivalenceCriteria(tc(ii));
        end
        saveToFile(stf);
        addFile(proj,siltfpath);
        close(stf);
        tf = sltest.testmanager.TestFile(siltfpath);
        resPath = fullfile(proj.RootFolder,'/testmngt/testresults/B2B/');
    else
        mode = 'Model';
        tf = sltest.testmanager.TestFile(miltfpath);
        resPath = fullfile(proj.RootFolder,'/testmngt/testresults/MIL/');
    end
   

         
    suite = testsuite(tf.FilePath); %Use SLTEST testman.mldatx file to create testsuite
   
    covPath = fullfile(resPath,'coverage');
    if ~isfolder(covPath)
        mkdir(covPath)
    end
        
    tapPath = fullfile(resPath,'tapResults');
    if ~isfolder(tapPath)
        mkdir(tapPath)
    end
    if strcmp(mode,'Code')
        tapResultsFile = fullfile(tapPath,'B2B_TAPResults.tap');
        xmlResultsFile = fullfile(tapPath,'B2B_myTestResults.xml');
        covRptfile = fullfile(covPath,[mode,'_Cobertura_Cov.xml']);
    else
        tapResultsFile = fullfile(tapPath,'MIL_TAPResults.tap');
        xmlResultsFile = fullfile(tapPath,'MIL_myTestResults.xml');
        covRptfile = fullfile(covPath,[mode,'_Cobertura_Cov.xml']);
    end
    
    %Delete Older Tap Results if any%
    if isfile(tapResultsFile)
        delete(tapResultsFile);
    end
    
    rpt = CoberturaFormat(covRptfile);
 
    p = XMLPlugin.producingJUnitFormat(xmlResultsFile);
 
    runner = TestRunner.withTextOutput;
    mcr = ModelCoverageReport(covPath);
    mcdcMet = CoverageMetrics('Decision',true,'Condition',true,'MCDC',true);
    covSettings = ModelCoveragePlugin('RecordModelReferenceCoverage',true,...
                     'Collecting',mcdcMet,'Producing',rpt);
    
    runner.addPlugin(TAPPlugin.producingVersion13(ToFile(tapResultsFile),'IncludingPassingDiagnostics',true','Verbosity',3));
    runner.addPlugin(p);
    runner.addPlugin(covSettings);
      

    results = runner.run(suite);
    display(results);
    %Save Results%
    resTM = sltest.testmanager.getResultSets;
    %Save Coverage Report%
    cv = resTM.getCoverageResults; 
    totalFailure = sum(vertcat(results(:).Failed));
    if strcmp(mode,'Code')
        cvhtml(fullfile(covPath,strcat(mode,'_Coverage.html')),cv(2));
    else
        cvhtml(fullfile(covPath,strcat(mode,'_Coverage.html')),cv)
    end
    %Call XML Summary%
    xmlSummary('Mode_Logic_Ex',mode,resTM,resPath)
    sltest.testmanager.exportResults(resTM,strcat(resPath,jobName,'_results.mldatx'));
    
    %Generate Report
    %repRes = sltest.testmanager.importResults(strcat(resPath,jobName,'_results.mldatx'));
    %filePath = fullfile(resPath,[jobName,'_Verification_Report.pdf']);
    %if ~isfile(filePath)
        %Do Nothing and Jump Out    
    %else
    %    disp('Older File Result file will be deleted');
    %    delete(filePath);
    %end
    %sltest.testmanager.report(repRes,filePath,...
	%'Author',['Executed for ',getenv('USERNAME'),' by Jenkins'],...
	%'Title',[jobName,' Verification Report'],...
	%'IncludeMLVersion',true,...
	%'IncludeTestResults',0,...
    %'IncludeSimulationSignalPlots',true,...
    %'IncludeComparisonSignalPlots',true,...
    %'IncludeCoverageResult',true);
    %%Add Files and Project to Project
    addFolderIncludingChildFiles(proj,covPath);
    addFolderIncludingChildFiles(proj,tapPath);
    addFile(proj,strcat(resPath,jobName,'_results.mldatx'));
    %addFile(proj,strcat(resPath,jobName,'_Verification_Report.pdf'));
    %addFile(proj,strcat(resPath,jobName,'_Verification_Report.pdf'));
    addFile(proj,strcat(resPath,['coverage\',mode,'_covinfo.xml']));
    addFile(proj,strcat(covPath,['\',mode,'_Coverage.html']))
    addFile(proj,strcat(covPath,['\',mode,'_Cobertura_Cov.xml']))
    % Clear test file and results from Test Manager
    close(tf);
    sltest.testmanager.clearResults;
    sltest.testmanager.clear;

    % Close Test Manager
    
    sltest.testmanager.close;
    

catch e
    disp(getReport(e, 'extended'));
end
exit(totalFailure>0)
