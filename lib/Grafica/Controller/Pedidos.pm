package Grafica::Controller::Pedidos;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Storable;
use Data::Printer;
use Grafica::Form::Pedido;
use Grafica::Form::PedidoProdutos;
use Grafica::Form::PedidoTotal;
use HTML::FormHandler;
use utf8;
use feature qw(switch);

# Formulário inicial de pedido
has 'pedido_form' => (
    isa     => 'Grafica::Form::Pedido',
    is      => 'rw',
    lazy    => 1,
    default => sub { Grafica::Form::Pedido->new }
);

# Formulário de seleção de produtos do pedido
has 'pedido_produtos_form' => (
    isa     => 'Grafica::Form::PedidoProdutos',
    is      => 'rw',
    lazy    => 1,
    default => sub { Grafica::Form::PedidoProdutos->new }
);

# Formulário de total do pedido.
has 'pedido_total_form' => (
    isa     => 'Grafica::Form::PedidoTotal',
    is      => 'rw',
    lazy    => 1,
    default => sub { Grafica::Form::PedidoTotal->new }
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

    @pedidos = $c->model('DB::Pedido')->search({
                status => 1,
                status => 3
           });
    @colunas = ("Código", "Data da encomenda", "Data de entrega", "Total", "Status");
    $c->stash (
        pedidos      => \@pedidos,
        colunas      => \@colunas
    );
}

=head2 novo_pedido

Inicializa novo pedido

=cut

sub novo_pedido :Path('novoPedido') Args(0) {
    my ( $self, $c ) = @_;
    my $params = $c->req->params;
    my $pedido = $c->model('DB::Pedido')->new({});
    my $form;

    $form = $self->pedido_form->run (
        params    => $params,
        name      => 'formPedido',
        item      => $pedido,
        no_update => 1, # Impede inserção no banco de dados.
    );
    $c->stash (
        current_view => 'TT',
        template     => 'pedidos/novoPedido.tt2',
        form         => $form
    );
    return unless $form->validated;
    $c->session->{'pedido_dados'} = {
        cliente      => $params->{'cliente'},
        data_entrega => $params->{'data_entrega'}
    };
    $c->res->redirect ($c->uri_for ('novoPedido', 'produtos'));
}

=head2 produtos_pedido

=cut

sub produtos_pedido :Path('novoPedido/produtos') Args(0) {
    my ($self, $c) = @_;
    my $params     = $c->req->params;
    my $pedido     = $c->model('DB::Pedido')->new({});
    my $produto;
    my @produtos   = $c->session->{'pedido_dados'}->{'produtos'};
    my $form = $self->pedido_produtos_form->run (
        params    => $params,
        name      => 'formPedidoProdutos',
        item      => $pedido,
        no_update => 1,
    );
    $c->stash (
        current_view => 'TT',
        template     => 'pedidos/pedidoProdutos.tt2',
        form         => $form,
        colunas      => [ 'Produto', 'Preço (R$)', 'Quantidade' ],
        
    );
    return unless $form->validated;
    $c->flash->{'form_params'} = $params;
    $c->res->redirect ($c->uri_for ('novoPedido', 'add'));
}

=head2 add_produto_pedido

=cut

sub add_produto_pedido :Path('novoPedido/add') Args(0) {
    my ($self, $c) = @_;
    my $params     = $c->flash->{'form_params'};
    my $produto    = $c->model('DB::Produto')->find($params->{'produto'});
    my @produtos   = $c->session->{'pedido_dados'}->{'produtos'} || ();
    push (@produtos, { 
        id         => $produto->id,
        descr      => $produto->descr,
        preco      => $produto->preco,
        quantidade => $params->{'quantidade'},
    });
    $c->session->{'pedido_dados'}->{'produtos'}  = \@produtos;
    $c->session->{'pedido_dados'}->{'subtotal'} += $produto->preco * $params->{'quantidade'};
    $c->res->redirect ($c->uri_for ('novoPedido', 'produtos'));
} 

=head2 rem_produto_pedido

=cut

sub rem_produto_pedido :Path('novoPedido/rem') Args(1) {
    my ($self, $c, $id_produto) = @_;    
    my @produtos                = $c->session->{'pedido_dados'}->{'produtos'};
    my $produto;

    for (0..length (@produtos)) {
        $produto = splice (@produtos, $_) if ($produtos[$_]->{'produto'} == $id_produto);
    }
        
    $c->session->{'pedido_dados'}->{'produtos'}  = \@produtos;
    $c->session->{'pedido_dados'}->{'subtotal'} -= $produto->{'preco'} * $produto->{'quantidade'};
    $c->res->redirect ($c->uri_for ('novoPedido', 'produtos'));

}



=head2 total_pedido

=cut

sub total_pedido :Path('novoPedido/total') Args(0) {
    my ($self, $c) = @_;
    
}

=head2 cancelar

=cut

sub cancelar :Local Args(0) {
    my ( $self, $c ) = @_;
}

=head2 detalhes

=cut

sub detalhes :Local Args(1) {
    my ( $self, $c, $id_pedido ) = @_;
    $c->stash (
    	pedido   => $c->model('DB::Pedido')->find($id_pedido),
    	template => 'src/details.tt2'
    );
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
