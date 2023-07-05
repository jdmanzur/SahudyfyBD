##### Este trabalho foi realizado pelo Grupo 1:
Bruno Fritoli Carrazza - RA: 770993
Jade Manzur de Almeida - RA: 771025
Vitor Kenzo Fukuhara Pellegatti - RA: 771066

---

## Estrutura do diretório

Abaixo está a estrutura do diretório atual. 
Dentro da pasta scripts, temos os scripts de criação dos dados, esses funcionam a partir de bases de dados originais retiradas da internet.
Dentro da pasta populações, temos os scripts .sql de população das tabelas individuais.
Os arquivos criar_tabelas.sql e backup_banco.sql são os arquivos para restaurar o banco de dados criado.


SBD_2023.1_G1_bruno_jade_vitor.zip/ \
├─ scripts/ \
│  ├─ generate_artists.py \
│  ├─ generate_musics.py \
│  ├─ generate_users.py \
│  ├─ generate_likes.py \
│ \
├─ populacoes/ \
│  ├─ generos.sql \
│  ├─ artistas.sql \
│  ├─ musicas.sql \
│  ├─ curtidas.sql \
│  ├─ usuarios.sql \
│ \
├─ backup_banco.sql \
├─ criar_tabelas.sql 



## Passo a Passo da Execução do Backup

- Criar uma base de dados nova no PostgreSQL
- Usar a funcionalidade Restore com o arquivo backup_banco.sql  
- Se necessário, usar o script criar_tabelas e inserir os dados das tabelas através dos scripts disponíveis em /populacoes.

## Passo a Passo da Execução dos Scripts

Passo a passo de execução dos scripts de python:

- baixar a bibloteca faker do python
   - pip install faker
- Rodar os srcipts na seguinte ordem:
   - generate_artists.py
   - generate_musics.py
   - generate_users.py
   - generate_likes.py
- Cada um dos scripts gera uma tabela de dados em .csv e o arquivo de backup correspondente.
- Os dados originais a partir dos quais geramos a base de dados final estão disponíveis no github (https://github.com/jdmanzur/SahudyfyBD), dentro do arquivo dados_originais.zip

## Tamanho das Tabelas

Tamanho das tabelas em registros e bytes:

- generos: 115 registros = 24 kB
- artistas: 50 mil de registros = 7056 kB
- musicas: 500 mil de registros = 52 MB
- usuarios: 250 mil de registros = 31 MB
- curtidas: 1 milhão de registros = 100 MB

O banco esta com um total de 198 MB de dados
