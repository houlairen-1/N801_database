function [maxIm, othIm ]=f_steer_img(steerIm,deltaTheta)
% modified by Bin Li
% 2017.7.26 
% steerIm: steerable filter images
% maxIm: gradient magnitude image
% othIm: tangent derivative image 

%%%%%%%%%%%%%%%%%% 
[nrows,ncols] = size(steerIm{1});
L = length(steerIm); % nb de rotations
imAbs = zeros(nrows,ncols,L);
imX = zeros(nrows,ncols,L);
for i = 1:L 
    imAbs(:,:,i) = abs(steerIm{i}); % valeur absolue de la derivee 
    imX(:,:,i) = steerIm{i};
end
% maxAngleIndex corresponds to the index of maximum angle
[maxIm, maxAngleIndex] = max(imAbs,[],3);
%%%%%%%%%%%%%%%%%%%%%%%% derivative at the \theta +/- 90 orientation
maxAngle=(maxAngleIndex-1)*deltaTheta;  
tanAngle=maxAngle;
tanAngle(maxAngle>=90)=tanAngle(maxAngle>=90)-90;
tanAngle(maxAngle<90)=tanAngle(maxAngle<90)+90;
tanAngleIndex = fix((tanAngle/deltaTheta)+1); 
%%%%%%%%%%%%%%%%%%  
othIm = zeros(nrows,ncols);
for i =1:nrows
    for j=1:ncols
        othIm(i,j)=imX(i,j,tanAngleIndex(i,j));
    end
end
%%%%%%%%%%%%%%%%%% 

