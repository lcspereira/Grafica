# Generated automatically with HTML::FormHandler::Generator::DBIC
# Using following commandline:
# form_generator.pl --rs_name=Grafica::DB::Result::Pedido --schema_name=Grafica::DB --db_dsn=dbi:Pg:dbname=grafica
{
    package Grafica::DB::Result::PedidoForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    use namespace::autoclean;
    with 'HTML::FormHandler::Widget::Theme::Bootstrap';


    has '+item_class' => ( 
        default => 'Grafica::DB::Result::Pedido' 
    );

    has_field 'total'            => ( 
        type     => 'TextArea', 
        required => 1, 
    );
    has_field 'desconto'         => ( 
        type => 'TextArea', 
    );
    has_field 'subtotal'         => ( 
        type     => 'TextArea', 
        required => 1, 
    );
    has_field 'data_entrega'     => ( 
        type     => 'Text', 
        required => 1, 
    );
    has_field 'data_encomenda'   => ( 
        type     => 'Text', 
        required => 1, 
    );
    has_field 'id_cliente'       => ( 
        type => 'Select', 
    );
    has_field 'status'           => ( 
        type => 'Select', 
    );
    has_field 'pedido_produtoes' => ( 
        type => '+PedidoProdutoField', 
    );
    has_field 'submit'           => ( 
        widget => 'Submit', 
    );

    __PACKAGE__->meta->make_immutable;
    no HTML::FormHandler::Moose;
}


{
    package PedidoProdutoField;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Field::Compound';
    use namespace::autoclean;
    with 'HTML::FormHandler::Widget::Theme::Bootstrap';

    has_field 'quant'      => ( 
        type     => 'Text', 
        required => 1, 
    );
    has_field 'id_produto' => ( 
        type => 'Select', 
    );
    has_field 'pedido'     => ( 
        type => 'Select', 
    );
    
    __PACKAGE__->meta->make_immutable;
    no HTML::FormHandler::Moose;
}


