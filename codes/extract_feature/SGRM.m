function f_ret = SGRM(img_path,t_file,img_count)
% %By: Qin Xinghong
% %Date: 2017.03.14
% %Dimension: 4406.
% % H. ABDULRAHMAN, M. CHAUMONT, P. MONTESINOS, and
% % B. MAGNIER, ¡°Color image steganalysis based on steerable gaussian
% % ?lters bank,¡± in ACM Workshop on Information Hiding and Multimedia
% % Security. ACM, 2016, pp. 109¨C114.
% %Input: img_path--directory of source images.
% %       t_file--target file name (including path). If t_file is empty, do
% %             not save the result to any file.
% %       img_count--count of images extracted.
% %       scrmq1_mat--if this argurment is exist, it means only
% %              compensating steerable gausian features.
% %Output: f_ret--extracted features.

    if isdir(img_path)==0
        %h=msgbox('The source image directory is not exist!','SRMQ1');
        disp('(3D_SPAM)The source image directory is not exist!');
        return;
    end    

    f_list=dir([img_path filesep '*.ppm']);
    len_list=length(f_list);
    if len_list<1
        %h=msgbox('No any file in the source image directory!','SRMQ1');
        disp('(3D_SPAM)No any file in the source image directory!');
        return;
    end
    
    if img_count==0
        img_count=len_list;
    elseif len_list<img_count
        img_count=len_list;
    end
   
    feature_s = zeros(img_count,4406);
    name_s = cell(img_count,1);    

    img_name='';
    disp('starting extract features!');
    tic;

%-----initial steer ganssian filters.
    delta_theta = 10;
    sigma = 0.7; 

    theta = [0:delta_theta:(180-delta_theta)];

    steer_Filter = cell(1,size(theta,2));
    h=stear_filter(sigma);
    for i=1:length(theta)
        h.theta = theta(i);
        steer_Filter{i}=h;
    end
%-----

    parfor i = 1:img_count
        img_name = f_list(i).name;
        name_s{i}=img_name;
        f_name = [img_path filesep img_name];
        % %Run default SRM extraction
        disp(['(3D-SPAM)extracting the ' num2str(i) ', image: ' img_name '...']);
        i_0=imread(f_name);
        fea_spam=stear_SPAM(i_0,steer_Filter);
        feature_s(i,:)=fea_spam;
    end
    F = feature_s;%F brings the SRM features
    names = name_s;% names brings the SRM submodels' names
    if ~isempty(t_file)
        save (t_file, 'names','F','-v7.3');
    end
    f_ret.F=F;
    f_ret.names=names;
    e_t=toc;
    fprintf('-----extracting finished! elapsed: %.6f.-----------',e_t);
end

function F=stear_SPAM(cover,steer_Filter)
    [MaxI_R,MaxI_G,MaxI_B,MaxI_angle_R,MaxI_angle_G,MaxI_angle_B]=stear_magnitude(cover,steer_Filter);
    F=zeros(1,4406);
    idx_0=1;
    idx_1=250;
    X=cell(6);
    X{1}=MaxI_R;
    X{2}=MaxI_G;
    X{3}=MaxI_B;
    X{4}=MaxI_angle_R;
    X{5}=MaxI_angle_G;
    X{6}=MaxI_angle_B;
    for i=1:3 %max gradient magnitude, 2nd, T=2
        f_m=spam_extract_2(X{i},2);
        F(1,idx_0:idx_1)=f_m;
        idx_0=idx_0+250;
        idx_1=idx_1+250;
    end

    idx_0=idx_1+1-250;
    idx_1=idx_1+686-250;
    for i=1:3 %max gradient magnitude, 2nd, T=3
        f_m=spam_extract_2(X{i},3);
        F(1,idx_0:idx_1)=f_m;
        idx_0=idx_0+686;
        idx_1=idx_1+686;
    end

    idx_0=idx_1+1-686;
    idx_1=idx_1+54-686;
    for i=4:6 %max angle magnitude, 2nd, T=1
        f_m=spam_extract_2(X{i},1);
        F(1,idx_0:idx_1)=f_m;
        idx_0=idx_0+54;
        idx_1=idx_1+54;
    end

    idx_0=idx_1+1-54;
    idx_1=idx_1+250-54;
    for i=4:6 %max angle magnitude, 2nd, T=2
        f_m=spam_extract_2(X{i},2);
        F(1,idx_0:idx_1)=f_m;
        idx_0=idx_0+250;
        idx_1=idx_1+250;
    end

    idx_0=idx_1+1-250;
    idx_1=idx_1+686-250;
    f_m=zeros(1,686);
    for i=4:6 %max angle magnitude, 2nd, T=3
        f_m=f_m+spam_extract_2(X{i},3);
    end
    F(1,idx_0:idx_1)=f_m;
end

function F = spam_extract_2(X,T)

    % horizontal left-right
    D = X(:,1:end-1) - X(:,2:end);
    L = D(:,3:end); C = D(:,2:end-1); R = D(:,1:end-2);
    Mh1 = GetM3(L,C,R,T);

    % horizontal right-left
    D = -D;
    % %L = D(:,1:end-2); C = D(:,2:end-1); R = D(:,3:end);
    L = D(:,3:end); C = D(:,2:end-1); R = D(:,1:end-2);
    Mh2 = GetM3(L,C,R,T);
    % vertical bottom top
    D = X(1:end-1,:) - X(2:end,:);
    L = D(3:end,:); C = D(2:end-1,:); R = D(1:end-2,:);
    Mv1 = GetM3(L,C,R,T);

    % vertical top bottom
    D = -D;
    % %L = D(1:end-2,:); C = D(2:end-1,:); R = D(3:end,:);
    L = D(3:end,:); C = D(2:end-1,:); R = D(1:end-2,:);
    Mv2 = GetM3(L,C,R,T);

    % diagonal left-right
    D = X(1:end-1,1:end-1) - X(2:end,2:end);
    L = D(3:end,3:end); C = D(2:end-1,2:end-1); R = D(1:end-2,1:end-2);
    Md1 = GetM3(L,C,R,T);

    % diagonal right-left
    D = -D;
    % %L = D(1:end-2,1:end-2); C = D(2:end-1,2:end-1); R = D(3:end,3:end);
    L = D(3:end,3:end); C = D(2:end-1,2:end-1); R = D(1:end-2,1:end-2);
    Md2 = GetM3(L,C,R,T);

    % minor diagonal left-right
    D = X(2:end,1:end-1) - X(1:end-1,2:end);
    L = D(1:end-2,3:end); C = D(2:end-1,2:end-1); R = D(3:end,1:end-2);
    Mm1 = GetM3(L,C,R,T);

    % minor diagonal right-left
    D = -D;
    % %L = D(3:end,1:end-2); C = D(2:end-1,2:end-1); R = D(1:end-2,3:end);
    L = D(1:end-2,3:end); C = D(2:end-1,2:end-1); R = D(3:end,1:end-2);
    Mm2 = GetM3(L,C,R,T);

    F1 = (Mh1+Mh2+Mv1+Mv2)/4;
    F2 = (Md1+Md2+Mm1+Mm2)/4;
    F = [F1' F2'];
end

function M = GetM3(L,C,R,T)
    % marginalization into borders
    L = L(:); L(L<-T) = -T; L(L>T) = T;
    C = C(:); C(C<-T) = -T; C(C>T) = T;
    R = R(:); R(R<-T) = -T; R(R>T) = T;

    % get cooccurences [-T...T]
    M = zeros(2*T+1,2*T+1,2*T+1);
    for w=-T:T
        for v=-T:T
            L2=L(C==v & R==w);
            for u=-T:T
                M(u+T+1,v+T+1,w+T+1) = sum(L2==u);
            end
        end
    end

    % normalization
    M = M(:)/sum(M(:));
end

function [MaxI_R,MaxI_G,MaxI_B,MaxI_angle_R,MaxI_angle_G,MaxI_angle_B]= stear_magnitude(cover,steer_Filter)
     delta_theta = 10;
     sigma = 0.7; 

    XX=cover;

    S = size(XX);
    if ((length(S) == 3 ) && (S(3)==3))
        %disp('color image')     
    else
         msg = 'The input image is not a color image of 3 channels';
         size(XX)
         error(msg)     
    end

    theta = [0:delta_theta:(180-delta_theta)];

%     steer_Filter = cell(1,size(theta,2));
%     h=stear_filter(sigma);
%     for i=1:length(theta)
%         h.theta = theta(i);
%         steer_Filter{i}=h;
%     end
    steer_Image_out_R = cell(1,size(theta,2));
    steer_Image_out_G = cell(1,size(theta,2));
    steer_Image_out_B = cell(1,size(theta,2));

    R = XX(:,:,1); % red
    G = XX(:,:,2); % green
    B = XX(:,:,3); % blue
    %[nrows,ncols] = size(R);

    for i = [1:length(theta)]
        [steer_Image_out_R{1,i},H] = steerGauss2(R,steer_Filter{i},false,false);
        [steer_Image_out_G{1,i},H] = steerGauss2(G,steer_Filter{i},false,false);
        [steer_Image_out_B{1,i},H] = steerGauss2(B,steer_Filter{i},false,false);
%         [steer_Image_out_R{1,i},H] = steerGauss2(R,theta(i),sigma,false);
%         [steer_Image_out_G{1,i},H] = steerGauss2(G,theta(i),sigma,false);
%         [steer_Image_out_B{1,i},H] = steerGauss2(B,theta(i),sigma,false);
        %filters{i} = H;
        %pause(0.1);
    end

    [MaxI_R MaxI_angle_R  Min_R ]= steer_max(steer_Image_out_R);

    [MaxI_G, MaxI_angle_G,  Min_G]= steer_max(steer_Image_out_G);

    [MaxI_B  MaxI_angle_B  Min_B ]= steer_max(steer_Image_out_B);
end

function [MaxI, I1, MinI ]= steer_max(steer1)
% steer1{1} drivative images
% % MaxI is the Maximum value from steerable filter images
% % I1 is the angle of maximum value
% % MinI is the angle of Minimum value.

    [nrows,ncols] = size(steer1{1});
    L = length(steer1); % nb de rotations
    imAbs = zeros(nrows,ncols,L);
    MaxI= zeros(nrows,ncols);
    I1 = ones(nrows,ncols);
    MinI= zeros(nrows,ncols);
    for i = 1:L 
        imAbs(:,:,i) = abs(steer1{i}); % valeur absolue de la derivee 
    end

    MaxI=imAbs(:,:,1);
    MinI=imAbs(:,:,1);

    for i = 2:L 
        for x = 1:nrows
            for y = 1:ncols
                if (MaxI(x,y)<imAbs(x,y,i) )
                    MaxI(x,y)=imAbs(x,y,i);
                    I1(x,y) = i;
                end
                if (MinI(x,y)>imAbs(x,y,i) )  % optional
                    MinI(x,y)=imAbs(x,y,i);
                end
            end
        end
    end
end

function [J,h] = steerGauss2(I,arg1,arg2,arg3)
% STEERGAUSS Implements a steerable Gaussian filter.
%    This m-file can be used to evaluate the first
%    directional derivative of an image, using the
%    method outlined in:
%
%       W. T. Freeman and E. H. Adelson, "The Design
%       and Use of Steerable Filters", IEEE PAMI, 1991.
%
%    [J,H] = STEERGAUSE(I,THETA,SIGMA,VIS) evaluates
%    the directional derivative of the input image I,
%    oriented at THETA degrees with respect to the
%    image rows. The standard deviation of the Gaussian
%    kernel is given by SIGMA (assumed to be equal to
%    unity by default). The filter parameters are 
%    returned to the user in the structure H.
%
%    [J,H] = STEERGAUSE(I,H,VIS) evaluates the
%    directional derivative of the input image I, using
%    the previously computed filter stored in H. Note
%    that H is a structure, with the following fields:
%           H.g: 1D Gaussian
%          H.gp: first-derivative of 1D Gaussian
%       H.theta: orientation of filter
%       H.sigma: standard derivation of Gaussian
%
%    Note that the filter support is automatically
%    adjusted (depending on the value of SIGMA).
%
%    In general, the visualization can be enabled 
%    (or disabled) by setting VIS = TRUE (or FALSE).
%    By default, the visualization is disabled.
%
% Author: Douglas R. Lanman, Brown University, Jan. 2006.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part I: Assign algorithm parameters.

% Load default image (if none provided).
% Note: Converts to grayscale.
    I = mean(double(I),3);

    % Process input arguments (according to usage mode).
    if ~exist('arg1','var') || ~isstruct(arg1)

        % Usage: [J,H] = STEERGAUSE(I,THETA,SIGMA,VIS)
        usageMode = 1;

        % Assign default filter orientation (if not provided).
        if ~exist('arg1','var') || isempty(arg1)
          arg1 = 0;
        end
        theta = -arg1*(pi/180);

        % Assign default standard deviation (if not provided).
        if ~exist('arg2','var') || isempty(arg2)
           arg2 = 1;
        end
        sigma = arg2;

        % Assign default visualization state (if not provided).
        if ~exist('arg3','var') || isempty(arg3)
           arg3 = false;
        end
        vis = arg3;    
    else
        % Usage: [J,H] = STEERGAUSE(I,H,VIS)
        usageMode = 2;

        % Extract filter parameters.
        h = arg1;
        theta = -h.theta*(pi/180);
        sigma = h.sigma;
        g = h.g;
        gp = h.gp;

        % Assign default visualization state (if not provided).
        if ~exist('arg2','var') || isempty(arg2)
           arg2 = false;
        end
        vis = arg2;    
    end % End of input pre-processing.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Part II: Evaluate separable filter kernels.

    % Calculate filter kernels (if not provided by user).
    if usageMode == 1

       % Determine necessary filter support (for Gaussian).
       Wx = floor((5/2)*sigma); 
       if Wx < 1
          Wx = 1;
       end
       x = [-Wx:Wx];

       % Evaluate 1D Gaussian filter (and its derivative).
       g = exp(-(x.^2)/(2*sigma^2));
       gp = -(x/sigma).*exp(-(x.^2)/(2*sigma^2));

       % Store filter kernels (for subsequent runs).
       h.g = g;
       h.gp = gp;
       h.theta = -theta*(180/pi);
       h.sigma = sigma;

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Part III: Determine oriented filter response.

    % Calculate image gradients (using separability).
    Ix = conv2(conv2(I,-gp,'same'),g','same');
    Iy = conv2(conv2(I,g,'same'),-gp','same');

    % Evaluate oriented filter response.
    J = cos(theta)*Ix+sin(theta)*Iy;

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Part IV: Visualization

    %Create figure window and display results.
    %Note: Will only create output window is requested by user.
    if vis
       figure(1); clf; set(gcf,'Name','Oriented Filtering');
       subplot(2,2,1); imagesc(I); axis image; colormap(gray);
          title('Input Image');
       subplot(2,2,2); imagesc(J); axis image; colormap(gray);
          title(['Filtered Image (\theta = ',num2str(-theta*(180/pi)),'{\circ})']);
       subplot(2,1,2); imagesc(cos(theta)*(g'*gp)+sin(theta)*(gp'*g));
          axis image; colormap(gray);
          title(['Oriented Filter (\theta = ',num2str(-theta*(180/pi)),'{\circ})']);
    end
end

function h = stear_filter(sigma)
  % Determine necessary filter support (for Gaussian).
   Wx = floor((5/2)*sigma); 
   if Wx < 1
      Wx = 1;
   end
   x = [-Wx:Wx];

   % Evaluate 1D Gaussian filter (and its derivative).
   g = exp(-(x.^2)/(2*sigma^2));
   gp = -(x/sigma).*exp(-(x.^2)/(2*sigma^2));

   % Store filter kernels (for subsequent runs).
   h.g = g;
   h.gp = gp;
   %h.theta = -theta*(180/pi);
   h.sigma = sigma;
end