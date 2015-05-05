/***************************************************************************
 * fc_pedido_cancelado
 ***************************************************************************
 * Restaura no estoque as quantidades dos produtos utilizados no pedido
 * cancelado.
 ***************************************************************************/
 
CREATE OR REPLACE FUNCTION fc_pedido_cancelado() RETURNS TRIGGER AS $$
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
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tg_pedido_cancelado
  AFTER UPDATE
  ON pedido
  FOR EACH ROW
  EXECUTE PROCEDURE fc_pedido_cancelado();