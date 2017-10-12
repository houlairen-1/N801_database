
for i=20:20:40
    er=num2str(i);
    cover=['../../data/PPG/LAN2/BOSS_PPG_LAN2_CRM.mat'];
    hillc=['../../data/PPG/LAN2/HILL_C/' ...
           'BOSS_PPG_LAN2_HILLC_' er '_CRM.mat'];
    hillcmdc=['../../data/PPG/LAN2/HILL_CMD_C/' ...
              'BOSS_PPG_LAN2_HILLCMDC_' er '_CRM.mat'];
    suniwardc=['../../data/PPG/LAN2/SUNIWARD_C/' ...
               'BOSS_PPG_LAN2_SUNIWARDC_' er '_CRM.mat'];
    suniwardcmdc=['../../data/PPG/LAN2/SUNIWARD_CMD_C/' ...
                  'BOSS_PPG_LAN2_SUNIWARDC_CMD_' er '_CRM.mat'];
    log='../../log/ensemble2/PPG/LAN2/CvsS1andS2/';
    ensemble2_CvsS1andS2(cover, hillcmdc, hillc, log, 1);
    ensemble2_CvsS1andS2(cover, hillcmdc, suniwardc, log, 1);
    ensemble2_CvsS1andS2(cover, hillcmdc, suniwardcmdc, log, 1);
    
    ensemble2_CvsS1andS2(cover, hillc, hillcmdc, log, 1);
    %    ensemble2_CvsS1andS2(cover, hillc, suniwardc, log, 1);
    %    ensemble2_CvsS1andS2(cover, hillc, suniwardcmdc, log, 1);
    
end