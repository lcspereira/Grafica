use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Grafica';
use Grafica::Controller::Pedidos;

ok( request('/pedidos')->is_success, 'Request should succeed' );
done_testing();
