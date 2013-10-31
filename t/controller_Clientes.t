use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Grafica';
use Grafica::Controller::Clientes;

ok( request('/clientes')->is_success, 'Request should succeed' );
done_testing();
