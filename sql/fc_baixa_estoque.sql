DROP TRIGGER IF EXISTS tg_baixa_estoque_inc;
DROP FUNCTION IF EXISTS fc_baixa_estoque();

CREATE OR REPLACE FUNCTION fc_baixa_estoque () RETURNS TRIGGER AS
$$
BEGIN
    UPDATE produto
    SET quant = quant - NEW.quant;
    WHERE id = NEW.id;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tg_baixa_estoque 
BEFORE INSERT OR UPDATE ON pedido_produto
EXECUTE PROCEDURE fc_baixa_estoque();
