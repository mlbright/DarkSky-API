# ABSTRACT: provides perl API to Forecast.io
package Forecast::IO;
use strict;
use warnings;
use JSON;
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

has latitude  => ( is => 'ro' );
has longitude => ( is => 'ro' );
has 'time'    => ( is => 'ro', default => '' );
has currently => ( is => 'ro' );

sub BUILDARGS {
    my ($class,%args) = @_;

    my $url    = "";
    my $params = "";
    if ( exists($args{time}) && $args{time} ne '' ) {
        $params = '/' . join( ',', $args{latitude}, $args{longitude}, $args{time} );
    }
    else {
        $params = '/' . join( ',', $args{latitude}, $args{longitude});
    }

    if (exists($args{units})) {
        $url = $api . '/' . $args{key} . $params . "?units=" . $args{units};
    } else {
        $url = $api . '/' . $args{key} . $params . "?units=auto";
    }

    my $response = HTTP::Tiny->new->get($url);

    die "Request to '$url' failed: $response->{status} $response->{reason}\n"
      unless $response->{success};

    my $forecast = decode_json( $response->{content} );

    while (my ($key,$val) = each %args) {
        unless ( exists($forecast->{$key})) {
            $forecast->{$key} = $val;
        }
    }
    return $forecast;
}

1;
