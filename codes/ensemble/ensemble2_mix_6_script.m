er=num2str(40);
cover_features_path_1=['../../data/PPG/LAN2/BOSS_PPG_LAN2_CRM.mat'];
cover_features_path_2=['../../data/PPG/BIL/BOSS_PPG_BIL_CRM.mat'];
cover_features_path_3=['../../data/PPG/BIC/BOSS_PPG_BIC_CRM.mat'];

stego_features_path_1=['../../data/PPG/LAN2/HILL_CMD_C/error/' ...
            'BOSS_PPG_LAN2_HILLCMDC_' er '_CRM.mat'];
stego_features_path_2=['../../data/PPG/BIL/HILL_CMD_C/' ...
            'BOSS_PPG_BIL_HILLCMDC_' er '_CRM.mat'];
stego_features_path_3=['../../data/PPG/BIC/HILL_CMD_C/' ...
            'BOSS_PPG_BIC_HILLCMDC_' er '_CRM.mat'];
cover_features_path_4=['../../data/AHD/LAN2/BOSS_AHD_LAN2_CRM.mat'];
cover_features_path_5=['../../data/AHD/BIL/BOSS_AHD_BIL_CRM.mat'];
cover_features_path_6=['../../data/AHD/BIC/BOSS_AHD_BIC_CRM.mat'];

stego_features_path_4=['../../data/AHD/LAN2/HILL_CMD_C/' ...
            'BOSS_AHD_LAN2_HILLCMDC_' er '_CRM.mat'];
stego_features_path_5=['../../data/AHD/BIL/HILL_CMD_C/' ...
            'BOSS_AHD_BIL_HILLCMDC_' er '_CRM.mat'];
stego_features_path_6=['../../data/AHD/BIC/HILL_CMD_C/' ...
            'BOSS_AHD_BIC_HILLCMDC_' er '_CRM.mat'];

log_dir='../../log/ensemble2/mix/';
repeated_times=1;

train_samples_percent=0.5;
init_seed=1836;
d_sub=0;                       

[features_dir, cover_features_name_1, ext]=fileparts(cover_features_path_1);
[features_dir, cover_features_name_2, ext]=fileparts(cover_features_path_2);
[features_dir, cover_features_name_3, ext]=fileparts(cover_features_path_3);
[features_dir, cover_features_name_4, ext]=fileparts(cover_features_path_4);
[features_dir, cover_features_name_5, ext]=fileparts(cover_features_path_5);
[features_dir, cover_features_name_6, ext]=fileparts(cover_features_path_6);
[features_dir, stego_features_name_1, ext]=fileparts(stego_features_path_1);
[features_dir, stego_features_name_2, ext]=fileparts(stego_features_path_2);
[features_dir, stego_features_name_3, ext]=fileparts(stego_features_path_3);
[features_dir, stego_features_name_4, ext]=fileparts(stego_features_path_4);
[features_dir, stego_features_name_5, ext]=fileparts(stego_features_path_5);
[features_dir, stego_features_name_6, ext]=fileparts(stego_features_path_6);
% log
%log_file = fullfile(log_dir, [cover_features_name_1 '_and_' ...
%                        cover_features_name_2 '_and_' cover_features_name_3 ...
%                        '_and_' cover_features_name_4 '_and_' ...
%                        cover_features_name_5 '_and_' ...
%                        cover_features_name_6 '_vs_' stego_features_name_1 ...
%                        '_and_' stego_features_name_2 '_and_' ...
%                        stego_features_name_3 '_and_' stego_features_name_4 ...
%                        '_and_' stego_features_name_5 '_and_' ...
%                        stego_features_name_6 '_r' num2str(repeated_times) ...
%                        '.log']);
log_file = fullfile(log_dir, [cover_features_name_1 '_vs_' ...
                    stego_features_name_1 '_r' num2str(repeated_times) ...
                    '_all.log']);
if exist(log_file, 'file') ~= 0
    fprintf('%s existed.\n', log_file);
    return
end
log_file_id=fopen(log_file, 'w');
fprintf('%s\n',fullfile(log_dir, ...
                        [cover_features_name_1 '_vs_' ...
                    stego_features_name_1 ...
                    '_r' num2str(repeated_times) ...
                    '.log']));
fprintf('%d\n', log_file_id);

cover_1=load(cover_features_path_1);
cover_2=load(cover_features_path_2);
cover_3=load(cover_features_path_3);
cover_4=load(cover_features_path_4);
cover_5=load(cover_features_path_5);
cover_6=load(cover_features_path_6);
stego_1=load(stego_features_path_1);
stego_2=load(stego_features_path_2);
stego_3=load(stego_features_path_3);
stego_4=load(stego_features_path_4);
stego_5=load(stego_features_path_5);
stego_6=load(stego_features_path_6);

names_c_1 = intersect(intersect(cover_1.names,cover_2.names), cover_3.names);
names_c_2 = intersect(intersect(cover_4.names,cover_5.names), cover_6.names);
names_s_1 = intersect(intersect(stego_1.names,stego_2.names), stego_3.names);
names_s_2 = intersect(intersect(stego_4.names,stego_5.names), stego_6.names);
names = intersect(intersect(names_c_1, names_c_2), intersect(names_s_1,names_s_2));
names = sort(names);

% Prepare cover features C1
cover_names = cover_1.names(ismember(cover_1.names,names));
[cover_names,ix] = sort(cover_names);
C1 = cover_1.F(ismember(cover_1.names,names),:);
C1 = C1(ix,:);

% Prepare cover features C2
cover_names = cover_2.names(ismember(cover_2.names,names));
[cover_names,ix] = sort(cover_names);
C2 = cover_2.F(ismember(cover_2.names,names),:);
C2 = C2(ix,:);

% Prepare cover features C3
cover_names = cover_3.names(ismember(cover_3.names,names));
[cover_names,ix] = sort(cover_names);
C3 = cover_3.F(ismember(cover_3.names,names),:);
C3 = C3(ix,:);

% Prepare cover features C4
cover_names = cover_1.names(ismember(cover_1.names,names));
[cover_names,ix] = sort(cover_names);
C4 = cover_1.F(ismember(cover_1.names,names),:);
C4 = C4(ix,:);

% Prepare cover features C5
cover_names = cover_2.names(ismember(cover_2.names,names));
[cover_names,ix] = sort(cover_names);
C5 = cover_2.F(ismember(cover_2.names,names),:);
C5 = C5(ix,:);

% Prepare cover features C6
cover_names = cover_3.names(ismember(cover_3.names,names));
[cover_names,ix] = sort(cover_names);
C6 = cover_3.F(ismember(cover_3.names,names),:);
C6 = C6(ix,:);

% Prepare stego features S1
stego_names = stego_1.names(ismember(stego_1.names,names));
[stego_names,ix] = sort(stego_names);
S1 = stego_1.F(ismember(stego_1.names,names),:);
S1 = S1(ix,:);

% Prepare stego features S2
stego_names = stego_2.names(ismember(stego_2.names,names));
[stego_names,ix] = sort(stego_names);
S2 = stego_2.F(ismember(stego_2.names,names),:);
S2 = S2(ix,:);

% Prepare stego features S3
stego_names = stego_3.names(ismember(stego_3.names,names));
[stego_names,ix] = sort(stego_names);
S3 = stego_3.F(ismember(stego_3.names,names),:);
S3 = S3(ix,:);

% Prepare stego features S4
stego_names = stego_1.names(ismember(stego_1.names,names));
[stego_names,ix] = sort(stego_names);
S4 = stego_1.F(ismember(stego_1.names,names),:);
S4 = S4(ix,:);

% Prepare stego features S5
stego_names = stego_2.names(ismember(stego_2.names,names));
[stego_names,ix] = sort(stego_names);
S5 = stego_2.F(ismember(stego_2.names,names),:);
S5 = S5(ix,:);

% Prepare stego features S6
stego_names = stego_3.names(ismember(stego_3.names,names));
[stego_names,ix] = sort(stego_names);
S6 = stego_3.F(ismember(stego_3.names,names),:);
S6 = S6(ix,:);

fprintf('\n\n-----------------------------------------\n');
fprintf('%s vs. %s:\n', ...
        cover_features_name_1,stego_features_name_1);
testing_errors = zeros(1,repeated_times);
training_time = zeros(1,repeated_times);
for seed=init_seed:init_seed+repeated_times-1
    tic;
    % PRNG initialization with init_seed 
    RandStream.setGlobalStream(RandStream('mt19937ar','Seed',seed));
    % Division into training/testing set
    random_permutation = randperm(size(C1,1));
    training_set = random_permutation(1:round(size(C1,1)*train_samples_percent));
    testing_set = random_permutation(round(size(C1,1)*train_samples_percent)+1:end);
    training_names = names(training_set);
    testing_names = names(testing_set);
    
    % Prepare training features
    TRN_cover = [C1(training_set,:); C2(training_set,:); ...
                 C3(training_set,:); C4(training_set,:); ...
                 C5(training_set,:); C6(training_set,:)];
    TRN_stego = [S1(training_set,:); S2(training_set,:); ...
                 S3(training_set,:); S4(training_set,:); ...
                 S5(training_set,:); S6(training_set,:)];
    
    % Prepare testing features
    TST_cover = [C1(testing_set,:); C2(testing_set,:); ...
                 C3(testing_set,:); C4(testing_set,:); ...
                 C5(testing_set,:); C6(testing_set,:)];
    TST_stego = [S1(testing_set,:); S2(testing_set,:); ...
                 S3(testing_set,:); S4(testing_set,:); ...
                 S5(testing_set,:); S6(testing_set,:)];
    %        switch (classfier_type)
    %          case 'ensemble'
    if d_sub>0
        settings=struct('d_sub',d_sub, ...
                        'seed_subspaces',seed, ...
                        'seed_bootstrap',seed, ...
                        'verbose',0);
    else
        settings=struct('seed_subspaces',seed, ...
                        'seed_bootstrap',seed, ...
                        'verbose',2);
    end
    [trained_ensemble,results] =  ...
        ensemble_training(TRN_cover,TRN_stego,settings);
    
    % Testing phase - we can conveniently test on cover and stego features
    % separately
    test_results_cover = ensemble_testing(TST_cover,trained_ensemble);
    test_results_stego = ensemble_testing(TST_stego,trained_ensemble);
    
    % Predictions: -1 stands for cover, +1 for stego
    false_alarms = sum(test_results_cover.predictions~=-1);
    missed_detections = sum(test_results_stego.predictions~=+1);
    num_testing_samples = size(TST_cover,1)+size(TST_stego,1);
    testing_errors(seed-init_seed+1) = ...
        (false_alarms + missed_detections)/num_testing_samples;
    
    t=toc;
    training_time(seed-init_seed+1)=t;
    fprintf('Testing error %i: %.4f\n', ...
            seed,testing_errors(seed-init_seed+1));
    fprintf(log_file_id,'Testing error %i: %.4f\n', ...
            seed,testing_errors(seed-init_seed+1));
    fprintf(log_file_id,['Time for ensemble %i: %.4f hours \n'],seed, t/3600);
end
fprintf(log_file_id,['Average time over %d splits for ensemble: %.4f hours \n'],repeated_times, mean(training_time)/3600);
fprintf(['-----------\n' ...
         'Average testing error over %d splits: ' ...
         '%.4f (+/- %.4f)\n'], ...
        repeated_times,mean(testing_errors),std(testing_errors));
fprintf(log_file_id,['-----------\n' ...
                    'Average testing error over %d splits: ' ...
                    '%.4f (+/- %.4f)\n'], ...
        repeated_times,mean(testing_errors),std(testing_errors));
fclose(log_file_id);
