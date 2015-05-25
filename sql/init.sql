--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.14
-- Dumped by pg_dump version 9.1.14
-- Started on 2015-05-25 00:42:58

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 1905 (class 1262 OID 16669)
-- Name: grafica; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE grafica WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';


ALTER DATABASE grafica OWNER TO postgres;

\connect grafica

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 170 (class 3079 OID 11639)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 1908 (class 0 OID 0)
-- Dependencies: 170
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 182 (class 1255 OID 16667)
-- Dependencies: 5 514
-- Name: fc_baixa_estoque_inc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fc_baixa_estoque_inc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    quant_estoque INTEGER;
BEGIN
    -- Verifica quantidade em estoque.
    SELECT quant
      INTO quant_estoque
      FROM produto 
     WHERE produto.id = NEW.id_produto;

    IF NEW.quant <= quant_estoque
    THEN
        UPDATE produto
        SET quant = quant - NEW.quant
        WHERE id = NEW.id_produto;
    ELSE
        RAISE EXCEPTION 'Quantidade insuficiente no estoque.';
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fc_baixa_estoque_inc() OWNER TO postgres;

--
-- TOC entry 183 (class 1255 OID 16671)
-- Dependencies: 514 5
-- Name: fc_pedido_cancelado(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fc_pedido_cancelado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ped_prod pedido_produto%ROWTYPE;
BEGIN
  FOR ped_prod IN SELECT * 
		    FROM pedido_produto 
		   WHERE id_pedido = NEW.id
  LOOP
    UPDATE produto
       SET quant = quant + ped_prod.quant
      WHERE ped_prod.id_produto = produto.id;
  END LOOP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.fc_pedido_cancelado() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 162 (class 1259 OID 16602)
-- Dependencies: 5
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cliente (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    cpf_cnpj character varying(20),
    ie character varying(20),
    telefone character varying(10),
    email character varying(50),
    endereco character varying(100),
    num_endereco integer,
    compl_endereco character varying(50),
    cep character varying(9),
    bairro character varying(50),
    cidade character varying(30)
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- TOC entry 161 (class 1259 OID 16600)
-- Dependencies: 162 5
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cliente_id_seq OWNER TO postgres;

--
-- TOC entry 1909 (class 0 OID 0)
-- Dependencies: 161
-- Name: cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cliente_id_seq OWNED BY cliente.id;


--
-- TOC entry 168 (class 1259 OID 16632)
-- Dependencies: 1778 1779 5
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pedido (
    id integer NOT NULL,
    id_cliente integer NOT NULL,
    data_encomenda timestamp without time zone DEFAULT now() NOT NULL,
    data_entrega timestamp without time zone NOT NULL,
    subtotal numeric(5,2) NOT NULL,
    desconto numeric(5,2),
    total numeric(5,2) NOT NULL,
    status integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- TOC entry 167 (class 1259 OID 16630)
-- Dependencies: 5 168
-- Name: pedido_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pedido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pedido_id_seq OWNER TO postgres;

--
-- TOC entry 1910 (class 0 OID 0)
-- Dependencies: 167
-- Name: pedido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pedido_id_seq OWNED BY pedido.id;


--
-- TOC entry 169 (class 1259 OID 16652)
-- Dependencies: 5
-- Name: pedido_produto; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pedido_produto (
    id_pedido integer NOT NULL,
    id_cliente integer NOT NULL,
    id_produto integer NOT NULL,
    quant double precision NOT NULL,
    observacao text
);


ALTER TABLE public.pedido_produto OWNER TO postgres;

--
-- TOC entry 166 (class 1259 OID 16619)
-- Dependencies: 1776 5
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE produto (
    id integer NOT NULL,
    descr character varying(1000) NOT NULL,
    preco numeric(6,2) NOT NULL,
    quant double precision,
    CONSTRAINT quant_check CHECK ((quant > (0)::double precision))
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- TOC entry 165 (class 1259 OID 16617)
-- Dependencies: 166 5
-- Name: produto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE produto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produto_id_seq OWNER TO postgres;

--
-- TOC entry 1911 (class 0 OID 0)
-- Dependencies: 165
-- Name: produto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE produto_id_seq OWNED BY produto.id;


--
-- TOC entry 164 (class 1259 OID 16611)
-- Dependencies: 5
-- Name: status; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE status (
    id integer NOT NULL,
    descr character varying(500) NOT NULL
);


ALTER TABLE public.status OWNER TO postgres;

--
-- TOC entry 163 (class 1259 OID 16609)
-- Dependencies: 5 164
-- Name: status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.status_id_seq OWNER TO postgres;

--
-- TOC entry 1912 (class 0 OID 0)
-- Dependencies: 163
-- Name: status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE status_id_seq OWNED BY status.id;


--
-- TOC entry 1773 (class 2604 OID 16605)
-- Dependencies: 162 161 162
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cliente ALTER COLUMN id SET DEFAULT nextval('cliente_id_seq'::regclass);


--
-- TOC entry 1777 (class 2604 OID 16635)
-- Dependencies: 167 168 168
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pedido ALTER COLUMN id SET DEFAULT nextval('pedido_id_seq'::regclass);


--
-- TOC entry 1775 (class 2604 OID 16622)
-- Dependencies: 166 165 166
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY produto ALTER COLUMN id SET DEFAULT nextval('produto_id_seq'::regclass);


--
-- TOC entry 1774 (class 2604 OID 16614)
-- Dependencies: 164 163 164
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY status ALTER COLUMN id SET DEFAULT nextval('status_id_seq'::regclass);


--
-- TOC entry 1781 (class 2606 OID 16607)
-- Dependencies: 162 162 1902
-- Name: id_cliente_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cliente
    ADD CONSTRAINT id_cliente_pk PRIMARY KEY (id);


--
-- TOC entry 1791 (class 2606 OID 16639)
-- Dependencies: 168 168 168 1902
-- Name: id_id_cliente_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pedido
    ADD CONSTRAINT id_id_cliente_pk PRIMARY KEY (id, id_cliente);


--
-- TOC entry 1787 (class 2606 OID 16628)
-- Dependencies: 166 166 1902
-- Name: id_produto_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY produto
    ADD CONSTRAINT id_produto_pk PRIMARY KEY (id);


--
-- TOC entry 1784 (class 2606 OID 16616)
-- Dependencies: 164 164 1902
-- Name: id_status_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY status
    ADD CONSTRAINT id_status_pk PRIMARY KEY (id);


--
-- TOC entry 1793 (class 2606 OID 16656)
-- Dependencies: 169 169 169 169 1902
-- Name: pedido_cliente_produto_fk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pedido_produto
    ADD CONSTRAINT pedido_cliente_produto_fk PRIMARY KEY (id_pedido, id_cliente, id_produto);


--
-- TOC entry 1788 (class 1259 OID 16640)
-- Dependencies: 168 1902
-- Name: data_encomenda_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX data_encomenda_idx ON pedido USING btree (data_encomenda);


--
-- TOC entry 1789 (class 1259 OID 16641)
-- Dependencies: 168 1902
-- Name: data_entrega_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX data_entrega_idx ON pedido USING btree (data_entrega);


--
-- TOC entry 1785 (class 1259 OID 16629)
-- Dependencies: 166 1902
-- Name: descr_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX descr_idx ON produto USING btree (descr varchar_pattern_ops);


--
-- TOC entry 1782 (class 1259 OID 16608)
-- Dependencies: 162 1902
-- Name: nome_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX nome_idx ON cliente USING btree (nome varchar_pattern_ops);


--
-- TOC entry 1799 (class 2620 OID 16668)
-- Dependencies: 169 182 1902
-- Name: tg_baixa_estoque_inc; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tg_baixa_estoque_inc AFTER INSERT ON pedido_produto FOR EACH ROW EXECUTE PROCEDURE fc_baixa_estoque_inc();


--
-- TOC entry 1798 (class 2620 OID 16672)
-- Dependencies: 183 168 1902
-- Name: tg_pedido_cancelado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tg_pedido_cancelado AFTER UPDATE ON pedido FOR EACH ROW EXECUTE PROCEDURE fc_pedido_cancelado();


--
-- TOC entry 1794 (class 2606 OID 16642)
-- Dependencies: 162 168 1780 1902
-- Name: id_cliente_pedido_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pedido
    ADD CONSTRAINT id_cliente_pedido_fk FOREIGN KEY (id_cliente) REFERENCES cliente(id);


--
-- TOC entry 1796 (class 2606 OID 16657)
-- Dependencies: 169 1790 168 168 169 1902
-- Name: id_pedido_cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pedido_produto
    ADD CONSTRAINT id_pedido_cliente_fk FOREIGN KEY (id_pedido, id_cliente) REFERENCES pedido(id, id_cliente);


--
-- TOC entry 1797 (class 2606 OID 16662)
-- Dependencies: 1786 169 166 1902
-- Name: id_produto_pedido_produto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pedido_produto
    ADD CONSTRAINT id_produto_pedido_produto FOREIGN KEY (id_produto) REFERENCES produto(id);


--
-- TOC entry 1795 (class 2606 OID 16647)
-- Dependencies: 164 168 1783 1902
-- Name: status_pedido_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pedido
    ADD CONSTRAINT status_pedido_fk FOREIGN KEY (status) REFERENCES status(id);


--
-- TOC entry 1907 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-05-25 00:42:59

--
-- PostgreSQL database dump complete
--

