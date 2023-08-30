-- Mostra quantas cirurgias cada médico fez 
SELECT COUNT(*), DEREF (tabela_cirurgia.dados_medico).crm as CRM
FROM tabela_cirurgia GROUP BY (DEREF (tabela_cirurgia.dados_medico).crm);

-- Mostra quantas cirurgias cada paciente fez
SELECT COUNT(*),DEREF(tabela_cirurgia.dados_paciente).nome AS Nome_do_Paciente 
FROM tabela_cirurgia GROUP BY DEREF(tabela_cirurgia.dados_paciente).nome ;

-- Mostra o número de telefone de todos os atendentes (consulta a VARRAY)
SELECT A.nome, T.* FROM tabela_atendentes A, TABLE(A.telefones) T;

-- chama o procedure exibir_informacoes para todos enfermeiros com idade inferior a 30 anos, e os ordena de forma crescente por idade.
DECLARE
    CURSOR c_enfermeiros IS
        SELECT VALUE(enf) AS enfermeiro
        FROM tabela_enfermeiros enf
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, enf.data_nascimento) / 12) < 30
        ORDER BY TRUNC(MONTHS_BETWEEN(SYSDATE, enf.data_nascimento) / 12);
BEGIN
    FOR e IN c_enfermeiros
    LOOP
        e.enfermeiro.exibir_informacoes;
    END LOOP;
END;
/

-- Mostra todos os enfermeiros que são de Pernambuco, mas não moram em Recife.
SELECT e.nome AS enfermeiro, e.coren, e.endereco.cidade, e.endereco.estado
FROM tabela_enfermeiros e
WHERE e.endereco.estado = 'PE' AND e.endereco.cidade <> 'Recife';

-- Testa a order member de cirurgia para identificar conflitos nas cirurgias
DECLARE
    aux NUMBER;
    cirurgia1 tp_cirurgia;
    cirurgia2 tp_cirurgia;
BEGIN
    SELECT VALUE (C) INTO cirurgia1 FROM tabela_cirurgia C WHERE data_cirurgia = TO_DATE('2022-08-19', 'YYYY-MM-DD');
    SELECT VALUE (C) INTO cirurgia2 FROM tabela_cirurgia C WHERE data_cirurgia = TO_DATE('2023-05-19', 'YYYY-MM-DD');
    aux := cirurgia1.conflito_cirurgia(cirurgia2);

    IF aux = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Não há conflito.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Conflito existente!');
    END IF;
END;
/

-- Mostra todos os funcionários do sexo feminino
SELECT f.nome, f.telefone FROM tabela_funcionarios f WHERE f.sexo = 'F';
