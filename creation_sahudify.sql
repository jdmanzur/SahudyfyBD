-- para apagar as coisas
DROP TABLE curtidas;
DROP TABLE musicas;
DROP TABLE artistas;
DROP TABLE usuarios;
DROP TABLE genero;

-- funcoes legais
SELECT pg_database_size('sahudify_definitivo');
SELECT pg_size_pretty( pg_database_size('sahudify_definitivo'));
SELECT pg_size_pretty(pg_total_relation_size('curtidas'));

--criacao das tabelas
CREATE TABLE genero(
	id_genero SERIAL NOT NULL,
	descricao varchar(50) NOT NULL,
	PRIMARY KEY (id_genero)
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
	FOREIGN KEY (genero) REFERENCES genero(id_genero)
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
-----------------------------------------------------

--checando se os campos estao corretos
select * from genero; -- OK 115
select * from usuarios; -- OK 250K
select * from artistas; -- OK 50K
select * from musicas; -- OK 500K
select * from curtidas; -- OK 1M!!

--C2 - CONSULTA 2 
--As musicas koreanas tradicionais mais ouvidas do usuario ----spike----
SELECT titulo, album, genero.descricao AS genero_musica, duracao, data_lancamento, tempo_ouvido
FROM curtidas NATURAL JOIN musicas INNER JOIN genero ON musicas.genero = genero.id_genero
WHERE genero.descricao = 'Forró' AND username = 'whatislife080115'
ORDER BY tempo_ouvido DESC;


--consulta pra ver os usuarios com mais curtidas
SELECT username, COUNT(username) as Curtidas FROM curtidas GROUP BY username ORDER BY Curtidas DESC

--C1- CONSULTA 1
--musicas do Ney Matogrosso que comecam com T
SELECT titulo, nome,  album, genero.descricao, duracao, data_lancamento 
FROM artistas NATURAL JOIN musicas INNER JOIN genero ON musicas.genero = genero.id_genero
WHERE nome = 'Ney Matogrosso' AND titulo ILIKE 'T%';


--C3 - CONSULTA 3
--ordena as mais curtidas dos que vao ter um show entre a data especificada
SELECT titulo, album, nome AS nome_artista, data_prox_show, curtidas_totais
FROM (
SELECT *
FROM musicas 
NATURAL JOIN 
    (SELECT id_musica, COUNT(id_musica) AS curtidas_totais FROM curtidas GROUP BY id_musica) AS get_count
 NATURAL JOIN 
(SELECT id_artista, nome, data_prox_show FROM artistas WHERE data_prox_show >= '01-01-2025' AND data_prox_show <= '01-01-2028') AS get_artista
-- ordena por curtidas totais
ORDER BY curtidas_totais DESC) AS musicas_artistas;
-- limita em 25 musicas
--LIMIT 25;
