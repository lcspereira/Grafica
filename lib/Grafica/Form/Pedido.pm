# Generated automatically with HTML::FormHandler::Generator::DBIC
# Using following commandline:
# form_generator.pl --rs_name=Grafica::DB::Result::Pedido --schema_name=Grafica::DB --db_dsn=dbi:Pg:dbname=grafica
{
    package Grafica::Form::Pedido;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    use namespace::autoclean;
    with 'HTML::FormHandler::Widget::Theme::Bootstrap';

    has '+widget_wrapper'    => ( 
        default => 'Bootstrap' 
    ); 

    has '+item_class'        => ( 
        default => 'Grafica::DB::Result::Pedido' 
    );

    has_field 'cliente'      => (
        label    => 'Cliente: ',
        type     => 'Select',
        required => 1,
    );

    has_field 'data_entrega' => ( 
        label            => 'Data de entrega: ',
        type             => 'Date', 
        required         => 1, 
        required_message => 'Por favor, informe a data de entrega.'
    );
    
    has_field 'subtotal'     => ( 
        label    => 'Subtotal: '
        type     => 'Float', 
        required => 1,
        value    => 0,
    );

    has_field 'desconto'     => ( 
        label => 'Desconto: ',
        type  => 'Float',
        value => 0,
    );  
    
    has_field 'total'        => (
        label    => 'Total: '
        type     => 'Float', 
        required => 1,
        value    => 0,
    );

    has_field 'submit'       => ( 
        label  => 'Incluir: '
        widget => 'Submit', 
    );

    no HTML::FormHandler::Moose;
    1;
}

