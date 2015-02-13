# Generated automatically with HTML::FormHandler::Generator::DBIC
# Using following commandline:
# form_generator.pl --rs_name=Grafica::DB::Result::Cliente --schema_name=Grafica::DB --db_dsn=dbi:Pg:dbname=grafica
package Grafica::Form::Cliente;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
use namespace::autoclean;
use utf8;
with 'HTML::FormHandler::TraitFor::Model::DBIC';
with 'HTML::FormHandler::Widget::Form::Table';

has '+widget_wrapper' => (
  default => 'Table'
);

has '+item_class'          => ( 
    default => 'Cliente' 
);

has_field 'nome'           => ( 
    type             => 'Text',
    label            => "Nome:",
    required         => 1,
    required_message => 'Por favor, informe o nome do cliente.'
);

has_field 'cpf_cnpj'       => ( 
    type             => 'Text', 
    label            => 'CPF/CNPJ: ',
    size             => 20,
    apply            => [ {
        check   => qr/^[0-9]{3}.[0-9]{3}.[0-9]{3}-[0-9]{2}$/,
        message => 'CPF inválido. (CPF deve ser digitado com pontos e traços.)'
    } ]
);

has_field 'ie'             => ( 
    type  => 'Text', 
    label => 'I.E.: ',
    size  => 11,
    apply => [ {
        check   => qr/^[0-9]{3}\/[0-9]{5}$/,
        message => 'I.E. inválido. (I.E. deve ser digitado com a barra.)'
    } ]
);

has_field 'cep'            => ( 
    type  => 'Text', 
    label => 'CEP:',
    size  => 9, 
    apply => [ {
        check   => qr/^[0-9]{8}$/,
        message => 'CEP inválido.'
    } ]
);

has_field 'endereco'       => ( 
    type             => 'Text',
    label            => 'Endereço:',
);

has_field 'num_endereco'   => ( 
    type             => 'Integer', 
    label            => 'Número:',
);

has_field 'compl_endereco' => ( 
    type  => 'Text',
    label => 'Complemento:',
    size  => 50, 
);

has_field 'bairro' => ( 
    type  => 'Text',
    label => 'Bairro:',
    size  => 50, 
);

has_field 'cidade'         => ( 
    type             => 'Text', 
    label            => 'Cidade:',
    size             => 30, 
);


has_field 'email'          => ( 
    type  => 'Text', 
    label => 'E-mail:',
    size  => 50,
    apply => [ {
        check   => qr/\@{1}/,
        message => 'E-mail inválido.'
    } ]
);

has_field 'telefone'       => ( 
    type  => 'Text',
    label => 'Telefone:',
    size  => 10,
);
            
has_field 'bSubmit'       => ( 
    type          => 'Submit',
    value         => 'Incluir',
    element_class => [ qw/btn btn-primary/ ],
);

no HTML::FormHandler::Moose;
1;
