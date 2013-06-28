# ABSTRACT: provides perl API to Forecast.io
package Forecast::IO;
use strict;
use warnings;
use JSON;
use HTTP::Tiny;
use Moo;

has key => ( is => 'ro' );

sub get {
    my ( $self, $lat, $long ) = @_;
    my $response =
      HTTP::Tiny->new->get("https://api.forecast.io/forecast/$key/$lat,$long");

    die "Failed!\n" unless $response->{success};

    print "$response->{status} $response->{reason}\n";

    while ( my ( $k, $v ) = each %{ $response->{headers} } ) {
        for ( ref $v eq 'ARRAY' ? @$v : $v ) {
            print "$k: $_\n";
        }
    }

    print $response->{content} if length $response->{content};
    
    return decode_json($response->{content});
}

1;
