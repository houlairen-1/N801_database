
clear all; clc; close all;
src = '/home/lgq/BOSS_AHD/BOSS_AHD_LAN2_all/';
dst = '../../data/AHD/LAN2/';
extract_features(src,dst,'CRM', false); 

src = '/home/lgq/BOSS_AHD/BOSS_AHD_BIC_all/';
dst = '../../data/AHD/BIC/';
extract_features(src,dst,'CRM', false); 
% extract_features(src,dst,'SGRM', true);  
% extract_features(src,dst,'GCRM', true); 

src = '/home/lgq/BOSS_AHD/BOSS_AHD_BIL_all/';
dst = '../../data/AHD/BIL/';
extract_features(src,dst,'CRM', false); 

cd ../ensemble/
auto_mix
% cover = '../../test/HILL_C/cover.mat';
% stego = '../../test/HILL_C/ColorHILL_p10.mat';
% log = '../../test/HILL_C/';
% ensemble2(cover, stego, log, 1);
% cover = '../../test/HILL_C/cover.mat';
% stego = '../../test/HILL_C/ColorHILL_p20.mat';
% log = '../../test/HILL_C/';
% ensemble2(cover, stego, log, 1);
% cover = '../../test/HILL_C/cover.mat';
% stego = '../../test/HILL_C/ColorHILL_p30.mat';
% log = '../../test/HILL_C/';
% ensemble2(cover, stego, log, 1);
% cover = '../../test/HILL_C/cover.mat';
% stego = '../../test/HILL_C/ColorHILL_p40.mat';
% log = '../../test/HILL_C/';
% ensemble2(cover, stego, log, 1);
% cover = '../../test/HILL_C/cover.mat';
% stego = '../../test/HILL_C/ColorHILL_p50.mat';
% log = '../../test/HILL_C/';
% ensemble2(cover, stego, log, 1);
% cd ../extract_features/