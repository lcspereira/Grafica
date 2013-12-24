package Grafica::Controller::Clientes;
use Moose;
use namespace::autoclean;
use Grafica::Form::Cliente;
use Catalyst qw/Session Session::Store::FastMmap Session::State::Cookie/;
use utf8;
BEGIN { extends 'Catalyst::Controller'; }

has clienteForm => (
  isa     => 'Grafica::Form::Cliente',
  is      => 'rw',
  lazy    => 1,
  default => sub { Grafica::Form::Cliente->new },
);

=head1 NAME

Grafica::Controller::Clientes - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 formulario

=cut

sub formulario {
    my ($self, $c, $idCliente) = @_;
    my $result;
    my %formOpt = (
        params => $c->req->params,
    );
    if ($idCliente) {
        $formOpt{'action'} = $c->uri_for(qw/clientes atualizar/);
        $formOpt{'item'}   = $c->model('DB::Cliente')->find($idCliente);
    } else {
        $formOpt{'action'} = $c->uri_for(qw/clientes cadastrar/);
    }
    $result = $self->clienteForm->run(%formOpt);
    return $result;
}

=head2 index

=cut

sub index :Path() :Args(0) {
    my ( $self, $c ) = @_;
    my @colunas;
    my @colunas_tabela;
    my $params = $c->req->params;
    $c->stash (
        current_view => 'TT',
        template     => 'clientes/index.tt2',
    );
    if ($params->{'nome'}) {
        $c->stash (
            cliente => $c->model->('DB::Cliente')->search( 
                {
                    nome => $params->{'nome'}
                }
            )
        );
    } else {
        $c->stash (
            clientes => $c->model('DB::Cliente')->all
        );
    }
    @colunas  = ('Nome', 'Endereço', 'Telefone', 'E-mail');
    $c->stash (
        colunas  => \@colunas,
    );
    
}

=head2 index

=cut

sub editar :Local :Args(0) {
    my ( $self, $c) = @_;
    my $form        = $self->formulario($c);
    $c->stash (
        form     => $form,
        template => 'clientes/edit.tt2'
    );
    return unless $form->validated ();
}


=head2 index

=cut

sub cadastrar :Local {
    my ( $self, $c ) = @_;
    my $cliente = $c->model('DB::Cliente')->new_result({});
    $DB::Single = 1;
    $c->stash (
        cliente        => $cliente,
        insert_success => 1
    );
    
    $c->res->redirect($c->uri_for(qw/clientes/));
}

=head2 index

=cut

sub excluir :Local :Args(0) {
    my ( $self, $c ) = @_;
    
}


=head2 index

=cut

sub detalhes :Local :Args(1) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Grafica::Controller::Clientes in Clientes.');
}

=encoding utf8

=head1 AUTHOR

,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
