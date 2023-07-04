import pandas as pd 
import random
from datetime import datetime, timedelta
import numpy as np

#lê a tabela de usuários para pegar uma amostra de nomes
df = pd.read_csv("usuarios_dataframe.csv") 
df = df[['username']] 

likes_df = pd.DataFrame() 
#gera uma amostragem aleatoria de 1 milhão de usuários, com repetições
likes_df['username'] = df.sample(n=1000000, replace=True )
print(likes_df)


#este trecho de código atribui para cada usuário, um id de música entre 1 e 500.000
unique_pair = False
likes_df['id_musica'] = [random.randint(1,500000) for i in range(len(likes_df))]

#o loop abaixo verifica se não há duplicatas do par username-id_musica, e se houver, muda o id para evitar o conflito
while unique_pair == False:

    likes_df.drop_duplicates(subset=['username', 'id_musica'], keep='first', inplace=True)
    
    if(len(likes_df) == 1000000):
        break
    else:
    
        to_add = likes_df.sample(n=1000000-len(likes_df), replace=True)
        to_add['id_musica'] = (to_add['id_musica'] % 500000)+1
        print(to_add)
    
        likes_df = pd.concat([likes_df, to_add], ignore_index=True)
        print(likes_df)
        likes_df.drop_duplicates(subset=['username', 'id_musica'], keep='first', inplace=True)
        
        unique_pair = True if len(likes_df) == 1000000 else False



#gera uma data aleatória de curtida, com inicio em 1/1/2010 até a data de hoje.
start_date = datetime.strptime('2010-01-01', '%Y-%m-%d')
end_date = datetime.today()

likes_df['data_curtida'] = [(start_date + timedelta(days=random.randint(0, (end_date - start_date).days))).strftime('%Y-%m-%d') for _ in range(len(likes_df))]


#gera um float aleatŕoio com o tempo de música ouvido 
likes_df['tempo_ouvido'] = [random.uniform(10.0, 500) for i in range(len(likes_df))]


#salva os dados numa tabela intermedíaria
likes_df.to_csv("curtidas_dataframe.csv")

#gera o sql curtidas.sql com os comandos de INSERT para 1.000.000 de curtidas.
with open('curtidas.sql', 'w') as f:
    for index, row in likes_df.iterrows():
        insert_statement = f"INSERT INTO curtidas (username, id_musica, data_curtida, tempo_ouvido) VALUES ('{row['username']}', '{row['id_musica']}','{row['data_curtida']}', '{row['tempo_ouvido']}');\n"
        f.write(insert_statement)