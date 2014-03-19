package Grafica::Controller::Pedidos;
use Moose;
use namespace::autoclean;
use Try::Tiny;
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
    my $params       = $c->req->params;
    my $pedido       = $c->model('DB::Pedido')->new({});
    my $form_opt     = {
        params    => $params,
        name      => 'formPedido',
        item      => $pedido,
        no_update => 1, # Impede inserção no banco de dados.
    };
    my $form;

    if ($c->session->{'pedido_dados'}) {
        $form_opt->{'update_field_list'} = {
            cliente      => {
                default => $c->session->{'pedido_dados'}->{'cliente'}->{'id'},
            },
            data_entrega => {
                default => $c->session->{'pedido_dados'}->{'data_entrega'},
            },
        };
    }
    $form = $self->pedido_form->run ($form_opt);
    $c->stash (
        current_view => 'TT',
        template     => 'pedidos/novoPedido.tt2',
        form         => $form
    );
    return unless $form->validated;
    
    $c->session->{'pedido_dados'} = {
        cliente      => {
            id   => $params->{'cliente'},
            nome => $c->model('DB::Cliente')->find($params->{'cliente'})->nome,
        },
        data_entrega => $params->{'data_entrega'},
        produtos     => [],
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
    my @produtos   = @{$c->session->{'pedido_dados'}->{'produtos'}};
    my $form       = $self->pedido_produtos_form->run (
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
        produtos     => \@produtos,
    );
    return unless $form->validated;
    
    $c->flash->{'form_params'} = $params;
    $c->res->redirect ($c->uri_for ('novoPedido', 'add'));
}

=head2 add_produto_pedido

=cut

sub add_produto_pedido :Path('novoPedido/add') Args(0) {
    my ($self, $c)      = @_;
    my $params          = $c->flash->{'form_params'};
    my $produto         = $c->model('DB::Produto')->find($params->{'produto'});
    my @produtos_pedido = @{$c->session->{'pedido_dados'}->{'produtos'}};

    push (@produtos_pedido, { 
        id         => $produto->id,
        descr      => $produto->descr,
        preco      => $produto->preco,
        quantidade => $params->{'quantidade'},
    });
    
    $c->session->{'pedido_dados'}->{'produtos'}  = \@produtos_pedido;
    $c->session->{'pedido_dados'}->{'subtotal'} += $produto->preco * $params->{'quantidade'};
    $c->res->redirect ($c->uri_for ('novoPedido', 'produtos'));
} 

=head2 rem_produto_pedido

=cut

sub rem_produto_pedido :Path('novoPedido/rem') Args(1) {
    my ($self, $c, $id_produto) = @_;    
    my @produtos_pedido         = @{$c->session->{'pedido_dados'}->{'produtos'}};
    my $produto;

    for (0..$#produtos_pedido) {
        $produto = splice (@produtos_pedido, $_, 1) if ($produtos_pedido[$_] && $produtos_pedido[$_]->{'id'} == $id_produto);
    }

    $c->session->{'pedido_dados'}->{'produtos'}  = \@produtos_pedido;
    $c->session->{'pedido_dados'}->{'subtotal'} -= $produto->{'preco'} * $produto->{'quantidade'};
    $c->res->redirect ($c->uri_for ('novoPedido', 'produtos'));
}



=head2 total_pedido

=cut

sub total_pedido :Path('novoPedido/total') Args(0) {
    my ($self, $c)   = @_;
    my $params       = $c->req->params;
    my $pedido       = $c->model('DB::Pedido')->new({});
    my $pedido_dados = $c->session->{'pedido_dados'};
    my $form         = $self->pedido_total_form->run (
        params            => $params,
        name              => 'formPedidoTotal',
        item              => $pedido,
        no_update         => 1,
        update_field_list => {
            subtotal => {
                default => sprintf ("%.2f", $pedido_dados->{'subtotal'}),
            },
        },
    );
    $c->stash (
        current_view => 'TT',
        template     => 'pedidos/pedidoTotal.tt2',
        form         => $form,
        colunas      => [ 'Produto', 'Preço (R$)', 'Quantidade' ],
        pedido_dados => $pedido_dados,
    );
    return unless $form->validated;

    $c->session->{'pedido_dados'}->{'desconto'} = $c->req->params->{'desconto'};
    $c->session->{'pedido_dados'}->{'total'}    = $c->req->params->{'total'};
    $c->res->redirect ($c->uri_for ('novoPedido', 'create'));
}


=head2 criar_pedido

=cut

sub criar_pedido :Path('novoPedido/create') Args(0) {
    my ( $self, $c ) = @_;
    my $pedido_dados = $c->session->{'pedido_dados'};
    my $pedido;
    my $pedido_produto;
    my $produto;

    try {
        $c->model('DB')->txn_do (sub {
            $pedido         = $c->model('DB::Pedido')->create ({
                id_cliente   => $pedido_dados->{'cliente'}->{'id'},
                data_entrega => $pedido_dados->{'data_entrega'},
                subtotal     => $pedido_dados->{'subtotal'},
                desconto     => $pedido_dados->{'desconto'},
                total        => $pedido_dados->{'total'}
             });

            # Relaciona os produtos com o pedido
            # e os insere no banco de dados.

            foreach $produto ($pedido_dados->{'produtos'}) {
                $pedido_produto =  $c->model('DB::PedidoProduto')->create ({
                  id_pedido     => $pedido->id,
                  id_cliente    => $pedido_dados->{'cliente'}->{'id'},
                  id_produto    => $produto->{'id'},
                  quant         => $produto->{'quant'},
                });
            }
        });
        $c->flash->{'message'} = "Pedido " . $pedido->id . " cadastrado com sucesso.";
        undef ($c->session->{'pedido_dados'});
        $c->res->redirect ($c->uri_for (''));
    } catch {
        $c->flash->{'message'} = "Erro ao atualizar pedido: $_";
        $c->res->redirect ($c->uri_for ('novoPedido', 'total'));
    };
}

=head2 cancelar

=cut

sub cancelar :Local Args(1) {
    my ( $self, $c, $id_pedido ) = @_;
    try {
        $c->model('DB::Pedido')->find($id_pedido)->update ({
           status => 2, 
        });
        $c->flash->{'message'} = "Pedido " . $id_pedido . " cancelado.";
        $c->res->redirect ($c->uri_for (''));
    } catch {
        $c->flash->{'message'} = "Erro ao cancelar pedido: $_";
        $c->res->redirect ($c->uri_for (''));
    };
}

=head2 detalhes

=cut

sub detalhes :Local Args(1) {
    my ( $self, $c, $id_pedido ) = @_;
    $c->stash (
    	  pedido   => $c->model('DB::Pedido')->find ($id_pedido),
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
