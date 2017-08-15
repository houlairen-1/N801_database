clc; clear all;

% 100 cores 1
% 100 cores 2
%% src = '/home/lgq/BOSS_AHD/BOSS_AHD_LAN2_all/';
%% dst = '../../data/AHD/LAN2/';
%% extract_features(src,dst,'GCRM',true);  % 100 cores 2
src = '/home/lgq/BOSS_AHD/BOSS_AHD_BIL_all/';
dst = '../../data/AHD/BIL/';
%% extract_features(src,dst,'CRM',true);   % 100 cores 2
%% extract_features(src,dst,'GCRM',true);  % 100 cores 2
extract_features(src,dst,'SGRM',true); % 100 cores 1
src = '/home/lgq/BOSS_AHD/BOSS_AHD_BIC_all/';
dst = '../../data/AHD/BIC/';
extract_features(src,dst,'CRM',true);    % 100 cores 1
extract_features(src,dst,'GCRM',true);  % 100 cores 1
extract_features(src,dst,'SGRM',true); % 100 cores 1

