package Grafica::Controller::Estoque;
use Moose;
use Grafica::Form::Produto;
use Try::Tiny;
use Data::Printer;
use namespace::autoclean;
use Spreadsheet::XLSX;
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

sub index :Path() :Args(0) {
    my ( $self, $c ) = @_;
    my @colunas      = ('Código', 'Produto', 'Preço', 'Quantidade');
    my $params       = $c->req->params;
    my @produtos;
    my $where;
    my $form_busca              = HTML::FormHandler->new ( 
        widget_wrapper => "Table",
        name           => "buscaProdutoForm",
        field_list     => [
            nome => { 
                name  => "descrBuscar",
                label => "Nome: ",
                type  => "Text",
            },
            bSubmit => {
                value => "Buscar",
                type  => "Submit"
            }
        ]
    );

    if ($c->flash->{'descr_buscar'}) {
        @produtos = $c->model('DB::Produto')->search({
            descr => {
                -ilike => "%" . $c->flash->{'descr_buscar'} . "%",
            },
        });
        undef ($c->flash->{'descr_buscar'});
    } else {
        @produtos = $c->model('DB::Produto')->search ({}, {
            order_by => { -asc => 'quant' },
        });
    }

    $c->stash->{'current_view'} = 'TT';
    $c->stash->{'produtos'}     = \@produtos;
    $c->stash->{'colunas'}      = \@colunas;
    $c->stash->{'template'}     = 'estoque/index.tt2';
    $c->stash->{'num_produtos'} = scalar (@produtos);
    $c->stash->{'form_busca'}   = $form_busca;
    return unless $form_busca->process (params => $params);
    $c->flash->{'descr_buscar'} = $params->{'descrBuscar'};
    $c->res->redirect ($c->uri_for ());
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
    my $message;

    try {
        $produto->insert;
        $message = "Produto " . $produto->id . " cadastrado com sucesso.";
        $c->res->body ("<script>alert ('" . $message . "'); window.opener.location.reload (true); window.close();</script>");
    } catch {
        $message = "Erro ao cadastrar produto: $_";
        $c->res->body ("<script>alert ('$message'); location.href='editar/'" . $produto->id . ");");
    };
}

=head2 atualizar

Altera determinado produto no estoque.

=cut

sub atualizar :Local :Args(0) {
    my ( $self, $c ) = @_;
    my $params       = $c->flash->{'form_params'};
    my $produto;
    my $message;

    try {
        $produto = $c->model('DB::Produto')->find ($c->flash->{'produto'}->id);
        $produto->update ({
            descr => $params->{'descr'},
            preco => $params->{'preco'},
            quant => $params->{'quant'}
        });
        $c->flash->{'message'} = "Produto " . $produto->id . " atualizado com sucesso.";
        $c->res->body ("<script>window.opener.location.reload (true); window.close();</script>");
        
        
        $message = "Produto " . $produto->id . " atualizado com sucesso.";
        $c->res->body ("<script>alert ('" . $message . "'); window.opener.location.reload (true); window.close();</script>");
    } catch {
        $message = "Erro ao cadastrar produto: $_";
        $c->res->body ("<script>alert ('$message'); location.href='editar/'" . $produto->id . ");");
    };
}

=head2 excluir

Exclui determinado produto do estoque.

@param: Código do produto.

=cut

sub excluir :Local :Args(1) {
    my ( $self, $c, $id_produto ) = @_;
    my $message;

    try {
        $c->model('DB::Produto')->find ($id_produto)->delete;
        $message = "Produto " . $id_produto . " excluído com sucesso.";
    } catch {
        $message = "Erro ao excluir produto: $_";
    };
    $message =~ s/\n/\ /g;
    $message =~ s/'/\\'/g;
    $c->res->body ("<script>alert ('$message');location.href = '" . $c->uri_for . "';</script>");
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

=head2 exportar

Exporta planilha de estoque para o sistema

=cut

sub exportar :Local :Args(0) {
    my ( $self, $c ) = @_;
    my $excel;
    my $worksheet;
    my $upload;
    my $linha;
    my $cell;
    my $form_export  = HTML::FormHandler->new ( 
        widget_wrapper => "Table",
        name           => "exportaPlanilhaForm",
        enctype        => "multipart/form-data",
        field_list     => [
            nome => { 
                name     => "arqPlanilha",
                label    => "Planilha: ",
                type     => "Upload",
                maxsize  => "20000",
                required => 1,
            },
            bSubmit => {
                value => "Exportar",
                type  => "Submit"
            }
        ]
    );
    my $produto;
    my $message;

    $c->stash->{'form'}         = $form_export;
    $c->stash->{'current_view'} = "Popup";
    $c->stash->{'template'}     = "estoque/export.tt2";
    if ($c->req->method eq "POST") {
        $c->req->params->{arqPlanilha} = $c->req->upload ('arqPlanilha');
        $form_export->process (params => $c->req->params);
    }
    return unless ($form_export->validated);
    #=====================================================================================
    # Processamento da planilha
    #=====================================================================================
    try {
        $upload = $c->req->params->{arqPlanilha};
        die ("Formato de planilha inválido.") if ($upload->tempname !~ /.xlsx$/i);
        $excel     = Spreadsheet::XLSX->new ($upload->tempname);
        $worksheet = $excel->{'Worksheet'}[0];
        die ("Estrutura de planilha inválida.") if ($worksheet->{'MaxCol'} != 1);

        foreach $linha ($worksheet->{'MinRow'}..$worksheet->{'MaxRow'}) {
            $produto = $c->model('DB::Produto')->find ($worksheet->{'Cells'}[$linha][0]->{'Val'});
            if ($produto) {
                $produto->update ({
                    descr => $worksheet->{'Cells'}[$linha][1]->{'Val'},
                    preco => $worksheet->{'Cells'}[$linha][2]->{'Val'},
                    quant => $worksheet->{'Cells'}[$linha][3]->{'Val'}, 
                });
            } else {
                $produto = $c->model('DB::Produto')->new ({
                    descr => $worksheet->{'Cells'}[$linha][1]->{'Val'},
                    preco => $worksheet->{'Cells'}[$linha][2]->{'Val'},
                    quant => $worksheet->{'Cells'}[$linha][3]->{'Val'},
                });
                $produto->insert;
            }
        }
        $c->res->body ("<script>alert ('Planilha exportada com sucesso.'); window.opener.location.reload (true); window.close();</script>");
    } catch { 
        $message = "Erro ao exportar planilha: $_";
        $message =~ s/\n/\ /g;
        $c->res->body ("<script>alert ('$message'); location.href=\"./exportar\";</script>");
    }
    #=====================================================================================
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
