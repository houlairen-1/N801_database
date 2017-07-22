clc; clear all;
mat_path='../../data/';

fprintf('names transpose and sort ...\n');
flist = dir([mat_path filesep '*_CRM.mat']);

for i = 1:numel(flist)
    file = flist(i).name;
    mat_file = load([mat_path, file]);
    [row col] = size(mat_file.names);

    fprintf('%d: %s names transpose ...\n', i,file);
    if row == 1 && col == 10000
        names = mat_file.names';
    end
    
    fprintf('%d: %s names sort ...\n', i,file);
    [names, index]=sort(names);
    F = mat_file.F(index,:);
    save([mat_path, file], 'names','F');
end

fprintf('okay\n');
