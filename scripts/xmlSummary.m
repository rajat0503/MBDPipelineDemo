function xmlSummary(mdlname,mode,result,respath)

cv = result.CoverageResults;
if strcmp(mode,'Code')
    conCov = conditioninfo(cv(2),mdlname);
    covdata.condition = 100*(conCov(1)/conCov(2));
    decCov = decisioninfo(cv(2),mdlname);
    covdata.decision = 100*(decCov(1)/decCov(2));
    mcdCov = mcdcinfo(cv(2),mdlname);
    covdata.mcdc = 100*(mcdCov(1)/mcdCov(2));
else
    conCov = conditioninfo(cv,mdlname);
    covdata.condition = 100*(conCov(1)/conCov(2));
    decCov = decisioninfo(cv,mdlname);
    covdata.decision = 100*(decCov(1)/decCov(2));
    mcdCov = mcdcinfo(cv,mdlname);
    covdata.mcdc = 100*(mcdCov(1)/mcdCov(2));
end

docNode = com.mathworks.xml.XMLUtils.createDocument('section');

section = docNode.getDocumentElement;
section.setAttribute('name','CoverageInfo')

table = docNode.createElement('table');
section.appendChild(table);
row0 = docNode.createElement('tr');
table.appendChild(row0);

%Create Table Headers
columns = {mode,'Condition','Decision','MCDC'};
for idx = 1:numel(columns)
    curr_nd = docNode.createElement('td');
    curr_nd.setAttribute('value',columns{idx});
    curr_nd.setAttribute('fontattribute','bold');
    curr_nd.setAttribute('align','center');
    curr_nd.setAttribute('width','350');
    row0.appendChild(curr_nd);
end

row1 = docNode.createElement('tr');
table.appendChild(row1);
data = {mdlname,string(covdata.condition),string(covdata.decision),...
    string(covdata.mcdc)};
for idx = 1:numel(data)
    curr_nd = docNode.createElement('td');
    curr_nd.setAttribute('value',data{idx});
    curr_nd.setAttribute('fontattribute','normal');
    curr_nd.setAttribute('align','center');
    curr_nd.setAttribute('width','350');
    row1.appendChild(curr_nd);
end
xmlfile = fullfile(respath,'coverage',strcat(mode,'_covinfo.xml'));
xmlwrite(xmlfile,docNode);

end