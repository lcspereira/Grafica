BEGIN;

  CREATE TABLE CLIENTE
  (
    ID SERIAL NOT NULL,
    NOME Varchar(100) NOT NULL,
    CPF_CNPJ Varchar(20) NOT NULL,
    IE Varchar(20),
    TELEFONE Varchar(10),
    EMAIL Varchar(50),
    ENDERECO Varchar(100) NOT NULL,
    NUM_ENDERECO Integer NOT NULL,
    COMPL_ENDERECO Varchar(50),
    CEP Varchar(9),
    CIDADE Varchar(30) NOT NULL,
    CONSTRAINT id_cliente_pk PRIMARY KEY (ID)
  );

  CREATE INDEX nome_idx ON cliente USING btree (nome varchar_pattern_ops);

  
  CREATE TABLE STATUS
  (
    ID SERIAL NOT NULL,
    DESCR Varchar(500) NOT NULL,
    CONSTRAINT id_status_pk PRIMARY KEY (ID)
  );


  CREATE TABLE PRODUTO
  (
    ID SERIAL NOT NULL,
    DESCR Varchar(1000) NOT NULL,
    PRECO Decimal(6,2) NOT NULL,
    QUANT Float,
    CONSTRAINT id_produto_pk PRIMARY KEY (ID)
  );
  
  CREATE INDEX descr_idx ON produto USING btree (descr varchar_pattern_ops);
  

  CREATE TABLE PEDIDO
  (
    ID SERIAL NOT NULL,
    ID_CLIENTE Integer NOT NULL,
    DATA_ENCOMENDA Timestamp NOT NULL,
    DATA_ENTREGA Timestamp NOT NULL,
    SUBTOTAL Decimal(5,2) NOT NULL,
    DESCONTO Decimal(5,2),
    TOTAL Decimal(5,2) NOT NULL,
    STATUS Integer NOT NULL,
    CONSTRAINT ID_ID_CLIENTE_PK PRIMARY KEY (ID,ID_CLIENTE)
  );

  CREATE INDEX data_encomenda_idx ON pedido USING btree (data_encomenda);
  CREATE INDEX data_entrega_idx ON pedido USING btree (data_entrega);

  ALTER TABLE PEDIDO ADD CONSTRAINT ID_CLIENTE_PEDIDO_FK
    FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE (ID);
  ALTER TABLE PEDIDO ADD CONSTRAINT STATUS_PEDIDO_FK
    FOREIGN KEY (STATUS) REFERENCES STATUS (ID);


  CREATE TABLE PEDIDO_PRODUTO
  (
    ID_PEDIDO Integer NOT NULL,
    ID_CLIENTE Integer NOT NULL,
    ID_PRODUTO Integer NOT NULL,
    QUANT Float NOT NULL,
    CONSTRAINT PEDIDO_CLIENTE_PRODUTO_FK PRIMARY KEY (ID_PEDIDO,ID_CLIENTE,ID_PRODUTO)
  );

  ALTER TABLE PEDIDO_PRODUTO ADD CONSTRAINT ID_PEDIDO_CLIENTE_FK
    FOREIGN KEY (ID_PEDIDO,ID_CLIENTE) REFERENCES PEDIDO (ID,ID_CLIENTE);

  ALTER TABLE PEDIDO_PRODUTO ADD CONSTRAINT ID_PRODUTO_PEDIDO_PRODUTO
    FOREIGN KEY (ID_PRODUTO) REFERENCES PRODUTO (ID);


  INSERT INTO status (descr) VALUES ('EM PRODUÇÃO');
  INSERT INTO status (descr) VALUES ('CANCELADO');
  INSERT INTO status (descr) VALUES ('AGUARDANDO ENTREGA');
  INSERT INTO status (descr) VALUES ('FINALIZADO');
COMMIT;
