exec cwm2_olap_dimension.drop_dimension ('VR_REPORTS', 'ODVYM');
commit;
exec cwm2_olap_dimension.create_dimension ('VR_REPORTS', 'ODVYM', 'Одиниці виміру', 'Одиниці виміру', 'Одиниці виміру', 'Одиниці виміру');
commit;
exec cwm2_olap_hierarchy.create_hierarchy ('VR_REPORTS', 'ODVYM', 'ODVYM_ROLLUP', 'Standard', 'Standard', 'Standard','UNSOLVED LEVEL-BASED');
exec cwm2_olap_dimension.set_default_display_hierarchy('VR_REPORTS', 'ODVYM', 'ODVYM_ROLLUP');
commit;
exec cwm2_olap_level.create_level('VR_REPORTS', 'ODVYM', 'ALL_LVL', '-', '-', '-', '-');
exec cwm2_olap_level.create_level('VR_REPORTS', 'ODVYM', 'ODVYM_LVL', 'Одиниця виміру', 'Одиниця виміру', 'Одиниця виміру', 'Одиниця виміру');
commit;
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'ODVYM', 'ODVYM_ROLLUP','ALL_LVL'); 
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'ODVYM', 'ODVYM_ROLLUP','ODVYM_LVL','ALL_LVL');
commit;
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'ODVYM', 'ODVYM_ROLLUP', 'ALL_LVL', 'VR_REPORTS', 'go2_ODVYM', 'VALL');
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'ODVYM', 'ODVYM_ROLLUP', 'ODVYM_LVL', 'VR_REPORTS', 'go2_ODVYM', 'odyn');
commit;
exec dbms_awm.create_awdimload_spec('ODVYM_LOAD', 'VR_REPORTS', 'ODVYM', 'FULL_LOAD');
exec dbms_awm.add_awdimload_spec_filter('ODVYM_LOAD', 'VR_REPORTS', 'ODVYM', 'VR_REPORTS','go2_ODVYM', '' );
commit;
exec CWM2_OLAP_VALIDATE.VALIDATE_DIMENSION('VR_REPORTS', 'ODVYM');
commit;


update pogr_go2_2 set QG = QG / 1000 where ODYN != 'вагонів';


/*
New cube with measures - current year, last year
*/
exec cwm2_olap_cube.drop_cube('VR_REPORTS', 'CUBE02');
commit;
exec cwm2_olap_cube.create_cube('VR_REPORTS', 'CUBE02', 'Куб', 'Куб', 'Куб');
commit;
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE02','VR_REPORTS', 'VantagGO2');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE02','VR_REPORTS', 'TIMEGO2');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE02','VR_REPORTS', 'PRYZN');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE02','VR_REPORTS', 'ODVYM');
commit;
exec cwm2_olap_measure.create_measure('VR_REPORTS', 'CUBE02', 'POTRIK', 'пот.рік','пот.рік', 'пот.рік');
exec cwm2_olap_measure.create_measure('VR_REPORTS', 'CUBE02', 'MYNRIK', 'мин.рік','мин.рік', 'мин.рік');
commit;
begin
cwm2_olap_table_map.Map_FactTbl_LevelKey('VR_REPORTS', 'CUBE02','VR_REPORTS', 'pogr_go2_2', 
    'LOWESTLEVEL',
    'DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;DIM:VR_REPORTS.PRYZN/HIER:PRYZN_ROLLUP/LVL:STAN_LVL/COL:STAN;'||
    'DIM:VR_REPORTS.ODVYM/HIER:ODVYM_ROLLUP/LVL:ODVYM_LVL/COL:odyn;');
end;
/
commit;
exec cwm2_olap_table_map.Map_FactTbl_Measure('VR_REPORTS', 'CUBE02','POTRIK', 'VR_REPORTS', 'pogr_go2_2', 'CV','DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;DIM:VR_REPORTS.PRYZN/HIER:PRYZN_ROLLUP/LVL:STAN_LVL/COL:STAN;DIM:VR_REPORTS.ODVYM/HIER:ODVYM_ROLLUP/LVL:ODVYM_LVL/COL:odyn;');
exec cwm2_olap_table_map.Map_FactTbl_Measure('VR_REPORTS', 'CUBE02','MYNRIK', 'VR_REPORTS', 'pogr_go2_2', 'QG','DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;DIM:VR_REPORTS.PRYZN/HIER:PRYZN_ROLLUP/LVL:STAN_LVL/COL:STAN;DIM:VR_REPORTS.ODVYM/HIER:ODVYM_ROLLUP/LVL:ODVYM_LVL/COL:odyn;');
commit;
exec CWM2_OLAP_VALIDATE.VALIDATE_CUBE('VR_REPORTS', 'CUBE02');
commit;


/*
AW
*/
exec dbms_awm.create_awdimension('VR_REPORTS', 'ODVYM', 'VR_REPORTS','AW1', 'ODVYM_AW1');
commit;
exec dbms_awm.refresh_awdimension('VR_REPORTS', 'AW1', 'ODVYM_AW1', 'ODVYM_LOAD');
commit;
exec dbms_awm.create_awcube('VR_REPORTS', 'CUBE02','VR_REPORTS', 'AW1','CUBE02_AW1');
commit;
exec dbms_awm.refresh_awcube('VR_REPORTS', 'AW1', 'CUBE02_AW1');
commit;
exec dbms_awm.CREATE_AWDIMENSION_ACCESS_FULL(2, 'VR_REPORTS', 'AW1', 'ODVYM_AW1', 'OLAP');
commit;
exec dbms_awm.CREATE_AWCUBE_ACCESS_FULL(4, 'VR_REPORTS', 'AW1', 'CUBE02_AW1', 'OLAP');
commit;
exec CWM2_OLAP_VERIFY_ACCESS.VERIFY_CUBE_ACCESS('VR_REPORTS', 'CUBE02_AW1');
commit;
connect vr_reports/vr_reports@uzvr;


/*
dimension Відправлення
*/
select * from go4_dor_ukr;
create view go4_dor_ukr as
select rownum-1 pp1, a.* from go4_dor a
where K_ADM = 22;

exec cwm2_olap_dimension.drop_dimension ('VR_REPORTS', 'VIDPR');
commit;
exec cwm2_olap_dimension.create_dimension ('VR_REPORTS', 'VIDPR', 'Відправлення', 'Відправлення', 'Відправлення', 'Відправлення');
commit;
exec cwm2_olap_hierarchy.create_hierarchy ('VR_REPORTS', 'VIDPR', 'VIDPR_ROLLUP', 'Standard', 'Standard', 'Standard','UNSOLVED LEVEL-BASED');
exec cwm2_olap_dimension.set_default_display_hierarchy('VR_REPORTS', 'VIDPR', 'VIDPR_ROLLUP');
commit;
exec cwm2_olap_level.create_level('VR_REPORTS', 'VIDPR', 'ALL_LVL', '-', '-', '-', '-');
exec cwm2_olap_level.create_level('VR_REPORTS', 'VIDPR', 'VIDPR_LVL', 'Відправлення', 'Відправлення', 'Відправлення', 'Відправлення');
commit;
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'VIDPR', 'VIDPR_ROLLUP','ALL_LVL'); 
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'VIDPR', 'VIDPR_ROLLUP','VIDPR_LVL','ALL_LVL');
commit;
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'VIDPR', 'VIDPR_ROLLUP', 'ALL_LVL', 'VR_REPORTS', 'go4_dor_ukr', 'K_GOS');
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'VIDPR', 'VIDPR_ROLLUP', 'VIDPR_LVL', 'VR_REPORTS', 'go4_dor_ukr', 'NU_DOR');
commit;
exec dbms_awm.create_awdimload_spec('VIDPR_LOAD', 'VR_REPORTS', 'VIDPR', 'FULL_LOAD');
exec dbms_awm.add_awdimload_spec_filter('VIDPR_LOAD', 'VR_REPORTS', 'VIDPR', 'VR_REPORTS','go4_dor_ukr', '' );
commit;
exec CWM2_OLAP_VALIDATE.VALIDATE_DIMENSION('VR_REPORTS', 'VIDPR');
commit;


/*
dimension Період
*/
select * from go2_period;
drop view go2_period;
create view go2_period as
select  np, '-' vall from
(SELECT 'за добу' np  from dual union all
SELECT 'накопичення з початку місяця' np  from dual union all
SELECT 'нак. повні місяці з початку року' np from dual);


exec cwm2_olap_dimension.drop_dimension ('VR_REPORTS', 'PERIOD');
commit;
exec cwm2_olap_dimension.create_dimension ('VR_REPORTS', 'PERIOD', 'Період', 'Період', 'Період', 'Період');
commit;
exec cwm2_olap_hierarchy.create_hierarchy ('VR_REPORTS', 'PERIOD', 'PERIOD_ROLLUP', 'Standard', 'Standard', 'Standard','UNSOLVED LEVEL-BASED');
exec cwm2_olap_dimension.set_default_display_hierarchy('VR_REPORTS', 'PERIOD', 'PERIOD_ROLLUP');
commit;
exec cwm2_olap_level.create_level('VR_REPORTS', 'PERIOD', 'ALL_LVL', '-', '-', '-', '-');
exec cwm2_olap_level.create_level('VR_REPORTS', 'PERIOD', 'PERIOD_LVL', 'Період', 'Період', 'Період', 'Період');
commit;
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'PERIOD', 'PERIOD_ROLLUP','ALL_LVL'); 
exec cwm2_olap_level.add_level_to_hierarchy('VR_REPORTS', 'PERIOD', 'PERIOD_ROLLUP','PERIOD_LVL','ALL_LVL');
commit;
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'PERIOD', 'PERIOD_ROLLUP', 'ALL_LVL', 'VR_REPORTS', 'go2_PERIOD', 'VALL');
exec cwm2_olap_table_map.MAP_DIMTBL_HIERLEVEL('VR_REPORTS', 'PERIOD', 'PERIOD_ROLLUP', 'PERIOD_LVL', 'VR_REPORTS', 'go2_PERIOD', 'np');
commit;
exec dbms_awm.create_awdimload_spec('PERIOD_LOAD', 'VR_REPORTS', 'PERIOD', 'FULL_LOAD');
exec dbms_awm.add_awdimload_spec_filter('PERIOD_LOAD', 'VR_REPORTS', 'PERIOD', 'VR_REPORTS','go2_PERIOD', '' );
commit;
exec CWM2_OLAP_VALIDATE.VALIDATE_DIMENSION('VR_REPORTS', 'PERIOD');
commit;


/*
Новий куб з dimensions - PERIOD, VIDPR
*/
exec cwm2_olap_cube.drop_cube('VR_REPORTS', 'CUBE03');
commit;
exec cwm2_olap_cube.create_cube('VR_REPORTS', 'CUBE03', 'Куб', 'Куб', 'Куб');
commit;
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE03','VR_REPORTS', 'VantagGO2');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE03','VR_REPORTS', 'TIMEGO2');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE03','VR_REPORTS', 'PRYZN');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE03','VR_REPORTS', 'ODVYM');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE03','VR_REPORTS', 'VIDPR');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE03','VR_REPORTS', 'PERIOD');
commit;
exec cwm2_olap_measure.create_measure('VR_REPORTS', 'CUBE03', 'POTRIK', 'пот.рік','пот.рік', 'пот.рік');
exec cwm2_olap_measure.create_measure('VR_REPORTS', 'CUBE03', 'MYNRIK', 'мин.рік','мин.рік', 'мин.рік');
commit;
begin
cwm2_olap_table_map.Map_FactTbl_LevelKey('VR_REPORTS', 'CUBE03','VR_REPORTS', 'pogr_go2_3', 
    'LOWESTLEVEL',
    'DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;'||
    'DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;'||
    'DIM:VR_REPORTS.PRYZN/HIER:PRYZN_ROLLUP/LVL:STAN_LVL/COL:STAN;'||
    'DIM:VR_REPORTS.ODVYM/HIER:ODVYM_ROLLUP/LVL:ODVYM_LVL/COL:odyn;'||
    'DIM:VR_REPORTS.VIDPR/HIER:VIDPR_ROLLUP/LVL:VIDPR_LVL/COL:DOR;'||
    'DIM:VR_REPORTS.PERIOD/HIER:PERIOD_ROLLUP/LVL:PERIOD_LVL/COL:period;');
end;
/
commit;
begin
    cwm2_olap_table_map.Map_FactTbl_Measure('VR_REPORTS', 'CUBE03','POTRIK', 'VR_REPORTS', 
    'pogr_go2_3', 'CV',
    'DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;'||
    'DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;'||
    'DIM:VR_REPORTS.PRYZN/HIER:PRYZN_ROLLUP/LVL:STAN_LVL/COL:STAN;'||
    'DIM:VR_REPORTS.ODVYM/HIER:ODVYM_ROLLUP/LVL:ODVYM_LVL/COL:odyn;'||
    'DIM:VR_REPORTS.VIDPR/HIER:VIDPR_ROLLUP/LVL:VIDPR_LVL/COL:DOR;'||
    'DIM:VR_REPORTS.PERIOD/HIER:PERIOD_ROLLUP/LVL:PERIOD_LVL/COL:period;');
end;
/
begin
    cwm2_olap_table_map.Map_FactTbl_Measure('VR_REPORTS', 'CUBE03','MYNRIK', 'VR_REPORTS', 
    'pogr_go2_3', 'QG',
    'DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;'||
    'DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;'||
    'DIM:VR_REPORTS.PRYZN/HIER:PRYZN_ROLLUP/LVL:STAN_LVL/COL:STAN;'||
    'DIM:VR_REPORTS.ODVYM/HIER:ODVYM_ROLLUP/LVL:ODVYM_LVL/COL:odyn;'||
    'DIM:VR_REPORTS.VIDPR/HIER:VIDPR_ROLLUP/LVL:VIDPR_LVL/COL:DOR;'||
    'DIM:VR_REPORTS.PERIOD/HIER:PERIOD_ROLLUP/LVL:PERIOD_LVL/COL:period;');
end;
/
commit;
exec CWM2_OLAP_VALIDATE.VALIDATE_CUBE('VR_REPORTS', 'CUBE03');
commit;

exec cwm2_olap_cube.drop_cube('VR_REPORTS', 'CUBE03_AW1');

exec dbms_awm.create_awdimension('VR_REPORTS', 'VIDPR', 'VR_REPORTS','AW1', 'VIDPR_AW1');
exec dbms_awm.create_awdimension('VR_REPORTS', 'PERIOD', 'VR_REPORTS','AW1', 'PERIOD_AW1');
commit;
exec dbms_awm.refresh_awdimension('VR_REPORTS', 'AW1', 'VIDPR_AW1', 'VIDPR_LOAD');
exec dbms_awm.refresh_awdimension('VR_REPORTS', 'AW1', 'PERIOD_AW1', 'PERIOD_LOAD');
commit;

exec dbms_awm.create_awcube('VR_REPORTS', 'CUBE03','VR_REPORTS', 'AW1','CUBE03_AW1');
commit;
exec dbms_awm.refresh_awcube('VR_REPORTS', 'AW1', 'CUBE03_AW1');
commit;
exec dbms_awm.CREATE_AWDIMENSION_ACCESS_FULL(2, 'VR_REPORTS', 'AW1', 'VIDPR_AW1', 'OLAP');
exec dbms_awm.CREATE_AWDIMENSION_ACCESS_FULL(3, 'VR_REPORTS', 'AW1', 'PERIOD_AW1', 'OLAP');
commit;
exec dbms_awm.CREATE_AWCUBE_ACCESS_FULL(4, 'VR_REPORTS', 'AW1', 'CUBE03_AW1', 'OLAP');
commit;
exec CWM2_OLAP_VERIFY_ACCESS.VERIFY_CUBE_ACCESS('VR_REPORTS', 'CUBE03_AW1');
commit;
connect vr_reports/vr_reports@uzvr;

