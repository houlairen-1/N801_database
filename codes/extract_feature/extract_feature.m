function  extract_feature(para_file )
% %By: QIn Xinghong
% %Date: 2016.04.22

if exist(para_file)~=2 % %para_file is not a file.
    disp('The specified file does not exist.');
    return;
end
f_id=fopen(para_file);
c_para=cell(100,7);
t_line=fgetl(f_id);
idx_line=0;
while ~feof(f_id)
    t_line=fgetl(f_id);
    %d_line=strsplit(t_line,',');
    d_line=regexp(t_line,',','split');
    idx_line=idx_line+1;
    c_para{idx_line,1}=str2num(d_line{1});
    c_para{idx_line,2}=d_line{2};
    c_para{idx_line,3}=d_line{3};
    c_para{idx_line,4}=str2num(d_line{4});
    c_para{idx_line,5}=d_line{5};
    if length(d_line)>=7
        c_para{idx_line,6}=str2num(d_line{6});%start_index
        c_para{idx_line,7}=str2num(d_line{7});%end_index
    else
        c_para{idx_line,6}=0;%start_index
        c_para{idx_line,7}=0;%end_index
    end
end
c_para=c_para(1:idx_line,:);
fclose(f_id);

addpath(genpath(pwd));

for idx=1:idx_line
    disp(strcat('Start extract',c_para{idx,5},' No.', num2str(idx),' folder.'));
    switch upper(c_para{idx,5})
        case 'SRM'
            SRM_features(c_para{idx,2},c_para{idx,3},c_para{idx,4});
        case 'SCRMQ1'
            SCRMQ1_features(c_para{idx,2},c_para{idx,3},c_para{idx,4},c_para{idx,6},c_para{idx,7});
        case 'SCRMSG'
            Steerable_features(c_para{idx,2},c_para{idx,3},c_para{idx,4});
        case '3D-SPAM'%SG
            features_3d_spam(c_para{idx,2},c_para{idx,3},c_para{idx,4});
        case '3D-RGB'%RGB
            features_3d_rgb(c_para{idx,2},c_para{idx,3},c_para{idx,4});
        case 'SPAM'
            spam_features(c_para{idx,2},c_para{idx,3},0,1);
        case 'MAXSRMD2'
            maxSRMd2_features(c_para{idx,2},c_para{idx,3},c_para{idx,4});
        otherwise
    end
end

end

