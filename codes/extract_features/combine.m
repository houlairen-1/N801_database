function combine(crm_path, gcrm_or_sgrm_path, is_gcrm)
%% lgq
%% mat: F, names
    if is_gcrm
        dst_list = regexp(gcrm_or_sgrm_path, '_6000', 'split');
    else
        dst_list = regexp(gcrm_or_sgrm_path, '_4406', 'split');
    end
    dst = dst_list{1};
    if exist([dst, '.mat'], 'file') ~= 0
        fprintf('%s has existed\n', [dst, '.mat']);
        return;
    end

    crm=load(crm_path);
    load(gcrm_or_sgrm_path);
    
    if isequal(crm.names, names) == 0
        fprintf('names different\n');
        return;
    end

    fprintf('%s and %s combine ...\n', crm_path, gcrm_or_sgrm_path);
    F = [crm.F F];
    
    save(dst, 'names','F', '-v7.3');
    fprintf('done\n');
