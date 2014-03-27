DROP TRIGGER IF EXISTS tg_baixa_estoque_inc ON pedido_produto;
DROP FUNCTION IF EXISTS fc_baixa_estoque_inc();

/**********************************************************************
 * fc_baixa_estoque_inc
 **********************************************************************
 * Função de trigger para subtrair os produtos incluidos no pedido
 * do estoque.
 **********************************************************************/
 
CREATE OR REPLACE FUNCTION fc_baixa_estoque_inc () RETURNS TRIGGER AS
$$
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
$$
LANGUAGE plpgsql;

/**********************************************************************/

CREATE TRIGGER tg_baixa_estoque_inc 
AFTER INSERT ON pedido_produto
FOR EACH ROW
EXECUTE PROCEDURE fc_baixa_estoque_inc();
