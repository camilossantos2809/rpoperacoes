/*
    Retorna um código de controle tributário que ainda não existe no cadastro
*/
create or replace function migracao.fn_gerar_cod_controle_trib()
returns varchar(6) as $$
declare
    cod_existentes varchar[];
    novo_controle integer = 1;
begin
    -- Gera uma lista com os códigos existentes
    select array_agg(trib_controle)
    into cod_existentes
    from tributacao;

    -- Incrementa a variável "novo_controle" até que o número gerado não esteja na listagem de códigos existentes
    while lpad(novo_controle::varchar(6), 6, '0') = any(cod_existentes) loop
        novo_controle = novo_controle + 1;
    end loop;

    return lpad(novo_controle::varchar(6), 6, '0');
end;
$$ language plpgsql;


select migracao.fn_gerar_cod_controle_trib();
/*
Exemplo de retorno
┌────────────────────────────┐
│ fn_gerar_cod_controle_trib │
├────────────────────────────┤
│ 000033                     │
└────────────────────────────┘
*/