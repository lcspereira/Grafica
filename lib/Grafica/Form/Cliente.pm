# Generated automatically with HTML::FormHandler::Generator::DBIC
# Using following commandline:
# form_generator.pl --rs_name=Grafica::DB::Result::Cliente --schema_name=Grafica::DB --db_dsn=dbi:Pg:dbname=grafica
{
    package Grafica::Form::Cliente;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler';
    use namespace::autoclean;
    with 'HTML::FormHandler::TraitFor::Model::DBIC';
    with 'HTML::FormHandler::Widget::Theme::Bootstrap';

    has '+widget_wrapper'      => ( 
        default => 'Bootstrap' 
    ); 

    has '+item_class'          => ( 
        default => 'Cliente' 
    );
    
    has_field 'nome'           => ( 
        type     => 'Text',
        label    => "Nome:",
        required => 1, 
    );
    
    has_field 'cpf_cnpj'       => ( 
        type     => 'Text', 
        label    => 'CPF/CNPJ',
        size     => 20, 
        required => 1, 
    );
    
    has_field 'ie'             => ( 
        type  => 'Text', 
        label => 'I.E.',
        size  => 20, 
    );

    has_field 'endereco'       => ( 
        type     => 'Text',
        label    => 'Endereço',
        required => 1, 
    );
   
    has_field 'num_endereco'   => ( 
        type     => 'Integer', 
        label    => 'Número:',
        required => 1, 
    );
 
    has_field 'compl_endereco' => ( 
        type  => 'Text',
        label => 'Complemento:',
        size  => 50, 
    );

    has_field 'cidade'         => ( 
        type     => 'Text', 
        label    => 'Cidade:',
        size     => 30, 
        required => 1, 
    );
    
    has_field 'cep'            => ( 
        type  => 'Text', 
        label => 'CEP:',
        size  => 9, 
    );
    
    has_field 'email'          => ( 
        type  => 'Text', 
        label => 'E-mail',
        size  => 50, 
    );

    has_field 'telefone'       => ( 
        type  => 'Text',
        label => 'Telefone:',
        size  => 10, 
    );
                
    has_field 'submit'       => ( 
        type          => 'Submit',
        value         => 'Incluir',
        element_class => ['btn'],
    );
    
    no HTML::FormHandler::Moose;
    1;
}
