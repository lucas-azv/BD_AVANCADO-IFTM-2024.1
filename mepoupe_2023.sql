drop database MePoupe;
create database MePoupe;
use MePoupe;

create table cliente(
cod_cliente int auto_increment,
nome varchar(50),
CPF char(11),
sexo char(1),
dt_nasc date,
telefone char(15),
email varchar(100),
primary key(cod_cliente));

insert into cliente values(1,'Bill Clinton','12999786543','M','1940-04-12', '11999786543',
 'william@gmail.com'),
 (2,'Trump', '13999786544', 'M','1942-05-10', '11999186543', 'trump@gmail.com');
 
 
create table conta_corrente(
cod_conta int auto_increment,
dt_hora_abertura datetime,
saldo numeric(9,2),
status_conta varchar(15),
cod_cliente int,
primary key(cod_conta),
foreign key(cod_cliente)references cliente(cod_cliente));

insert into conta_corrente values (1,'2020-03-15 13:50:00', 50,'Ativa',1);
insert into conta_corrente values (2,'2020-03-18 15:30:00',500,'Ativa',2);


create table Registro_Saque(
cod_saque int auto_increment,
cod_conta int,
dt_saque datetime,
valor_saque numeric(9,2),
primary key(cod_saque),
foreign key(cod_conta)references conta_corrente(cod_conta));

 create table Registro_Deposito(
cod_deposito int auto_increment,
cod_conta int,
dt_deposito datetime,
valor_deposito numeric(9,2),
primary key(cod_deposito),
foreign key(cod_conta)references conta_corrente(cod_conta));


insert into registro_saque values(1,2,'2020-03-20 14:00:00', 20);
insert into registro_saque values(2,2,'2020-04-20 17:30:00', 80);


insert into registro_deposito values(1,2,'2020-03-19 16:10:00', 40);
insert into registro_deposito values(2,2,'2020-04-22 19:15:00', 800);

select * from registro_deposito;

-- lista de exercicios procedures

insert into cliente values
(3,'Bora Bill','12334566788','M','1979-06-31', '3499887766','borabill@gmail.com'),
(4,'Receba','11233455677','M','2000-08-26', '1199112233','receba@gmail.com');

insert into conta_corrente values (3,'2020-07-10 10:00:00', 300,'Ativa',3);
insert into conta_corrente values (4,'2020-07-11 11:00:00', 1000,'Ativa',4);

insert into registro_deposito values 
(3,3,'2020-07-10 10:30:00', 200),
(4,3,'2020-07-10 11:00:00', 100),
(5,4,'2020-07-11 12:00:00', 500),
(6,4,'2020-07-12 09:00:00', 500),
(7,4,'2020-07-12 10:00:00', 100),
(8,4,'2020-07-12 11:00:00', 200);

insert into registro_saque values 
(3,3,'2020-07-10 12:00:00', 50),
(4,3,'2020-07-10 13:00:00', 100),
(5,4,'2020-07-12 12:00:00', 300),
(6,4,'2020-07-12 13:00:00', 400);

-- ex 02

delimiter //

create procedure sp_insere_cli(
in p_nome varchar(50),
in p_cpf char(11),
in p_sexo char(1),
in p_dt_nasc date,
in p_telefone char(15),
in p_email varchar(100)
)
begin
if p_nome is null or p_cpf is null or p_sexo is null or p_dt_nasc is null or p_telefone is null or p_email is null then
signal sqlstate '45000' set message_text = 'Todos os campos devem ser preenchidos.';
else
insert into cliente (nome, CPF, sexo, dt_nasc, telefone, email)
values (p_nome, p_cpf, p_sexo, p_dt_nasc, p_telefone, p_email);
end if;
end //

delimiter ;

-- ex 03

create table registro_transferencia (
    cod_transferencia int auto_increment,
    cod_conta_origem int,
    cod_conta_destino int,
    valor_transferencia numeric(9,2),
    dt_hora_transferencia datetime,
    primary key (cod_transferencia)
);

delimiter //

create procedure sp_registra_transferencia(
in p_cod_conta_origem int,
in p_cod_conta_destino int,
in p_valor_transferencia numeric(9,2)
)
begin
declare v_saldo_origem numeric(9,2);

select saldo into v_saldo_origem
from conta_corrente
where cod_conta = p_cod_conta_origem;

if v_saldo_origem >= p_valor_transferencia then
start transaction;
        
update conta_corrente
set saldo = saldo - p_valor_transferencia
where cod_conta = p_cod_conta_origem;
        
update conta_corrente
set saldo = saldo + p_valor_transferencia
where cod_conta = p_cod_conta_destino;
        
insert into registro_transferencia (cod_conta_origem, cod_conta_destino, valor_transferencia, dt_hora_transferencia)
values (p_cod_conta_origem, p_cod_conta_destino, p_valor_transferencia, now());

commit;
else
signal sqlstate '45000' set message_text = 'Saldo insuficiente para realizar a transferência.';
end if;
end //

delimiter ;

-- ex 04

delimiter //
create procedure sp_relatorio_depositos_periodo(
in p_data_inicial date,
in p_data_final date
)
begin
select c.nome as nome_cliente, cc.cod_conta, sum(rd.valor_deposito) as total_depositos
from cliente c
join conta_corrente cc on c.cod_cliente = cc.cod_cliente
join registro_deposito rd on cc.cod_conta = rd.cod_conta
where rd.dt_deposito between p_data_inicial and p_data_final
group by c.nome, cc.cod_conta
order by total_depositos desc;
end//

-- ex 05

create procedure sp_relatorio_anual(
in p_ano int,
in p_codigo_relatorio int
)
begin
if p_codigo_relatorio = 1 then
select cod_conta, month(dt_saque) as mes, sum(valor_saque) as total_saques
from registro_saque
where year(dt_saque) = p_ano
group by cod_conta, month(dt_saque);
elseif p_codigo_relatorio = 2 then
select cod_conta, month(dt_deposito) as mes, sum(valor_deposito) as total_depositos
from registro_deposito
where year(dt_deposito) = p_ano
group by cod_conta, month(dt_deposito);
else
signal sqlstate '45000' set message_text = 'Código de relatório inválido.';
end if;
end //

-- lista de exercicios triggers e funções

-- ex 01
create table tb_red_clients (
    cod_cliente int,
    nome varchar(100),
    cpf varchar(11),
    numero_conta int,
    data_entrada_vermelho date,
    data_saida_vermelho date,
    valor_taxa decimal(10, 2)
);

delimiter //

-- ex 01
create or replace trigger tr_red_clients
before insert on registro_saque
for each row
begin
    declare v_saldo_atual decimal(10, 2);
    declare v_nome varchar(100);
    declare v_cpf varchar(11);
    declare v_conta_aberta int;
    
    select saldo into v_saldo_atual from conta_corrente where cod_conta = new.cod_conta;
    
    if (v_saldo_atual - new.valor_saque) < -200 then
        signal sqlstate '45000' set message_text = 'saque não permitido: saldo insuficiente com limite de r$ 200 no vermelho';
    end if;

    update conta_corrente
    set saldo = saldo - new.valor_saque
    where cod_conta = new.cod_conta;

    select count(*) into v_conta_aberta 
    from tb_red_clients 
    where numero_conta = new.cod_conta 
      and data_saida_vermelho is null;

    if (v_saldo_atual >= 0 and (v_saldo_atual - new.valor_saque) < 0 and v_conta_aberta = 0) then
        select nome, cpf into v_nome, v_cpf from cliente where cod_cliente = (select cod_cliente from conta_corrente where cod_conta = new.cod_conta);
        insert into tb_red_clients (cod_cliente, nome, cpf, numero_conta, data_entrada_vermelho, data_saida_vermelho, valor_taxa)
        values ((select cod_cliente from conta_corrente where cod_conta = new.cod_conta), v_nome, v_cpf, new.cod_conta, curdate(), null, null);
    end if;
end;
//

delimiter ;

-- ex 02
delimiter //

create or replace function func_calcula_valor_taxa (
    p_data_inicio date,
    p_data_fim date
) returns decimal(10, 2)
begin
    declare v_dias_diff int;
    declare v_taxa decimal(10, 2);
    
    set v_dias_diff = datediff(p_data_fim, p_data_inicio);
    set v_taxa = v_dias_diff * 5;
    return v_taxa;
end;
//

delimiter ;

-- ex 03
delimiter //

create or replace trigger tr_redout_clients
before insert on registro_deposito
for each row
begin
    declare v_saldo_atual decimal(10, 2);
    declare v_data_entrada date;
    declare v_taxa decimal(10, 2);
    
    select saldo into v_saldo_atual from conta_corrente where cod_conta = new.cod_conta;

    update conta_corrente
    set saldo = saldo + new.valor_deposito
    where cod_conta = new.cod_conta;

    if (v_saldo_atual < 0 and (v_saldo_atual + new.valor_deposito) >= 0) then
        select data_entrada_vermelho into v_data_entrada from tb_red_clients where numero_conta = new.cod_conta and data_saida_vermelho is null;
        set v_taxa = func_calcula_valor_taxa(v_data_entrada, curdate());
        update tb_red_clients
        set data_saida_vermelho = curdate(), valor_taxa = v_taxa
        where numero_conta = new.cod_conta and data_saida_vermelho is null;
    end if;
end;
//

delimiter ;
