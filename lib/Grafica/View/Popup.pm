package Grafica::View::Popup;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    PRE_PROCESS        => 'config/main',
    WRAPPER            => 'site/popup_wrapper',
    TEMPLATE_EXTENSION => '.tt',
    INCLUDE_PATH       => [ 
      Grafica->path_to ('root', 'src'),
      Grafica->path_to ('root', 'lib'),
    ],
    TIMER              => 0,
    static_root        => '/static',
    static_build       => 0,
    ENCODING           => 'utf8',
});

sub template_vars {
    my $self = shift;
    return (
        $self->NEXT::template_vars(@_),
        static_root  => $self->{static_root},
        static_build => $self->{static_build}
    );
}

=head1 NAME

Grafica::View::Popup - Catalyst TT::Bootstrap View

=head1 SYNOPSIS

See L<Grafica>

=head1 DESCRIPTION

Catalyst TT::Bootstrap View.

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
