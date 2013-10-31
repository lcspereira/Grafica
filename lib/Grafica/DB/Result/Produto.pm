use utf8;
package Grafica::DB::Result::Produto;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grafica::DB::Result::Produto

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

=head1 TABLE: C<produto>

=cut

__PACKAGE__->table("produto");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'produto_id_seq'

=head2 descr

  data_type: 'varchar'
  is_nullable: 0
  size: 1000

=head2 preco

  data_type: 'numeric'
  is_nullable: 0
  size: [6,2]

=head2 quant

  data_type: 'double precision'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "produto_id_seq",
  },
  "descr",
  { data_type => "varchar", is_nullable => 0, size => 1000 },
  "preco",
  { data_type => "numeric", is_nullable => 0, size => [6, 2] },
  "quant",
  { data_type => "double precision", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 pedido_produtoes

Type: has_many

Related object: L<Grafica::DB::Result::PedidoProduto>

=cut

__PACKAGE__->has_many(
  "pedido_produtoes",
  "Grafica::DB::Result::PedidoProduto",
  { "foreign.id_produto" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-10-27 22:21:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XhTAcy2FcJz/katrbjGrcQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
