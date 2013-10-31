package Grafica::Controller::Estoque;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Grafica::Controller::Estoque - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Grafica::Controller::Estoque in Estoque.');
}

=head2 index

=cut

sub cadastrar :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Grafica::Controller::Estoque in Estoque.');
}

=head2 index

=cut

sub excluir :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Grafica::Controller::Estoque in Estoque.');
}

=head2 index

=cut

sub detalhes :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Grafica::Controller::Estoque in Estoque.');
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
