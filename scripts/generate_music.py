from faker import Faker
import pandas as pd
import random
from datetime import datetime, timedelta
from faker.providers import BaseProvider

#instancia um objeto da classe Faker para criar emails e nomes falsos
fake = Faker()

#cria uma tabela vazia para iniciar a população
music_df = pd.DataFrame()

#lê um arquivo de dados com nomes reais de músicas e atribui à tabela de dados
df_music = pd.read_csv("dados_originais/tracks.csv")
music_df['titulo'] = df_music['name']

#remove células vazias
music_df.dropna(inplace=True)
#remove músicas cujo titulo não apresenta letras do alfabeto latino
music_df = music_df[music_df['titulo'].str.contains(r'^[A-Za-z ]+$')]

#gera duplicatas aleatórias para que o número de músicas seja igual à 500.000
duplicatas = music_df.sample(n=188686, replace=True)
music_df = music_df.append(duplicatas, ignore_index=True)


#atribui um id aleatorio entre 1 e 50.000 para relacionar uma musica à um artista
music_df['id_artista'] = [random.randint(1,50000) for i in range(len(music_df))]
#gera uma frase curta para ser usada como nome do album
music_df['album'] = [fake.sentence(nb_words=((i%3)+1))[:-1] for i in range(len(music_df))]
#atribui um id aleatorio entre 1 e 115 para relacionar uma musica com um genero
music_df['genero'] = [random.randint(1, 115) for i in range(len(music_df))]
#atribui um float como duracao
music_df['duracao'] = [random.uniform(0.1, 60) for i in range(len(music_df))]

#atribui uma data aleatória de lançamento, com [inicio em 1/1/1200 até a data de hoje.
start_date = datetime.strptime('1200-01-01', '%Y-%m-%d')
end_date = datetime.today()

music_df['data_lancamento'] = [(start_date + timedelta(days=random.randint(0, (end_date - start_date).days))).strftime('%Y-%m-%d') for _ in range(len(music_df))]

#salva em uma tabela de dados intermediária
music_df.to_csv("musicas_dataframe.csv")


#gera o sql musicas.sql com os comandos de INSERT para 500.000 musicas.
with open('musicas.sql', 'w') as f:
    for index, row in music_df.iterrows():
        insert_statement = f"INSERT INTO musicas (id_artista, titulo, album, genero, duracao, data_lancamento) VALUES ('{row['id_artista']}', '{row['titulo']}', '{row['album']}', '{row['genero']}', '{row['duracao']}', '{row['data_lancamento']}' );\n"
        f.write(insert_statement)
