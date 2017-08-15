function F=f_steer_SPAM(im_n)
% feature extraction method proposed by 
% Hasan Abdulrahman, Marc Chaumont, Philippe Montesinos, 
% and Baptiste Magnier, "Color Image Steganalysis Based on Steerable Gaussian Filters Bank," 
% IH&MMSec'2016, in Proceedings of the 4th ACM workshop on Information Hiding and Multimedia Security, 
% Vigo, Galicia, Spain, 6 pages, June 20-22, 2016.
% http://www.lirmm.fr/~chaumont/FAQ-ColorImageSteganalysisBasedonSteerableGaussianFiltersBank.html
% modified by Bin Li
% 2017.7.26

% About the dimension of the feature vector:

% The first set, produced by [10], is made of 18,157 features. 
%  The second set is made of 4406 features and comes from SPAM features from 
%  - the gradient magnitude image of each channel (R, G, B) ; it gives 2808 features;
%  - the derivative image (related to the tangent vector) for each channel (R, G, B) ; it gives 1598 features.
% 
% More details about the second set:
%  - The co-occurences matrices are computed with triplets which means that co-occurences have (2xT+1)^3 bins.
%  - 4 matrices are computed (horizontal right, and left, and vertical right, and left) and then summed.
%  - 4 others matrices are computed (horizontal right, and left, and vertical right and left) and then summed.
%  - The two matrices are then concatenated in a feature vector.
%  - For each T values (except for the derivative image with T=3), the feature vectors of each channel  are concatenated.
% 
%  Thus:
%  - For the gradient magnitude, T is equal to 2 or 3. This leads to a dimension = 3x(2x5^3) + 3x(2x7^3) = 3x250 + 3x686 = 2808 features,
%  - For the derivative image, T is equal to 1, 2 or 3. This leads to a dimension = 3x(2x3^3) + 3x(2x5^3) + (2x7^3) = 3x54+3x250+686 = 1598 features. 
%   Note that for T=3, we sum the 3 co-occurrences matrices (from R, G, B channels) instead of concatenate them (indeed, otherwise, bins values are too small for T=3). 


% Obtain magnitude images and derivative images
im_n = double(im_n);
X=cell(1,3); % gradient magnitude images
Y=cell(1,3); % tangent derivative images
[X{1},X{2},X{3},Y{1},Y{2},Y{3}]=f_steer_magnitude(im_n);

% Coocurrence matrix feature extraction
F=zeros(1,4406);
t1=2*3^3; % 54
t2=2*5^3; %250
t3=2*7^3; % 686


% 2 808 features from gradient magnitude images (T 2 f2; 3g),
%gradient magnitude images,  T=2
offset = 0;
for i=1:3 
    f_m=f_spam_extract_2(X{i},2);
    F(  offset+(i-1)*t2+1 : offset+(i-1)*t2+t2    )=f_m;
end
%gradient magnitude images,  T=3
offset = 3*t2;
for i=1:3  
    f_m=f_spam_extract_2(X{i},3);
    F(offset+(i-1)*t3+1 : offset+(i-1)*t3+t3 )=f_m;
end

% 1 598 features from tangent derivative images (T 2 f1; 2; 3g and for
% T=3 there is a fusion of matrices)
% tangent derivative images, T =1
offset = 3*t2+3*t3;
for i=1:3  
    f_m=f_spam_extract_2(Y{i},1);
    F(offset+(i-1)*t1+1 : offset+(i-1)*t1+t1)=f_m;
end
% tangent derivative images, T =2
offset = 3*t2+3*t3+3*t1;
for i=1:3  
    f_m=f_spam_extract_2(Y{i},2);
    F(offset+(i-1)*t2+1 : offset+(i-1)*t2+t2)=f_m;
end
% tangent derivative images, T =3
offset = 3*t2+3*t3+3*t1+3*t2;
temp=zeros(1,686);
for i=1:3  
    temp=temp+f_spam_extract_2(Y{i},3);
end
F(offset+1 : offset+t3)=temp;
