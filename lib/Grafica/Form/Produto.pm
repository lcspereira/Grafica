# Generated automatically with HTML::FormHandler::Generator::DBIC
# Using following commandline:
# form_generator.pl --rs_name=Grafica::DB::Result::Produto --schema_name=Grafica::DB --db_dsn=dbi:Pg:dbname=grafica
{
    package Grafica::Form::Produto;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler';
    use namespace::autoclean;
    with 'HTML::FormHandler::TraitFor::Model::DBIC';
    with 'HTML::FormHandler::Widget::Theme::Bootstrap';

    has '+widget_wrapper' => ( 
        default => 'Bootstrap' 
    ); 

    has '+item_class'     => ( 
        default => 'Grafica::DB::Result::Produto' 
    );
    
    has_field 'descr'     => (
        label            => 'Descrição: ',
        type             => 'TextArea', 
        required         => 1,
        message_required => 'Por favor, digite uma breve descrição do produto',
    );

    has_field 'quant'     => ( 
        label            => 'Quantidade: ',
        type             => 'Float', 
        required         => 1,
        message_required => 'Por favor, informe a quantidade do produto'
    );

    has_field 'preco'     => (
        label            => 'Preço: ',
        type             => 'Float', 
        required         => 1,
        message_required => 'Por favor, informe o preço do produto.'
    );
    
    has_field 'submit'       => ( 
        type          => 'submit',
        value         => 'Incluir',
        element_class => ['btn'],
    );

    no HTML::FormHandler::Moose;
    1;
}

