function scr = read_NM_Jesusito(infilename)
% Creates a Scores object from information stored in a text file.
% Inputs:
%   infilename: The name of the text file to read.
% Outputs:
%   scr: An object of type Scores constructed from the information in
%     the file.

assert(nargin==1)
assert(isa(infilename,'char'))

fid = fopen(infilename);

modelset = {};
segset = {};
chunk = 1000;
rd = chunk;
%          1 2  3  4  5  6  7  8 9  A  B 
format = '%s%s%*s%*s%*s%*s%*s%*s%s%*s%*s';
header = textscan(fid,format,1);
while rd==chunk
    lines = textscan(fid,format,chunk);
    models = lines{1};
    testsegs = lines{2};
    modelset = union(modelset,models);
    segset = union(segset,testsegs);
    rd = length(models);
end

frewind(fid);
header = textscan(fid,format,1);
scoremask = false(length(modelset),length(segset));
scoremat = inf(size(scoremask));
rd = chunk;
while rd==chunk
    lines = textscan(fid,format,chunk);
    models = lines{1};
    testsegs = lines{2};
    scores = strcmpi('NM3',lines{3});
    
    [dummy,ii] = ismember(models,modelset); 
    [dummy,jj] = ismember(testsegs,segset);

    scoremask(sub2ind(size(scoremask),ii,jj)) = true;
    scoremat(sub2ind(size(scoremat),ii,jj)) = scores;
    
    rd = length(models);
end

fclose(fid);

scr = Scores();
scr.modelset = modelset;
scr.segset = segset;
scr.scoremat = scoremat;
scr.scoremask = scoremask;

assert(scr.validate())

end
