function ensemble2_mix_2(cover_features_path_1,cover_features_path_2, ...
                       stego_features_path_1, ...
                       stego_features_path_2, ...
                       log_dir,repeated_times, ...
                       train_samples_percent,init_seed,d_sub)
%% C1-C2-S1-S2
    if nargin<4+2
        repeated_times=10;
    end
    if nargin<5+2
        train_samples_percent=0.5;
    end
    if nargin<6+2
        init_seed=1836;
    end
    if nargin<7+2
        %d_sub=2000;
        % 赋值为0，意味着如果没有指定d_sub，那么就不设定d_sub
        d_sub=0;                       
    end
    
    [features_dir, cover_features_name_1, ext]=fileparts(cover_features_path_1);
    [features_dir, cover_features_name_2, ext]=fileparts(cover_features_path_2);
    [features_dir, stego_features_name_1, ext]=fileparts(stego_features_path_1);
    [features_dir, stego_features_name_2, ext]=fileparts(stego_features_path_2);
    % log
    log_file = fullfile(log_dir, [cover_features_name_1 '_and_' cover_features_name_2 '_vs_' ...
                        stego_features_name_1 '_and_' stego_features_name_2 '_r' num2str(repeated_times) ...
                        '.log']);
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
    stego_1=load(stego_features_path_1);
    stego_2=load(stego_features_path_2);
    
    names_c = intersect(cover_1.names,cover_2.names);
    names_s = intersect(stego_1.names,stego_2.names);
    names = intersect(names_c, names_s);
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
        TRN_cover = [C1(training_set,:); C2(training_set,:)];
        TRN_stego = [S1(training_set,:); S2(training_set,:)];
        
        % Prepare testing features
        TST_cover = [C1(testing_set,:) C2(testing_set,:)];
        TST_stego = [S1(testing_set,:) S2(testing_set,:)];
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
