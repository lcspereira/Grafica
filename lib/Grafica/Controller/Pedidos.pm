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

    try {
        @pedidos = $c->model(__PACKAGE__->config->{'pedido'})->search();
        @colunas = $pedidos[0]->meta->get_all_attributes ();
        $c->stash (
            pedidos      => \@pedidos,
            colunas      => \@colunas
        );
    } catch {
        my $err = $_;
        given ($err) {
            when (/Can't\ call\ method\ "meta"\ on\ an\ undefined\ value/) {
                # Caso não consiga carregar os dados da base, não exibe
                # a tabela.
                $c->stash (
                    no_pedidos   => 1
                );
            }
            default {
                die ($err);
            }
        };
    };
}

=head2 editar

Cadastra ou atualiza pedido no banco de dados.

=cut

sub editar :Local :CaptureArgs(1){
    my ( $self, $c ) = @_;
    my $pedido;
    my @clientes;
    my $form = $self->pedidoForm->run (
        params => $c->req->params,
        #action =>
    );
    $c->stash (
        form => $form,
    );
    #return unless $form->validated ();
}

=head2 cancelarPedido

=cut

sub cancelarPedido :Path("/cancelar") :Args(0) {
    my ( $self, $c ) = @_;
}

=head2 detalhes

=cut

sub detalhes :Path("/detalhes") :Args(0) {
    my ( $self, $c ) = @_;
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
