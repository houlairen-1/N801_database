function F = f_spam_extract_2(X,T)
% modified by Bin Li
% 2017.7.27

%quantization and truncation
X = round(X);
X(X<-T) = -T; 
X(X>T) = T;

% horizontal left-right
D = X(:,1:end-1) - X(:,2:end);
L = D(:,3:end); C = D(:,2:end-1); R = D(:,1:end-2);
Mh1 = f_GetM3(L,C,R,T);

% horizontal right-left
D = -D;
L = D(:,1:end-2); C = D(:,2:end-1); R = D(:,3:end);
Mh2 = f_GetM3(L,C,R,T);

% vertical bottom top
D = X(1:end-1,:) - X(2:end,:);
L = D(3:end,:); C = D(2:end-1,:); R = D(1:end-2,:);
Mv1 = f_GetM3(L,C,R,T);

% vertical top bottom
D = -D;
L = D(1:end-2,:); C = D(2:end-1,:); R = D(3:end,:);
Mv2 = f_GetM3(L,C,R,T);

% diagonal left-right
D = X(1:end-1,1:end-1) - X(2:end,2:end);
L = D(3:end,3:end); C = D(2:end-1,2:end-1); R = D(1:end-2,1:end-2);
Md1 = f_GetM3(L,C,R,T);

% diagonal right-left
D = -D;
L = D(1:end-2,1:end-2); C = D(2:end-1,2:end-1); R = D(3:end,3:end);
Md2 = f_GetM3(L,C,R,T);

% minor diagonal left-right
D = X(2:end,1:end-1) - X(1:end-1,2:end);
L = D(1:end-2,3:end); C = D(2:end-1,2:end-1); R = D(3:end,1:end-2);
Mm1 = f_GetM3(L,C,R,T);

% minor diagonal right-left
D = -D;
L = D(3:end,1:end-2); C = D(2:end-1,2:end-1); R = D(1:end-2,3:end);
Mm2 = f_GetM3(L,C,R,T);

F1 = (Mh1+Mh2+Mv1+Mv2)/4;
F2 = (Md1+Md2+Mm1+Mm2)/4;
F = [F1' F2'];