--criacao das tabelas
CREATE TABLE genero(
	genero_id SERIAL NOT NULL,
	genero varchar(50) NOT NULL,
	PRIMARY KEY (genero_id)
);

CREATE TABLE usuarios(
	username varchar(200) NOT NULL,
	nome varchar(150),
	email varchar(150) NOT NULL,
	senha varchar(100) NOT NULL,
	data_nascimento date NOT NULL,
	PRIMARY KEY (username)
);

CREATE TABLE artistas(
	id_artista SERIAL NOT NULL,
	nome varchar(250) NOT NULL,
	nacionalidade varchar(100) NOT NULL,
	descricao varchar(500),
	data_prox_show date,
	data_ult_show date,
	PRIMARY KEY (id_artista)
);

CREATE TABLE musicas(
	id_musica SERIAL NOT NULL,
	id_artista SERIAL NOT NULL,
	titulo varchar(750) NOT NULL,
	album varchar(100) ,
	genero INT NOT NULL,
	duracao float,
	data_lancamento date NOT NULL,
	PRIMARY KEY (id_musica),
	FOREIGN KEY (id_artista) REFERENCES artistas(id_artista),
	FOREIGN KEY (genero) REFERENCES genero(genero_id)
);

CREATE TABLE curtidas(
	username varchar(200) NOT NULL,
	id_musica SERIAL NOT NULL, -- 1 : 500 000
	data_curtida date, 
	tempo_ouvido float,
	PRIMARY KEY (username,id_musica),
	FOREIGN KEY (username) REFERENCES usuarios(username),
	FOREIGN KEY (id_musica) REFERENCES musicas(id_musica)
);