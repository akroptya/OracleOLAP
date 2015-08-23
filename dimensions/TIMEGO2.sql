-- Dates
-- hierarchies

exec cwm2_olap_dimension.drop_dimension ('VR_REPORTS', 'TIMEGO2');
commit;
exec cwm2_olap_dimension.create_dimension ('VR_REPORTS', 'TIMEGO2', 'Дата', 'Дата', 'Дата', 'Дата');
commit;
exec cwm2_olap_hierarchy.create_hierarchy ('VR_REPORTS', 'TIMEGO2', 'TIMEGO2_ROLLUP', 'Standard', 'Standard', 'Standard','UNSOLVED LEVEL-BASED');
exec cwm2_olap_dimension.set_default_display_hierarchy('VR_REPORTS', 'TIMEGO2', 'TIMEGO2_ROLLUP');
commit;
exec cwm2_olap_level.create_level('VR_REPORTS', 'TIMEGO2', 'ALL_LVL', 'ALL', 'ALL', 'ALL','ALL');
exec cwm2_olap_level.create_level('VR_REPORTS', 'TIMEGO2', 'TIME_LVL', 'Дата', 'Дата', 'Дата','Дата');
commit;
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'TIMEGO2', 'TIMEGO2_ROLLUP','ALL_LVL'); 
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'TIMEGO2', 'TIMEGO2_ROLLUP','TIME_LVL','ALL_LVL');
commit;
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'TIMEGO2', 'TIMEGO2_ROLLUP', 'ALL_LVL', 'VR_REPORTS', 'daybyday', 'CENT');
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'TIMEGO2', 'TIMEGO2_ROLLUP', 'TIME_LVL', 'VR_REPORTS', 'daybyday', 'MYDAY','CENT');
commit;
exec dbms_awm.create_awdimload_spec('TIMEGO2_LOAD', 'VR_REPORTS', 'TIMEGO2', 'FULL_LOAD');
exec dbms_awm.add_awdimload_spec_filter('TIMEGO2_LOAD', 'VR_REPORTS', 'TIMEGO2', 'VR_REPORTS','daybyday', '' );
commit;
exec CWM2_OLAP_VALIDATE.VALIDATE_DIMENSION('VR_REPORTS', 'TIMEGO2');
commit;

