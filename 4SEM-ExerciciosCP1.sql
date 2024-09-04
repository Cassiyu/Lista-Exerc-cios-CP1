-- RM551491

-- Remover tabela e pacote existentes (se houver)
drop table funcionarios;
drop package pkg_funcionario;

-- Criar a tabela
create table funcionarios (
    id number(10), 
    nome varchar2(50),
    salario number(10,2),
    departamento varchar2(50),
    gerente varchar2(50)
);

-- Inserir dados na tabela
insert into funcionarios (id, nome, salario, departamento, gerente) values (1, 'João Silva', 3500.00, 'Recursos Humanos', 'Carlos Mendes');
insert into funcionarios (id, nome, salario, departamento, gerente) values (2, 'Maria Oliveira', 4200.50, 'Financeiro', 'Ana Costa');
insert into funcionarios (id, nome, salario, departamento, gerente) values (3, 'Pedro Santos', 3100.75, 'Tecnologia', 'Lucas Pereira');
insert into funcionarios (id, nome, salario, departamento, gerente) values (4, 'Ana Costa', 5000.00, 'Marketing', 'Carlos Mendes');
insert into funcionarios (id, nome, salario, departamento, gerente) values (5, 'Lucas Pereira', 2800.00, 'Financeiro', 'Ana Costa');



-- Habilitar saída do DBMS_OUTPUT
set serveroutput on;

-- Criar o package
create or replace package pkg_funcionario is
    function retorna_salario(p_id in number) return number;
    procedure atualiza_salario(p_id in number, p_novo_salario in number);
end pkg_funcionario;
/

-- Criar o package body
create or replace package body pkg_funcionario is

    function retorna_salario(p_id in number) return number is
        v_salario number(10,2);
    begin
        select salario into v_salario
        from funcionarios
        where id = p_id;
        dbms_output.put_line('Retorna Salário');
        dbms_output.put_line('Id: ' || p_id);
        dbms_output.put_line('Salário: ' || v_salario);
        return v_salario;
    end retorna_salario;

    procedure atualiza_salario(p_id in number, p_novo_salario in number) is
    begin
        update funcionarios
        set salario = p_novo_salario
        where id = p_id;
        dbms_output.put_line('Atualiza Salário');
        dbms_output.put_line('Id: ' || p_id);
        dbms_output.put_line('Salário atualizado: ' || p_novo_salario);
    end atualiza_salario;
    
end pkg_funcionario;
/

-- Testar retorna salário
declare
    v_salario number(10,2);
begin
    v_salario := pkg_funcionario.retorna_salario(1); 
end;
/

-- Testar atualiza salário
begin
    pkg_funcionario.atualiza_salario(1, 4500.00);
end;
/

-- Testar novamente para retornar o salário atualizado
declare
    v_salario number(10,2);
begin
    v_salario := pkg_funcionario.retorna_salario(1); 
end;
/

--------------------------------------------------------------------------------

-- Remover pacote existente (se houver)
drop package pkg_matematica;

-- Criar o package
create or replace package pkg_matematica is
    function calcula_fatorial(p_numero in number) return number;
end pkg_matematica;
/

-- Criar o package body
create or replace package body pkg_matematica is
    function calcula_fatorial(p_numero in number) return number is
        v_fatorial number := 1;
        v_resultado number;
    begin
        for i in 1..p_numero loop
            v_fatorial := v_fatorial * i;
        end loop;
        v_resultado := v_fatorial;
        dbms_output.put_line('O fatorial é: ' || v_resultado);
        return v_resultado;
    end calcula_fatorial;
end pkg_matematica;
/

-- Testar calcula fatorial
declare
    v_resultado number;
begin
    v_resultado := pkg_matematica.calcula_fatorial(5); 
end;
/

--------------------------------------------------------------------------------

-- Remover pacote existente (se houver)
drop package pkg_string;

-- Criar o package 
create or replace package pkg_string is
    function inverte_string(p_string in varchar2) return varchar2;
end pkg_string;
/

-- Criar o package body
create or replace package body pkg_string is
    function inverte_string(p_string in varchar2) return varchar2 is
        v_resultado varchar2(4000);
        i number;
    begin
        v_resultado := '';
        for i in reverse 1..length(p_string) loop
            v_resultado := v_resultado || substr(p_string, i, 1);
        end loop;
        dbms_output.put_line('String invertida: ' || v_resultado);
        return v_resultado;
    end inverte_string;
end pkg_string;
/

-- Testar iverte string
declare
    v_resultado varchar2(4000);
begin
    v_resultado := pkg_string.inverte_string('Exemplo Teste');
end;
/

--------------------------------------------------------------------------------

-- Remover procedimento existente (se houver)
drop procedure contar_funcionarios_por_departamento;

-- Criar procedure
create or replace procedure contar_funcionarios_por_departamento(
    p_nome_departamento in varchar2,
    p_total_funcionarios out number
) is
begin
    select count(*)
    into p_total_funcionarios
    from funcionarios
    where departamento = p_nome_departamento;
    dbms_output.put_line('Número total de funcionários no departamento ' || p_nome_departamento || ': ' || p_total_funcionarios);

exception
    when no_data_found then
        p_total_funcionarios := 0;
        dbms_output.put_line('Nenhum funcionário encontrado no departamento ' || p_nome_departamento);
    when others then
        dbms_output.put_line('Erro inesperado: ' || sqlerrm);
end contar_funcionarios_por_departamento;
/

-- Testar procedure
declare
    v_total_funcionarios number;
begin
    contar_funcionarios_por_departamento('Financeiro', v_total_funcionarios);
end;
/

--------------------------------------------------------------------------------

-- Remover procedimento existente (se houver)
drop procedure inserir_funcionario;

-- Criar procedure
create or replace procedure inserir_funcionario(
    p_id in number,
    p_nome in varchar2,
    p_salario in number,
    p_departamento in varchar2,
    p_gerente in varchar2
) is
begin
    insert into funcionarios (id, nome, salario, departamento, gerente)
    values (p_id, p_nome, p_salario, p_departamento, p_gerente);
    dbms_output.put_line('Funcionário inserido: ' || p_nome);
exception
    when dup_val_on_index then
        dbms_output.put_line('Erro: Já existe um funcionário com o ID ' || p_id);
    when others then
        dbms_output.put_line('Erro inesperado: ' || sqlerrm);
end inserir_funcionario;
/

-- Testar inserir funcionário
begin
    inserir_funcionario(6, 'Carlos Mendes', 3200.00, 'Recursos Humanos', 'Cássio Sakai');
end;
/

--------------------------------------------------------------------------------

-- Remover procedimento existente (se houver)
drop procedure obter_nome_gerente;

-- Criar procedure
create or replace procedure obter_nome_gerente(
    p_funcionario_id in number,
    p_gerente_nome out varchar2
) is
begin
    select gerente
    into p_gerente_nome
    from funcionarios
    where id = p_funcionario_id;
    dbms_output.put_line('Nome do gerente do funcionário com ID ' || p_funcionario_id || ': ' || p_gerente_nome);

exception
    when no_data_found then
        p_gerente_nome := null;
        dbms_output.put_line('Nenhum gerente encontrado para o funcionário com ID ' || p_funcionario_id);
    when others then
        dbms_output.put_line('Erro inesperado: ' || sqlerrm);
end obter_nome_gerente;
/

-- Testar obter nome gerente
declare
    v_gerente_nome varchar2(50);
begin
    obter_nome_gerente(1, v_gerente_nome);
end;
/

--------------------------------------------------------------------------------

-- Remover procedimento existente (se houver)
drop procedure excluir_funcionario;

-- Criar procedure
create or replace procedure excluir_funcionario(
    p_funcionario_id in number
) is
begin
    delete from funcionarios
    where id = p_funcionario_id;
    
    if sql%rowcount = 0 then
        dbms_output.put_line('Nenhum funcionário encontrado com o ID ' || p_funcionario_id);
    else
        dbms_output.put_line('Funcionário com ID ' || p_funcionario_id || ' excluído com sucesso.');
    end if;

exception
    when others then
        dbms_output.put_line('Erro inesperado: ' || sqlerrm);
end excluir_funcionario;
/

-- Testar excluir funcionário
begin
    excluir_funcionario(3);
end;
/

--------------------------------------------------------------------------------

-- Remover tabela de log existente (se houver)
drop table funcionarios_log;

-- Criar tabela de log
create table funcionarios_log (
    id number(10),
    acao varchar2(10),
    nome varchar2(50),
    salario number(10,2),
    departamento varchar2(50),
    gerente varchar2(50),
    data_modificacao timestamp default current_timestamp
);


-- Criar trigger
create or replace trigger trg_funcionarios_log
after insert or update or delete on funcionarios
for each row
begin
    if inserting then
        insert into funcionarios_log (id, acao, nome, salario, departamento, gerente)
        values (:new.id, 'INSERT', :new.nome, :new.salario, :new.departamento, :new.gerente);
    elsif updating then
        insert into funcionarios_log (id, acao, nome, salario, departamento, gerente)
        values (:new.id, 'UPDATE', :new.nome, :new.salario, :new.departamento, :new.gerente);
    elsif deleting then
        insert into funcionarios_log (id, acao, nome, salario, departamento, gerente)
        values (:old.id, 'DELETE', :old.nome, :old.salario, :old.departamento, :old.gerente);
    end if;
end;
/

-- Inserir um funcionário para gerar um log
insert into funcionarios (id, nome, salario, departamento, gerente) values (7, 'Laura Lima', 3700.00, 'Recursos Humanos', 'Carlos Mendes');

-- Atualizar um funcionário para gerar um log
update funcionarios set salario = 3800.00 where id = 7;

-- Excluir um funcionário para gerar um log
delete from funcionarios where id = 7;

-- Verificar os logs
select * from funcionarios_log;

--------------------------------------------------------------------------------

-- Criar trigger
create or replace trigger trg_verifica_salario_minimo
before insert on funcionarios
for each row
begin
    if :new.salario < 1320.00 then
        raise_application_error(-20001, 'Não é permitido inserir um funcionário com salário abaixo de R$ 1.320,00.');
    end if;
end;
/

-- Tentar inserir um funcionário com salário menor que o salário mínimo
begin
    insert into funcionarios (id, nome, salario, departamento, gerente)
    values (8, 'João Pereira', 1000.00, 'Marketing', 'Ana Costa');
        exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

-- Inserir um funcionário com salário igual ou superior ao salário mínimo
begin
insert into funcionarios (id, nome, salario, departamento, gerente)
values (9, 'Maria Souza', 1500.00, 'TI', 'Carlos Mendes');
end;
/

--------------------------------------------------------------------------------

-- Remover tabela existente (se houver)
drop table departamentos;


-- Criar tabela
create table departamentos (
    id number(10) primary key,
    nome varchar2(50),
    data_modificacao date
);

-- Criar trigger
create or replace trigger trg_atualiza_data_modificacao
before update on departamentos
for each row
begin
    :new.data_modificacao := sysdate;
end;
/

-- Inserir um registro
begin
    insert into departamentos (id, nome, data_modificacao)
    values (1, 'Recursos Humanos', sysdate);
end;
/

-- Atualizar o registro para verificar a atualização da data
update departamentos
set nome = 'RH'
where id = 1;

-- Verificar o registro atualizado
select * from departamentos;

--------------------------------------------------------------------------------

-- Remover tabela existente (se houver)
drop table recursos_humanos;

-- Criar tabela 
create table recursos_humanos (
    id number(10) primary key,
    mensagem varchar2(100),
    data_notificacao date
);

-- Criar trigger
create or replace trigger trg_notifica_novo_funcionario
after insert on funcionarios
for each row
begin
    insert into recursos_humanos (id, mensagem, data_notificacao)
    values (
        :new.id, 
        'Novo funcionário contratado: ' || :new.nome || ', ID: ' || :new.id, 
        sysdate
    );
end;
/

-- Inserir um novo funcionário
begin
    insert into funcionarios (id, nome, salario, departamento, gerente)
    values (22, 'Maria Fernanda', 2500.00, 'Marketing', 'Carlos Mendes');
end;
/

-- Verificar a tabela de notificações
select * from recursos_humanos;

--------------------------------------------------------------------------------

-- Remover pacote existente (se houver)
drop package pkg_util;

-- Criar package
create or replace package pkg_util is
    procedure contar_funcionarios_por_departamento(
        p_nome_departamento in varchar2,
        p_total_funcionarios out number
    );

    procedure inserir_funcionario(
        p_id in number,
        p_nome in varchar2,
        p_salario in number,
        p_departamento in varchar2,
        p_gerente in varchar2
    );
end pkg_util;
/

-- Criar package body
create or replace package body pkg_util is

    procedure contar_funcionarios_por_departamento(
        p_nome_departamento in varchar2,
        p_total_funcionarios out number
    ) is
    begin
        select count(*)
        into p_total_funcionarios
        from funcionarios
        where departamento = p_nome_departamento;
    exception
        when no_data_found then
            p_total_funcionarios := 0;
        when others then
            dbms_output.put_line('Erro: ' || sqlerrm);
    end contar_funcionarios_por_departamento;

    procedure inserir_funcionario(
        p_id in number,
        p_nome in varchar2,
        p_salario in number,
        p_departamento in varchar2,
        p_gerente in varchar2
    ) is
    begin
        insert into funcionarios (id, nome, salario, departamento, gerente)
        values (p_id, p_nome, p_salario, p_departamento, p_gerente);
    exception
        when others then
            dbms_output.put_line('Erro ao inserir funcionário: ' || sqlerrm);
    end inserir_funcionario;

end pkg_util;
/

-- Testar procedure contar_funcionarios_por_departamento
declare
    v_total_funcionarios number;
begin
    pkg_util.contar_funcionarios_por_departamento('TI', v_total_funcionarios);
    dbms_output.put_line('Total de funcionários no departamento TI: ' || v_total_funcionarios);
end;
/

-- Testar procedure inserir_funcionario
begin
    pkg_util.inserir_funcionario(23, 'Ana Souza', 3200.00, 'Marketing', 'Carlos Mendes');
    dbms_output.put_line('Funcionário inserido com sucesso.');
end;
/

--------------------------------------------------------------------------------

-- Remover pacote existente (se houver)
drop package pkg_funcional;

-- Criar package
create or replace package pkg_funcional is
    procedure obter_nome_gerente(
        p_funcionario_id in number,
        p_gerente_nome out varchar2
    );

    procedure excluir_funcionario(
        p_funcionario_id in number
    );
end pkg_funcional;
/

-- Criar package body
create or replace package body pkg_funcional is

    procedure obter_nome_gerente(
        p_funcionario_id in number,
        p_gerente_nome out varchar2
    ) is
    begin
        select gerente
        into p_gerente_nome
        from funcionarios
        where id = p_funcionario_id;
        dbms_output.put_line('Nome do gerente do funcionário com ID ' || p_funcionario_id || ': ' || p_gerente_nome);
    
    exception
        when no_data_found then
            p_gerente_nome := null;
            dbms_output.put_line('Nenhum gerente encontrado para o funcionário com ID ' || p_funcionario_id);
        when others then
            dbms_output.put_line('Erro inesperado: ' || sqlerrm);
    end obter_nome_gerente;

    procedure excluir_funcionario(
        p_funcionario_id in number
    ) is
    begin
        delete from funcionarios
        where id = p_funcionario_id;
        
        if sql%rowcount = 0 then
            dbms_output.put_line('Nenhum funcionário encontrado com o ID: ' || p_funcionario_id);
        else
            dbms_output.put_line('Funcionário com ID ' || p_funcionario_id || ' excluído com sucesso.');
        end if;
    exception
        when others then
            dbms_output.put_line('Erro ao excluir funcionário: ' || sqlerrm);
    end excluir_funcionario;

end pkg_funcional;
/

-- Testar procedure obter_nome_gerente
declare
    v_gerente_nome varchar2(50);
begin
    pkg_funcional.obter_nome_gerente(1, v_gerente_nome);
    dbms_output.put_line('Nome do gerente: ' || v_gerente_nome);
end;
/

-- Testar procedure excluir_funcionario
begin
    pkg_funcional.excluir_funcionario(9);
end;
/
