
for i=20:20:40
    er=num2str(i);
    cover_1=['../../data/PPG/LAN2/BOSS_PPG_LAN2_CRM.mat'];
    cover_2=['../../data/PPG/BIL/BOSS_PPG_BIL_CRM.mat'];
    cover_3=['../../data/PPG/BIC/BOSS_PPG_BIC_CRM.mat'];

    hillcmdc_1=['../../data/PPG/LAN2/HILL_CMD_C/' ...
              'BOSS_PPG_LAN2_HILLCMDC_' er '_CRM.mat'];
    hillcmdc_2=['../../data/PPG/BIL/HILL_CMD_C/' ...
              'BOSS_PPG_BIL_HILLCMDC_' er '_CRM.mat'];
    hillcmdc_3=['../../data/PPG/BIC/HILL_CMD_C/' ...
              'BOSS_PPG_BIC_HILLCMDC_' er '_CRM.mat'];
    log='../../log/ensemble2/mix/';
    %    ensemble2_mix_3(cover_1,cover_2,cover_3, hillcmdc_1, hillcmdc_2, ...
    %                    hillcmdc_3, log, 1);

    cover_4=['../../data/AHD/LAN2/BOSS_AHD_LAN2_CRM.mat'];
    cover_5=['../../data/AHD/BIL/BOSS_AHD_BIL_CRM.mat'];
    cover_6=['../../data/AHD/BIC/BOSS_AHD_BIC_CRM.mat'];

    hillcmdc_4=['../../data/AHD/LAN2/HILL_CMD_C/' ...
              'BOSS_AHD_LAN2_HILLCMDC_' er '_CRM.mat'];
    hillcmdc_5=['../../data/AHD/BIL/HILL_CMD_C/' ...
              'BOSS_AHD_BIL_HILLCMDC_' er '_CRM.mat'];
    hillcmdc_6=['../../data/AHD/BIC/HILL_CMD_C/' ...
              'BOSS_AHD_BIC_HILLCMDC_' er '_CRM.mat'];
    ensemble2_mix_3(cover_4,cover_5,cover_6, hillcmdc_4, hillcmdc_5, ...
                    hillcmdc_6, log, 1);
    
    ensemble2_mix_2(cover_1,cover_4,hillcmdc_1,hillcmdc_4,log, 1);
    ensemble2_mix_6(cover_1,cover_2,cover_3, cover_4,cover_5,cover_6, ...
                    hillcmdc_1, hillcmdc_2, hillcmdc_3, hillcmdc_4, ...
                    hillcmdc_5, hillcmdc_6, log, 1);
end