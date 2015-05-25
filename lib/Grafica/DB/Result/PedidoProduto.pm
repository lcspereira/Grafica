use utf8;
package Grafica::DB::Result::PedidoProduto;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grafica::DB::Result::PedidoProduto

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<pedido_produto>

=cut

__PACKAGE__->table("pedido_produto");

=head1 ACCESSORS

=head2 id_pedido

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 id_cliente

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 id_produto

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 quant

  data_type: 'double precision'
  is_nullable: 0

=head2 observacao

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id_pedido",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "id_cliente",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "id_produto",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "quant",
  { data_type => "double precision", is_nullable => 0 },
  "observacao",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_pedido>

=item * L</id_cliente>

=item * L</id_produto>

=back

=cut

__PACKAGE__->set_primary_key("id_pedido", "id_cliente", "id_produto");

=head1 RELATIONS

=head2 id_produto

Type: belongs_to

Related object: L<Grafica::DB::Result::Produto>

=cut

__PACKAGE__->belongs_to(
  "id_produto",
  "Grafica::DB::Result::Produto",
  { id => "id_produto" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 pedido

Type: belongs_to

Related object: L<Grafica::DB::Result::Pedido>

=cut

__PACKAGE__->belongs_to(
  "pedido",
  "Grafica::DB::Result::Pedido",
  { id => "id_pedido", id_cliente => "id_cliente" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-24 23:53:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nt4Dc8s4BSXTs1WCoEE6xw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
