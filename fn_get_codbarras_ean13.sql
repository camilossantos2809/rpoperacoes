/*
    Retorna o código informado no parâmetro no formato EAN13 válido.

    Exemplos:
        select fn_get_codbarras_ean13('1');
        Resultado: 0000000000017

        select fn_get_codbarras_ean13('978858057290');
        Resultado: 9788580572902
*/
create or replace function fn_get_codbarras_ean13(p_codbarras varchar(12))
returns varchar(13) as $$
declare
    v_soma integer;
    v_digitos smallint[12];
    v_DV smallint;
begin
    --Verifica a quantidade de dígitos informados no parâmetro da função
    if length(p_codbarras) > 12 then
        raise exception 'O valor informado no parâmetro possui mais do que 12 dígitos';
    end if;

    --Formata o valor do parâmetro com zeros à esquerda e o converte em um array
    v_digitos := string_to_array(lpad(p_codbarras,12,'0'), null);
    
    --É somado cada elemento do array, caso ele esteja num índice par o valor será 
    --multiplicado por 3 antes de ser somado.
    for i in 1..12 loop
        if mod(i,2) = 0 then
            v_soma := coalesce(v_soma, 0) + (v_digitos[i] * 3);
        else
            v_soma := coalesce(v_soma, 0) + v_digitos[i];
        end if;
    end loop;

    --O resultado da subtração de 10 pela sobra da divisão da soma dos dígitos 
    --por 10 é o dígito verificador
    v_DV = 10 - mod(v_soma, 10);
    if v_DV = 10 then
        v_DV := 0;
    end if;
    
    --É retornado o código de barras concatenado ao dígito verificador
    return array_to_string(v_digitos, '') || v_DV;
end
$$ language plpgsql volatile strict;
