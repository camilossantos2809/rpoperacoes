
Para executar o script **exemplo_basico_rpservices.py** é necessário seguir os passos abaixo:
1. Instale o **pipenv**: `pip install pipenv`
2. Instale as dependências: `pipenv install`
3. Crie o arquivo `config.ini` e preencha conforme o exemplo abaixo para definir a `url` onde foi instalado o webservice e os dados de autenticação cadastrados no FlexDB.

     [DEFAULT]
     
    base_url = http://localhost:9000/v1.0/
    
    usuario = 100001
    
    senha = 123456

> Ao executar o script conforme o passo 4, caso o arquivo de configuração ainda não exista ele será criado automaticamente.
4. Execute o script: `pipenv run python exemplo_basico_rpservices.py`
