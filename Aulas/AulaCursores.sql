--Cursores

set serveroutput on;

create or replace procedure Lista_cidades (PREFIXO IN VARCHAR2) is
    CURSOR cs_cidade(COD_PREF VARCHAR2) is 
        Select * From CIDADE 
        WHERE NOME_CIDADE LIKE UPPER(PREFIXO)||'%'
        ORDER BY cod_cidade;
    total NUMBER;
Begin
    --OPEN cs_cidade;
   -- FETCH cs_cidade INTO v_cidade;
    For v_cidade in cs_cidade LOOP
        DBMS_OUTPUT.PUT_LINE('Código: ' || v_cidade.cod_cidade || ' Nome: ' || v_cidade.nome_cidade);
        SELECT COUNT(*) INTO TOTAL FROM CIDADE;
        DBMS_OUTPUT.PUT_LINE('TOTAL: ' || TOTAL);
    END LOOP;
    
   -- CLOSE cs_cidade;
End;

EXEC Lista_cidades('B');

create or replace procedure Lista_cidades_pessoas (p_cod_cidade IN VARCHAR2) is
    CURSOR cs_alunos(v_id_cidade NUMBER) is 
        Select * From ALUNO
        WHERE id_cidade = v_id_cidade;
    CURSOR cs_professor(v_id_cidade NUMBER) is 
        Select * From PROFESSOR
        WHERE id_cidade = v_id_cidade;
    v_cidade cidade%ROWTYPE;
Begin
    Select * INTO v_cidade From Cidade Where cod_cidade = p_cod_cidade;
    DBMS_OUTPUT.PUT_LINE(v_cidade.nome_cidade);
    For rProfessor in cs_professor(v_cidade.id_cidade) LOOP
        DBMS_OUTPUT.PUT_LINE('Prof. ' || rProfessor.nome_professor || ' Cod: '|| rProfessor.id_professor);
    END LOOP;
    For rAluno in cs_alunos(v_cidade.id_cidade) LOOP
        DBMS_OUTPUT.PUT_LINE(rAluno.nome_aluno || ' Cod: '|| rAluno.cod_professor);
    END LOOP;
End;

