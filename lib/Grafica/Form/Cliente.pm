# Generated automatically with HTML::FormHandler::Generator::DBIC
# Using following commandline:
# form_generator.pl --rs_name=Grafica::DB::Result::Cliente --schema_name=Grafica::DB --db_dsn=dbi:Pg:dbname=grafica
{
    package Grafica::Form::ClienteForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler';
    use namespace::autoclean;
    with 'HTML::FormHandler::TraitFor::Model::DBIC';
    with 'HTML::FormHandler::Widget::Theme::Bootstrap';

    has '+widget_wrapper'      => ( 
        default => 'Bootstrap' 
    ); 

    has '+item_class'          => ( 
        default => 'Grafica::DB::Result::Cliente' 
    );
    
    has_field 'nome'           => ( 
        type     => 'Text', 
        required => 1, 
    );
    
    has_field 'cpf_cnpj'       => ( 
        type     => 'Text', 
        size     => 20, 
        required => 1, 
    );
    
    has_field 'ie'             => ( 
        type => 'Text', 
        size => 20, 
    );

    has_field 'endereco'       => ( 
        type     => 'Text', 
        required => 1, 
    );
   
    has_field 'num_endereco'   => ( 
        type     => 'Integer', 
        required => 1, 
    );
 
    has_field 'compl_endereco' => ( 
        type => 'Text', 
        size => 50, 
    );

    has_field 'cidade'         => ( 
        type     => 'Text', 
        size     => 30, 
        required => 1, 
    );
    
    has_field 'cep'            => ( 
        type => 'Text', 
        size => 9, 
    );
    
    has_field 'email'          => ( 
        type => 'Text', 
        size => 50, 
    );

    has_field 'telefone'       => ( 
        type => 'Text', 
        size => 10, 
    );
                
    has_field 'submit'       => ( 
        type          => 'submit',
        value         => 'Incluir',
        element_class => ['btn'],
    );

    no HTML::FormHandler::Moose;
    1;
}
