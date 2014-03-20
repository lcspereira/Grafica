# Generated automatically with HTML::FormHandler::Generator::DBIC
# Using following commandline:
# form_generator.pl --rs_name=Grafica::DB::Result::Pedido --schema_name=Grafica::DB --db_dsn=dbi:Pg:dbname=grafica

package Grafica::Form::Pedido;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use namespace::autoclean;
with 'HTML::FormHandler::TraitFor::Model::DBIC';
with 'HTML::FormHandler::Widget::Theme::Bootstrap';

has '+widget_wrapper'    => ( 
    default => 'Bootstrap' 
); 

has '+item_class'        => ( 
    default => 'Grafica::DB::Result::Pedido' 
);

has_field 'cliente'      => (
    label            => 'Cliente: ',
    type             => 'Select',
    required         => 1,
    required_message => 'Por favor, selecione um cliente.',
    empty_select     => '-- Selecione o cliente -- ',
);

has_field 'data_entrega' => ( 
    label            => 'Data de entrega: ',
    type             => 'Date', 
    format           => 'dd/mm/yy',
    required         => 1, 
    required_message => 'Por favor, informe a data de entrega.'
);


has_field 'submit'       => ( 
    type          => 'Submit',
    value         => 'Incluir',
    element_class => ['btn', 'btn-primary'],
);

sub options_cliente {
    my $self = shift;
    return unless $self->schema;i
    my @clientes     = $self->schema->resultset('Cliente')->all;
    my @opt_clientes = map { { value => $_->id, label => $_->nome } } @clientes;
    return @opt_clientes;
}

no HTML::FormHandler::Moose;
1;
