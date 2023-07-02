-- para apagar as coisas
DROP TABLE curtidas;
DROP TABLE musicas;
DROP TABLE artistas;
DROP TABLE usuarios;
DROP TABLE generos;

-- funcoes legais
SELECT pg_database_size('sahudify_definitivo');
SELECT pg_size_pretty( pg_database_size('empresa'));
SELECT pg_size_pretty(pg_total_relation_size('artistas'));

--criacao das tabelas
CREATE TABLE genero(
	genero_id SERIAL NOT NULL,
	genero varchar(50) NOT NULL,
	PRIMARY KEY (genero_id)
);

CREATE TABLE usuarios(
	username varchar(100) NOT NULL,
	nome varchar(50),
	email varchar(50) NOT NULL,
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
	username varchar(100) NOT NULL,
	id_musica SERIAL NOT NULL,
	data_curtida date,
	tempo_ouvido float,
	PRIMARY KEY (username,id_musica),
	FOREIGN KEY (username) REFERENCES usuarios(username),
	FOREIGN KEY (id_musica) REFERENCES musicas(id_musica)
);
-----------------------------------------------------

--checando se os campos estao corretos
select * from genero; -- OK 115
select * from usuarios;
select * from artistas; -- OK 250K
select * from musicas; -- OK 700K
select * from curtidas;

--consultas
--As musicas pop mais ouvidas do usuario omega
SELECT titulo, album, genero, duracao, data_lancamento, tempo_ouvido
FROM curtidas NATURAL JOIN musicas
WHERE genero = 'Pop' AND username = 'omega'
ORDER BY tempo_ouvido DESC;

--musicas da taylor que comecam com E
SELECT titulo, album, genero, duracao, data_lancamento 
FROM artistas NATURAL JOIN musicas 
WHERE nome = 'Taylor Swift'  AND titulo ILIKE 'E%';

--ordena as mais curtidas dos que vao ter um show entre a data especificada
SELECT titulo, album, genero, duracao, data_lancamento, curtidas_totais
FROM (
SELECT *
FROM musicas 
NATURAL JOIN 
    (SELECT id_musica, COUNT(id_musica) AS curtidas_totais FROM curtidas GROUP BY id_musica) AS get_count
 NATURAL JOIN 
(SELECT id_artista FROM artistas WHERE data_prox_show >= '01-01-2023' AND data_prox_show <= '01-01-2024') AS get_artista
-- ordena por curtidas totais
ORDER BY curtidas_totais DESC) AS musicas_artistas
-- limita em 25 musicas
LIMIT 25;
