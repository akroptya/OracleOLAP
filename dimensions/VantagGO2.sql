-- Cargos

-- long name
exec cwm2_olap_dimension_attribute.create_dimension_attribute('VR_REPORTS', 'VantagGO2', 'Nazva_full', 'Назва', 'Назва', 'Назва');
-- короткое название (Саши)
exec cwm2_olap_dimension_attribute.create_dimension_attribute('VR_REPORTS', 'VantagGO2', 'Nazva_trunc', 'Назва', 'Назва', 'Назва');
commit;
exec cwm2_olap_level_attribute.create_level_attribute('VR_REPORTS', 'VantagGO2', 'Nazva_full', 'ALL_LVL', 'Nazva_full','Назва', 'Назва', 'Назва');
exec cwm2_olap_level_attribute.create_level_attribute('VR_REPORTS', 'VantagGO2', 'Nazva_full', 'VANTAG_LVL', 'Nazva_full','Назва', 'Назва', 'Назва');
commit;
exec cwm2_olap_level_attribute.create_level_attribute('VR_REPORTS', 'VantagGO2', 'Nazva_trunc', 'ALL_LVL', 'Nazva_trunc','Назва', 'Назва', 'Назва');
exec cwm2_olap_level_attribute.create_level_attribute('VR_REPORTS', 'VantagGO2', 'Nazva_trunc', 'VANTAG_LVL', 'Nazva_trunc','Назва', 'Назва', 'Назва');
commit;
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVELATTR('VR_REPORTS', 'VantagGO2', 'Nazva_full', 'VantagGO2_ROLLUP', 'ALL_LVL', 'Nazva_full', 'VR_REPORTS', 'go2_vantag', 'NALL'); 
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVELATTR('VR_REPORTS', 'VantagGO2', 'Nazva_full', 'VantagGO2_ROLLUP', 'VANTAG_LVL', 'Nazva_full', 'VR_REPORTS', 'go2_vantag', 'NNG'); 
commit;
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVELATTR('VR_REPORTS', 'VantagGO2', 'Nazva_trunc', 'VantagGO2_ROLLUP', 'ALL_LVL', 'Nazva_trunc', 'VR_REPORTS', 'go2_vantag', 'VALL'); 
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVELATTR('VR_REPORTS', 'VantagGO2', 'Nazva_trunc', 'VantagGO2_ROLLUP', 'VANTAG_LVL', 'Nazva_trunc', 'VR_REPORTS', 'go2_vantag', 'KNG'); 
commit;

select 1 from dual;


exec cwm2_olap_dimension.drop_dimension ('VR_REPORTS', 'VantagGO2');
commit;
exec cwm2_olap_dimension.create_dimension ('VR_REPORTS', 'VantagGO2', 'Вантаж', 'Вантаж', 'Вантаж', 'Вантаж');
commit;
exec cwm2_olap_hierarchy.create_hierarchy ('VR_REPORTS', 'VantagGO2', 'VantagGO2_ROLLUP', 'Standard', 'Standard', 'Standard','UNSOLVED LEVEL-BASED');
exec cwm2_olap_dimension.set_default_display_hierarchy('VR_REPORTS', 'VantagGO2', 'VantagGO2_ROLLUP');
commit;
exec cwm2_olap_level.create_level('VR_REPORTS', 'VantagGO2', 'ALL_LVL', 'ALL', 'ALL', 'ALL','ALL');
exec cwm2_olap_level.create_level('VR_REPORTS', 'VantagGO2', 'VANTAG_LVL', 'VANTAG', 'VANTAG', 'VANTAG','VANTAG');
commit;
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'VantagGO2', 'VantagGO2_ROLLUP','ALL_LVL'); 
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'VantagGO2', 'VantagGO2_ROLLUP','VANTAG_LVL','ALL_LVL');
commit;
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'VantagGO2', 'VantagGO2_ROLLUP', 'ALL_LVL', 'VR_REPORTS', 'go2_vantag', 'VALL');
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'VantagGO2', 'VantagGO2_ROLLUP', 'VANTAG_LVL', 'VR_REPORTS', 'go2_vantag', 'KNG','VALL');
commit;
exec dbms_awm.create_awdimload_spec('VantagGO2_LOAD', 'VR_REPORTS', 'VantagGO2', 'FULL_LOAD');
exec dbms_awm.add_awdimload_spec_filter('VantagGO2_LOAD', 'VR_REPORTS', 'VantagGO2', 'VR_REPORTS','go2_vantag', '' );
commit;
exec CWM2_OLAP_VALIDATE.VALIDATE_DIMENSION('VR_REPORTS', 'VantagGO2');
commit;
connect vr_reports/vr_reports@uzvr;



set echo on
set linesize 135
set pagesize 50
set serveroutput on size 1000000
execute cwm2_olap_manager.set_echo_on;

