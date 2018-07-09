/*
    Retorna a descrição do Sitef para a bandeira do cartão de acordo o movimento.
    É verificado se a descrição existe ou não na tabela cadbins com base nos campos cdb_descsitef e cdb_dc.
    Pode ser utilizada para cadastrar a descrição das bandeiras no cadastro de bins.
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
