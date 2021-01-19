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
rootdir = pwd;

datadir = fullfile(rootdir,'data/pilot_1');
p.savefilename = 'processed_data';

load(fullfile(datadir,p.savefilename));

% Rows:
% 1) rt
% 2) response button
% 3) accuracy
% 4-8) related to trial type, but these are already sorted in the structure
plotrow = 1;

sizes = d.results.size(plotrow,:);
sizes_congruent = d.results.size_congruent(plotrow,:);
sizes_congruent_falsefont = d.results.size_congruent_falsefont(plotrow,:);
sizes_congruent_font = d.results.size_congruent_font(plotrow,:);
sizes_incongruent = d.results.size_incongruent(plotrow,:);
sizes_incongruent_falsefont = d.results.size_incongruent_falsefont(plotrow,:);
sizes_incongruent_font = d.results.size_incongruent_font(plotrow,:);

colour = d.results.colour(plotrow,:);
colour_congruent = d.results.colour_congruent(plotrow,:);
colour_congruent_falsefont = d.results.colour_congruent_falsefont(plotrow,:);
colour_congruent_font = d.results.colour_congruent_font(plotrow,:);
colour_incongruent = d.results.colour_incongruent(plotrow,:);
colour_incongruent_falsefont = d.results.colour_incongruent_falsefont(plotrow,:);
colour_incongruent_font = d.results.colour_incongruent_font(plotrow,:);

% boxplot(sizes(1,:))%,'Labels',{'size ff','size norm','colour ff','colour norm'})
x = [1,2];
y = [nanmean(sizes),nanmean(colour)];

plot(x,y,'*')
extend = 10;
axis([0 3 min([y])-extend max([y])+extend]);
hold on
line(x,y)
hold off


for subject = 1:length(d.subjects)
    subj_sizes(subject,:) = d.subjects(subject).results.size(plotrow,:);
    subj_sizes_congruent(subject,:) = d.subjects(subject).results.size_congruent(plotrow,:);
    subj_sizes_congruent_falsefont(subject,:) = d.subjects(subject).results.size_congruent_falsefont(plotrow,:);
    subj_sizes_congruent_font(subject,:) = d.subjects(subject).results.size_congruent_font(plotrow,:);
    subj_sizes_incongruent(subject,:) = d.subjects(subject).results.size_incongruent(plotrow,:);
    subj_sizes_incongruent_falsefont(subject,:) = d.subjects(subject).results.size_incongruent_falsefont(plotrow,:);
    subj_sizes_incongruent_font(subject,:) = d.subjects(subject).results.size_incongruent_font(plotrow,:);

    subj_colour(subject,:) = d.subjects(subject).results.colour(plotrow,:);
    subj_colour_congruent(subject,:) = d.subjects(subject).results.colour_congruent(plotrow,:);
    subj_colour_congruent_falsefont(subject,:) = d.subjects(subject).results.colour_congruent_falsefont(plotrow,:);
    subj_colour_congruent_font(subject,:) = d.subjects(subject).results.colour_congruent_font(plotrow,:);
    subj_colour_incongruent(subject,:) = d.subjects(subject).results.colour_incongruent(plotrow,:);
    subj_colour_incongruent_falsefont(subject,:) = d.subjects(subject).results.colour_incongruent_falsefont(plotrow,:);
    subj_colour_incongruent_font(subject,:) = d.subjects(subject).results.colour_incongruent_font(plotrow,:);
end

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
