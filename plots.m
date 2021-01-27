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
%plot([1 1]*1.5, ylim, '--k')                % vertical line at ‘x=1.5’
%plot(xlim, [1 1]*1.5, '--k')                % horizontal line at ‘y=1.5’

% is our stroop working:
% are incongruent trials slower than congruent trials in the stroop (colour-font) task?
clear vars;
vars(1,:) = filter_data(data,[],[],'congruent','colour','font');
vars(2,:) = filter_data(data,[],[],'incongruent','colour','font');
make_params(vars,'means'); % yes they are

% is our colour baseline working:
% are colour baseline (falsefont-colour) trials similar across both congruent and incongruent trials
% and somewhere between stroop (colour-font) congruent and incongruent trials?
clear vars;
vars(1,:) = filter_data(data,[],[],'congruent','colour','font');
vars(2,:) = filter_data(data,[],[],'congruent','colour','falsefont');
vars(3,:) = filter_data(data,[],[],'incongruent','colour','falsefont');
vars(4,:) = filter_data(data,[],[],'incongruent','colour','font');
make_params(vars,'means'); % kind of? seems like there might be an effect of incongruency though...

% is there an effect of size (visualisation - though we should quantify)

% does the size task work as a word baseline?
% if so there should be no effect of congruency
clear vars;
vars(1,:) = filter_data(data,[],[],'congruent','sizes','falsefont');
vars(2,:) = filter_data(data,[],[],'incongruent','sizes','falsefont');
vars(3,:) = filter_data(data,[],[],'congruent','sizes','font');
vars(4,:) = filter_data(data,[],[],'incongruent','sizes','font');
make_params(vars,'means',1); % looks good, though fonts appear to interfere
plot([1 1]*2.5, ylim, '--k'); hold off

% performance should be worse for colour naming during incongruent trials
% than size naming
clear vars;
vars(1,:) = filter_data(data,[],[],'congruent','colour','font');
vars(2,:) = filter_data(data,[],[],'incongruent','colour','font');
vars(3,:) = filter_data(data,[],[],'congruent','sizes','font');
vars(4,:) = filter_data(data,[],[],'incongruent','sizes','font');
% make_params(vars,'means'); % yep!
% % but this shouldn't be true during false font trials
% clear vars;
vars(5,:) = filter_data(data,[],[],'congruent','colour','falsefont');
vars(6,:) = filter_data(data,[],[],'incongruent','colour','falsefont');
vars(7,:) = filter_data(data,[],[],'congruent','sizes','falsefont');
vars(8,:) = filter_data(data,[],[],'incongruent','sizes','falsefont');
make_params(vars,'means',1); % almost, but there appears to be an effect of incongruency in the colour baseline!
plot([1 1]*2.5, ylim, ':k');
plot([1 1]*6.5, ylim, ':k');
plot([1 1]*4.5, ylim, '--k'); hold off

% lets look at this congruency effect in the false font
clear vars;
vars(1,:) = filter_data(data,[],[],'congruent','colour','falsefont');
vars(2,:) = filter_data(data,[],[],'incongruent','colour','falsefont');
make_params(vars,'means');
clear vars;
vars(1,:) = filter_data(data,[],'red','congruent','colour','falsefont');
vars(2,:) = filter_data(data,[],'blue','congruent','colour','falsefont');
vars(3,:) = filter_data(data,[],'green','congruent','colour','falsefont');
vars(4,:) = filter_data(data,[],'red','incongruent','colour','falsefont');
vars(5,:) = filter_data(data,[],'blue','incongruent','colour','falsefont');
vars(6,:) = filter_data(data,[],'green','incongruent','colour','falsefont');
make_params(vars,'means',1); % could be incongruent blue, but mostly driven by incongruent green!
plot(xlim, [1 1]*715, ':k');
plot([1 1]*3.5, ylim, '--k'); hold off

% lets look at this difference in font/falsefont across size conditions
clear vars;
vars(1,:) = filter_data(data,[],[],'congruent','sizes','falsefont');
vars(2,:) = filter_data(data,[],[],'incongruent','sizes','falsefont');
vars(3,:) = filter_data(data,[],[],'congruent','sizes','font');
vars(4,:) = filter_data(data,[],[],'incongruent','sizes','font');
make_params(vars,'means',1);
plot([1 1]*2.5, ylim, '--k'); hold off
clear vars;
vars(1,:) = filter_data(data,'short',[],'congruent','sizes','falsefont');
vars(2,:) = filter_data(data,'medium',[],'congruent','sizes','falsefont');
vars(3,:) = filter_data(data,'tall',[],'congruent','sizes','falsefont');
vars(4,:) = filter_data(data,'short',[],'incongruent','sizes','falsefont');
vars(5,:) = filter_data(data,'medium',[],'incongruent','sizes','falsefont');
vars(6,:) = filter_data(data,'tall',[],'incongruent','sizes','falsefont');
vars(7,:) = filter_data(data,'short',[],'congruent','sizes','font');
vars(8,:) = filter_data(data,'medium',[],'congruent','sizes','font');
vars(9,:) = filter_data(data,'tall',[],'congruent','sizes','font');
vars(10,:) = filter_data(data,'short',[],'incongruent','sizes','font');
vars(11,:) = filter_data(data,'medium',[],'incongruent','sizes','font');
vars(12,:) = filter_data(data,'tall',[],'incongruent','sizes','font');
make_params(vars,'means',1); % shorts are pulling false fonts down, mediums are pulling fonts up
plot([1 1]*3.5, ylim, ':k');
plot([1 1]*9.5, ylim, ':k');
%plot(xlim, [1 1]*710, ':k');
plot([1 1]*6.5, ylim, '--k'); hold off






