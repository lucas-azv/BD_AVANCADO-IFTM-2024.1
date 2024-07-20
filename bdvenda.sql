Create database venda;
Use venda;
/* Criação das tabelas */

Create table cliente (
    codCliente int auto_increment primary key,
    Nome varchar(50),
    Endereco varchar(50),
    Telefone varchar(11),
    CNPJ varchar(14)
);
create table categoria(
codCat int auto_increment primary key,
nomeCategoria varchar(50));
Create table produto(
codProduto int auto_increment primary key,
nome varchar(30) unique not null,
valorUnit numeric(7,2),
quantidade smallint,
codCat int,
foreign key(codCat) references categoria(codCat));




Create table Pedido (
    codPedido int auto_increment primary key,
    codCliente int,
    dataCompra date,
    valorTotal numeric(7 , 2 ),
Status varchar(20),
    Foreign key (codcliente)
        references cliente (codCliente)
);
Create table ItemPedido(
codItem int auto_increment primary key,
codProduto int,
codPedido int,
quantidade smallint,
valorItem numeric(7,2),
Foreign key(codPedido) references Pedido(codPedido), 
Foreign key(codProduto) references produto(codProduto));

Create table Entrada (
    cod_Entrada int auto_increment primary key,
    dataEntrada date,
    codProduto int,
    qtdeProd smallint,
    Foreign key (codProduto)
        references produto (codProduto)
); 

Insert into categoria values(1, "Produtos esportivos");
insert into produto values (1,"Bicicleta",500,50,1),(2,"Capacete",50,50,1);
insert into produto values (3,"Oculos",500,30,1),(4,"Sapatilha",50,50,1);

insert into cliente values(1,"Bic & Companhia","Rua x","32355678","01234567880012");
insert into cliente values(2,"Bic UDI","Rua Y","32355898","01234567880013");
insert into pedido values(1,1,current_date(),null,'PENDENTE');
insert into pedido values(2,1,current_date(),null,'PENDENTE');

insert into pedido values(3,1,'2022-04-01',null,'PENDENTE');



insert into itemPedido values(1,1,1,10,500);
insert into itemPedido values(2,2,1,10,50);
insert into itemPedido values(3,1,2,15,500);
insert into itemPedido values(4,2,2,20,50);

insert into itemPedido values(5,3,3,15,500);
insert into itemPedido values(6,2,3,20,50);

insert into entrada values(1,current_date(),1,30);