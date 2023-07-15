--C1- CONSULTA 1
--musicas do Ney Matogrosso que comecam com T
SELECT titulo, nome,  album, genero.descricao, duracao, data_lancamento 
FROM artistas NATURAL JOIN musicas INNER JOIN genero ON musicas.genero = genero.id_genero
WHERE nome = 'Ney Matogrosso' AND titulo ILIKE 'T%';

--C2 - CONSULTA 2 
--As musicas koreanas tradicionais mais ouvidas do usuario ----spike----
SELECT titulo, album, genero.descricao AS genero_musica, duracao, data_lancamento, tempo_ouvido
FROM curtidas NATURAL JOIN musicas INNER JOIN genero ON musicas.genero = genero.id_genero
WHERE genero.descricao = 'Forró' AND username = 'whatislife080115'
ORDER BY tempo_ouvido DESC;

--consulta pra ver os usuarios com mais curtidas
SELECT username, COUNT(username) as Curtidas FROM curtidas GROUP BY username ORDER BY Curtidas DESC

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
