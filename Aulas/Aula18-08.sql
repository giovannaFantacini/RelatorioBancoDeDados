/*declare 
Num number;
CodAluno aluno.cod_aluno%Type;

begin
    Num := 2;
    DBMS_OUTPUT.PUT_LINE('Num: ' || Num); 
end;

*/

/*select nvl(nota, -1) from aluno_avaliacao;
update aluno_avaliacao
    set nota = 4
    where id_aluno_avaliacao = 1;
    commit;
*/
-- select to_char(sysdate, 'Day/MONTH/YYYY HH:MM:SS') from dual;
/*
declare 
Tot_alunos number;
Max_cod aluno.cod_aluno%Type;

BEGIN
    SELECT COUNT(A.ID_ALUNO), MAX(A.COD_ALUNO)
        INTO Tot_alunos, Max_cod
        FROM ALUNO A, CIDADE C
        WHERE A.ID_CIDADE = C.ID_CIDADE
            AND upper(C.NOME_CIDADE) = 'BIRIGUI';
            
    DBMS_OUTPUT.PUT_LINE('Total Alunos: ' || Tot_alunos); 
    DBMS_OUTPUT.PUT_LINE('Max Cod: ' || Max_cod); 
END;
*/

/*
declare 
nome_professor professor.nome_professor%TYPE;
nome_cidade cidade.nome_cidade%TYPE;
*/

/*
declare 
nome_professor varchar2(10);
nome_cidade varchar2(10);
*/

SET SERVEROUTPUT ON

declare 
v_professor PROFESSOR%ROWTYPE;
v_cidade CIDADE%ROWTYPE;

BEGIN
    SELECT P.nome_professor, C.nome_cidade
        INTO v_professor.nome_professor, v_cidade.nome_cidade
        FROM PROFESSOR P, CIDADE C
        WHERE P.ID_CIDADE = C.ID_CIDADE
            AND p.cod_professor = 'P003';
            
   DBMS_OUTPUT.PUT_LINE('NOME PROFESSOR: ' || v_professor.nome_professor); 
   DBMS_OUTPUT.PUT_LINE('CIDADE PROFESSOR: ' || v_cidade.nome_cidade); 
END;



/*
declare
    v_Tipo_Idade VARCHAR2(20);
    v_Idade aluno.idade%type;
    v_id_aluno aluno.id_aluno%type;
    

begin
    v_id_aluno := 1;
    Select A.idade 
        INTO v_Idade
        FROM ALUNO A
        WHERE A.ID_ALUNO = v_id_aluno;
    
    IF v_Idade <= 5 THEN 
        v_Tipo_Idade := 'Criança';
    ELSIF v_Idade < 18 THEN
        v_Tipo_Idade := 'Adolescente';
    ELSE 
        v_Tipo_Idade := 'Adulto';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Idade aluno: ' || v_Idade); 
    DBMS_OUTPUT.PUT_LINE('O aluno é ' || v_Tipo_Idade); 
end;

*/














