use strict;
use warnings;
use JSON;
use HTTP::Tiny;

package Forecast::IO;

# ABSTRACT: provides perl API to Forecast.io

sub new {
    my ( $self, $key ) = @_;
    $self = {};
    $self->{key} = $key;
    bless($self);
    return $self;
}

1;
