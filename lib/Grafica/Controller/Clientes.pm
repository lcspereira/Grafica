package Grafica::Controller::Clientes;
use Moose;
use namespace::autoclean;
use Grafica::Form::Cliente;
use Try::Tiny;
use Data::Printer;
use JSON;

use utf8;
BEGIN { extends 'Catalyst::Controller'; }

# Formulário de cliente.
has cliente_form => (
    isa     => 'Grafica::Form::Cliente',
    is      => 'rw',
    lazy    => 1,
    default => sub { Grafica::Form::Cliente->new },
);

=head1 NOME

Grafica::Controller::Clientes - Módulo para cadastro/consulta de clientes.

=head1 DESCRIÇÃO

Controller para cadastro / edição de dados de clientes.

=head1 METODOS

=cut

=head2 index

Primeira página do módulo de clientes.
Lista os clientes cadastrados, e possui formulário
para consulta de clientes por nome.

=cut

sub index :Path() :Args() {
    my ( $self, $c ) = @_;
    my @colunas;
    my @clientes;
    my $params                  = $c->req->params;
    my $form_busca              = HTML::FormHandler->new ( 
        widget_wrapper => "Table",
        name           => "buscaClienteForm",
        field_list     => [
            nome => { 
                name  => "nomeBuscar",
                label => "Nome: ",
                type  => "Text",
            },
            bSubmit => {
                value => "Buscar",
                type  => "Submit"
            }
        ]
    );

  
    $c->stash->{'current_view'} = 'TT';
    $c->stash->{'template'}     = 'clientes/index.tt2';
    if ($c->flash->{'nome_buscar'}) {
        @clientes = $c->model('DB::Cliente')->search({
            nome => {
                -ilike => "%" . $c->flash->{'nome_buscar'} . "%",
            },
        });
        undef ($c->flash->{'nome_buscar'});
    } else {
        @clientes = $c->model('DB::Cliente')->all;
    }

    @colunas                    = ('Nome', 'Endereço', 'Telefone', 'E-mail');
    $c->stash->{'clientes'}     = \@clientes;
    $c->stash->{'colunas'}      = \@colunas;
    $c->stash->{'num_clientes'} = scalar (@clientes);
    $c->stash->{'form_busca'}   = $form_busca;
    return unless $form_busca->process (params => $params);
    $c->flash->{'nome_buscar'} = $params->{'nomeBuscar'};
    $c->res->redirect ($c->uri_for ());
}

=head2 editar

Formulário de edição de cliente.

É utilizado tanto para cadastro novo, quanto para
editar contatos existentes.

@param: Código do cliente.

=cut

sub editar :Local :Args() {
    my ( $self, $c, $id_cliente ) = @_;
    my $form;
    my $action;
    my $result;
    my %form_opt = (
        params => $c->req->params,
        name   => 'formCliente'
    ); # Opções para geração de formulário
    
    $c->stash->{'current_view'} = 'Popup';
    # Verifica se o formulário será preenchido
    # com dados de cliente existente na base de dados,
    # ou se cria um formulário em branco.
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
    $c->stash->{'template'} = 'clientes/edit.tt2';
    
    return unless ($form->validated);              # Validação do formulário.
    
    $c->flash->{'form_params'} = $c->req->params;
    $c->res->redirect ($action);
}


=head2 cadastrar

Cadastra novo cliente.

=cut

sub cadastrar :Local Args(0){
    my ( $self, $c ) = @_;
    my $cliente      = $c->flash->{'cliente'};
    my $message;

    try {
        $cliente->insert;
        $message = "Cliente " . $cliente->id . " cadastrado com sucesso.";
        $c->res->body ("<script>alert ('" . $message . "'); window.opener.location.reload (true); window.close();</script>");
    } catch {
        $message = "Erro ao inserir cliente: $_";
        $c->res->body ("<script>alert ('" . $message . "'); window.opener.location.reload (true); window.close();</script>");
    };
}


=head2 atualizar

Atualiza cliente existente na base de dados.

=cut

sub atualizar :Local {
    my ( $self, $c ) = @_;
    my $params       = $c->flash->{'form_params'};       
    my $cliente;
    my $message;

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
        $message = "Cliente " . $cliente->id . " atualizado com sucesso.";
        $c->res->body ("<script>alert ('$message'); window.opener.location.reload (true); window.close();</script>");
    } catch {
        $message = "Erro ao atualizar cliente: $_";
        $c->res->body ("<script>alert ('$message'); location.href='editar/'" . $cliente->id . ");");
    };
}


=head2 excluir

Exclui o cliente do banco de dados.

@param: Código do cliente.

@param int: Código do cliente.

=cut

sub excluir :Local :Args(1) {
    my ( $self, $c, $id_cliente ) = @_;
    my $message;

    try {
        $c->model('DB::Cliente')->find($id_cliente)->delete;
        $message = "Cliente" . $id_cliente . " excluído com sucesso.";
    } catch {
        $message = "Erro ao excluir cliente: $_"; 
    };
    $message =~ s/\n/\ /g;
    $message =~ s/'/\\'/g;
    $c->res->body ("<script>alert ('$message');location.href = '" . $c->uri_for ("clientes") . "';</script>");
}


=head2 detalhes

Consulta dados de um determinado cliente
e os exibe na tela.

@param: Código do cliente.

=cut

sub detalhes :Local :Args(1) {
    my ( $self, $c, $id_cliente ) = @_;
    my @colunas                   = ("Código", "Data da encomenda", "Data de entrega", 'Total (R$)', "Status");

    $c->stash (
        current_view => 'Popup',
        cliente      => $c->model('DB::Cliente')->find($id_cliente),
        # Procura os pedidos associados ao cliente.
        pedidos      => [ $c->model('DB::Pedido')->search ({
            id_cliente => $id_cliente,
            status     => {
                -in => [ 1, 3 ]
            },  
        }) ],
        template => 'clientes/details.tt2',
        colunas  => \@colunas,
    );
}

=head2 busca_cep

Executa pesquisa de rua por CEP. Imprime o resultado da busca em JSON.

@param: CEP da rua a ser buscado.

=cut

sub busca_cep :Local :Args(1) {
    my ($self, $c, $cep) = @_;
    my $cepper           = WWW::Correios::CEP->new;
    my $addr;

    for (1..3) {
        $addr = $cepper->find ($cep);
        last if ( -z $addr->{'status'});
        sleep (1);
    }
    $c->res->content_type ('application/json');
    $c->res->body (JSON->new->utf8(1)->encode ($addr));
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
