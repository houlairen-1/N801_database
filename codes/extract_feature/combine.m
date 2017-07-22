clc; clear all;
% data_path='../../data/HILL_CMD_C/';
data_path='../../data/SUNIWARD_CMD_C/';
fprintf('combine procejure\n');
%% % cover
%% crm_list = dir([data_path filesep '*2_CRM.mat']);
%% gcrm_list = dir([data_path filesep '*2_SGRM.mat']);
%% 
%% for i = 1:numel(crm_list)
%%     crm_file = crm_list(i).name;
%%     gcrm_file = gcrm_list(i).name;
%% 
%%     fprintf('%d: %s and %s load ...\n', i, crm_file, gcrm_file);
%%     crm=load([data_path, crm_file]);
%%     load([data_path, gcrm_file]);
%% 
%%     fprintf('%d: %s and %s combine ...\n', i, crm_file, gcrm_file);
%%     F = [crm.F F];
%%     save([data_path, gcrm_file], 'names','F');
%% end

% stego
crm_list = dir([data_path filesep '*0_CRM.mat']);
gcrm_list = dir([data_path filesep '*0_SGRM.mat']);

for i = 1:numel(crm_list)
    crm_file = crm_list(i).name;
    gcrm_file = gcrm_list(i).name;
    fprintf('%d: %s and %s load ...\n', i, crm_file, gcrm_file);
    crm=load([data_path, crm_file]);
    load([data_path, gcrm_file]);
    
    if isequal(crm.names, names) == 0
        fprintf('names different\n');
        return;
    end

    fprintf('%d: %s and %s combine ...\n', i, crm_file, gcrm_file);
    F = [crm.F F];
    save([data_path, gcrm_file], 'names','F');
end
fprintf('\nokay\n');
