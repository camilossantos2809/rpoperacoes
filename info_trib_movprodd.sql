select
  cast(substr(mprd_cextra1,1,4) as varchar(4)) as cfop,
  mprd_tipo as controle_grade_trib,
	mprd_nextra2 as basecalcicmsst,
	mprd_nextra3 as basecalcicms,
  cast(substr(mprd_cextra1,5,2) as varchar(2)) as cstpis,
  cast(substr(mprd_cextra1,7,2) as varchar(2)) as cstcofins,
  cast(split_part(mprd_cextra2,'&',1) as varchar(3)) as natpiscofins,
  cast(split_part(mprd_cextra2,'&',2) as varchar) as simb_escrita,
  cast(replace(split_part(mprd_cextra4,'[',2),']','') as varchar(3)) as cst_escrita
from 
  movprodd0714
where 
  mprd_simbicms = '17' 
  and mprd_cst = '020' 
  and mprd_datamvto >= '2014-07-01' 
  and mprd_prod_codigo = '21077';
