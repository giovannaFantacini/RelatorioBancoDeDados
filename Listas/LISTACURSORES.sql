
set serveroutput on;

DROP TABLE DEPARTAMENTOS;
DROP TABLE EMPREGADOS;

CREATE TABLE DEPARTAMENTOS(
    Codigo Number(3) NOT NULL CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY,
    Descricao Varchar(30));

CREATE TABLE EMPREGADOS (
    Codigo Number(5) NOT NULL CONSTRAINT PK_EMPREGADO PRIMARY KEY,
    Nome Varchar(50),
    Sobrenome Varchar(50),
    Data_Nascimento Date,
    Data_Admissao Date,
    Data_Rescisao Date,
    Salario Number(9,2),
    Profissao Varchar(40),
    Depto Number(3),
    CONSTRAINT FK_DEPARTAMENTO_EMPREGADO FOREIGN KEY (DEPTO) REFERENCES DEPARTAMENTOS);
    
INSERT INTO Departamentos (Codigo, Descricao) VALUES (1, 'Departamento A');
INSERT INTO Departamentos (Codigo, Descricao) VALUES (2, 'Departamento B');
INSERT INTO Departamentos (Codigo, Descricao) VALUES (3, 'Departamento C');

INSERT INTO Empregados (Codigo, Nome, Sobrenome, Data_Nascimento, Data_Admissao, Data_Rescisao, Salario, Profissao, Depto)
VALUES (101, 'Joao', 'Silva', TO_DATE('1980-01-15', 'YYYY-MM-DD'), TO_DATE('2020-05-10', 'YYYY-MM-DD'), NULL, 5000.00, 'Analista', 1);
INSERT INTO Empregados (Codigo, Nome, Sobrenome, Data_Nascimento, Data_Admissao, Data_Rescisao, Salario, Profissao, Depto)
VALUES (102, 'Maria', 'Souza', TO_DATE('1985-07-20', 'YYYY-MM-DD'), TO_DATE('2019-11-22', 'YYYY-MM-DD'), NULL, 6000.00, 'Engenheiro', 2);
INSERT INTO Empregados (Codigo, Nome, Sobrenome, Data_Nascimento, Data_Admissao, Data_Rescisao, Salario, Profissao, Depto)
VALUES (103, 'Carlos', 'Fernandes', TO_DATE('1990-03-08', 'YYYY-MM-DD'), TO_DATE('2021-02-05', 'YYYY-MM-DD'), NULL, 5500.00, 'Programador', 3);



-- Mostrar todos os nomes de funcionários em letras maiúsculas, sobrenome em minúsculas.

CREATE OR REPLACE PROCEDURE SP_MOSTRA_EMPREGADOS IS
  CURSOR C_EMPREGADO IS
      SELECT * FROM EMPREGADOS WHERE Data_Rescisao IS NULL;  
BEGIN
    FOR REG_EMPREGADO IN C_EMPREGADO LOOP
        DBMS_OUTPUT.PUT_LINE(UPPER(REG_EMPREGADO.NOME) || ' ' || LOWER(REG_EMPREGADO.SOBRENOME));
    END LOOP;
END;

EXEC SP_MOSTRA_EMPREGADOS;

-- Verificar se existem aniversariantes no mês, se sim mostrar a quantidade e os nomes e sobrenomes dos aniversariantes; se não, mostrar “nenhum aniversariante neste mês”.

CREATE OR REPLACE PROCEDURE SP_MOSTRA_ANIVERSARIANTES IS
  CURSOR C_EMPREGADO IS
      SELECT NOME, SOBRENOME, COUNT(*) AS QTD_ANIVERSARIANTES
      FROM EMPREGADOS WHERE EXTRACT(MONTH FROM Data_Nascimento) = EXTRACT(MONTH FROM SYSDATE)
      GROUP BY NOME, SOBRENOME;  
    v_encontrou_registros BOOLEAN := FALSE;
BEGIN
    FOR REG_EMPREGADO IN C_EMPREGADO LOOP
        DBMS_OUTPUT.PUT_LINE(REG_EMPREGADO.NOME|| ' ' || REG_EMPREGADO.SOBRENOME||
      ' - Quantidade de aniversariantes: ' || REG_EMPREGADO.QTD_ANIVERSARIANTES);
      
      v_encontrou_registros := TRUE;
    END LOOP;
    IF NOT v_encontrou_registros THEN
      DBMS_OUTPUT.PUT_LINE('Nenhum aniversariante neste mês.');
    END IF;
END;

EXEC SP_MOSTRA_ANIVERSARIANTES;

 INSERT INTO EMPREGADOS (Codigo, Nome, Sobrenome, Data_Nascimento, Data_Admissao, Data_Rescisao, Salario, Profissao, Depto)
  VALUES (104, 'Giovanna', 'Teste', TO_DATE('1980-11-15', 'YYYY-MM-DD'), SYSDATE, NULL, 7000.00, 'Testador', 1);


-- Receber um valor e trazer nome,data_admissao,salario de todos os empregados que ganhem acima deste valor.

CREATE OR REPLACE PROCEDURE SP_MOSTRA_SALARIO(VALOR NUMBER) IS
  CURSOR C_EMPREGADO IS
      SELECT NOME, Data_Admissao, Salario
      FROM EMPREGADOS WHERE Salario >= VALOR;         
BEGIN
    FOR REG_EMPREGADO IN C_EMPREGADO LOOP
            DBMS_OUTPUT.PUT_LINE(REG_EMPREGADO.NOME|| ' DATA ADMISSAO: ' || REG_EMPREGADO.Data_Admissao||
          ' R$' || REG_EMPREGADO.Salario);
    END LOOP;
END;

DECLARE
    VALOR NUMBER := 5500.00;
BEGIN 
  SP_MOSTRA_SALARIO(VALOR); 
END;

-- Idem a anterior, mas trazer também a descrição do departamento em que trabalha.

CREATE OR REPLACE PROCEDURE SP_MOSTRA_SALARIO_DETALHES(VALOR EMPREGADOS.Salario%TYPE) IS
  CURSOR C_EMPREGADO IS
      SELECT E.NOME, E.Data_Admissao, E.Salario, D.Descricao
      FROM EMPREGADOS E, DEPARTAMENTOS D WHERE Salario >= VALOR and E.DEPTO = D.CODIGO;         
BEGIN
    FOR REG_EMPREGADO IN C_EMPREGADO LOOP
            DBMS_OUTPUT.PUT_LINE(REG_EMPREGADO.NOME|| ' DATA ADMISSAO: ' || REG_EMPREGADO.Data_Admissao||
          ' R$' || REG_EMPREGADO.Salario || ' DESCRIÇÃO: ' || REG_EMPREGADO.Descricao);
    END LOOP;
END;

DECLARE
    VALOR NUMBER := 5500.00;
BEGIN 
  SP_MOSTRA_SALARIO_DETALHES(VALOR); 
END;


--  Receber o código do departamento e traga a média de salário de cada departamento.

CREATE OR REPLACE PROCEDURE SP_MEDIA_SALARIO_DEPARTAMENTO(CODIGO EMPREGADOS.Depto%TYPE) IS
  V_MEDIA_SALARIO FLOAT;
  CURSOR C_DEPTO IS
      SELECT * FROM DEPARTAMENTOS;         
BEGIN
   FOR depto_rec IN C_DEPTO LOOP
    SELECT AVG(Salario) INTO V_MEDIA_SALARIO
    FROM Empregados WHERE Depto = depto_rec.Codigo;
    DBMS_OUTPUT.PUT_LINE('Departamento: ' || depto_rec.CODIGO || ', Média de Salário: ' || V_MEDIA_SALARIO);
  END LOOP;
END;

EXEC SP_MEDIA_SALARIO_DEPARTAMENTO(3);

-- Receber o código do departamento e mostre a descrição do depto. o nome do empregado e a quantos meses o empregado trabalha na empresa.

CREATE OR REPLACE PROCEDURE SP_EMPREGADOS_POR_DEPARTAMENTO(P_CODIGO EMPREGADOS.Depto%TYPE) IS
  CURSOR C_EMPREGADO IS
      SELECT NOME, Data_Admissao FROM EMPREGADOS WHERE DEPTO = P_CODIGO;         
  V_DESCRICAO DEPARTAMENTOS.DESCRICAO%TYPE;
BEGIN
    SELECT DESCRICAO 
    INTO V_DESCRICAO 
    FROM DEPARTAMENTOS D WHERE D.CODIGO = P_CODIGO;
    DBMS_OUTPUT.PUT_LINE('Departamento:' || V_DESCRICAO );
   FOR REG_EMPREGADO IN C_EMPREGADO LOOP
    DBMS_OUTPUT.PUT_LINE(REG_EMPREGADO.NOME || ' MESES TRABALHADOS: ' || ROUND(MONTHS_BETWEEN(SYSDATE, REG_EMPREGADO.DATA_ADMISSAO), 0));
  END LOOP;
END;

EXEC SP_EMPREGADOS_POR_DEPARTAMENTO(1);

-- Mostrar todos os empregados demitidos, e quantos meses estes trabalharam na empresa

CREATE OR REPLACE PROCEDURE SP_EMPREGADOS_DEMITIDOS IS
  CURSOR C_EMPREGADO IS
      SELECT NOME, Data_Admissao, Data_Rescisao FROM EMPREGADOS WHERE Data_Rescisao IS NOT NULL;         
BEGIN
   FOR REG_EMPREGADO IN C_EMPREGADO LOOP
    DBMS_OUTPUT.PUT_LINE(REG_EMPREGADO.NOME || ' MESES TRABALHADOS: ' || ROUND(MONTHS_BETWEEN(REG_EMPREGADO.DATA_Rescisao, REG_EMPREGADO.DATA_ADMISSAO), 0));
  END LOOP;
END;

INSERT INTO Empregados (Codigo, Nome, Sobrenome, Data_Nascimento, Data_Admissao, Data_Rescisao, Salario, Profissao, Depto)
VALUES (105, 'Ana', 'Silva', TO_DATE('1985-09-15', 'YYYY-MM-DD'), TO_DATE('2020-07-10', 'YYYY-MM-DD'), TO_DATE('2023-11-27', 'YYYY-MM-DD'), 6000.00, 'Analista', 2);
INSERT INTO Empregados (Codigo, Nome, Sobrenome, Data_Nascimento, Data_Admissao, Data_Rescisao, Salario, Profissao, Depto)
VALUES (106, 'Mariana', 'Oliveira', TO_DATE('1992-12-21', 'YYYY-MM-DD'), TO_DATE('2022-04-18', 'YYYY-MM-DD'), TO_DATE('2023-11-27', 'YYYY-MM-DD'), 5000.00, 'Desenvolvedor', 1);

EXEC SP_EMPREGADOS_DEMITIDOS;

--  Receber uma porcentagem e recalcule o salário de todos os funcionários que estão empregados, mostrando na tela o seu nome, salário atual e salário projetado.

CREATE OR REPLACE PROCEDURE SP_EMPREGADOS_AJUSTE_SALARIO(PORCENTAGEM_AJUSTE FLOAT) IS
  CURSOR C_EMPREGADO IS
      SELECT NOME, SALARIO FROM EMPREGADOS WHERE Data_Rescisao IS NULL;  
  V_AJUSTE FLOAT;
BEGIN
   V_AJUSTE := (PORCENTAGEM_AJUSTE/100) + 1;
   FOR REG_EMPREGADO IN C_EMPREGADO LOOP
    DBMS_OUTPUT.PUT_LINE(REG_EMPREGADO.NOME || ' Salario atual: ' || REG_EMPREGADO.salario || ' Salario Projetado: ' || ROUND(REG_EMPREGADO.salario*V_AJUSTE, 2));
  END LOOP;
END;

EXEC SP_EMPREGADOS_AJUSTE_SALARIO(50);

-- Mostrar na tela o nome do funcionário, seu salário e sua contribuição ao imposto de renda. IMPORTANTE: Você deverá utilizar a função criada no exercício 1.

CREATE OR REPLACE PROCEDURE SP_EMPREGADOS_IR IS
  CURSOR C_EMPREGADO IS
      SELECT NOME, SALARIO FROM EMPREGADOS WHERE Data_Rescisao IS NULL;  
  CONTRIBUICAO FLOAT;
BEGIN
   FOR REG_EMPREGADO IN C_EMPREGADO LOOP
     IF REG_EMPREGADO.salario <= 1164 THEN
        CONTRIBUICAO := 0;
    ELSIF REG_EMPREGADO.salario <= 2326 THEN
        CONTRIBUICAO := 0.15;
    ELSE
        CONTRIBUICAO := 0.275;
    END IF;
    DBMS_OUTPUT.PUT_LINE(REG_EMPREGADO.NOME || ' Salario: ' || REG_EMPREGADO.salario || ' Contribuição IR: ' || ROUND(REG_EMPREGADO.salario*CONTRIBUICAO, 2));
  END LOOP;
END;

EXEC SP_EMPREGADOS_IR;

-- Receber o mês e mostrar os nomes dos funcionários admitidos e demitidos neste mês

CREATE OR REPLACE PROCEDURE SP_MES_EMPREGADOS_DEMITIDOS(V_MESSELECIONADO INTEGER) IS
  CURSOR C_EMPREGADO IS
      SELECT NOME, DATA_ADMISSAO, DATA_RESCISAO FROM EMPREGADOS 
      WHERE EXTRACT(MONTH FROM Data_Rescisao) = V_MESSELECIONADO OR
      EXTRACT(MONTH FROM Data_ADMISSAO) = V_MESSELECIONADO;  
BEGIN
   FOR REG_EMPREGADO IN C_EMPREGADO LOOP
     IF REG_EMPREGADO.DATA_RESCISAO IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(REG_EMPREGADO.NOME || ' DEMITIDO');
    ELSE
        DBMS_OUTPUT.PUT_LINE(REG_EMPREGADO.NOME || ' CONTRATADO');
    END IF;
  END LOOP;
END;

EXEC SP_MES_EMPREGADOS_DEMITIDOS(5);
EXEC SP_MES_EMPREGADOS_DEMITIDOS(4);

-- Mostrar todos os meses, e para cada um deles, o número de demitidos e contratados
CREATE OR REPLACE PROCEDURE SP_MES_ADMITIDOS_DEMITIDOS IS
  CURSOR C_EMPREGADO IS
      SELECT
            TO_CHAR(MONTH_START_DATE, 'YYYY-MM') AS Mes,
            COUNT(CASE WHEN Data_Admissao IS NOT NULL THEN 1 END) AS Contratados,
            COUNT(CASE WHEN Data_Rescisao IS NOT NULL THEN 1 END) AS Demitidos
        FROM
            (
                SELECT
                    TRUNC(Data_Admissao, 'MONTH') AS MONTH_START_DATE,
                    Data_Admissao,
                    Data_Rescisao
                FROM
                    Empregados
                WHERE
                    Data_Admissao IS NOT NULL
                    OR Data_Rescisao IS NOT NULL
            )
        GROUP BY
            TO_CHAR(MONTH_START_DATE, 'YYYY-MM')
        ORDER BY
            TO_CHAR(MONTH_START_DATE, 'YYYY-MM');
BEGIN
   FOR REG_EMPREGADO IN C_EMPREGADO LOOP
     DBMS_OUTPUT.PUT_LINE('MÊS: ' || REG_EMPREGADO.MES || ' CONTRATADOS: ' || REG_EMPREGADO.Contratados ||
     ' DEMITIDOS: ' || REG_EMPREGADO.Demitidos);
  END LOOP;
END;

EXEC SP_MES_ADMITIDOS_DEMITIDOS;

-- Criar um procedure que mostre o total de funcionários empregados, total bruto da folha de pagamento e 
-- total de descontos da folha de pagamento (descontos referentes a IR)
CREATE OR REPLACE PROCEDURE SP_RELATORIO_EMPREGADOS IS
  CURSOR C_EMPREGADO IS
      SELECT
            COUNT(CODIGO) AS TOTAL_FUNCIONARIOS,
            SUM(SALARIO) AS SOMA_SALARIO,
            SUM(CASE 
                WHEN SALARIO <= 1164 THEN 0
                WHEN SALARIO <= 2326 THEN SALARIO*0.15
                ELSE SALARIO*0.275
              END)AS SOMA_CONTRIBUICAO
        FROM  EMPREGADOS   
        WHERE Data_Rescisao IS NULL;
BEGIN
   FOR REG_EMPREGADO IN C_EMPREGADO LOOP
     DBMS_OUTPUT.PUT_LINE('TOTAL FUNCIONARIOS: ' || REG_EMPREGADO.TOTAL_FUNCIONARIOS
     || ' SOMA SALARIOS: ' || REG_EMPREGADO.SOMA_SALARIO ||
     ' SOMA CONTRIBUIÇÃO: ' || REG_EMPREGADO.SOMA_CONTRIBUICAO);
  END LOOP;
END;

EXEC SP_RELATORIO_EMPREGADOS;

-- Criar uma função que receba o número do mês e retorne o nome deste.
CREATE OR REPLACE FUNCTION NOME_DO_MES(V_NUMERO_MES IN NUMBER) RETURN VARCHAR2 IS
    V_NOME_MES VARCHAR2(30);
BEGIN
    CASE V_NUMERO_MES
        WHEN 1 THEN V_NOME_MES := 'Janeiro';
        WHEN 2 THEN V_NOME_MES := 'Fevereiro';
        WHEN 3 THEN V_NOME_MES := 'Março';
        WHEN 4 THEN V_NOME_MES := 'Abril';
        WHEN 5 THEN V_NOME_MES := 'Maio';
        WHEN 6 THEN V_NOME_MES := 'Junho';
        WHEN 7 THEN V_NOME_MES := 'Julho';
        WHEN 8 THEN V_NOME_MES := 'Agosto';
        WHEN 9 THEN V_NOME_MES := 'Setembro';
        WHEN 10 THEN V_NOME_MES := 'Outubro';
        WHEN 11 THEN V_NOME_MES := 'Novembro';
        WHEN 12 THEN V_NOME_MES := 'Dezembro';
        ELSE
            V_NOME_MES := 'Mês Inválido';
    END CASE;

    RETURN V_NOME_MES;
END;

DECLARE
    V_NOME_MES VARCHAR2(30);
BEGIN
    V_NOME_MES := NOME_DO_MES(7);  
    DBMS_OUTPUT.PUT_LINE('mês: ' || V_NOME_MES);
END;

-- Mostrar o nome dos funcionários e a data de admissão e demissão no seguinte formato: 07 de novembro de 2006

CREATE OR REPLACE PROCEDURE SP_DATAS_EMPREGADOS IS
  CURSOR C_EMPREGADO IS
      SELECT NOME, DATA_ADMISSAO, DATA_RESCISAO FROM EMPREGADOS;
BEGIN
   FOR REG_EMPREGADO IN C_EMPREGADO LOOP
        DBMS_OUTPUT.PUT_LINE(REG_EMPREGADO.NOME || ' DATA ADMISSÃO: ' ||
        EXTRACT(DAY FROM REG_EMPREGADO.DATA_ADMISSAO) || ' DE ' || NOME_DO_MES(EXTRACT(MONTH FROM REG_EMPREGADO.DATA_ADMISSAO))
        || ' DE ' || EXTRACT(YEAR FROM REG_EMPREGADO.DATA_ADMISSAO));
        IF REG_EMPREGADO.DATA_RESCISAO IS NOT NULL THEN 
            DBMS_OUTPUT.PUT_LINE(' DATA RESCISAO: ' || EXTRACT(DAY FROM REG_EMPREGADO.DATA_RESCISAO) 
            || ' DE ' || NOME_DO_MES(EXTRACT(MONTH FROM REG_EMPREGADO.DATA_RESCISAO))
            || ' DE ' || EXTRACT(YEAR FROM REG_EMPREGADO.DATA_RESCISAO));
        END IF;
  END LOOP;
END;

EXEC SP_DATAS_EMPREGADOS;

