import requests
from urllib.parse import urljoin

"""
Exemplo básico de implementação para utilização do RPServices.

O código abaixo pode ser utilizado também para testar o funcionamento de uma instalação no cliente.

Para consultar os serviços disponíveis na API consultar o link abaixo:
http://servicosflex.rpinfo.com.br:9000/v1.0/documentacao
"""

# Substituir "localhost" pelo endereço que será disponibilizado o serviço
base_url = "http://localhost:9000/v1.0/"

# Usuário e senha cadastrados no FlexDB
usuario = {'usuario': '100001', 'senha': '123456'}

# Necessário criar uma sessão para armazenar os dados de autenticação
sessao = requests.Session()

# Envio de dados ao webservice para autenticação do usuário e senha
sessao.post(urljoin(base_url, "auth"), json=usuario)

# Envio de consulta de dados apos autenticado
unidades = sessao.get(urljoin(base_url, "unidades"))

# Exibição dos resultados obtidos na consulta anterior
print(f"Retorno: {unidades.status_code}-{unidades.text}-{unidades.url}")
