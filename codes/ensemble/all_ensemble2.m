function all_ensemble2(src, dst)
    all_analysis = [{'CRM'}, {'SGRM'}];
    %    all_analysis = [{'CRM'}, {'GCRM'}, {'SGRM'}];
    %     all_steganography = [{'HILL_C'}, {'HILL_CMD_C'}, {'SUNIWARD_C'}, ...
    %                         {'SUNIWARD_CMD_C'}];
    all_steganography = [{'HILL_C'}, {'HILL_CMD_C'}];
    if exist(dst, 'dir')==0
        mkdir(dst);
    end
    for i = 1:numel(all_steganography)
        folder = [dst all_steganography{i}];
        if exist(folder)==0
            mkdir(folder);
        end
    end

    for u = 1:numel(all_analysis)
        % cover
        cover_list = dir([src filesep '*.mat']);
        for v=1:numel(cover_list)
            cover_split = regexp(cover_list(v).name, '_', 'split');
            if isequal(cover_split{end}, [all_analysis{u} '.mat'])
                cover_filter(1) = {cover_list(v).name};
                fprintf('cover filter: %s\n', cover_list(v).name)
            end
        end
        cover = [src, cover_filter{1}];
        fprintf('%s\n', all_analysis{u});
        for i=1:numel(all_steganography)
            % only 0.2 and 0.4 bpp
            stego_list = dir([[src, all_steganography{i}] filesep ...
                              '*.mat']);
            fprintf('%s\n', [src, all_steganography{i}]);
            k = 1;
            for j=1:numel(stego_list)
                num_list = regexp(stego_list(j).name, '[0-9][0-9]', 'match');
                embedding_rate = str2num(num_list{1});
                
                stego_split = regexp(stego_list(j).name, '_', 'split');
                flag = isequal(stego_split{end}, [all_analysis{u} '.mat']);
                
                if mod(embedding_rate, 10)==0 && flag
                    stego_filter(k) = {stego_list(j).name};
                    k = k+1;
                    fprintf('stego filter: %s\n', stego_list(j).name)
                end
            end
            
            for j=1:numel(stego_filter)
                stego = [src, all_steganography{i} '/' ...
                             stego_filter{j}];
                log = [dst all_steganography{i}];
                %                fprintf('%s\n%s\n', stego, log)
                ensemble2(cover, stego, log, 1);
            end
        end
        fprintf('\n');
    end
