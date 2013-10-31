use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Grafica';
use Grafica::Controller::Estoque;

ok( request('/estoque')->is_success, 'Request should succeed' );
done_testing();
