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
                # Caso não consiga carregar os dados da base, 
                # não exibe a tabela.
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

Carrega formulário de pedido.

=cut

sub editar :Local :CaptureArgs(1){
    my ( $self, $c ) = @_;
    my $pedido;
    my @clientes;
    my $validate;
    $c->stash (
        current_view => 'TT',
        template     => 'pedidos/editar.tt2'
    );

    my $form = $self->pedidoForm->run (
        action => 'incluir',
        name   => 'pedidoForm',
    );
    $c->stash (
        form => $form,
    );

    $validate = $form->process ($c->req);
    return unless $form->validated;
    #$c->stash (
    #    form_values => $form->fif
    #);
    $pedido = $c->model(__PACKAGE__->config->{'pedido'})->new({});
    $pedido->populate_from_widget($validate);
    $c->stash->{'widget_result'} = $validate;
}

=head2 cancelar

=cut

sub cancelar :Local :Args(0) {
    my ( $self, $c ) = @_;
}

=head2 detalhes

=cut

sub detalhes :Local :Args(0) {
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
