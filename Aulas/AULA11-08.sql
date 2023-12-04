
-- 3 – Mostrar o total geral de alunos e a média de idade nomeando o total como “Total Alunos” e a média como “Média Alunos”;
SELECT COUNT(ID_ALUNO) AS "TOTAL ALUNOS", 
        ROUND(TRUNC(AVG(IDADE),2), 2) AS "MEDIA ALUNO"
        FROM ALUNO;

-- 4 – Alterar o nome da disciplina “Lógica I” para “Lógica e Algoritmos I”;
UPDATE DISCIPLINA SET NOME_DISCIPLINA = 'Lógica e Algoritmos I'
 --   SELECT * FROM DISCIPLINA
    WHERE NOME_DISCIPLINA = 'Lógica I';

-- 5 – Excluir as avaliações que tiverem nota maior que 10 ou nota negativa;
-- SELECT * FROM ALUNO_AVALIACAO
   DELETE FROM ALUNO_AVALIACAO
    WHERE NOTA > 10 OR NOTA < 0;
COMMIT;

-- 6 – Mostrar todos os alunos (código e nome), suas disciplinas (código e nome) e a média das notas;
/*FROM => PLANO CARTESIANO VEM TODAS AS COMBINAÇÕES 7 ALUNOS E 5 CIDADES = 35 POSSIBILIDADES*/
SELECT * FROM ALUNO A, CIDADE C,/* ALUNO_DISCIPLINA AD,*/ DISCIPLINA D, PROFESSOR P, CIDADE C1, ALUNO_AVALIACAO AL_AV, AVALIACAO AV
    WHERE A.id_cidade = C.id_cidade AND 
        --A.id_aluno = AD.id_aluno AND 
       -- AD.id_disciplina = D.id_disciplina AND
        D.id_professor = P.id_professor AND
        P.id_cidade = C1.id_cidade AND 
        A.id_aluno = AL_AV.id_aluno AND 
        AL_AV.id_avaliacao = AV.id_avaliacao AND
        AV.ID_DISCIPLINA = D.id_disciplina
    ORDER BY A.id_aluno;

-- 7 – Mostrar os professores (nome, cidade), suas disciplinas (nome), os alunos (nome, cidade), a média, maior e menor nota por disciplina.
SELECT A.COD_ALUNO, A.NOME_ALUNO,  D.COD_DISCIPLINA, D.NOME_DISCIPLINA, TRUNC(AVG(NOTA),2) MEDIA, MAX(NOTA) MAIORNOTA, MIN(NOTA) MENORNOTA
    FROM ALUNO A, CIDADE C,/* ALUNO_DISCIPLINA AD,*/ DISCIPLINA D, PROFESSOR P, CIDADE C1, ALUNO_AVALIACAO AL_AV, AVALIACAO AV
    WHERE A.id_cidade = C.id_cidade AND 
        D.id_professor = P.id_professor AND
        P.id_cidade = C1.id_cidade AND 
        A.id_aluno = AL_AV.id_aluno AND 
        AL_AV.id_avaliacao = AV.id_avaliacao AND
        AV.ID_DISCIPLINA = D.id_disciplina
        GROUP BY A.COD_ALUNO, A.NOME_ALUNO,  D.COD_DISCIPLINA, D.NOME_DISCIPLINA
    ORDER BY A.COD_ALUNO, A.NOME_ALUNO,  D.COD_DISCIPLINA, D.NOME_DISCIPLINA;


