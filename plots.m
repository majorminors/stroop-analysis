%% do plotting
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
if ispc
    rootdir = 'G:\Woolgar-Lab\projects\Dorian\stroop-analysis'
else
    rootdir = '/group/woolgar-lab/projects/Dorian/stroop-analysis'; %% root directory - used to inform directory mappings
end

datadir = fullfile(rootdir,'data/pilot_1');
p.savefilename = 'processed_data';

load(fullfile(datadir,p.savefilename));

sizeff = [];
sizenorm = [];
colourff = [];
colournorm = [];
for subject = 1:length(d.subjects)
    sizeff = [sizeff,d.subjects(subject).results.size_congruent_falsefont(1,:)];
    sizenorm = [sizenorm,d.subjects(subject).results.size_congruent_font(1,:)];
    colourff = [colourff,d.subjects(subject).results.colour_congruent_falsefont(1,:)];
    colournorm = [colournorm,d.subjects(subject).results.colour_congruent_font(1,:)];  
end
sizeff = sizeff';
sizenorm = sizenorm';
colourff = colourff';
colournorm = colournorm';
boxplot([sizeff,sizenorm,colourff,colournorm],'Labels',{'size ff','size norm','colour ff','colour norm'})

% boxplot(sizeff)
% %cols
% cong = 1;
% incong = 2;
% %rows
% colour = 1:3;
% size = 4:6;
% falsefont = [2,5];
% font = [3,6];
% 
% code = 1:6;
% 
% for subject = 1:length(d.subjects)
%     scatter(colour,d.subjects(subject).results.means(colour,cong),[],'green');
%     scatter(colour,d.subjects(subject).results.means(colour,incong),[],'red');
%     hold on
% end
