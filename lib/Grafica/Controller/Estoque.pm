package Grafica::Controller::Estoque;
use Moose;
use Grafica::Form::Produto;
use Try::Tiny;
use Data::Printer;
use namespace::autoclean;
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

# Formulário de produto.
has produto_form => (
    isa     => 'Grafica::Form::Produto',
    is      => 'rw',
    lazy    => 1,
    default => sub { Grafica::Form::Produto->new },
);

=head1 Nome

Grafica::Controller::Estoque

=head1 DESCRIÇÃO

Controller que representa o módulo Estoque.

=head1 MÉTODOS

=cut


=head2 index

Página inicial do módulo Estoque.
Exibe os produtos em estoque, ordenando pela quantidade.
Alerta caso algum produto esteja com menos de 10 unidades no estoque.

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my @colunas      = ('Produto', 'Preço', 'Quantidade');
    my $params       = $c->req->params;
    my @produtos;
    my $where;
    
    #if ($params->{'descr'}) {
    #  $where = {
    #      descr
      #}

    @produtos                   = $c->model('DB::Produto')->search ({}, 
        {
          order_by => { -asc => 'quant' },
        }
    ); 

    $c->stash->{'current_view'} = 'TT';
    $c->stash->{'produtos'}     = \@produtos;
    $c->stash->{'colunas'}      = \@colunas;
    $c->stash->{'template'}     = 'estoque/index.tt2';
    $c->stash->{'num_produtos'} = scalar (@produtos);

}

=head2 editar

Formulário de cadastro / alteração de algum produto do estoque.

@param: Código do produto.
=cut

sub editar :Local :Args() {
    my ( $self, $c, $id_produto ) = @_;
    my $action;
    my $form;
    my $result;
    my %form_opt = (
        params => $c->req->params,
        name   => 'formProduto'
    );

    # Define se o produto será cadastrado ou alterado.
    if ($id_produto) {
        $c->flash->{'produto'} = $c->model('DB::Produto')->find ($id_produto);
        $action                = $c->uri_for ('atualizar');
    } else {
        $c->flash->{'produto'} = $c->model('DB::Produto')->new({});
        $action                = $c->uri_for ('cadastrar');
    }

    $c->stash->{'current_view'} = 'Popup';
    $form_opt{'item'}           = $c->flash->{'produto'};
    $form                       = $self->produto_form->run (%form_opt);
    $c->stash->{'form'}         = $form;
    $c->stash->{'template'}     = 'estoque/edit.tt2';
    return unless ($form->validated);
    $c->flash->{'form_params'} = $c->req->params;
    $c->res->redirect ($action);
}

=head2 cadastrar

Cadastra um novo produto no estoque.

=cut

sub cadastrar :Local :Args(0) {
    my ( $self, $c ) = @_;
    my $produto      = $c->flash->{'produto'};
    try {
        $produto->insert;
        $c->flash->{'message'} = "Produto " . $produto->id . " cadastrado com sucesso.";
        $c->res->body ("<script>window.opener.location.reload (true); window.close();</script>");
    } catch {
        $c->flash->{'message'} = "Erro ao cadastrar produto: " . $_;
        $c->res->redirect ($c->uri_for ('editar'));
    };
}

=head2 atualizar

Altera determinado produto no estoque.

=cut

sub atualizar :Local :Args(0) {
    my ( $self, $c ) = @_;
    my $params       = $c->flash->{'form_params'};
    my $produto;
    try {
        $produto = $c->model('DB::Produto')->find ($c->flash->{'produto'}->id);
        $produto->update ({
            descr => $params->{'descr'},
            preco => $params->{'preco'},
            quant => $params->{'quant'}
        });
        $c->flash->{'message'} = "Produto " . $produto->id . " atualizado com sucesso.";
        $c->res->body ("<script>window.opener.location.reload (true); window.close();</script>");
    } catch {
        $c->flash->{'message'} = "Erro ao atualizar produto: $_";
        $c->res->redirect ($c->uri_for ('editar'));
    };
}

=head2 excluir

Exclui determinado produto do estoque.

@param: Código do produto.

=cut

sub excluir :Local :Args(1) {
    my ( $self, $c, $id_produto ) = @_;
    try {
        $c->model('DB::Produto')->find ($id_produto)->delete;
        $c->flash->{'message'} = "Produto " . $id_produto . " excluído com sucesso.";
    } catch {
        $c->flash->{'message'} = "Erro ao excluir produto: $_";
    };
    $c->res->redirect ($c->uri_for (''));
}

=head2 detalhes

Exibe detalhes sobre produto.

@param: Código do produto.

=cut

sub detalhes :Local :Args(1) {
    my ( $self, $c, $id_cliente ) = @_;
    $c->stash (
        current_view => 'Popup',
        produto      => $c->model("DB::Produto")->find ($id_cliente),
        template     => 'estoque/details.tt2',
    );
}

=encoding utf8

=head1 AUTHOR

Lucas Pereira,,,

=head1 LICENSE

Esta biblioteca é software livre. Você pode redistribuí-la e/ou modificá-la
sob os mesmos termos que o próprio Perl.

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
