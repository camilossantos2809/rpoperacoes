import configparser
import json
import os
import sys
from urllib.parse import urljoin

import requests


"""
Exemplo básico de implementação para utilização do RPServices.

O código abaixo pode ser utilizado também para testar o funcionamento de uma instalação no cliente.

Para consultar os serviços disponíveis na API consultar o link abaixo:
http://servicosflex.rpinfo.com.br:9000/v1.0/documentacao
"""


def get_config():
    '''
    Realiza as operações necessárias para leitura do arquivo de configurações config.ini
    '''
    config = configparser.ConfigParser()
    if not os.path.exists('config.ini'):
        print('Arquivo config.ini não encontrado... será gerado um arquivo com formato pré-definido...')
        config['DEFAULT'] = {
            'base_url': "http://localhost:9000/v1.0/",
            'usuario': '100000',
            'senha': '123456'
        }
        with open('config.ini', 'w') as configfile:
            config.write(configfile)
        print('Arquivo config.ini criado com formato pré-definido, por favor, altere os parâmetros e execute o script novamente.\n')
        sys.exit()
    config.read('config.ini')
    return config


# variável que possuirá os parâmetros definidos em config.ini
config = get_config()

# Endereço que será disponibilizado o serviço
base_url = config['DEFAULT']['base_url']

# Usuário externo e senha cadastrados no FlexDB
usuario = {
    'usuario': config['DEFAULT']['usuario'],
    'senha': config['DEFAULT']['senha']
}

# Necessário criar uma sessão para armazenar os dados de autenticação
sessao = requests.Session()

# Envio de dados ao webservice para autenticação do usuário e senha
sessao.post(urljoin(base_url, "auth"), json=usuario)

# Envio de consulta de dados apos autenticado
# Para esse exemplo serão consultados os dados do cadastro de unidades/lojas
unidades = sessao.get(urljoin(base_url, "unidades"))

# Exibição dos resultados obtidos na consulta anterior
print(json.dumps(json.loads(unidades.text), indent=2))
