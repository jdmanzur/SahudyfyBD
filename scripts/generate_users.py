import pandas as pd 
from faker import Faker
import random
from datetime import datetime, timedelta



#instancia um objeto da classe Faker para criar emails e nomes falsos
fake = Faker()

#cria uma tabela vazia para iniciar a população
users_df = pd.DataFrame() 


#lê uma base de dados que contém milhares de nomes de usuário
#daqui, são selecionados 250.000 nomes
df = pd.read_csv('dados_originais/users.csv', nrows=250000)

#atribui os nomes à tabela de dados
users_df['username'] = df['author']

#gera o nome falso
users_df['nome'] = [fake.name() for i in range(len(users_df))]
#gera emails falsos
users_df['email'] = [fake.email() for i in range(len(users_df))]
#gera uma senha numérica aleatoria de 4 digitos
users_df['senha'] = [random.randint(1000, 10000) for i in range(len(users_df))]

#gera uma data falsa de nascimento, com inicio em 1/1/1950 até 01/01/2006
start_date = datetime.strptime('1950-01-01', '%Y-%m-%d')
end_date = datetime.strptime('2006-01-01', '%Y-%m-%d')

users_df['data_nascimento'] = [(start_date + timedelta(days=random.randint(0, (end_date - start_date).days))).strftime('%Y-%m-%d') for _ in range(len(users_df))]


#salva numa tabela de dados intermediária.
users_df.to_csv("usuarios_dataframe.csv")


#gera o arquivo sql usuarios.sql, com as claúsulas de INSERT correspondente à inserção de 250000 tuplas de usuário
with open('usuarios.sql', 'w') as f:
    for index, row in users_df.iterrows():
        insert_statement = f"INSERT INTO usuarios (username, nome, email, senha, data_nascimento) VALUES ('{row['username']}', '{row['nome']}','{row['email']}', '{row['senha']}', '{row['data_nascimento']}');\n"
        f.write(insert_statement)