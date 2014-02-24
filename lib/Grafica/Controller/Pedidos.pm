package Grafica::Controller::Pedidos;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Storable;
use Grafica::Form::Pedido;
use feature qw(switch);

has 'pedido_form' => (
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

=head2 novoPedido

Inicializa novo pedido

=cut

sub novoPedido :Local Args(0) {
    my ( $self, $c ) = @_;
    my $pedido;
    my $params = $c->req->params;
    my $form   = $self->pedido_form->run (
        params => $params,
        name   => 'formPedido',
        item   => $c->model('DB::Pedido')->new({}),
    );
    $c->stash (
        current_view => 'TT',
        template     => 'pedidos/edit.tt2',
        form         => $form
    );
    return unless $form->validated;
    $c->session->{'pedido'} = {
        cliente      => $params->{'cliente'},
        data_entrega => $params->{'data_entrega'}
    };
    $c->res->redirect ($c->uri_for ('novoPedido/produtos');
}

=head2 produtosPedido

=cut

sub produtosPedido :Path('novoPedido/produtos') Args(0) {
    my ($self, $c)          = @_;
    $c->res->body ("produtos");
}

=head2 totalPedido

=cut

sub totalPedido :Path('novoPedido/total') Args(0) {
    my ($self, $c) = @_;
    $c->res->body ("total");
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
