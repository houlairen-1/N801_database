clc; clear all;

image_num=10000;
% feature_num=18157;
names = cell(image_num, 1);

if isempty(gcp('nocreate'))==1
    parpool('jobmjs', 100);
end

log_dir='../../log/';
data_dir = '/home/lgq/BOSS_AHD_all/BOSS_AHD_LAN2_all/';
t_dir='../../data/AHD/';
fprintf('CRM extraction\n');

% cover image
diary([log_dir, 'BOSS_AHD_LAN2_CRM.log']);
diary on;
cur_dir = [data_dir, 'BOSS_AHD_LAN2'];
t_file = [t_dir, 'BOSS_AHD_LAN2_CRM'];
flist = dir([cur_dir filesep '*.ppm']);

MEXstart = tic;
parfor i = 1:image_num
    names(i,1) = {flist(i).name};
    temp(i,:) = CRM(fullfile(cur_dir, names{i,1}));
    fprintf('\n%s %s', cur_dir, names{i,1});
end
F=cell2mat((struct2cell(temp))');
MEXend = toc(MEXstart);

save(t_file, 'F', 'names');
fprintf('\n - DONE');
fprintf('\n\nCRM extracted %d images in %.2f seconds, in average %.2f seconds per image\n', image_num, MEXend, MEXend / image_num);
diary off;

% stego
for dir_no = 20:20:40
    log_file = ['../../log/BOSS_AHD_LAN2_HILLC_', num2str(dir_no), ...
                '_CRM.log'];
    if exist(log_file, 'file')
        delete(log_file);
    end
    diary(log_file);
    diary on;
    clear F; clear names;
    cur_dir = ['/home/lgq/BOSS_AHD_all/BOSS_AHD_LAN2_all/HILL_C/' ...
               'BOSS_AHD_LAN2_HILLC_', num2str(dir_no)];
    t_file = ['../../data/AHD/HILL_C/BOSS_AHD_LAN2_HILLC_', num2str(dir_no), ...
              '_CRM'];
    flist = dir([cur_dir filesep '*.ppm']);
    MEXstart = tic;

    parfor i = 1:image_num
        names(i,1) = {flist(i).name};
        temp(i,:) = CRM(fullfile(cur_dir, names{i,1}));
        fprintf('\n%s %s', cur_dir, names{i,1});
    end
    F=cell2mat((struct2cell(temp))');
    
    MEXend = toc(MEXstart);
    fprintf('\n - DONE');
    fprintf('\n\nCRM extracted %d images in %.2f seconds, in average %.2f seconds per image\n', image_num, MEXend, MEXend / image_num);

    save(t_file, 'F', 'names');
    diary off;
end
%delete(gcp('nocreate'));
fprintf('\nokay\n');
