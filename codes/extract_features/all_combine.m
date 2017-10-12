function all_combine(root_path)
    % cover
    crm = dir([root_path filesep '*_CRM*']);
    gcrm = dir([root_path filesep '*_GCRM_*']);
    sgrm = dir([root_path filesep '*_SGRM_*']);

    combine([root_path, crm(1).name], [root_path, gcrm(1).name], ...
            true);
    combine([root_path, crm(1).name], [root_path, sgrm(1).name], ...
            false);
    
    %     all_steganography = [{'HILL_C'}, {'HILL_CMD_C'}, {'SUNIWARD_C'}, ...
    %                         {'SUNIWARD_CMD_C'}];
    all_steganography = [{'HILL_C'}, {'HILL_CMD_C'}];
    for i=1:numel(all_steganography)
        % only 0.2 and 0.4 bpp
        stego_list = dir([[root_path, all_steganography{i}] filesep ...
                          '*.mat']);
        fprintf('%s\n', [root_path, all_steganography{i}]);
        %        fprintf('%s\n', stego_list(1).name);
        k = 1;
        for j=1:numel(stego_list)
            num_list = regexp(stego_list(j).name, '[0-9][0-9]', 'match');
            embedding_rate = str2num(num_list{1});

            stego_split = regexp(stego_list(j).name, '_', 'split');
            flag = isequal(stego_split{end}, 'CRM.mat') || ...
                   isequal(stego_split{end}, '6000.mat') || ...
                   isequal(stego_split{end}, '4406.mat');

            if mod(embedding_rate, 10)==0 && flag  % 10:(10,30,50); 0:(20, 40)
                stego_filter(k) = {stego_list(j).name};
                k = k+1;
                fprintf('filter: %s\n', stego_list(j).name)
            end
        end
        
        for j=1:3:numel(stego_filter)
            crm_path = [root_path, all_steganography{i}, '/', stego_filter{j}];
            gcrm_path = [root_path, all_steganography{i} '/' ...
                         stego_filter{j+1}];
            sgrm_path = [root_path, all_steganography{i} '/' ...
                         stego_filter{j+2}];
            
            combine(crm_path, gcrm_path, true);
            combine(crm_path, sgrm_path, false);
        end
    end
