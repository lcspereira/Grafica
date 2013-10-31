package Grafica::Controller::Pedidos;
use Moose;
use namespace::autoclean;
use Try::Tiny;
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

=cut

sub cadastrar :Path("/cadastrar") :Args(0) {

}

=head2 excluir

=cut

sub excluir :Path :Args(0) {
  
}

=head2 index

=cut

sub detalhes :Path :Args(0) {

}

=encoding utf8

=head1 AUTHOR

Lucas Pereira,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
