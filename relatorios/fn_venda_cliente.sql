/*
    Realiza uma consulta da movimentação dos clientes por cupom em determinado período

    Parâmetros:
        data_inicial = Data inicial do período consultado
        data_final = Data final do período consultado
        cod_cliente = Irá realizar a consulta referente ao código do cliente informado.
        Se informado 0 (zero) consulta todos os clientes.
    
    Retorno:
        Retorna um conjunto de linhas contendo as movimentações de venda por cupom.
        As colunas seguem a estrutura do FlexDB (tabela vdadet)
    
    Obs:
        Essa função utiliza a fn_query_periodo() disponível no repositório:
        https://github.com/camilossantos2809/rpoperacoes/blob/master/relatorios/fn_query_periodo.sql
*/
create or replace function utils.fn_venda_cliente(
    data_inicial date,
    data_final date,
    cod_cliente numeric
)
returns table (
     vdet_cnpjcpf varchar(14),
     clie_codigo numeric(8,0),
     clie_nome varchar(80),
     prod_codigo numeric(8,0),
     prod_descricao varchar(40),
     vdet_datamvto date,
     vdet_unid_codigo varchar(3),
     vdet_qtde numeric(10,3),
     vdet_valor numeric(12,3),
     vdet_valordesc numeric(12,3),
     vdet_valoracfin numeric(12,3),
     vdet_oferta varchar(1),
     vdet_codfi varchar(3),
     vdet_pdv varchar(3),
     vdet_cupom varchar(8),
     vdet_hora varchar(4)
)
language plpgsql
as $$
declare
  vFiltroCliente text;
begin
    vFiltroCliente='';
    if cod_cliente<>0 then
        vFiltroCliente=format('and clie_codigo=%s',cod_cliente);
    else
        vFiltroCliente='and clie_codigo is not null';
    end if;
return query
  execute utils.fn_query_periodo(
      'vdadet',
      $1,
      $2,
      format(E'left join clientes
        on (vdet_cnpjcpf=clie_cnpjcpf)
        inner join produtos
        on (vdet_prod_codigo=prod_codigo)
        where vdet_status=\'N\' %s', vFiltroCliente),
        array['vdet_cnpjcpf','clie_codigo','clie_nome','prod_codigo','prod_descricao','vdet_datamvto',
        'vdet_unid_codigo','vdet_qtde', 'vdet_valor','vdet_valordesc','vdet_valoracfin','vdet_oferta',
        'vdet_codfi','vdet_pdv','vdet_cupom','vdet_hora'],
        true
    )
    using data_inicial,data_final;
return;
end
$$;