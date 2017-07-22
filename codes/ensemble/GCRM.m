function GCRM(data_path)
log_path='../../log/ensemble/';
% data_path='../../data/HILL_CMD_C/';
flist = dir([data_path filesep '*_GCRM.mat']);
cover_file = flist(1).name;
fprintf('cover is %s\n', cover_file);
cover = load([data_path, cover_file]);

for i = 2:numel(flist)
    stego_file = flist(i).name;
    fprintf('%d: stego is %s\n', i, stego_file);
    stego = load([data_path, stego_file]);

    for seed_value = 1:2
        log_file = [log_path, stego_file, '_', num2str(seed_value), ...
                    '.log'];
        if exist(log_file, 'file')
            delete(log_file);
        end
        diary(log_file);
        diary on;
        MEXstart = tic;
        classify_BOSSbase(cover, stego, seed_value);
        MEXend = toc(MEXstart);
        diary off;
    end
end
%delete(gcp('nocreate'));
fprintf('\nokay\n');