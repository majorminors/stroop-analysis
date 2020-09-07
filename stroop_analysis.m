%% do stroop data
% Dorian Minors
% Created: SEP20
%
% 
%% set up

close all;
clearvars;
clc;

fprintf('setting up %s\n', mfilename);
p = struct(); % keep some of our parameters tidy
d = struct(); % set up a structure for the data info
t = struct(); % set up a structure for temp data

% set up variables
rootdir = '/group/woolgar-lab/projects/Dorian/stroop-analysis'; %% root directory - used to inform directory mappings
datadir = fullfile(rootdir,'data');
p.datafilepattern = 'jatos_results_*';

% directory mapping
addpath(genpath(fullfile(rootdir, 'tools'))); % add tools folder to path (don't think we need this, but in case)

d.fileinfo = dir(fullfile(datadir, p.datafilepattern)); % find all the datafiles and get their info
for i = 1:length(d.fileinfo) % loop through each
  t.path = fullfile(datadir, d.fileinfo(i).name); % get the full path to the file
  fprintf(1, 'working with %s\n', t.path); % print that so you can check
  
  t.alldata = loadjson(t.path); % load in the data
end
