# ABSTRACT: provides perl API to Forecast.io
package Forecast::IO;
use strict;
use warnings;
use JSON::PP;
use HTTP::Tiny;
use Moo;

my $api   = "https://api.forecast.io/forecast";
my $docs  = "https://developer.forecast.io/docs/v2";
my %units = (
    si   => 1,
    us   => 1,
    auto => 1,
    ca   => 1,
    uk   => 1,
);

has key => ( is => 'ro' );
has units => (
    is    => 'ro',
    'isa' => sub {
        die "Invalid units specified: see $docs\n"
          unless exists( $units{ $_[0] } );
    },
    'default' => 'auto',
);

sub get {
    my ( $self, $lat, $long, $time ) = @_;

    my $url    = "";
    my $params = "";
    if ( defined $time ) {
        $params = "/$lat,$long,$time";
    }
    else {
        $params = "/$lat,$long";
    }

    $url = $api . '/' . $self->{key} . $params . "?units=" . $self->{units};

    my $response = HTTP::Tiny->new->get($url);

    die "Request to '$url' failed: $response->{status} $response->{reason}\n"
      unless $response->{success};

    return decode_json( $response->{content} );
}

1;
