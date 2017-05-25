/*
    Altera o valor de um campo da tvd_registro.
    
    tvd_registro - varchar correspondente ao conteúdo da coluna tvd_registro
    posicao - Índice do elemento que será alterado. Obs: Inicia com 1.
    novo_valor - Novo valor que será atribuído ao elemento.
*/
create or replace function fn_update_tvd_registro(tvd_registro varchar, posicao integer, novo_valor varchar)
returns varchar as $$
declare 
  array_tvd_registro varchar[];
begin
  array_tvd_registro = string_to_array(tvd_registro, '|');
  array_tvd_registro[posicao] = novo_valor;
  return array_to_string(array_tvd_registro, '|');
end;
$$ language plpgsql STRICT;
