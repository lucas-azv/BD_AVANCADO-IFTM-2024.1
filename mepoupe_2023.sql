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