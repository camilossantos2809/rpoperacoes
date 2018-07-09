/*
    Retorna a descrição do Sitef para a bandeira do cartão de acordo o movimento.
    É verificado se a descrição existe ou não na tabela cadbins com base nos campos cdb_descsitef e cdb_dc.
    Pode ser utilizada para cadastrar a descrição das bandeiras no cadastro de bins.

    Exemplo de retorno:

    wrpdv=# \i cons_descricao_bandeira_tef.sql 
    +--------------+----+------------------+------------+
    | finalizadora | dc |     bandeira     | cadastrado |
    +--------------+----+------------------+------------+
    | 04           | D  | VISA DEBITO      | S          |
    | 04           | D  | NUTRICASH        | N          |
    | 05           | C  | NEUS             | N          |
    | 04           | D  | SODEXO ALIMENTAC | N          |
    | 04           | D  | TICKET ALIMENTAC | N          |
    | 04           | D  | MASTERCARD DEBIT | N          |
    | 05           | C  | MASTERCARD CREDI | N          |
    | 04           | D  | ELO DEBITO       | N          |
    | 04           | D  | ALIMENTACAO      | S          |
    | 05           | C  | VISA CREDITO     | N          |
    | 05           | C  | ELO CREDITO      | N          |
    | 05           | C  | HIPERCARD        | N          |
    +--------------+----+------------------+------------+
    (12 registros)
*/

with bandeiras as (
    select 
        case 
            when split_part(tvd_registro,'|',1) = '04' -- Informar somente o código da finalizadora débito
            then 'D'
            else 'C'
        end as dc,
        split_part(tvd_registro,'|',1) as finalizadora,
        split_part(tvd_registro,'|',49) as bandeira
    from tab_venda_1017
    where
        tvd_tipo_reg like 'FIN%' --Somente logs de finalização de venda
        and split_part(tvd_registro,'|',1) in('04','05') --Códigos das finalizadoras referentes ao cartão
        -- and tvd_unidade = '101'
        -- and cast(tvd_data_hora as date) = '2016-11-28'
    group by 1,2,3
    order by 1,2,3
)
select 
    finalizadora,
    dc,
    bandeira,
    case 
        when cdb_descsitef is null
        then 'N'
        else 'S'
    end as cadastrado
from bandeiras
    left join cadbins
        on (
            lower(bandeira)=lower(cdb_descsitef)
            and dc = cdb_dc
        );
