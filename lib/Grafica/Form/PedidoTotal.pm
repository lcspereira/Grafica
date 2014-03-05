# Generated automatically with HTML::FormHandler::Generator::DBIC
# Using following commandline:
# form_generator.pl --rs_name=Grafica::DB::Result::Pedido --schema_name=Grafica::DB --db_dsn=dbi:Pg:dbname=grafica

package Grafica::Form::PedidoTotal;
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

has_field 'subtotal'     => ( 
    label                 => 'Subtotal: R$ ',
    type                  => 'Float',
    precision             => 2,
    decimal_symbol        => '.',
    decimal_symbol_for_db => '.',
    required              => 1,
    disabled              => 1,
);

has_field 'desconto'     => ( 
    label                 => 'Desconto: R$ ',
    type                  => 'Float',    
    precision             => 2,
    decimal_symbol        => '.',
    decimal_symbol_for_db => '.',
    default               => 0,
);  

has_field 'total'        => (
    label                 => 'Total: R$',
    type                  => 'Float',     
    precision             => 2,
    decimal_symbol        => '.',
    decimal_symbol_for_db => '.',
    required              => 1,
    default               => 0,
);

has_field 'submit'       => ( 
    type          => 'Submit',
    value         => 'Finalizar pedido',
    element_class => ['btn', 'btn-primary'],
);

no HTML::FormHandler::Moose;
1;

