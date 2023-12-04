SET SERVEROUTPUT ON;
/*
declare
v_nota aluno_avaliacao.nota%TYPE;
v_alunos aluno%ROWTYPE;


begin
    SELECT MAX(N.nota) INTO v_nota
    FROM Aluno_Avaliacao N;
    
    SELECT MIN(id_aluno) INTO v_alunos.id_aluno FROM Aluno_Avaliacao
    WHERE nota = v_nota;
    
    SELECT A.nome_aluno, A.cod_aluno
    INTO v_alunos.nome_aluno, v_alunos.cod_aluno
    FROM Aluno A
    WHERE a.id_aluno =  v_alunos.id_aluno ;

    DBMS_OUTPUT.PUT_LINE('Maior Nota: ' || v_nota); 
    DBMS_OUTPUT.PUT_LINE('Nome Aluno: ' || v_alunos.nome_aluno); 

end;*/

--- Estrutura Record

/*
declare 
    TYPE t_aluno IS RECORD(
        cod_aluno aluno.cod_aluno%type,
        nome_aluno aluno.nome_aluno%type
    );
    v_aluno t_aluno;
BEGIN 
    select cod_aluno, nome_aluno
        into v_aluno.cod_aluno, v_aluno.nome_aluno
        from aluno
        where id_aluno = 1;
        
    DBMS_OUTPUT.PUT_LINE(v_aluno.cod_aluno); 
END;

*/


-- Tabuada do 5
declare 
    tab_5 integer;
    cont integer := 1;
begin

    WHILE cont <= 10 LOOP
        tab_5 :=  5 * cont;
        cont := cont + 1;
        DBMS_OUTPUT.PUT_LINE(tab_5);      
    END LOOP;
end;

-- Criar um bloco PL/SQL anônimo para imprimir as tabuadas para os números 1 ao 10.

declare
    tab integer;

begin
    
    For tabuada IN 1 .. 10 LOOP
        For multiplicador IN 1 .. 10 LOOP
            tab := tabuada * multiplicador;
            dbms_output.put_line(tab);
        END LOOP;
    END LOOP;

end;
    

-- Criar um bloco PL/SQL para apresentar os anos bissextos entre 2000 e 2100. Um ano será bissexto quando for possível dividi?lo por 4, mas não por 100 ou quando for possível dividi?lo por 400.


DECLARE
    ano INTEGER := 2000;
BEGIN
    WHILE ano <= 2100 LOOP
        IF ((MOD(ano, 4) = 0 AND MOD(ano, 100) != 0) OR MOD(ano, 400) = 0) THEN
            dbms_output.put_line(ano);
        END IF;
        ano := ano + 1;
    END LOOP;
END;


-- Criar um bloco PL/SQL para imprimir a sequência de Fibonacci: 1  1  2  3  5  8  13  21  34  55.

DECLARE
    anterior INTEGER := 0;
    proximo INTEGER;
    aux INTEGER := 1;
BEGIN
    FOR cont IN 0 .. 100 LOOP
        dbms_output.put_line(aux);
        proximo := anterior + aux;
        anterior := aux;
        aux :=proximo;
    END LOOP;
    
END;

