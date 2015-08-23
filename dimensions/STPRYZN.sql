/*
                           всього
            внутрішнє                       експорт
            внутрішнє               порти           переходи
            внутрішнє               3кр           3кр      СНД
                            станція
*/

exec cwm2_olap_dimension.drop_dimension ('VR_REPORTS', 'RYZN');
commit;
exec cwm2_olap_dimension.create_dimension ('VR_REPORTS', 'PRYZN', 'Призначення', 'Призначення', 'Призначення', 'Призначення');
commit;
exec cwm2_olap_hierarchy.create_hierarchy ('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP', 'Standard', 'Standard', 'Standard','UNSOLVED LEVEL-BASED');
exec cwm2_olap_dimension.set_default_display_hierarchy('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP');
commit;
exec cwm2_olap_level.create_level('VR_REPORTS', 'PRYZN', 'ALL_LVL', 'Всього', 'Всього', 'Всього', 'Всього');
exec cwm2_olap_level.create_level('VR_REPORTS', 'PRYZN', 'VYDSPOL_LVL', 'Сполучення', 'Сполучення', 'Сполучення', 'Сполучення');
exec cwm2_olap_level.create_level('VR_REPORTS', 'PRYZN', 'PORTPEREH_LVL', 'Тип станції', 'Тип станції', 'Тип станції', 'Тип станції');
exec cwm2_olap_level.create_level('VR_REPORTS', 'PRYZN', 'REG_LVL', 'Регіон', 'Регіон', 'Регіон', 'Регіон');
exec cwm2_olap_level.create_level('VR_REPORTS', 'PRYZN', 'STAN_LVL', 'Станція', 'Станція', 'Станція', 'Станція');
commit;
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP','ALL_LVL'); 
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP','VYDSPOL_LVL','ALL_LVL');
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP','PORTPEREH_LVL','VYDSPOL_LVL');
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP','REG_LVL','PORTPEREH_LVL');
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP','STAN_LVL','REG_LVL');
commit;
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP', 'ALL_LVL', 'VR_REPORTS', 'D_STPRYZN', 'VALL');
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP', 'VYDSPOL_LVL', 'VR_REPORTS', 'D_STPRYZN', 'VYDSPOL');
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP', 'PORTPEREH_LVL', 'VR_REPORTS', 'D_STPRYZN', 'PORTPEREH');
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP', 'REG_LVL', 'VR_REPORTS', 'D_STPRYZN', 'REG');
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'PRYZN', 'PRYZN_ROLLUP', 'STAN_LVL', 'VR_REPORTS', 'D_STPRYZN', 'STAN');
commit;
exec dbms_awm.create_awdimload_spec('PRYZN_LOAD', 'VR_REPORTS', 'PRYZN', 'FULL_LOAD');
exec dbms_awm.add_awdimload_spec_filter('PRYZN_LOAD', 'VR_REPORTS', 'PRYZN', 'VR_REPORTS','D_STPRYZN', '' );
commit;
exec CWM2_OLAP_VALIDATE.VALIDATE_DIMENSION('VR_REPORTS', 'PRYZN');
commit;


