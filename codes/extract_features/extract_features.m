function extract_features(src, dst, analysis, contain_cover)
% src: image database, eg. '/home/lgq/BOSS_PPG/BOSS_PPG_BIC_all'
% dst: all the features of database save as mat file
%      eg. '../../data/PPG/BIC'
% analysis: composed of CRM, GCRM and SGRM 
% contain_cover: whether generate features of cover
% CRM feature numel: 18157;
% GCRM feature numel: 6000;
% CRM feature numel: 4406;
    % add path to steganalysis
    addpath('toolbar/CRM');
    addpath('toolbar/GCRM');
    addpath('toolbar/GCRM/uti');
    addpath('toolbar/SGRM');
    
    % open 100 cores in CPU server
    if isempty(gcp('nocreate'))==1
        parpool('jobmjs', 100);
    end

    image_num=10000;
    names = cell(image_num, 1);
    analysis_func = str2func(analysis);
    
    if exist(dst, 'dir')==0
        mkdir(dst);
    end
    if contain_cover
        % get cover folder's name
        src_split = regexp(src, '/', 'split');
        src_last = src_split{end-1};
        src_last_split = regexp(src_last, '_all', 'split');
        cover = src_last_split{1};
        image_path = [src, cover];

        mat_file = [dst cover '_' analysis];
        %        fprintf('%s\n', cover);
        fprintf('%s\n', image_path);
        %        fprintf('%s\n', mat_file);
        if isequal(analysis,'GCRM')
            mat_file = [mat_file '_6000'];
        elseif isequal(analysis,'SGRM')
            mat_file = [mat_file '_4406'];
        end
        %        fprintf('mat_file is %s\n', mat_file);
        if exist([mat_file, '.mat'], 'file') == 0
            analysis_func(image_path,mat_file,image_num);
        else
            fprintf('%s existed\n', [mat_file, '.mat']);
        end
    end
    
    all_steganography = [{'HILL_C'}, {'HILL_CMD_C'}, {'SUNIWARD_C'}, ...
                        {'SUNIWARD_CMD_C'}];
    for i = 1:numel(all_steganography)
        folder = [dst all_steganography{i}];
        if exist(folder)==0
            mkdir(folder);
        end
    end
    for i=1:numel(all_steganography)
        % only 0.2 and 0.4 bpp
        stego_list = dir([src, all_steganography{i}]);
        fprintf('%s\n', [src, all_steganography{i}]);
        %        fprintf('%s\n', stego_list(1).name);
        k = 1;
        for j=1:numel(stego_list)
            stego_split = regexp(stego_list(j).name, '_', 'split');
            embedding_rate = str2num(stego_split{end});
            if mod(embedding_rate, 20)==0
                stego_filter(k) = {stego_list(j).name};
                k = k+1;
                fprintf('filter: %s\n', stego_list(j).name)
            end
        end
        
        for j=1:numel(stego_filter)
            image_path = [src, all_steganography{i}, '/', stego_filter{j}];
            mat_file = [dst '/' all_steganography{i} '/' stego_filter{j} ...
                        '_' analysis];
            if isequal(analysis,'GCRM')
                mat_file = [mat_file '_6000'];
            elseif isequal(analysis,'SGRM')
                mat_file = [mat_file '_4406'];
            end
            if exist([mat_file, '.mat'], 'file') == 0
                analysis_func(image_path,mat_file,image_num);
            else
                fprintf('%s existed\n', [mat_file, '.mat']);
            end
        end
    end
    %delete(gcp('nocreate'));
