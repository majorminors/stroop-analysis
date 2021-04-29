%% deal with stroopjs data for stats!
% Dorian Minors
% Created: SEP20
%
%
%% set up

close all;
clearvars;
clc;

rootdir = pwd; %% root directory - used to inform directory mappings
datadir = fullfile(rootdir,'data/pilot_1');
filename = 'processed_data';
load(fullfile(datadir,[filename '.mat']));
savefile = fullfile(datadir,[filename '.txt']); %%file name
fid = fopen(savefile,'a');
    
    fprintf(fid, '%s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t \n',...
        'subjectid',...
        'colour congruent',...
        'colour incongruent',...
        'colour congruent falsefont',...
        'colour incongruent falsefont',...
        'colour congruent font',...
        'colour incongruent font',...
        'size congruent',...
        'size incongruent',...
        'size congruent falsefont',...
        'size incongruent falsefont',...
        'size congruent font',...
        'size incongruent font');


% fprintf(fid,'%s \t %s \t %s \t %s \t %s \t %s \t %s \t  %s \t \n',...
%             'subjectid',...
%             'rt',...
%             'accuracy',...
%             'size',...
%             'colour',...
%             'congruency',...
%             'attended feature',...
%             'stimulus type');

for subj = 1:numel(d.subjects)
        fprintf(1, 'working with subject %1.0f\n', subj); % print that so you can check
        
%      t.results.means = [mean(t.results.colour_congruent(1,:),'omitnan'),mean(t.results.colour_incongruent(1,:),'omitnan');mean(t.results.colour_congruent_falsefont(1,:),'omitnan'),mean(t.results.colour_incongruent_falsefont(1,:),'omitnan');mean(t.results.colour_congruent_font(1,:),'omitnan'),mean(t.results.colour_incongruent_font(1,:),'omitnan');mean(t.results.size_congruent(1,:),'omitnan'),mean(t.results.size_incongruent(1,:),'omitnan');mean(t.results.size_congruent_falsefont(1,:),'omitnan'),mean(t.results.size_incongruent_falsefont(1,:),'omitnan');mean(t.results.size_congruent_font(1,:),'omitnan'),mean(t.results.size_incongruent_font(1,:),'omitnan')];
%     disp(t.results.means);
%     
%     t.results.accuracy = [accthis(t.results.colour_congruent(3,:)),accthis(t.results.colour_incongruent(3,:));accthis(t.results.colour_congruent_falsefont(3,:)),accthis(t.results.colour_incongruent_falsefont(3,:));accthis(t.results.colour_congruent_font(3,:)),accthis(t.results.colour_incongruent_font(3,:));accthis(t.results.size_congruent(3,:)),accthis(t.results.size_incongruent(3,:));accthis(t.results.size_congruent_falsefont(3,:)),accthis(t.results.size_incongruent_falsefont(3,:));accthis(t.results.size_congruent_font(3,:)),accthis(t.results.size_incongruent_font(3,:))];
%     disp(t.results.accuracy);
%     
%     t.results.ies = t.results.means./t.results.accuracy;
    
              
              fprintf(fid, '%f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t \n',...
                  subj,...
                  d.subjects(subj).results.ies(1,1),...
                  d.subjects(subj).results.ies(1,2),...
                  d.subjects(subj).results.ies(2,1),...
                  d.subjects(subj).results.ies(2,2),...
                  d.subjects(subj).results.ies(3,1),...
                  d.subjects(subj).results.ies(3,2),...
                  d.subjects(subj).results.ies(4,1),...
                  d.subjects(subj).results.ies(4,2),...
                  d.subjects(subj).results.ies(5,1),...
                  d.subjects(subj).results.ies(5,2),...
                  d.subjects(subj).results.ies(6,1),...
                  d.subjects(subj).results.ies(6,2));

        
%     for trial = 1:numel(d.subjects(subj).testdata.all(1,:))
%     
%     fprintf(fid,'%f \t %f \t %f \t %s \t %s \t %s \t %s \t  %s \t \n',...
%             subj,...
%             d.subjects(subj).testdata.all{1,trial},...
%             d.subjects(subj).testdata.all{3,trial},...
%             d.subjects(subj).testdata.all{4,trial},...
%             d.subjects(subj).testdata.all{5,trial},...
%             d.subjects(subj).testdata.all{6,trial},...
%             d.subjects(subj).testdata.all{7,trial},...
%             d.subjects(subj).testdata.all{8,trial});
% 
%     end; clear trial
    
end

fclose('all');