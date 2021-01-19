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

plotdir = fullfile(datadir,'plots');
if ~exist(plotdir,'dir')
    mkdir(plotdir);
end
addpath(genpath(fullfile(rootdir, 'lib'))); % add libraries to path

load(fullfile(datadir,p.savefilename),'d');
data = d.testdata.allcodes;

% Rows:
% 1) rt
% 2) response button
% 3) accuracy (0,1)
% 4) size (1 = short, 2 = md, 3 = tall)
% 5) colour (1 = red, 2 = blue,3 = green)
% 6) congruency (1 = congruent, 2 = incongruent)
% 7) test type (1 = size trial, 2 = colour trial)
% 8) font type (1 = falsefont, 2 = font)
%filter_data(data,sizing,colour,congruency,trialtype,font)

%% colours
vars(1,:) = filter_data(data,'short',[],'incongruent','colour','font');
vars(2,:) = filter_data(data,'short',[],'incongruent','colour','falsefont');
vars(3,:) = filter_data(data,'medium',[],'incongruent','colour','font');
vars(4,:) = filter_data(data,'medium',[],'incongruent','colour','falsefont');
vars(5,:) = filter_data(data,'tall',[],'incongruent','colour','font');
vars(6,:) = filter_data(data,'tall',[],'incongruent','colour','falsefont');

[fig1,xpoints,means,sem] = make_params(vars);

vars(1,:) = filter_data(data,'short',[],'congruent','colour','font');
vars(2,:) = filter_data(data,'short',[],'congruent','colour','falsefont');
vars(3,:) = filter_data(data,'medium',[],'congruent','colour','font');
vars(4,:) = filter_data(data,'medium',[],'congruent','colour','falsefont');
vars(5,:) = filter_data(data,'tall',[],'congruent','colour','font');
vars(6,:) = filter_data(data,'tall',[],'congruent','colour','falsefont');

[fig2,xpoints,means,sem] = make_params(vars);

%% sizes
vars(1,:) = filter_data(data,'short',[],'incongruent','sizes','font');
vars(2,:) = filter_data(data,'short',[],'incongruent','sizes','falsefont');
vars(3,:) = filter_data(data,'medium',[],'incongruent','sizes','font');
vars(4,:) = filter_data(data,'medium',[],'incongruent','sizes','falsefont');
vars(5,:) = filter_data(data,'tall',[],'incongruent','sizes','font');
vars(6,:) = filter_data(data,'tall',[],'incongruent','sizes','falsefont');

[fig3,xpoints,means,sem] = make_params(vars);

vars(1,:) = filter_data(data,'short',[],[],'sizes','font');
vars(2,:) = filter_data(data,'short',[],[],'sizes','falsefont');
vars(3,:) = filter_data(data,'medium',[],[],'sizes','font');
vars(4,:) = filter_data(data,'medium',[],[],'sizes','falsefont');


vars(1,:) = filter_data(data,[],[],[],'sizes','font');
vars(2,:) = filter_data(data,[],[],[],'sizes','falsefont');
vars(3,:) = filter_data(data,[],[],[],'colour','font');
vars(4,:) = filter_data(data,[],[],[],'colour','falsefont');

[fig4,xpoints,means,sem] = make_params(vars);

% vars(1,:) = filter_data(data,[],'red','incongruent','colour','font');
% vars(2,:) = filter_data(data,[],'red','incongruent','colour','falsefont');
% vars(3,:) = filter_data(data,[],'green','incongruent','colour','font');
% vars(4,:) = filter_data(data,[],'green','incongruent','colour','falsefont');
% vars(5,:) = filter_data(data,[],'blue','incongruent','colour','font');
% vars(6,:) = filter_data(data,[],'blue','incongruent','colour','falsefont');

[xpoints,means,sem] = make_params(vars);



% sizes = d.results.size(1,:);
% sizes_congruent = d.results.size_congruent(1,:);
% sizes_congruent_falsefont = d.results.size_congruent_falsefont(1,:);
% sizes_congruent_font = d.results.size_congruent_font(1,:);
% sizes_incongruent = d.results.size_incongruent(1,:);
% sizes_incongruent_falsefont = d.results.size_incongruent_falsefont(1,:);
% sizes_incongruent_font = d.results.size_incongruent_font(1,:);
% 
% colour = d.results.colour(1,:);
% colour_congruent = d.results.colour_congruent(1,:);
% colour_congruent_falsefont = d.results.colour_congruent_falsefont(1,:);
% colour_congruent_font = d.results.colour_congruent_font(1,:);
% colour_incongruent = d.results.colour_incongruent(1,:);
% colour_incongruent_falsefont = d.results.colour_incongruent_falsefont(1,:);
% colour_incongruent_font = d.results.colour_incongruent_font(1,:);
% 
% % boxplot(sizes(1,:))%,'Labels',{'size ff','size norm','colour ff','colour norm'})
% x = [1,2];
% y = [nanmean(sizes_congruent),nanmean(colour)];
% z = [nansem(sizes),nansem(colour)];
% 
% plot(x,y,'*')
% hold on
% er = errorbar(1:2,y,z);
% extend = 10;
% axis([0 3 min([y])-extend max([y])+extend]);
% hold on
% line(x,y)
% hold off
% 
% 
% for subject = 1:length(d.subjects)
%     subj_sizes(subject,:) = d.subjects(subject).results.size(1,:);
%     subj_sizes_congruent(subject,:) = d.subjects(subject).results.size_congruent(1,:);
%     subj_sizes_congruent_falsefont(subject,:) = d.subjects(subject).results.size_congruent_falsefont(1,:);
%     subj_sizes_congruent_font(subject,:) = d.subjects(subject).results.size_congruent_font(1,:);
%     subj_sizes_incongruent(subject,:) = d.subjects(subject).results.size_incongruent(1,:);
%     subj_sizes_incongruent_falsefont(subject,:) = d.subjects(subject).results.size_incongruent_falsefont(1,:);
%     subj_sizes_incongruent_font(subject,:) = d.subjects(subject).results.size_incongruent_font(1,:);
%     
%     subj_colour(subject,:) = d.subjects(subject).results.colour(1,:);
%     subj_colour_congruent(subject,:) = d.subjects(subject).results.colour_congruent(1,:);
%     subj_colour_congruent_falsefont(subject,:) = d.subjects(subject).results.colour_congruent_falsefont(1,:);
%     subj_colour_congruent_font(subject,:) = d.subjects(subject).results.colour_congruent_font(1,:);
%     subj_colour_incongruent(subject,:) = d.subjects(subject).results.colour_incongruent(1,:);
%     subj_colour_incongruent_falsefont(subject,:) = d.subjects(subject).results.colour_incongruent_falsefont(1,:);
%     subj_colour_incongruent_font(subject,:) = d.subjects(subject).results.colour_incongruent_font(1,:);
% end
