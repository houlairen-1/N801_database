function GCRM(img_path,t_file,img_count)
% %Date: 2017.07.24
% % H. ABDULRAHMAN, M. CHAUMONT, P. MONTESINOS, and
% % B. MAGNIER, ¡°Color images steganalysis using rgb channel geometric
% % transformation measures,¡± Security & Communication Networks, vol.
% % 123, no. 1, pp. 512¨C516., 2016.
% % For method 1 (resp. method 2) we use one symmetrized spam14h and
% % one spam14v submodel, with 25 features each. We also use the minmax22h,
% % minmax22v, minmax24, minmax34h, minmax34v, minmax41, minmax34,
% % minmax48h, minmax48v, and minmax54 submodels with 45 features for each.
% % All submodels are gathered in a one dimension vector to erect a dimensionality
% % of (2  25 + 10  45)  6 = 3000 features. 
    if exist(t_file,'file')~=0
        fprintf('The file %s has existed!\r\n',t_file);
        return;
    end

    if isdir(img_path)==0
        disp('(GCRM)The source image directory is not exist!');
        return;
    end    

    f_list=dir([img_path filesep '*.ppm']);
    len_list=length(f_list);
    if len_list<1
        disp('(GCRM)No any file in the source image directory!');
        return;
    end
    
    if img_count==0
        img_count=len_list;
    elseif len_list<img_count
        img_count=len_list;
    end
   
    feature_s = zeros(img_count,6000);
    name_s = cell(img_count,1);    
    img_name='';
    disp('starting extract features!');
    tic;
    
    parfor i = 1:img_count
        img_name = f_list(i).name;
        name_s{i}=img_name;
        f_name = [img_path filesep img_name];
        % %Run default GCRM extraction
        disp(['(GCRM)extracting ' img_path '/' img_name '...']);
        i_0=imread(f_name);
        fea_3d=rgb_3d(i_0);
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