alter table pogr_go2 add (pokaznyk VARCHAR2(32));
update pogr_go2 set pokaznyk = 'пот.рік' where DT >= to_date('01.01.2005','dd.mm.yyyy');
update pogr_go2 set QG = 65 * CV;
insert into pogr_go2
select DT, KGN, STAN, CV, QG, '+/-' from pogr_go2 where DT >= to_date('01.01.2005','dd.mm.yyyy') 
and pokaznyk = 'пот.рік';
update pogr_go2 set DT = ADD_MONTHS(DT,12) where pokaznyk = 'мин.рік';

 update pogr_go2 a set (a.CV, a.QG) = 
(select decode(c.CV, 0, 0b.CV*100/c.CV, b.QG*100/c.QG
from pogr_go2 b, pogr_go2 c
where
    b.DT = c.DT and b.KGN = c.KGN and b.STAN = c.STAN and b.pokaznyk = 'пот.рік' and
    c.pokaznyk = 'мин.рік' and b.DT = a.DT and b.KGN = a.KGN and b.STAN = a.STAN and rownum < 2
        )
where
    pokaznyk = '%';
    

create index pogr_go2_pokaznyk on pogr_go2 (pokaznyk);
create index pogr_go2_DT on pogr_go2 (DT);
create index pogr_go2_KGNSTAN on pogr_go2 (KGN, STAN);

insert into pogr_go2
select DT, KGN, STAN, 0, 0, 'пот.рік'
from pogr_go2 a
where 
    pokaznyk = 'мин.рік' and
    DT < to_Date('12.05.2005','dd.mm.yyyy') and
    (KGN, STAN) not in (select KGN, STAN from pogr_go2 b where b.pokaznyk = 'пот.рік'
    and b.DT = a.DT);

select * from pogr_go2 order by DT;

delete pogr_go2 where POKAZNYK = '%';

alter table pogr_go2 add (period VARCHAR2(32));
update pogr_go2 set period = 'накоп.з поч.міс.';
insert into pogr_go2
select DT, KGN, STAN, 0, 0, POKAZNYK, 'накоп.повних.міс.'
from pogr_go2;

drop  table pogr_go2;
create table pogr_go2 as
select DT, KGN, STAN, sum(CV) CV from oas_public.pogr_go4@dl_uzi
where DT > to_date('01.01.2004','dd.mm.yyyy')
group by DT, KGN, STAN;

select max(DT) from pogr_go2 where pokaznyk = 'пот.рік';
rollback;

select * from oas_public.pogr_go4@dl_uzi
where DT > to_date('01.01.2004','dd.mm.yyyy');

alter table pogr_go2 add (QG number);
alter table pogr_go2 modify (KGN VARCHAR2(255));
alter table pogr_go2 modify (STAN VARCHAR2(255));

update pogr_go2 a set a.KGN = (select b.NNGT from go2_vantag2 b where b.KNG = a.KGN);
update pogr_go2 a set a.KGN = 'інші' where KGN is null;
update pogr_go2 a set a.STAN = (select nvl(NAME_S, STAN) from go4_styky where CODE = STAN);
commit;

--create table pogr_go22 as
select * from pogr_go2 where DT >= to_date('01.01.2005','dd.mm.yyyy') order by DT;

update pogr_go2 a set a.KGN = 'інші';


exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'GO2','VR_REPORTS', 'SDACHAOBJ');
exec cwm2_olap_table_map.REMOVEMAP_FACTTBL_LEVELKEY('VR_REPORTS', 'GO2','VR_REPORTS', 'pogr_go2');
exec cwm2_olap_table_map.Map_FactTbl_LevelKey('VR_REPORTS', 'GO2','VR_REPORTS', 'pogr_go2', 'LOWESTLEVEL','DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;DIM:VR_REPORTS.SDACHAOBJ/HIER:SDACHAOBJ_ROLLUP/LVL:STAN_LVL/COL:STAN;');
exec cwm2_olap_table_map.Map_FactTbl_Measure('VR_REPORTS', 'GO2','VAGS', 'VR_REPORTS', 'pogr_go2', 'CV','DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;DIM:VR_REPORTS.SDACHAOBJ/HIER:SDACHAOBJ_ROLLUP/LVL:STAN_LVL/COL:STAN;');
exec cwm2_olap_table_map.Map_FactTbl_Measure('VR_REPORTS', 'GO2','TONS', 'VR_REPORTS', 'pogr_go2', 'QG','DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;DIM:VR_REPORTS.SDACHAOBJ/HIER:SDACHAOBJ_ROLLUP/LVL:STAN_LVL/COL:STAN;');

exec cwm2_olap_cube.drop_cube('VR_REPORTS', 'GO2');
commit;
exec cwm2_olap_cube.create_cube('VR_REPORTS', 'GO2', 'Куб ГО2', 'Куб ГО2', 'Куб ГО2');
commit;
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'GO2','VR_REPORTS', 'VantagGO2');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'GO2','VR_REPORTS', 'TIMEGO2');
commit;
exec cwm2_olap_measure.create_measure('VR_REPORTS', 'GO2', 'VAGS', 'вагон2','вагонів', 'вагонів');
exec cwm2_olap_measure.create_measure('VR_REPORTS', 'GO2', 'TONS', 'тон2','тис.тон', 'тон');
commit;
exec cwm2_olap_table_map.Map_FactTbl_LevelKey('VR_REPORTS', 'GO2','VR_REPORTS', 'pogr_go2', 'LOWESTLEVEL','DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;');
commit;
exec cwm2_olap_table_map.Map_FactTbl_Measure('VR_REPORTS', 'GO2','VAGS', 'VR_REPORTS', 'pogr_go2', 'CV','DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;');
exec cwm2_olap_table_map.Map_FactTbl_Measure('VR_REPORTS', 'GO2','TONS', 'VR_REPORTS', 'pogr_go2', 'QG','DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;');
commit;
exec CWM2_OLAP_VALIDATE.VALIDATE_CUBE('VR_REPORTS', 'GO2');
commit;
connect vr_reports/vr_reports@uzvr;


-- Cube with destination stations
exec cwm2_olap_cube.drop_cube('VR_REPORTS', 'CUBE01');
commit;
exec cwm2_olap_cube.create_cube('VR_REPORTS', 'CUBE01', 'Куб', 'Куб', 'Куб');
commit;
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE01','VR_REPORTS', 'VantagGO2');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE01','VR_REPORTS', 'TIMEGO2');
exec cwm2_olap_cube.add_dimension_to_cube('VR_REPORTS', 'CUBE01','VR_REPORTS', 'PRYZN');
commit;
exec cwm2_olap_measure.create_measure('VR_REPORTS', 'CUBE01', 'VAGS01', 'вагон01','вагонів01', 'вагонів01');
exec cwm2_olap_measure.create_measure('VR_REPORTS', 'CUBE01', 'TONS01', 'тон01','тис.тон01', 'тон01');
commit;
begin
cwm2_olap_table_map.Map_FactTbl_LevelKey('VR_REPORTS', 'CUBE01','VR_REPORTS', 'pogr_go2_1', 
    'LOWESTLEVEL',
    'DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;DIM:VR_REPORTS.PRYZN/HIER:PRYZN_ROLLUP/LVL:STAN_LVL/COL:STAN;');
end;
/
commit;
exec cwm2_olap_table_map.Map_FactTbl_Measure('VR_REPORTS', 'CUBE01','VAGS01', 'VR_REPORTS', 'pogr_go2_1', 'CV','DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;DIM:VR_REPORTS.PRYZN/HIER:PRYZN_ROLLUP/LVL:STAN_LVL/COL:STAN;');
exec cwm2_olap_table_map.Map_FactTbl_Measure('VR_REPORTS', 'CUBE01','TONS01', 'VR_REPORTS', 'pogr_go2_1', 'QG','DIM:VR_REPORTS.VantagGO2/HIER:VantagGO2_ROLLUP/LVL:VANTAG_LVL/COL:KGN;DIM:VR_REPORTS.TIMEGO2/HIER:TIMEGO2_ROLLUP/LVL:TIME_LVL/COL:DT;DIM:VR_REPORTS.PRYZN/HIER:PRYZN_ROLLUP/LVL:STAN_LVL/COL:STAN;');
commit;
exec CWM2_OLAP_VALIDATE.VALIDATE_CUBE('VR_REPORTS', 'CUBE01');
commit;


create table go2go4fact as
select DOR, DT, KGN, STAN, sum(CV) CV from oas_public.pogr_go4@dl_uzi
where DT > to_date('01.01.2004','dd.mm.yyyy')
group by DT, KGN, STAN;

select * from go2go4fact;

select a.DT, a.DOR, a.KGN, a.STAN, sum(a.CV) CV, sum(b.CV) CVp 
from
    (select distinct DT, DOR, KGN, STAN, 0 CV  from oas_public.pogr_go4@dl_uzi
    union all 
    select DT, DOR, KGN, STAN, CV  from oas_public.pogr_go4@dl_uzi) a,
    (select distinct DT, DOR, KGN, STAN, 0 CV  from oas_public.pogr_go4@dl_uzi
    union all 
    select DT, DOR, KGN, STAN, CV  from oas_public.pogr_go4@dl_uzi) b
where 
    a.DT > to_date('01.01.2004','dd.mm.yyyy') and
    b.DT > to_date('01.01.2004','dd.mm.yyyy') and
    to_char(a.DT,'dd.mm') = to_char(b.DT,'dd.mm') and
    a.DT = ADD_MONTHS(b.DT,-12)
group by a.DT, a.DOR, a.KGN, a.STAN;
    
select distinct DT, DOR, KGN, STAN, 0 CV  from oas_public.pogr_go4@dl_uzi;   

