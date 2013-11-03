# Generated automatically with HTML::FormHandler::Generator::DBIC
# Using following commandline:
# form_generator.pl --rs_name=Grafica::DB::Result::Cliente --schema_name=Grafica::DB --db_dsn=dbi:Pg:dbname=grafica
{
    package Grafica::DB::Result::ClienteForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    use namespace::autoclean;


    has '+item_class' => ( default => 'Grafica::DB::Result::Cliente' );

    has_field 'cidade'         => ( 
        type     => 'Text', 
        size     => 30, 
        required => 1, 
    );
    has_field 'cep'            => ( 
        type => 'Text', 
        size => 9, 
    );
    has_field 'compl_endereco' => ( 
        type => 'Text', 
        size => 50, 
    );
    has_field 'num_endereco'   => ( 
        type     => 'Integer', 
        required => 1, 
    );
    has_field 'endereco'       => ( 
        type     => 'TextArea', 
        required => 1, 
    );
    has_field 'email'          => ( 
        type => 'Text', 
        size => 50, 
    );
    has_field 'telefone'       => ( 
        type => 'Text', 
        size => 10, 
    );
    has_field 'ie'             => ( 
        type => 'Text', 
        size => 20, 
    );
    has_field 'cpf_cnpj'       => ( type => 'Text', size => 20, required => 1, );
    has_field 'nome'           => ( type => 'TextArea', required => 1, );
    has_field 'pedidoes'       => ( type => '+PedidoField', );
    has_field 'submit'         => ( widget => 'Submit', );

    __PACKAGE__->meta->make_immutable;
    no HTML::FormHandler::Moose;
}


{
    package PedidoField;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Field::Compound';
    use namespace::autoclean;

    has_field 'total'          => ( type => 'TextArea', required => 1, );
    has_field 'desconto'       => ( type => 'TextArea', );
    has_field 'subtotal'       => ( type => 'TextArea', required => 1, );
    has_field 'data_entrega'   => ( type => 'Text', required => 1, );
    has_field 'data_encomenda' => ( type => 'Text', required => 1, );
    has_field 'id_cliente'     => ( type => 'Select', );
    has_field 'status'         => ( type => 'Select', );
    
    __PACKAGE__->meta->make_immutable;
    no HTML::FormHandler::Moose;
}


