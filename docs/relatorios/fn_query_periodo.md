# [fn\_query\_periodo.sql](#fnqueryperiodosql)

Função que cria comando SQL dinâmico concatenando o nome da tabela informada no parâmetro \(movprodd, vdadet, invfisc\) ao mes e ano e gerando a consulta para cada tabela correspondente ao período informado.

Conforme o período solicitado no parâmetro, será gerado um comando SQL dinâmico adicionando um UNION para cada mês de movimento.

A intenção é que essa função seja um utilitário para seu uso em outras funções, ela não foi idealizada para ser executada diretamente no frontend.



