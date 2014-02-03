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

=head1 NAME

Grafica::Controller::Estoque - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c )        = @_;
    my @colunas             = ('Produto', 'Preço', 'Quantidade');
    $c->stash->{'produtos'} = [ $c->model('DB::Produto')->all ];
    $c->stash->{'colunas'}  = \@colunas;
    $c->stash->{'template'} = 'estoque/index.tt2';

}

=head2 editar

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
    if ($id_produto) {
        $c->flash->{'produto'} = $c->model('DB::Produto')->find ($id_produto);
        $action                = $c->uri_for ('atualizar');
    } else {
        $c->flash->{'produto'} = $c->model('DB::Produto')->new({});
        $action                = $c->uri_for ('cadastrar');
    }
    $form_opt{'item'}       = $c->flash->{'produto'};
    $form                   = $self->produto_form->run (%form_opt);
    $c->stash->{'form'}     = $form;
    $c->stash->{'template'} = 'estoque/edit.tt2';
    return unless ($form->validated);
    $c->flash->{'form_params'} = $c->req->params;
    $c->res->redirect ($action);
}

=head2 cadastrar

=cut

sub cadastrar :Local :Args(0) {
    my ( $self, $c ) = @_;
    my $produto      = $c->flash->{'produto'};
    try {
        $produto->insert;
        $c->flash->{'message'} = "Produto " . $produto->id . " cadastrado com sucesso.";
        $c->res->redirect ($c->uri_for (''));
    } catch {
        $c->flash->{'message'} = "Erro ao cadastrar produto: " . $_;
        $c->res->redirect ($c->uri_for ('editar'));
    };
}

=head2 atualizar

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
        $c->res->redirect ('');
    } catch {
        $c->flash->{'message'} = "Erro ao atualizar produto: $_";
        $c->res->redirect ($c->uri_for ('editar'));
    };
}

=head2 excluir

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

=cut

sub detalhes :Local :Args(1) {
    my ( $self, $c, $id_cliente ) = @_;
    $c->stash (
        produto  => $c->model("DB::Produto")->find ($id_cliente),
        template => 'produto/details.tt2',
    );
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
