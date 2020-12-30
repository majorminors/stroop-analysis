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
datadir = fullfile(rootdir,'data/pilot_1');
p.savefilename = 'processed_data';
p.datafilepattern = 'jatos_results_*';
p.keycodes = [1,2,3;49,50,51]; % JS keycode mappings
d.legend = {1,2,3,4;'red','blue','green',NaN;'short','medium','tall',NaN;'congruent','incongruent',NaN,NaN; 'size', 'colour','size_only','colour_only'}; % keep a record of the codes we'll work with

% directory mapping
addpath(genpath(fullfile(rootdir, 'tools'))); % add tools folder to path (don't think we need this, but in case)

save_file = fullfile(datadir, p.savefilename);

%% loop through subjects
d.fileinfo = dir(fullfile(datadir, p.datafilepattern)); % find all the datafiles and get their info
for subject = 1:length(d.fileinfo) % loop through each subject
    t.path = fullfile(datadir, d.fileinfo(subject).name); % get the full path to the file
    fprintf(1, 'working with %s\n', t.path); % print that so you can check
    
    t.alldata = loadjson(t.path); % load in the data
    
    t.id = t.alldata{1}.unique_id; % since we generated unique ids we'll pull these in
    
    % init a couple of counters
    t.testcounter = 0;
    t.traincounter = 0;
    %% loop through trials
    % data is all in a row, so we go through each col and pull the values we want
    for trial = 1:length(t.alldata)
        clear t.current_trial t.curr;
        
        t.current_trial = t.alldata{trial};
        
        % don't worry about unlabelled trials, or fixation trials
        if isfield(t.current_trial, 'exp_part')
            if ~strcmp(t.current_trial.exp_part, 'fixation')
                
                % get rt
                if isempty(t.current_trial.rt)
                    t.curr.rt = 0;
                else
                    t.curr.rt = t.current_trial.rt;
                end
                
                
                %%  this will need to change for vocal
                % get response (convert from JS keycode using p.keycodes
                if isempty(t.current_trial.key_press) % if this isn't empty
                    t.curr.resp = 0;
                else
                    t.curr.resp = p.keycodes(1,find(p.keycodes(2,:) == t.current_trial.key_press));
                end
                
                % get stimulus information
                t.curr.stim_size = convertCharsToStrings(t.current_trial.stim_data.size);
                t.curr.stim_colour = convertCharsToStrings(t.current_trial.stim_data.colour);
                t.curr.stim_print = convertCharsToStrings(t.current_trial.stim_data.print);
                t.curr.congruency = convertCharsToStrings(t.current_trial.stim_data.congruency);
                
                % get test information
                t.curr.test_type = convertCharsToStrings(t.current_trial.test_type);
                
                % consolidate all that data
                % all = cell array complete
                % allcodes = array with numeric codes based on d.legend
                t.curr.all(:,1) = num2cell(t.curr.rt);
                t.curr.allcodes(:,1) = t.curr.rt;
                
                t.curr.all(:,2) = num2cell(t.curr.resp);
                t.curr.allcodes(:,2) = t.curr.resp;
                
                t.curr.all(:,3) = {t.curr.stim_size};
                if strcmp(t.curr.stim_size,d.legend{3,1})
                    t.curr.allcodes(:,3) = 1;
                elseif strcmp(t.curr.stim_size,d.legend{3,2})
                    t.curr.allcodes(:,3) = 2;
                elseif strcmp(t.curr.stim_size,d.legend{3,3})
                    t.curr.allcodes(:,3) = 3;
                end
                
                t.curr.all(:,4) = {t.curr.stim_colour};
                if strcmp(t.curr.stim_colour,d.legend{2,1})
                    t.curr.allcodes(:,4) = 1;
                elseif strcmp(t.curr.stim_colour,d.legend{2,2})
                    t.curr.allcodes(:,4) = 2;
                elseif strcmp(t.curr.stim_colour,d.legend{2,3})
                    t.curr.allcodes(:,4) = 3;
                end
                
                t.curr.all(:,5) = {t.curr.congruency};
                if strcmp(t.curr.congruency,d.legend{4,1})
                    t.curr.allcodes(:,5) = 1;
                elseif strcmp(t.curr.congruency,d.legend{4,2})
                    t.curr.allcodes(:,5) = 2;
                end
                
                t.curr.all(:,6) = {t.curr.test_type};
                if strcmp(t.curr.test_type,d.legend{5,1})
                    t.curr.allcodes(:,6) = 1;
                elseif strcmp(t.curr.test_type,d.legend{5,2})
                    t.curr.allcodes(:,6) = 2;
                elseif strcmp(t.curr.test_type,d.legend{5,3})
                    t.curr.allcodes(:,6) = 3;
                elseif strcmp(t.curr.test_type,d.legend{5,4})
                    t.curr.allcodes(:,6) = 4;
                end
                
                %% load the sorted data according to experiment part
                if strcmp(t.current_trial.exp_part, 'testing') % put test data in one var
                    t.testcounter = t.testcounter+1;

                    t.testdata.all(:,t.testcounter) = t.curr.all;
                    t.testdata.allcodes(:,t.testcounter) = t.curr.allcodes;
                    
                elseif strcmp(t.current_trial.exp_part, 'training') % put training data in another
                    t.traincounter = t.traincounter+1;

                    t.traindata.all(:,t.traincounter) = t.curr.all;
                    t.traindata.allcodes(:,t.traincounter) = t.curr.allcodes;

                end
            end
        end
    end
    
    %% collate the outputs per subject
    d.subjects(subject).id = t.id;
    d.subjects(subject).JSONdata = t.alldata;
    d.subjects(subject).testdata = t.testdata;
    d.subjects(subject).traindata = t.traindata;
    
    %% do some filtering
    t.size_trials = filter_data(d.subjects(subject).testdata.allcodes,'sizes');
    t.congruent_size_trials = filter_data(t.size_trials,'congruent');
    t.incongruent_size_trials = filter_data(t.size_trials,'incongruent');
    [mean(t.congruent_size_trials(1,:)),mean(t.incongruent_size_trials(1,:))]
    
    t.colour_trials = filter_data(d.subjects(subject).testdata.allcodes,'colour');
    t.congruent_colour_trials = filter_data(t.colour_trials,'congruent');
    t.incongruent_colour_trials = filter_data(t.colour_trials,'incongruent');
    [mean(t.congruent_colour_trials(1,:)),mean(t.incongruent_colour_trials(1,:))]
    
end

fprintf('saving output from %s\n', mfilename);
save(save_file,'d'); % save all data to a .mat file

function filtered_data = filter_data(data,filter)
    
    switch filter
        case 'congruent'
            idx = find(data(4,:) == 1); % congruent
        case 'incongruent'
            idx = find(data(4,:) == 2); % incongruent
        case 'sizes'
            idx = find(data(5,:) == 1); % size info
        case 'colour'
            idx = find(data(5,:) == 2); % colour info
    end
    
    filtered_data = data(:,idx);

end