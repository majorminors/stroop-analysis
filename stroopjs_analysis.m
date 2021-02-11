%% deal with stroopjs data
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
rootdir = pwd; %% root directory - used to inform directory mappings
datadir = fullfile(rootdir,'data/pilot_1');
p.savefilename = 'processed_data';
p.datafilepattern = 'jatos_results_*';
p.keycodes = [1,2,3;49,50,51]; % JS keycode mappings
d.legend = {1,2,3,4;'red','blue','green',NaN;'short','medium','tall',NaN;'congruent','incongruent',NaN,NaN; 'size', 'colour','size_only','colour_only';'falsefont','font',NaN,NaN}; % keep a record of the codes we'll work with
% make sure this legend is correct per the experiment - we code accuracy on the
% legend, not the experiment

% directory mapping
addpath(genpath(fullfile(rootdir, 'lib'))); % add libraries path

save_file = fullfile(datadir, p.savefilename);

%% loop through subjects
d.fileinfo = dir(fullfile(datadir, p.datafilepattern)); % find all the datafiles and get their info
t.alldata = {};
t.skip_this_dataset = 0;
for file = 1:length(d.fileinfo)
    t.path = fullfile(datadir, d.fileinfo(file).name); % get the full path to the file
    fprintf(1, 'working with %s\n', t.path); % print that so you can check
    
    t.load = loadjson(t.path); % load in the data
    
    if length(t.load) > 1
        dataset = [1,length(t.load(1,:))];
            disp(dataset);
        while (dataset(1) <= dataset(2))
            if isempty(t.load{1,dataset(1)})
                t.load(:,dataset(1)) = [];
                dataset(2) = dataset(2)-1;
                disp(dataset);
            end
            dataset(1) = dataset(1)+1;
        end
    end           

    t.alldata = [t.alldata,t.load]; % concat those into one var, so each subject is a cell
    
end
d.alldata = t.alldata; % save all the data

% init these
d.testdata.all = [];
d.testdata.allcodes = [];
d.traindata.all = [];
d.traindata.allcodes = [];

% init some results - same structure exists for each subject in d.subjects.results
d.results.size = [];
d.results.size_congruent = [];
d.results.size_congruent_falsefont = [];
d.results.size_congruent_font = [];
d.results.size_incongruent = [];
d.results.size_incongruent_falsefont = [];
d.results.size_incongruent_font = [];

d.results.colour = [];
d.results.colour_congruent = [];
d.results.colour_congruent_falsefont = [];
d.results.colour_congruent_font = [];
d.results.colour_incongruent = [];
d.results.colour_incongruent_falsefont = [];
d.results.colour_incongruent_font = [];
    
for subject = 1:length(t.alldata) % loop through each subject
    fprintf(1, 'working with subject %1.0f\n', subject); % print that so you can check

    t.this_subj_data = t.alldata{subject};
    
    t.id = t.this_subj_data{1}.unique_id; % since we generated unique ids we'll pull these in
    
    % init a couple of counters
    t.testcounter = 0;
    t.traincounter = 0;
    %% loop through trials
    % data is all in a row, so we go through each col and pull the values we want
    for trial = 1:length(t.this_subj_data)
        clear t.current_trial t.curr;
        
        t.current_trial = t.this_subj_data{trial};
        
        % let's pull the procedure of the subject (this is actually pushed
        % to the last trial)
        if isfield(t.current_trial, 'procedure')
            t.procedure = cell(2,4);
            for iProc = 1:4 % loop through the four tests
                % index into the procedure variable into the first trial of each test and search the
                % stimulus string for size or colour - the stimulus is an html instruction that tells the participant to pay
                % attention to colour or size, so it should contain those words
               if contains(t.current_trial.procedure{1,iProc}{1,1}.stimulus,'height')
                   t.procedure{1,iProc} = 'size';
               elseif contains(t.current_trial.procedure{1,iProc}{1,1}.stimulus,'colour')
                   t.procedure{1,iProc} = 'colour';
               else
                   error('your code does not catch the procedure type properly')
               end
               
               % now we pull whether it's a false font or not\
               
               for iTrl = 1:length(t.current_trial.procedure{1,iProc})
                   tmp = t.current_trial.procedure{1,iProc}{1,iTrl};
                   if isfield(tmp,'timeline_variables')
                       if contains(tmp.timeline_variables{1,1}.stim_path,'/ff')
                           t.procedure{2,iProc} = 'falsefont';
                       else
                           t.procedure{2,iProc} = 'font';
                       end
                   end
               end; clear tmp 
            end
        end
        
        % don't worry about unlabelled trials, or fixation trials
        if isfield(t.current_trial, 'exp_part')
            if ~strcmp(t.current_trial.exp_part, 'fixation')
                
                % get rt
                if isempty(t.current_trial.rt)
                    t.curr.rt = NaN;
                else
                    t.curr.rt = t.current_trial.rt;
                end
                
                
                %%  this will need to change for vocal
                % get response (convert from JS keycode using p.keycodes
                if isempty(t.current_trial.key_press) % if response is empty
                    t.curr.resp = NaN;
                elseif isempty(p.keycodes(1,find(p.keycodes(2,:) == t.current_trial.key_press))) % else if response is not valid
                    t.curr.resp = t.current_trial.key_press; % save the javascript keycode
                else
                    t.curr.resp = p.keycodes(1,find(p.keycodes(2,:) == t.current_trial.key_press));
                end
                
                % get stimulus information
                t.curr.stim_size = convertCharsToStrings(t.current_trial.stim_data.size);
                t.curr.stim_colour = convertCharsToStrings(t.current_trial.stim_data.colour);
                t.curr.stim_print = convertCharsToStrings(t.current_trial.stim_data.print);
                if startsWith(t.curr.stim_print,'ff')
                    t.curr.stim_type = 'falsefont';
                else
                    t.curr.stim_type = 'font';
                end
                t.curr.congruency = convertCharsToStrings(t.current_trial.stim_data.congruency);
                
                % get test information
                t.curr.test_type = convertCharsToStrings(t.current_trial.test_type);
                
                % consolidate all that data
                % all = cell array complete
                % allcodes = array with numeric codes based on d.legend
                
                % code rt
                t.curr.all(:,1) = num2cell(t.curr.rt);
                t.curr.allcodes(:,1) = t.curr.rt;
                
                % code response button
                t.curr.all(:,2) = num2cell(t.curr.resp);
                t.curr.allcodes(:,2) = t.curr.resp;
                
                % 3 - accuracy calculated during coding of test type
                
                % code stimulus size
                t.curr.all(:,4) = {t.curr.stim_size};
                if strcmp(t.curr.stim_size,d.legend{3,1})
                    t.curr.allcodes(:,4) = 1;
                elseif strcmp(t.curr.stim_size,d.legend{3,2})
                    t.curr.allcodes(:,4) = 2;
                elseif strcmp(t.curr.stim_size,d.legend{3,3})
                    t.curr.allcodes(:,4) = 3;
                end
                
                % code stimulus colour
                t.curr.all(:,5) = {t.curr.stim_colour};
                if strcmp(t.curr.stim_colour,d.legend{2,1})
                    t.curr.allcodes(:,5) = 1;
                elseif strcmp(t.curr.stim_colour,d.legend{2,2})
                    t.curr.allcodes(:,5) = 2;
                elseif strcmp(t.curr.stim_colour,d.legend{2,3})
                    t.curr.allcodes(:,5) = 3;
                end
                
                % code congruency
                t.curr.all(:,6) = {t.curr.congruency};
                if strcmp(t.curr.congruency,d.legend{4,1})
                    t.curr.allcodes(:,6) = 1;
                elseif strcmp(t.curr.congruency,d.legend{4,2})
                    t.curr.allcodes(:,6) = 2;
                end
                
                % code test type (size or colour)
                t.curr.all(:,7) = {t.curr.test_type};
                if strcmp(t.curr.test_type,d.legend{5,1})
                    % size
                    t.curr.allcodes(:,7) = 1;
                elseif strcmp(t.curr.test_type,d.legend{5,2})
                    % coour
                    t.curr.allcodes(:,7) = 2;
                elseif strcmp(t.curr.test_type,d.legend{5,3})
                    % size
                    t.curr.allcodes(:,7) = 3;
                elseif strcmp(t.curr.test_type,d.legend{5,4})
                    %colour
                    t.curr.allcodes(:,7) = 4;
                end

                % code accuracy
                if t.curr.allcodes(:,7) == 1 || t.curr.allcodes(:,7) == 3 && t.curr.resp == t.curr.allcodes(:,4)
                    % if a colour trial and response matches colour code
                    t.curr.accuracy = 1;
                elseif t.curr.allcodes(:,7) == 2 || t.curr.allcodes(:,7) == 4 && t.curr.resp == t.curr.allcodes(:,5)
                    % if a size trial and response matches size code
                    t.curr.accuracy = 1;
                else
                    t.curr.accuracy = 0;
                end
                t.curr.all(:,3) = {t.curr.accuracy};
                t.curr.allcodes(:,3) = t.curr.accuracy;
                
                % code stimulus type (font or falsefont)
                t.curr.all(:,8) = {t.curr.stim_type};
                if strcmp(t.curr.stim_type,d.legend{6,1})
                    t.curr.allcodes(:,8) = 1;
                elseif strcmp(t.curr.stim_type,d.legend{6,2})
                    t.curr.allcodes(:,8) = 2;
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
    d.subjects(subject).procedure = t.procedure;
    d.subjects(subject).JSONdata = t.this_subj_data;
    d.subjects(subject).testdata = t.testdata;
    d.testdata.all = [d.testdata.all,t.testdata.all];
    d.testdata.allcodes = [d.testdata.allcodes,t.testdata.allcodes];
    d.subjects(subject).traindata = t.traindata;
    d.traindata.allcodes = [d.traindata.allcodes,t.traindata.allcodes];
    d.traindata.all = [d.traindata.all,t.traindata.all];
    d.subjects(subject).results = []; % init this
    
    %% do some filtering
    t.results = [];
    
    t.results.size = filter_data(d.subjects(subject).testdata.allcodes,'sizes');
    t.results.size_congruent = filter_data(t.results.size,'congruent');
    t.results.size_congruent_falsefont = filter_data(t.results.size_congruent,'falsefont');
    t.results.size_congruent_font = filter_data(t.results.size_congruent,'font');
    t.results.size_incongruent = filter_data(t.results.size,'incongruent');
    t.results.size_incongruent_falsefont = filter_data(t.results.size_incongruent,'falsefont');
    t.results.size_incongruent_font = filter_data(t.results.size_incongruent,'font');
    
    t.results.colour = filter_data(d.subjects(subject).testdata.allcodes,'colour');
    t.results.colour_congruent = filter_data(t.results.colour,'congruent');
    t.results.colour_congruent_falsefont = filter_data(t.results.colour_congruent,'falsefont');
    t.results.colour_congruent_font = filter_data(t.results.colour_congruent,'font');
    t.results.colour_incongruent = filter_data(t.results.colour,'incongruent');
    t.results.colour_incongruent_falsefont = filter_data(t.results.colour_incongruent,'falsefont');
    t.results.colour_incongruent_font = filter_data(t.results.colour_incongruent,'font');
    
    t.results.means = [mean(t.results.colour_congruent(1,:),'omitnan'),mean(t.results.colour_incongruent(1,:),'omitnan');mean(t.results.colour_congruent_falsefont(1,:),'omitnan'),mean(t.results.colour_incongruent_falsefont(1,:),'omitnan');mean(t.results.colour_congruent_font(1,:),'omitnan'),mean(t.results.colour_incongruent_font(1,:),'omitnan');mean(t.results.size_congruent(1,:),'omitnan'),mean(t.results.size_incongruent(1,:),'omitnan');mean(t.results.size_congruent_falsefont(1,:),'omitnan'),mean(t.results.size_incongruent_falsefont(1,:),'omitnan');mean(t.results.size_congruent_font(1,:),'omitnan'),mean(t.results.size_incongruent_font(1,:),'omitnan')];
    disp(t.results.means);
    
    t.results.accuracy = [accthis(t.results.colour_congruent(3,:)),accthis(t.results.colour_incongruent(3,:));accthis(t.results.colour_congruent_falsefont(3,:)),accthis(t.results.colour_incongruent_falsefont(3,:));accthis(t.results.colour_congruent_font(3,:)),accthis(t.results.colour_incongruent_font(3,:));accthis(t.results.size_congruent(3,:)),accthis(t.results.size_incongruent(3,:));accthis(t.results.size_congruent_falsefont(3,:)),accthis(t.results.size_incongruent_falsefont(3,:));accthis(t.results.size_congruent_font(3,:)),accthis(t.results.size_incongruent_font(3,:))];
    disp(t.results.accuracy);
    
    t.results.overview = [mean(d.subjects(subject).testdata.allcodes(1,:));accthis(d.subjects(subject).testdata.allcodes(3,:))];
    
    d.subjects(subject).results = t.results;
    d.results.size = [d.results.size, t.results.size];
    d.results.size_congruent = [d.results.size_congruent, t.results.size_congruent];
    d.results.size_congruent_falsefont = [d.results.size_congruent_falsefont,t.results.size_congruent_falsefont];
    d.results.size_congruent_font = [d.results.size_congruent_font, t.results.size_congruent_font];
    d.results.size_incongruent = [d.results.size_incongruent,t.results.size_incongruent];
    d.results.size_incongruent_falsefont = [d.results.size_incongruent_falsefont,t.results.size_incongruent_falsefont];
    d.results.size_incongruent_font = [d.results.size_incongruent_font,t.results.size_incongruent_font];
    
    d.results.colour = [d.results.colour,t.results.colour];
    d.results.colour_congruent = [d.results.colour_congruent,t.results.colour_congruent];
    d.results.colour_congruent_falsefont = [d.results.colour_congruent_falsefont, t.results.colour_congruent_falsefont];
    d.results.colour_congruent_font = [d.results.colour_congruent_font, t.results.colour_congruent_font];
    d.results.colour_incongruent = [d.results.colour_incongruent, t.results.colour_incongruent];
    d.results.colour_incongruent_falsefont = [d.results.colour_incongruent_falsefont,t.results.colour_incongruent_falsefont];
    d.results.colour_incongruent_font = [d.results.colour_incongruent_font,t.results.colour_incongruent_font];
    
end

fprintf('saving output from %s\n', mfilename);
save(save_file,'d'); % save all data to a .mat file

function filtered_data = filter_data(data,filter)
    
    switch filter
        case 'congruent'
            idx = find(data(6,:) == 1); % congruent
        case 'incongruent'
            idx = find(data(6,:) == 2); % incongruent
        case 'sizes'
            idx = find(data(7,:) == 1); % size info
        case 'colour'
            idx = find(data(7,:) == 2); % colour info
        case 'falsefont'
            idx = find(data(8,:) == 1); % print info
        case 'font'
            idx = find(data(8,:) == 2); % print info
    end
    
    filtered_data = data(:,idx);

end

function accuracy = accthis(data)
    accuracy = sum(data)/length(data);
end
