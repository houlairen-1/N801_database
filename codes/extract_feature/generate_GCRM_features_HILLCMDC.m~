clc; clear all;

image_num=10000;
% GCRM
% feature_num=6000;

if isempty(gcp('nocreate'))==1
    parpool('jobmjs', 100);
end

log_file = ['../../log/BOSS_AHD_LAN2_GCRM.log'];
if exist(log_file, 'file')
    fprintf('delete %s\n', log_file);
    delete(log_file);
end
diary(log_file);
diary on;
cur_dir = ['/home/lgq/BOSS_AHD_all/BOSS_AHD_LAN2_all/' ...
           'BOSS_AHD_LAN2'];
t_file = ['../../data/AHD/BOSS_AHD_LAN2_GCRM'];

MEXstart = tic;
GCRM(cur_dir, t_file, image_num);
MEXend = toc(MEXstart);

fprintf('\n - DONE');
fprintf(['\n\nGCRM extracted %d images in %.2f seconds, in average ' ...
         '%.2f seconds per image\n'], image_num, MEXend, MEXend / image_num);

diary off;

% stego
for dir_no = 20:20:40
    log_file = ['../../log/BOSS_AHD_LAN2_HILLC_', num2str(dir_no), ...
                '_GCRM.log'];
    if exist(log_file, 'file')
        fprintf('delete %s\n', log_file);
        delete(log_file);
    end
    diary(log_file);
    diary on;
    cur_dir = ['/home/lgq/BOSS_AHD_all/BOSS_AHD_LAN2_all/HILL_C/' ...
               'BOSS_AHD_LAN2_HILLC_', num2str(dir_no)];
    t_file = ['../../data/AHD/HILL_C/BOSS_AHD_LAN2_HILLC_', ...
              num2str(dir_no), '_GCRM'];

    MEXstart = tic;
    GCRM(cur_dir, t_file, image_num);
    MEXend = toc(MEXstart);

    fprintf('\n - DONE');
    fprintf(['\n\nGCRM extracted %d images in %.2f seconds, in average ' ...
    '%.2f seconds per image\n'], image_num, MEXend, MEXend / image_num);


    diary off;
end
%delete(gcp('nocreate'));
fprintf('\nokay\n');