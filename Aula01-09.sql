-- set serveroutput on;

-- Procedimentos e funções locais

/*
DEClARE
  v_TestVar NUMBER:= 11;
  
  PROCEDURE EX_FOR (N IN NUMBER);
  FUNCTION AREA(BASE IN NUMBER, ALT IN NUMBER) RETURN NUMBER;
  
  PROCEDURE SELECIONA(OPCAO IN INTEGER, N IN NUMBER, BASE IN NUMBER, ALT IN NUMBER) IS
  -- DECLARAÇÃO DE VARIAVEL DA FUNÇÃO
  BEGIN
   IF OPCAO = 1 THEN
     EX_FOR(N);
   ELSE
     DBMS_OUTPUT.PUT_LINE(AREA(BASE,ALT));
   END IF;
  END;
  
  PROCEDURE EX_FOR (N IN NUMBER) IS  
  v_Res NUMBER;
  BEGIN
    FOR v_cont IN 1..10 LOOP
      DBMS_OUTPUT.PUT(N);
      DBMS_OUTPUT.PUT(' x ');
      DBMS_OUTPUT.PUT(v_cont);
      DBMS_OUTPUT.PUT(' = ');
      v_Res := v_cont * N;
      DBMS_OUTPUT.PUT_LINE(v_Res);
    END LOOP; 
  END;
  
  FUNCTION AREA( BASE IN NUMBER, ALT IN NUMBER) RETURN NUMBER IS
  BEGIN
  
    RETURN (BASE*ALT)/2;
  END AREA;

BEGIN
  EX_FOR(4);
  EX_FOR(5);
  EX_FOR(6);
   
  DBMS_OUTPUT.PUT_LINE(AREA(3,5));
  
 -- SELECIONA(1, 9, 0, 0);
 -- SELECIONA(2, 0, 10, 4);

END;*/


-- Function calcula a media
/*
DECLARE

    FUNCTION CALCULA_MEDIA(CODIGO_ALUNO IN ALUNO.COD_ALUNO%TYPE, 
                CODIGO_DISCIPLINA IN DISCIPLINA.COD_DISCIPLINA%TYPE) RETURN NUMBER IS 
                
    MEDIA NUMBER;
    SOMA NUMBER;
    TOTAL NUMBER;
    
    BEGIN
    
      SELECT SUM(NOTA), COUNT(NOTA)
      INTO SOMA, TOTAL
      FROM ALUNO A, ALUNO_AVALIACAO AL_AV , DISCIPLINA D,  AVALIACAO AV  
      WHERE A.COD_ALUNO = CODIGO_ALUNO AND 
            D.COD_DISCIPLINA = CODIGO_DISCIPLINA AND
            AL_AV.ID_ALUNO = A.ID_ALUNO AND
            AL_AV.ID_AVALIACAO = AV.ID_AVALIACAO AND
            D.ID_DISCIPLINA = AV.ID_DISCIPLINA;
      
       DBMS_OUTPUT.PUT_LINE(SOMA);
       DBMS_OUTPUT.PUT_LINE(TOTAL);
    
      IF TOTAL > 0 THEN
        MEDIA := SOMA/TOTAL;
      ELSE
        MEDIA := -1;
      END IF;
    
      RETURN MEDIA;
      
    END CALCULA_MEDIA;

BEGIN
  DBMS_OUTPUT.PUT_LINE(CALCULA_MEDIA('1058002','LP1'));
END;
*/

-- Parametros IN, OUT e IN OUT

/*
DECLARE
    taxa number;
    salario number;
    
    --parâmetros IN
    procedure p_aumenta_salario1(sal_base in number, taxa in number) is
    sal_novo number(10,2);
    begin
        sal_novo := sal_base*(1+taxa);
        dbms_output.put_line('SAL?RIO NOVO (procedure in): '||sal_novo);
    end;
    
    --parâmetros IN e OUT
    -- OUT = variavel de saida, só permite gravacao
    procedure p_aumenta_salario2(sal_base in number, taxa in number, sal_novo out number) is    
    begin
        sal_novo := sal_base*(1+taxa);        
    end;    
    
    --parâmetros IN e IN OUT
    -- IN OUT = grava o valor e permite leitura, retorna 
    procedure p_aumenta_salario3(sal_base in out number, taxa in number) is    
    begin
        sal_base := sal_base*(1+taxa);        
    end;        
    
    --function
    function f_aumenta_salario(sal_base in number, taxa in number) return number is
    begin
        return sal_base*(1+taxa);        
    end;
BEGIN
    -- números decimais devem ser passados em variaveis (bug com uso de ponto no PL/SQL em parâmetros)
    taxa := 0.45; 
    --in
    p_aumenta_salario1(1000,taxa);
    
    --in e out
    p_aumenta_salario2(1000,taxa,salario);
    dbms_output.put_line('SAL?RIO NOVO (procedure out): '||salario);
    
    --in e in out
    salario := 1000;
    p_aumenta_salario3(salario,taxa);
    dbms_output.put_line('SAL?RIO NOVO (procedure in out): '||salario);
    
    --function
    salario := f_aumenta_salario(1000,taxa);
    dbms_output.put_line('SAL?RIO NOVO (function): '|| salario);
END;


*/

-- CALCULO DE NOTA  FISCAL

DECLARE 
    V_VLR_NOTA NUMBER;
    V_IPI NUMBER;
    V_ICMS NUMBER;
    V_PIS_COFINS NUMBER;
    V_VLR_IPI NUMBER;
    V_VLR_ICMS NUMBER;
    V_VLR_PIS_COFINS NUMBER;
    
    
    FUNCTION CALCULA_NOTA(P_VLR_PROD NUMBER, P_IPI NUMBER, P_ICMS NUMBER, P_PIS_COFINS NUMBER, P_VLR_IPI OUT NUMBER,
                          P_VLR_ICMS OUT NUMBER, P_VLR_PIS_COFINS OUT NUMBER)RETURN NUMBER IS
    BEGIN
        P_VLR_IPI := P_VLR_PROD * P_IPI;
        P_VLR_ICMS := P_VLR_PROD * P_ICMS;
        P_VLR_PIS_COFINS := P_VLR_PROD * P_PIS_COFINS;
        RETURN(P_VLR_PROD + P_VLR_IPI + P_VLR_ICMS + P_VLR_PIS_COFINS);
    END;

BEGIN 
   V_VLR_NOTA := CALCULA_NOTA(1000, 0.10, 0.25, 0.015, V_VLR_IPI, V_VLR_ICMS, V_VLR_PIS_COFINS); 
   dbms_output.put_line('VALOR NOTA: '|| V_VLR_NOTA);
   dbms_output.put_line('VALOR IPI: '|| V_VLR_IPI);
   dbms_output.put_line('VALOR ICMS: '|| V_VLR_ICMS);
   dbms_output.put_line('VALOR COFINS: '|| V_VLR_PIS_COFINS);
END;