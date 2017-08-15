function f_ensemble2_multiple_times(cover_features_path,stego_features_path,log_dir,classfier_type,repeated_times,train_samples_percent,init_seed,d_sub)

    if nargin<5
        repeated_times=10;
    end
    if nargin<6
        train_samples_percent=0.5;
    end
    if nargin<7
        init_seed=1836;
    end
    if nargin<8
        %d_sub=2000;
        % 赋值为0，意味着如果没有指定d_sub，那么就不设定d_sub
        d_sub=0;                       
    end
    
    [features_dir, cover_features_name, ext]=fileparts(cover_features_path);
    [features_dir, stego_features_name, ext]=fileparts(stego_features_path);
    % log
    log_file_id=fopen(fullfile(log_dir, ...
                               [cover_features_name '_vs_' ...
                        stego_features_name ...
                        '_r' num2str(repeated_times) ...
                        '.log']),'w');
    
    cover=load(cover_features_path);
    stego=load(stego_features_path);
    
    names = intersect(cover.names,stego.names);
    names = sort(names);

    % Prepare cover features C
    cover_names = cover.names(ismember(cover.names,names));
    [cover_names,ix] = sort(cover_names);
    C = cover.F(ismember(cover.names,names),:);
    C = C(ix,:);

    % Prepare stego features S
    stego_names = stego.names(ismember(stego.names,names));
    [stego_names,ix] = sort(stego_names);
    S = stego.F(ismember(stego.names,names),:);
    S = S(ix,:);
    %LCLSRM classfier
    switch (classfier_type)
      case 'LCLSRM'
        D=size(C,2);
        varC = var(C,1);
        remove = false(1,D);
        adepts = unique([find(C(1,:)==C(2,:)) find(S(1,:)==S(2,:))]);
        for ad_id = adepts
            U1=unique(C(:,ad_id));
            if numel(U1)==1
                U2=unique(S(:,ad_id));
                if numel(U2)==1, if U1==U2, remove(ad_id) = true; end; end
            end
        end
        % and also check for NaN values (may occur when the feature value is 
        % constant over images)
        nan_values = (isnan(varC))>0;
        remove = nan_values | remove;
        C = C(:,~remove);
        S = S(:,~remove);
        clear varC;
    end
    
    fprintf('\n\n-----------------------------------------\n');
    fprintf('%s vs. %s:\n', ...
            cover_features_name,stego_features_name);
    fprintf(log_file_id,'\n\n-----------------------------------------\n');
    fprintf(log_file_id,'%s vs. %s:\n', ...
            cover_features_name,stego_features_name);
    testing_errors = zeros(1,repeated_times);
    training_time = zeros(1,repeated_times);
    for seed=init_seed:init_seed+repeated_times-1
        tic;
        % PRNG initialization with init_seed 
        RandStream.setGlobalStream(RandStream('mt19937ar','Seed',seed));
        % Division into training/testing set
        random_permutation = randperm(size(C,1));
        training_set = random_permutation(1:20000);%round(size(C,1)* ...
                                                  %train_samples_percent));
        testing_set = random_permutation(20001:39523);%(round(size(C,1)* ...
                                                      %train_samples_percent)+1:end);
        training_names = names(training_set);
        testing_names = names(testing_set);
    
        % Prepare training features
        TRN_cover = C(training_set,:);
        TRN_stego = S(training_set,:);

        % Prepare testing features
        TST_cover = C(testing_set,:);
        TST_stego = S(testing_set,:);
        switch (classfier_type)
          case 'ensemble'
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
            
          case 'LCLSRM'
            [ Results ] = LCLSMR ( TRN_cover, TRN_stego, TST_cover, ...
                                   TST_stego, true);
            testing_errors(seed-init_seed+1)=Results.PE;
        end
        t=toc;
        training_time(seed-init_seed+1)=t;
        fprintf('Testing error %i: %.4f\n', ...
                seed,testing_errors(seed-init_seed+1));
        fprintf(log_file_id,'Testing error %i: %.4f\n', ...
                seed,testing_errors(seed-init_seed+1));
        fprintf(log_file_id,['Time for ensemble %i: %.4f hours \n'],seed, t/3600);
    end
    fprintf(log_file_id,['Average time over %d splits for ensemble: %.4f hours \n'],repeated_times, mean(training_time));
    fprintf(['-----------\n' ...
             'Average testing error over %d splits: ' ...
             '%.4f (+/- %.4f)\n'], ...
            repeated_times,mean(testing_errors),std(testing_errors));
    fprintf(log_file_id,['-----------\n' ...
             'Average testing error over %d splits: ' ...
             '%.4f (+/- %.4f)\n'], ...
            repeated_times,mean(testing_errors),std(testing_errors));
    fclose(log_file_id);
end    