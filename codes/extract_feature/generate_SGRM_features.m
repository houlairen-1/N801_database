clc; clear all;

image_num=10000;
% SGRM
% feature_num=6000;

if isempty(gcp('nocreate'))==1
    parpool('jobmjs', 100);
end

diary(['../../log/BOSS_AHD_LAN2_SGRM.log']);
diary on;
cur_dir = ['/home/lgq/BOSS_AHD_all/BOSS_AHD_LAN2_all/' ...
           'BOSS_AHD_LAN2'];
t_file = ['../../data/AHD/BOSS_AHD_LAN2_SGRM'];
MEXstart = tic;

SGRM(cur_dir, t_file, image_num);

MEXend = toc(MEXstart);
fprintf('\n - DONE');
fprintf('\n\nSGRM extracted %d images in %.2f seconds, in average %.2f seconds per image\n', image_num, MEXend, MEXend / image_num);

diary off;

% stego
for dir_no = 20:20:40
    diary(['../../log/BOSS_AHD_LAN2_HILLC_', num2str(dir_no), '_SGRM.log']);
    diary on;
    cur_dir = ['/home/lgq/BOSS_AHD_all/BOSS_AHD_LAN2_all/HILL_C/' ...
               'BOSS_AHD_LAN2_HILLC_', num2str(dir_no)];
    t_file = ['../../data/AHD/HILL_C/BOSS_AHD_LAN2_HILLC_', num2str(dir_no), '_SGRM'];
    MEXstart = tic;

    SGRM(cur_dir, t_file, image_num);
    
    MEXend = toc(MEXstart);
    fprintf('\n - DONE');
    fprintf('\n\nSGRM extracted %d images in %.2f seconds, in average %.2f seconds per image\n', image_num, MEXend, MEXend / image_num);

    diary off;
end
%delete(gcp('nocreate'));
fprintf('\nokay\n');