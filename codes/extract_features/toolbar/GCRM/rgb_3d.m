function f=rgb_3d(IMAGE)
% %q=[0:1; 0:3; 0:5; 0:7; 0:9; 1]    
% % feature extraction method proposed by
% % H. ABDULRAHMAN, M. CHAUMONT, P. MONTESINOS, and
% % B. MAGNIER, ¡°Color images steganalysis using rgb channel geometric
% % transformation measures,¡± Security & Communication Networks, vol.
% % 123, no. 1, pp. 512¨C516., 2016.
% % 2017.07.24
% % About the dimention of the feature vector:
% % For method 1 (resp. method 2) one symmetrized spam14h and
% % one spam14v submodel, with 25 features each and the minmax22h,
% % minmax22v, minmax24, minmax34h, minmax34v, minmax41, minmax34,
% % minmax48h, minmax48v, and minmax54 submodels with 45 features for each
% % were used.
% % All submodels are gathered in a one dimension vector to erect a dimensionality
% % of (2  25 + 10  45)  6 = 3000 features. 

    %    dir = pwd;
    %    addpath(strcat(dir,'/uti'));
    [s1,s2,s3]=size(IMAGE);
    if s3~=3
        fprintf('The input is not a RGB image!\r\n');
    end
    X=double(IMAGE);
    q=[0.1 0.3 0.5 0.7 0.9 1];
    f=zeros(1,6000);
        
    % According to equation(12)
    % horizontal and vertical gradient derivatives by a convolution with a [1 -1] mask
    D_0=X(1:s1-1,1:s2-1,:)-X(1:s1-1,2:s2,:);
    D_1=X(1:s1-1,1:s2-1,:)-X(2:s1,1:s2-1,:);%v:[1 -1]
    D_n=sqrt(D_0.*D_0+D_1.*D_1);
    D_12=D_n(:,:,1).*D_n(:,:,2);
    D_13=D_n(:,:,1).*D_n(:,:,3);
    
    % according to equation(15)(16)
    % obtain the cosine of the difference between the two gradient angles
    % C_RG
    C_RG=(D_0(:,:,1).*D_0(:,:,2)+D_1(:,:,1).*D_1(:,:,2))./D_12;
    C_RG(D_12==0)=0;
    % C_RB
    C_RB=(D_0(:,:,1).*D_0(:,:,3)+D_1(:,:,1).*D_1(:,:,3))./D_13;
    C_RB(D_13==0)=0;
    
    % 3 000 features from cosine of rotation angles
    CC = [C_RG;C_RB];
    i_0=1;i_1=500;
    for qq=q
        f_srm=rgb_SRM(CC,qq);
        f(1,i_0:i_1)=f_srm;
        i_0=i_0+500;
        i_1=i_1+500;
    end
    
    % according to equation(17)(18)
    % obtain the cosine of the difference between the two gradient angles
    % S_RG
    S_RG=(D_0(:,:,1).*D_1(:,:,2)-D_1(:,:,1).*D_0(:,:,2))./D_12;
    S_RG(D_12==0)=0;
    % S_RB
    S_RB=(D_0(:,:,1).*D_1(:,:,3)-D_1(:,:,1).*D_0(:,:,3))./D_13;
    S_RB(D_13==0)=0;
    
    % 3 000 features from sine of rotation angles
    SS = [S_RG;S_RB];
    for qq=q
        f_srm=rgb_SRM(SS,qq);
        f(1,i_0:i_1)=f_srm;
        i_0=i_0+500;
        i_1=i_1+500;
    end
end