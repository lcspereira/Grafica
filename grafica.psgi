use strict;
use warnings;

use Grafica;

my $app = Grafica->apply_default_middlewares(Grafica->psgi_app);
$app;

