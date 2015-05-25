use utf8;
package Grafica::DB::Result::Pedido;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grafica::DB::Result::Pedido

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

=head1 TABLE: C<pedido>

=cut

__PACKAGE__->table("pedido");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'pedido_id_seq'

=head2 id_cliente

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 data_encomenda

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 data_entrega

  data_type: 'timestamp'
  is_nullable: 0

=head2 subtotal

  data_type: 'numeric'
  is_nullable: 0
  size: [5,2]

=head2 desconto

  data_type: 'numeric'
  is_nullable: 1
  size: [5,2]

=head2 total

  data_type: 'numeric'
  is_nullable: 0
  size: [5,2]

=head2 status

  data_type: 'integer'
  default_value: 1
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "pedido_id_seq",
  },
  "id_cliente",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "data_encomenda",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "data_entrega",
  { data_type => "timestamp", is_nullable => 0 },
  "subtotal",
  { data_type => "numeric", is_nullable => 0, size => [5, 2] },
  "desconto",
  { data_type => "numeric", is_nullable => 1, size => [5, 2] },
  "total",
  { data_type => "numeric", is_nullable => 0, size => [5, 2] },
  "status",
  {
    data_type      => "integer",
    default_value  => 1,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=item * L</id_cliente>

=back

=cut

__PACKAGE__->set_primary_key("id", "id_cliente");

=head1 RELATIONS

=head2 id_cliente

Type: belongs_to

Related object: L<Grafica::DB::Result::Cliente>

=cut

__PACKAGE__->belongs_to(
  "id_cliente",
  "Grafica::DB::Result::Cliente",
  { id => "id_cliente" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 pedido_produtoes

Type: has_many

Related object: L<Grafica::DB::Result::PedidoProduto>

=cut

__PACKAGE__->has_many(
  "pedido_produtoes",
  "Grafica::DB::Result::PedidoProduto",
  {
    "foreign.id_cliente" => "self.id_cliente",
    "foreign.id_pedido"  => "self.id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 status

Type: belongs_to

Related object: L<Grafica::DB::Result::Status>

=cut

__PACKAGE__->belongs_to(
  "status",
  "Grafica::DB::Result::Status",
  { id => "status" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-24 23:53:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TBc804SE1ov1ddwAP1ffIQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
