function CRM(img_path,t_file,img_count)
    if exist([t_file '.mat'],'file')~=0
        fprintf('The file %s has existed!\r\n',t_file);
        return;
    end

    if isdir(img_path)==0
        disp('(CRM)The source image directory is not exist!');
        return;
    end    

    f_list=dir([img_path filesep '*.ppm']);
    len_list=length(f_list);
    if len_list<1
        disp('(CRM)No any file in the source image directory!');
        return;
    end
    
    if img_count==0
        img_count=len_list;
    elseif len_list<img_count
        img_count=len_list;
    end
   
    feature_s = zeros(img_count,18157);
    name_s = cell(img_count,1);    
    img_name='';
    disp('starting extract features!');
    tic;
    
    parfor i = 1:img_count
        img_name = f_list(i).name;
        name_s{i}=img_name;
        f_name = [img_path filesep img_name];
        % %Run default GCRM extraction
        disp(['(CRM)extracting ' img_path '/'  img_name '...']);
        i_0=imread(f_name);
        fea_3d=SCRMQ1(i_0);
        feature_s(i,:)=fea_3d;
    end
    F = feature_s;%F brings the SRM features
    names = name_s;% names brings the SRM submodels' names
    if ~isempty(t_file)
        fprintf('%s saving ...', t_file);
        save (t_file, 'names','F','-v7.3');
        fprintf('\nsaved!\n');
    end
    e_t=toc;
    fprintf('-----extracting finished! elapsed: %.2f.-----------\n',e_t);
end
