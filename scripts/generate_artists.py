from faker import Faker
import pandas as pd
import random
from datetime import datetime, timedelta
from faker.providers import BaseProvider

#cria uma instancia da classe Faker para gerar dados falsos
fake = Faker()

#configuração dos dados para gerar descrições aleatórias dos artistas
class MusicProvider(BaseProvider):
    def music_sentence(self):
        adjectives = ['melodic', 'harmonious', 'upbeat', 'rhythmic', 'soulful', 'energetic']
        genres = ['rock', 'pop', 'jazz', 'hip hop', 'blues', 'country']
        instruments = ['guitar', 'piano', 'drums', 'violin', 'saxophone', 'trumpet']
        verbs = ['performs', 'plays', 'delivers', 'creates', 'embodies']
        adverbs = ['passionately', 'brilliantly', 'skillfully', 'captivatingly', 'expressively']

        adjective = random.choice(adjectives)
        genre = random.choice(genres)
        instrument = random.choice(instruments)
        verb = random.choice(verbs)
        adverb = random.choice(adverbs)

        sentence_structure = random.choice([
            f"{adjective} {genre} {verb} {adverb} on the {instrument}.",
            f"{adverb.capitalize()}, {genre} {verb} with {adjective} intensity using a {instrument}.",
            f"{adjective.capitalize()} {genre} that {verb} {adverb} with their {instrument}.",
            f"{adverb.capitalize()} {verb} {genre} {adjective}ly with their {instrument}.",
            f"Likes to play the {instrument} very much!",
            f"{verb.capitalize()} cool sounds for {adjective} {genre}."
        ])

        return sentence_structure

fake.add_provider(MusicProvider)



artistas_df = pd.DataFrame()
#lendo arquivo de dados e filtrando o que será usado.
df_music = pd.read_csv("dados_originais/artists.csv")
artistas_df['nome'] = df_music['artist_mb']
artistas_df['nacionalidade'] = df_music['country_mb']

#remove duplicatas para que não existam artistas de mesmo nome.
artistas_df.drop_duplicates(subset='nome', keep='first', inplace=True)
#remove amostras vazias
artistas_df.dropna(inplace=True)


#remove artistas cujo nome excede 250 caracteres
artistas_df = artistas_df[artistas_df['nome'].str.len() <= 250]

#remove artistas cujo nome não contém letras do alfabeto latino
artistas_df = artistas_df[artistas_df['nome'].str.contains(r'^[A-Za-z ]+$')]

#filtra a base de dados para que existam apenas 50.000 artistas na base de dados
#artistas_df = artistas_df[:50000]
artistas_df = artistas_df.sample(n=50000, replace=False)




#gera descrições falsas para os artistas, de acordo com a especificacao dada no começo do código
artistas_df['descricao'] = [fake.music_sentence() for i in range(len(artistas_df))]


#gera datas aleatorias para ultimo e proximo show
today = datetime.now()

artistas_df['data_ult_show'] = [fake.date_between(start_date=today - timedelta(days=365*3), end_date=today) for _ in range(len(artistas_df))]
artistas_df['data_prox_show'] = [fake.date_between(start_date=today, end_date=today + timedelta(days=365*3)) for _ in range(len(artistas_df))]


print(artistas_df.head())

#salva numa tabela intermediaria
artistas_df.to_csv("artistas_dataframe.csv")


with open('artistas.sql', 'w') as f:
    for index, row in artistas_df.iterrows():
        insert_statement = f"INSERT INTO artistas (nome, nacionalidade, descricao, data_ult_show, data_prox_show) VALUES ('{row['nome']}', '{row['nacionalidade']}', '{row['descricao']}', '{row['data_ult_show']}', '{row['data_prox_show']}');\n"
        f.write(insert_statement)
