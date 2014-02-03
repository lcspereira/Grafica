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

Grafica::Controller::Clientes - Módulo para cadastro/consulta de clientes.

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
    my @clientes;
    my $params              = $c->req->params;
    $c->stash->{'template'} = 'clientes/index.tt2';
    if ($params->{'nome'}) {
        $c->stash->{'cliente'} = $c->model->('DB::Cliente')->search({
            nome => $params->{'nome'}
        });
    } else {
        $c->stash->{'clientes'} = [ $c->model('DB::Cliente')->all ];
    }
    @colunas               = ('Nome', 'Endereço', 'Telefone', 'E-mail');
    $c->stash->{'colunas'} = \@colunas;
}

=head2 editar

Formulário de edição de cliente.

É utilizado tanto para cadastro novo, quanto para
editar contatos existentes.

@param int: Código do cliente.

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
    $c->flash->{'form_params'} = $c->req->params;
    $c->res->redirect ($action);
}


=head2 cadastrar

Cadastra novo cliente.

=cut

sub cadastrar :Local Args(0){
    my ( $self, $c ) = @_;
    my $cliente = $c->flash->{'cliente'};
    try {
        $cliente->insert;
        $c->flash->{'message'} = "Cliente " . $cliente->id . " cadastrado com sucesso.";
        $c->res->redirect ($c->uri_for (''));
    } catch {
        $c->flash->{'message'}           = "Erro ao inserir cliente: $_";
        $c->res->redirect ($c->uri_for ('editar'));
    };
}


=head2 atualizar

Atualiza cliente na base de dados.

=cut

sub atualizar :Local {
    my ( $self, $c ) = @_;
    my $params       = $c->flash->{'form_params'};       
    my $cliente;
    try {
        # Atualiza cliente conforme os parâmetros.
        $cliente = $c->model('DB::Cliente')->find ($c->flash->{'cliente'}->id);

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
        $c->flash->{'message'}        = "Cliente " . $cliente->id . " adicionado com sucesso.";
        $c->res->redirect ($c->uri_for (''));
    } catch {
      $c->flash->{'message'}           = "Erro ao atualizar cliente: $_";
      $c->res->redirect ($c->uri_for ('editar', $cliente->id));
    };
}


=head2 excluir

Exclui o cliente do banco de dados.

@param int: Código do cliente.

=cut

sub excluir :Local :Args(1) {
    my ( $self, $c, $id_cliente ) = @_;
    try {
        $c->model('DB::Cliente')->find($id_cliente)->delete;
        $c->flash->{'message'} = "Cliente " . $id_cliente . " excluído com sucesso.";
    } catch {
        $c->flash->{'message'} = "Erro ao excluir cliente: $_";
    };
    $c->res->redirect ($c->uri_for (''));
}


=head2 detalhes

Consulta dados de um determinado cliente
e os exibe na tela.

@param int: Código do cliente.

=cut

sub detalhes :Local :Args(1) {
    my ( $self, $c, $id_cliente ) = @_;
    $c->stash (
        cliente  => $c->model('DB::Cliente')->find($id_cliente),
        # Procura os pedidos associados ao cliente.
        pedidos  => [ $c->model('DB::Pedido')->search ({
            id_cliente => $id_cliente,
            status     => {
                -in => [ 1, 3 ]
            },  
        }) ],
        template => 'clientes/details.tt2'
    );
}

=encoding utf8

=head1 AUTHOR

Lucas Pereira (lucas.pereira6c@gmail.com)

=head1 LICENSE

Esta biblioteca é software livre. Você pode redistribuí-la e/ou modificá-la
sob os mesmos termos que o próprio Perl.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
