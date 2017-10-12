% cd /home/lgq/BOSS_PPG/code/HILL_C/
% main
% 
% cd ../HILL_CMD_C/
% main
% 
% cd /home/lgq/Workspace/doing/steganalysis/codes/extract_features/

clear all; clc; close all;
% rc = '/home/lgq/BOSS_PPG/BOSS_PPG_CCROP_all/';
% st = '../../data/PPG/CCROP/';
% xtract_features(src,dst,'CRM', true); 
% xtract_features(src,dst,'SGRM', true);  
% extract_features(src,dst,'GCRM', true); 

% 100 cores 1
% 100 cores 2

cd toolbar/CRM
% src = ['/home/lgq/Data/cover'];
% dst = ['../../../../test/cover'];
% CRM(src,dst,10000);
src = ['/home/lgq/Data/qxh/HILL_C/ColorHILL_p10'];
dst = ['../../../../test/HILL_C/ColorHILL_p10'];
CRM(src,dst,10000);
src = ['/home/lgq/Data/qxh/HILL_C/ColorHILL_p20'];
dst = ['../../../../test/HILL_C/ColorHILL_p20'];
CRM(src,dst,10000);
src = ['/home/lgq/Data/qxh/HILL_C/ColorHILL_p30'];
dst = ['../../../../test/HILL_C/ColorHILL_p30'];
CRM(src,dst,10000);
src = ['/home/lgq/Data/qxh/HILL_C/ColorHILL_p40'];
dst = ['../../../../test/HILL_C/ColorHILL_p40'];
CRM(src,dst,10000);
src = ['/home/lgq/Data/qxh/HILL_C/ColorHILL_p50'];
dst = ['../../../../test/HILL_C/ColorHILL_p50'];
CRM(src,dst,10000);
cd ../../

cd ../ensemble/
cover = '../../test/HILL_C/cover.mat';
stego = '../../test/HILL_C/ColorHILL_p10.mat';
log = '../../test/HILL_C/';
ensemble2(cover, stego, log, 1);
cover = '../../test/HILL_C/cover.mat';
stego = '../../test/HILL_C/ColorHILL_p20.mat';
log = '../../test/HILL_C/';
ensemble2(cover, stego, log, 1);
cover = '../../test/HILL_C/cover.mat';
stego = '../../test/HILL_C/ColorHILL_p30.mat';
log = '../../test/HILL_C/';
ensemble2(cover, stego, log, 1);
cover = '../../test/HILL_C/cover.mat';
stego = '../../test/HILL_C/ColorHILL_p40.mat';
log = '../../test/HILL_C/';
ensemble2(cover, stego, log, 1);
cover = '../../test/HILL_C/cover.mat';
stego = '../../test/HILL_C/ColorHILL_p50.mat';
log = '../../test/HILL_C/';
ensemble2(cover, stego, log, 1);
cd ../extract_features/

% cd toolbar/CRM
% src = ['/home/lgq/BOSS_PPG/BOSS_PPG_CCROP_all/BOSS_PPG_CCROP/'];
% dst = ['../../../../data/PPG/CCROP/BOSS_PPG_CCROP_CRM'];
% CRM(src,dst,10000);
% src = ['/home/lgq/BOSS_PPG/BOSS_PPG_CCROP_all/HILL_CMD_C/' ...
%        'BOSS_PPG_CCROP_HILLCMDC_40/'];
% dst = ['../../../../data/PPG/CCROP/HILL_CMD/' ...
%        'BOSS_PPG_CCROP_HILLCMD_40_CRM'];
% CRM(src,dst,10000);
% cd ../../
% 
% cd toolbar/SGRM
% src = ['/home/lgq/BOSS_PPG/BOSS_PPG_CCROP_all/BOSS_PPG_CCROP/'];
% dst = ['../../../../data/PPG/CCROP/BOSS_PPG_CCROP_SGRM'];
% SGRM(src,dst,10000);
% src = ['/home/lgq/BOSS_PPG/BOSS_PPG_CCROP_all/HILL_CMD_C/' ...
%        'BOSS_PPG_CCROP_HILLCMDC_40/'];
% dst = ['../../../../data/PPG/CCROP/HILL_CMD/' ...
%        'BOSS_PPG_CCROP_HILLCMD_40_SGRM'];
% SGRM(src,dst,10000);
% cd ../../
% 
% cd toolbar/GCRM
% src = ['/home/lgq/BOSS_PPG/BOSS_PPG_CCROP_all/BOSS_PPG_CCROP/'];
% dst = ['../../../../data/PPG/CCROP/BOSS_PPG_CCROP_GCRM'];
% GCRM(src,dst,10000);
% src = ['/home/lgq/BOSS_PPG/BOSS_PPG_CCROP_all/HILL_CMD_C/' ...
%        'BOSS_PPG_CCROP_HILLCMDC_40/'];
% dst = ['../../../../data/PPG/CCROP/HILL_CMD/' ...
%        'BOSS_PPG_CCROP_HILLCMD_40_GCRM'];
% GCRM(src,dst,10000);
% cd ../../
