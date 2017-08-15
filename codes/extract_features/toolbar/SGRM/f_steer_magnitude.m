function [MaxI_R,MaxI_G,MaxI_B,Oth_MaxI_R,Oth_MaxI_G,Oth_MaxI_B]= f_steer_magnitude(cover)
% MaxI_X: gradient magnitude image
% Oth_MaxI_X: tangent derivative image 
% modified by Bin Li
% 2017.7.26


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

    steer_Image_out_R = cell(1,size(theta,2));
    steer_Image_out_G = cell(1,size(theta,2));
    steer_Image_out_B = cell(1,size(theta,2));

    R = XX(:,:,1); % red
    G = XX(:,:,2); % green
    B = XX(:,:,3); % blue
    %[nrows,ncols] = size(R);

    for i = [1:length(theta)]
        [steer_Image_out_R{1,i},H] = steerGauss2(R,theta(i),sigma,false);
        [steer_Image_out_G{1,i},H] = steerGauss2(G,theta(i),sigma,false);
        [steer_Image_out_B{1,i},H] = steerGauss2(B,theta(i),sigma,false);
%         filters{i} = H;
    end

    [MaxI_R, Oth_MaxI_R  ]= f_steer_img(steer_Image_out_R,delta_theta);

    [MaxI_G, Oth_MaxI_G ]= f_steer_img(steer_Image_out_G,delta_theta);

    [MaxI_B,  Oth_MaxI_B ]= f_steer_img(steer_Image_out_B,delta_theta);
  
end