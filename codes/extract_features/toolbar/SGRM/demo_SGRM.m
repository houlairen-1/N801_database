% function [F1,F2] = demo_SGRM()
F1 = f_steer_SPAM(imread('9999.ppm'));
F2 = f_steer_SPAM(imread('s9999.ppm'));
y = F1-F2;
bar(y);

% FC = SCRMQ1('9999.ppm');
% Ss = fieldnames(FC);
% f1 = struct2cell(FC);
% temp1 = [];
% for k = 1:length(Ss)
%     A = f1{k};
%     b = size(A,2);
%     temp1 = [temp1 A];
% end
% FS = SCRMQ1('s9999.ppm')
% Ss = fieldnames(FS);
% f1 = struct2cell(FS);
% temp2 = [];
% for k = 1:length(Ss)
%     A = f1{k};
%     b = size(A,2);
%     temp2 = [temp2 A];
% end
% F1 = [temp1 F1];
% F2 = [temp2 F2];

% end