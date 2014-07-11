use utf8;
package Grafica::DB::Result::Cliente;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grafica::DB::Result::Cliente

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

=head1 TABLE: C<cliente>

=cut

__PACKAGE__->table("cliente");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'cliente_id_seq'

=head2 nome

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 cpf_cnpj

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 ie

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 telefone

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 endereco

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 num_endereco

  data_type: 'integer'
  is_nullable: 0

=head2 compl_endereco

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 cep

  data_type: 'varchar'
  is_nullable: 1
  size: 9

=head2 cidade

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 bairro

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "cliente_id_seq",
  },
  "nome",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "cpf_cnpj",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "ie",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "telefone",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "endereco",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "num_endereco",
  { data_type => "integer", is_nullable => 0 },
  "compl_endereco",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "cep",
  { data_type => "varchar", is_nullable => 1, size => 9 },
  "cidade",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "bairro",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 pedidoes

Type: has_many

Related object: L<Grafica::DB::Result::Pedido>

=cut

__PACKAGE__->has_many(
  "pedidoes",
  "Grafica::DB::Result::Pedido",
  { "foreign.id_cliente" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2014-07-09 18:28:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:a/YIYDglKCG0IBjnut1fsA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
