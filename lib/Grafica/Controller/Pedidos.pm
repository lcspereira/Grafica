package Grafica::Controller::Pedidos;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use HTML::FormHandler;
use feature qw(switch);


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

=head2 cadastrar

Cadastra ou atualiza pedido no banco de dados.

=cut

sub cadastrar :Path("/cadastrar") :Args(1) {
    my ( $self, $c ) = @_;
    my $pedido;
    my @clientes;
    my $form;

    try {
        if (defined ($c->req->params)) {
            $pedido = $c->model(__PACKAGE__->config->{'pedido'})->find ({ id => $c->req->params->{'id'}});
        } else {
           $pedido = $c->model(__PACKAGE__->config->{'pedido'})->new;
        }
        foreach my $cliente ($c->model(__PACKAGE__->config->{'cliente'})->search ()) {
            push (@clientes, $cliente->nome);
        }
        $form = HTML::FormHandler->new (
            name       => 'pedido',
            field_list => [ 
                cliente => {
                    Type    => 'Select',
                    options => \@clientes,
                    m
    } catch {
    };
}

=head2 excluir

=cut

sub excluir :Path :Args(0) {
    my ( $self, $c ) = @_;
}

=head2 index

=cut

sub detalhes :Path :Args(0) {
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
