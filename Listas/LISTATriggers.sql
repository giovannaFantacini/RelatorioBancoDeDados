set serveroutput on;

CREATE TABLE AMIGO (AID INTEGER NOT NULL CONSTRAINT PK_AMIGO PRIMARY KEY,

                      ANOME VARCHAR2(50) NOT NULL, 

                      SEXO CHAR(1) NOT NULL,

                      IDADE INTEGER NOT NULL);  
                      
CREATE TABLE PRESENTE (PID INTEGER NOT NULL CONSTRAINT PK_PRESENTE PRIMARY KEY,

                      PDESCRICAO VARCHAR2(50) NOT NULL, 

                      PVALOR REAL NOT NULL);  

CREATE TABLE LISTAPRESENTE (LPID INTEGER NOT NULL CONSTRAINT PK_LISTAPRESENTE PRIMARY KEY,

                      AID INTEGER NOT NULL, 

                      PID INTEGER NOT NULL,

                      PREFERENCIA INTEGER NOT NULL,

                      CONSTRAINT FK_AMIGO_PRESENTE FOREIGN KEY (AID) REFERENCES AMIGO,
                      CONSTRAINT FK_PRESENTE FOREIGN KEY (PID) REFERENCES PRESENTE);

CREATE TABLE AMIGOSECRETO (ASID INTEGER NOT NULL CONSTRAINT PK_AMIGOSECRETO PRIMARY KEY,

                           AID INTEGER NOT NULL,
                           
                           AID_AMIGO INTEGER NOT NULL,
                           
                           PID_RECEBIDO INTEGER NOT NULL,
                           
                           CONSTRAINT FK_AMIGO FOREIGN KEY (AID) REFERENCES AMIGO,
                           CONSTRAINT FK_AMIGO_SECRETO FOREIGN KEY (AID_AMIGO) REFERENCES AMIGO,
                           CONSTRAINT FK_PRESENTE_RECEBIDO FOREIGN KEY (PID_RECEBIDO) REFERENCES PRESENTE);
                           

--EX 1

Create Or Replace Trigger trg_add_amigo
  Before Insert or Update Of idade On amigo
  For Each Row
Declare
Begin
  IF :NEW.idade < 18 THEN
      dbms_output.put_line('Validação Idade');
      RAISE_APPLICATION_ERROR(-20001, 'Não é possivel a participação no amigo secreto para menores de 18 anos');
  END IF;
End;

INSERT INTO AMIGO (AID, ANOME, SEXO, IDADE) VALUES
                  (1, 'GIOVANNA', 'F', 15);
                  
-- EX 2

Create Or Replace Trigger trg_add_lista_presente
   Before Insert or Update On listaPresente
   For Each Row
   Declare
   total_presentes integer;
   valor_presentes integer;
   Begin
        Select count(*) into total_presentes from listaPresente lp where lp.aid = :NEW.aid;
        Select sum(p.pvalor) into valor_presentes from listaPresente lp, Presente p
                where lp.aid = :NEW.aid and lp.pid = p.pid;
        IF total_presentes >= 10 OR valor_presentes >= 500 THEN
            dbms_output.put_line('Validação Quantidade de Presentes e Valor dos presentes');
            RAISE_APPLICATION_ERROR(-20001, 'Não é possivel inserir mais de 10 presentes na lista ou o valor total dos presentes ultrapassou R$500,00');
        End IF; 
   End;

INSERT INTO PRESENTE (PID, PDESCRICAO, PVALOR) VALUES (1, 'CAIXA BOM-BOM', 100);
INSERT INTO PRESENTE (PID, PDESCRICAO, PVALOR) VALUES (2, 'OCULOS', 100);
INSERT INTO PRESENTE (PID, PDESCRICAO, PVALOR) VALUES (3, 'BARRA CHOCOLATE', 100);
INSERT INTO PRESENTE (PID, PDESCRICAO, PVALOR) VALUES (4, 'CORTE DE CABELO', 100);
INSERT INTO PRESENTE (PID, PDESCRICAO, PVALOR) VALUES (5, 'UNHA NO SALÃO', 100);
INSERT INTO PRESENTE (PID, PDESCRICAO, PVALOR) VALUES (20, 'SOBRANCELHA', 100);

INSERT INTO LISTAPRESENTE (LPID, AID, PID, PREFERENCIA) VALUES (1, 1, 1, 1);
INSERT INTO LISTAPRESENTE (LPID, AID, PID, PREFERENCIA) VALUES (2, 1, 2, 2);
INSERT INTO LISTAPRESENTE (LPID, AID, PID, PREFERENCIA) VALUES (3, 1, 3, 3);
INSERT INTO LISTAPRESENTE (LPID, AID, PID, PREFERENCIA) VALUES (4, 1, 4, 4);
INSERT INTO LISTAPRESENTE (LPID, AID, PID, PREFERENCIA) VALUES (5, 1, 5, 5);
INSERT INTO LISTAPRESENTE (LPID, AID, PID, PREFERENCIA) VALUES (10, 1, 6, 20);

-- EX 3 

Create Or Replace Trigger trg_valida_participacao
   Before Insert or Update On AmigoSecreto
   For Each Row
   Declare
   total_presentes_amigo integer;
   total_presentes_sorteado integer;
   Begin
        Select count(*) into total_presentes_amigo from listaPresente lp where lp.aid = :NEW.aid;
        Select count(*) into total_presentes_sorteado from listaPresente lp where lp.aid = :NEW.aid_amigo;
        IF total_presentes_amigo < 1 OR total_presentes_sorteado < 1 THEN
            dbms_output.put_line('Validação existencia de presentes na lista');
            RAISE_APPLICATION_ERROR(-20001, 'Um dos participantes não possui presentes cadastrados');
        End IF; 
   End;
   
INSERT INTO AMIGO (AID, ANOME, SEXO, IDADE) VALUES
                  (2, 'PEDRO', 'M', 20);

INSERT INTO AMIGOSECRETO (ASID, AID, AID_AMIGO, PID_RECEBIDO) VALUES
                          (1, 1, 2, 3);
                          
-- EX 4  

Create Or Replace Trigger trg_valida_presente
   Before Insert or Update On AmigoSecreto
   For Each Row
   Declare
   presente_escolhido integer;
   Begin
        Select count(*) into presente_escolhido from listaPresente lp 
            where lp.aid = :NEW.aid_amigo AND lp.pid = :NEW.pid_recebido;  
        IF presente_escolhido = 0 THEN
            dbms_output.put_line('Validação presentes escolhido');
            RAISE_APPLICATION_ERROR(-20001, 'O presente não faz parte da lista de presentes do usuario');
        End IF; 
   End;


INSERT INTO LISTAPRESENTE (LPID, AID, PID, PREFERENCIA) VALUES (8, 2, 6, 1);

INSERT INTO AMIGOSECRETO (ASID, AID, AID_AMIGO, PID_RECEBIDO) VALUES
                          (1, 1, 2, 3);
                          
-- Ex 5 e 6

CREATE OR REPLACE VIEW VW_ALUNO_AVALIACAO AS SELECT * FROM ALUNO_AVALIACAO;

create or replace Trigger trg_atualiza_media
   INSTEAD OF Insert or Update or Delete On vw_aluno_avaliacao
   For Each Row
   Declare
   v_nova_media float;
   v_disciplina avaliacao.id_disciplina%type;
   v_id_aluno_disciplina aluno_disciplina.id_aluno_disciplina%type;
   v_id_avaliacao Aluno_Avaliacao.id_avaliacao%type;
   v_id_aluno Aluno.id_aluno%type;
   v_aprovacao VARCHAR2(15);
   Begin
        IF DELETING THEN 
            v_id_avaliacao := :OLD.id_avaliacao;
            v_id_aluno := :OLD.id_aluno;       

        ELSIF INSERTING or UPDATING THEN
            v_id_avaliacao := :NEW.id_avaliacao;
            v_id_aluno := :NEW.id_aluno;
    
        END IF;
        
        Select a.id_disciplina into v_disciplina from avaliacao a
                where v_id_avaliacao = a.id_avaliacao;  

        Select avg(av.nota) into v_nova_media from avaliacao a, aluno_avaliacao av
            where a.id_disciplina = v_disciplina and av.id_aluno = v_id_aluno; 

        Select id_aluno_disciplina into v_id_aluno_disciplina from aluno_disciplina
            where v_id_aluno = id_aluno and v_disciplina = id_disciplina;   
        
        IF v_nova_media >= 6 THEN
            v_aprovacao := 'APROVAÇÃO';
        ELSIF v_nova_media >= 4 THEN
            v_aprovacao := 'RECUPERAÇÃO';
        ELSE
            v_aprovacao := 'REPROVADO';
        END IF;

       Update Aluno_Disciplina SET media = v_nova_media, situacao = v_aprovacao 
       where id_aluno_disciplina = v_id_aluno_disciplina;
       
   End;
   
ALTER TABLE ALUNO_DISCIPLINA ADD(MEDIA REAL);

ALTER TABLE ALUNO_DISCIPLINA ADD(SITUACAO VARCHAR2(15));

Update vw_aluno_avaliacao set nota = 5 where id_aluno_avaliacao = 13
