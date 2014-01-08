package Grafica::Controller::Clientes;
use Moose;
use namespace::autoclean;
use Grafica::Form::Cliente;
use Try::Tiny;
use Data::Printer;
use utf8;
BEGIN { extends 'Catalyst::Controller'; }

# Formulário de cliente.
has cliente_form => (
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

=head2 index

Primeira página do módulo de clientes.
Lista os clientes cadastrados, e possui formulário
para consulta de clientes por nome.
TODO: Implementar pesquisa por endereço.

=cut

sub index :Path() :Args(0) {
    my ( $self, $c ) = @_;
    my @colunas;
    my @colunas_tabela;
    my $params              = $c->req->params;
    $c->stash->{'template'} = 'clientes/index.tt2';
    if ($params->{'nome'}) {
        $c->stash->{'cliente'} = $c->model->('DB::Cliente')->search({
            nome => $params->{'nome'}
        });
    } else {
        $c->stash->{'clientes'} = $c->model('DB::Cliente')->all;
    }
    @colunas               = ('Nome', 'Endereço', 'Telefone', 'E-mail');
    $c->stash->{'colunas'} = \@colunas;
}

=head2 editar

Formulário de edição de cliente.

É utilizado tanto para cadastro novo, quanto para
editar contatos existentes.

=cut

sub editar :Local :Args() {
    my ( $self, $c, $id_cliente ) = @_;
    my $form;
    my $action;
    my $result;
    my %form_opt = (
        params => $c->req->params,
        name   => 'formCliente'
    );
    if ($id_cliente) {
        $c->flash->{'cliente'} = $c->model('DB::Cliente')->find($id_cliente);
        $action                = $c->uri_for ('atualizar');
    } else {
        $c->flash->{'cliente'} = $c->model('DB::Cliente')->new({});
        $action                = $c->uri_for ('cadastrar');
    }
    $form_opt{'item'}       = $c->flash->{'cliente'};
    $form                   = $self->cliente_form->run(%form_opt);
    $c->stash->{'form'}     = $form;
    $c->stash->{'template'} ='clientes/edit.tt2';
    return unless ($form->validated);
    $c->res->redirect ($action);
}


=head2 cadastrar

Cadastra novo cliente.

=cut

sub cadastrar :Local Args(0){
    my ( $self, $c ) = @_;
    my $cliente = $c->flash->{'cliente'};
    try {
        $cliente->insert();
        $c->flash->{'cliente_insert'} = $cliente;
        $c->flash->{'insert_success'} = 1;
        $c->res->redirect ($c->uri_for (''));
    } catch {
        $c->flash->{'erro'}           = "Erro ao inserir cliente: $_";
        $c->flash->{'insert_success'} = undef;
        $c->res->redirect ($c->uri_for ('editar'));
    };
}


=head2 atualizar

Atualiza cliente na base de dados.

=cut

sub atualizar :Local {
    my ( $self, $c ) = @_;
    my $params       = $c->req->params;       
    my $cliente;
    try {
        # Atualiza cliente conforme os parâmetros.
        $cliente = $c->flash->{'cliente'};
        $cliente->update ({
            nome           => $params->{'nome'},
            cpf_cnpj       => $params->{'cpf_cnpj'},
            ie             => $params->{'ie'},
            telefone       => $params->{'telefone'},
            email          => $params->{'email'},
            endereco       => $params->{'endereco'},
            num_endereco   => $params->{'num_endereco'},
            compl_endereco => $params->{'compl_endereco'},
            cep            => $params->{'cep'},
            cidade         => $params->{'cidade'}
        });
        $c->flash->{'cliente_update'}        = $cliente;
        $c->flash->{'update_success'} = 1;
        $c->res->redirect ($c->uri_for (''));
    } catch {
      $c->flash->{'erro'}           = "Erro ao atualizar cliente: $_";
      $c->log->debug ($c->flash->{'erro'});
      $c->flash->{'update_success'} = undef;
      $c->res->redirect ($c->uri_for ('editar', $cliente->id));
    };
}


=head2 excluir

Exclui o(s) cliente(s) do banco de dados.

=cut

sub excluir :Local :Args(0) {
    my ( $self, $c) = @_;
    my $id_cliente;
    try {
        # Exclui os clientes em transação.
        $c->model('DB::Cliente')->txn_do(sub {
              foreach $id_cliente ($c->session->{'clientesExcluir'}) {
                  $c->model('DB::Cliente')->find($id_cliente)->delete;
              }
        });
        $c->session->{'delete_success'} = 1;
        $c->res->redirect ($c->uri_for ('index'));
    } catch {
        die ("Erro ao excluir cliente $id_cliente: $_");
    };
}


=head2 detalhes

Consulta dados de um determinado cliente
e os exibe na tela.

=cut

sub detalhes :Local :Args(1) {
    my ( $self, $c, $id_cliente ) = @_;
    $c->stash (
        cliente  => $c->model('DB::Cliente')->find($id_cliente),
        # Procura os pedidos associados ao cliente.
        pedidos  => $c->model('DB::Pedido')->search ({
            id_cliente => $id_cliente,
            status     => {
                -between => [1, 3]
            }, 
            {
                join => 'pedido',
            }
        }),
        template => 'clientes/details.tt2'
    );
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
