package Grafica::Controller::Pedidos;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Grafica::Form::Pedido;
use feature qw(switch);

has 'pedidoForm' => (
    isa     => 'Grafica::Form::Pedido',
    is      => 'rw',
    lazy    => 1,
    default => sub { Grafica::Form::Pedido->new }
);

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Grafica::Controller::Pedidos - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my @pedidos;
    my @colunas;
    my $err;
    $c->stash (
        current_view => 'TT',
        template     => 'welcome.tt2'
    );

    @pedidos = $c->model('DB::Pedido')->search({
                status => 1,
                status => 3
           });
    @colunas = ("Código", "Data da encomenda", "Data de entrega", "Total", "Status");
    $c->stash (
        pedidos      => \@pedidos,
        colunas      => \@colunas
    );
}

=head2 editar

Carrega formulário de pedido.

=cut

sub editar :Local Args(0){
    my ( $self, $c, $id_pedido) = @_;
    my $produto;
    my @produtos;
    my $pedido;
    my @clientes;
    my $validate;
    $c->stash (
        current_view => 'TT',
        template     => 'pedidos/editar.tt2'
    );

    my $form = $self->pedidoForm->run (
        action => 'incluir',
        params => $c->req->params,
        name   => 'pedidoForm',
    );
    $c->stash (
        form => $form,
    );

    #$validate = $form->process ($c->req);
    return unless $form->validated;
    $pedido = $c->model('DB::Pedido')->new({});
    $pedido->populate_from_widget($validate);
    #foreach $produto (@produtos) {
    #    $pedido->add_to_pedido_produto ({
    #        id_pedido  => $pedido->,
    #        id_cliente => $cliente,
    #        id_produto => $produto,
    #       quant      => $quant
    #    });
    #}
  $c->stash->{'widget_result'} = $form->result;
}

=head2 cancelar

=cut

sub cancelar :Local Args(0) {
    my ( $self, $c ) = @_;
}

=head2 detalhes

=cut

sub detalhes :Local Args(1) {
    my ( $self, $c, $id_pedido ) = @_;
    $c->stash (
    	pedido   => $c->model('DB::Pedido')->find($id_pedido),
    	template => 'src/details.tt2'
    );
}

=encoding utf8

=head1 AUTHOR

Lucas Pereira,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
