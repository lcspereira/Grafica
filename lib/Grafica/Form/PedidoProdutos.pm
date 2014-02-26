# Generated automatically with HTML::FormHandler::Generator::DBIC
# Using following commandline:
# form_generator.pl --rs_name=Grafica::DB::Result::Pedido --schema_name=Grafica::DB --db_dsn=dbi:Pg:dbname=grafica

package Grafica::Form::PedidoProdutos;
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

has_field 'produto'      => (
    label         => "Adicionar produto: ",
    type          => 'Select',
    empty_select  => '-- Selecione o produto --', 
);

has_field 'quantidade' => (
    label => 'Quantidade: ',
    type  => 'Float',
);


has_field 'submit'       => ( 
    type          => 'Submit',
    value         => 'Incluir',
    element_class => ['btn', 'btn-primary'],
);

sub options_produto {
    my $self = shift;
    return unless $self->schema;
    my @produtos     = $self->schema->resultset('Produto')->all;
    my @opt_produtos = map { { value => $_->id, label => join (' - ', ($_->descr, 'R$ ' . $_->preco)) } } @produtos;
    return @opt_produtos;
}

no HTML::FormHandler::Moose;
1;

