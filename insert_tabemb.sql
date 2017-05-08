/*
  Insere os tipos de embalagens dos produtos
  que não existem na tabela tabemb.
*/
insert into tabemb (
  temb_codigo
)
select 
  prod_emb
from 
  produtos
group by 
  prod_emb
having 
  prod_emb not in (
    select temb_codigo
    from tabemb
  );