use Test::More tests => 6;

use DarkSky::API;
use strict;
use warnings;
use HTTP::Tiny;
use Test::MockModule;

my $lat  = 43.6667;
my $long = -79.4167;
my $time = 1373241600;

my $mock = Test::MockModule('HTTP::Tiny');
$mock->mock(get => sub {
    return {
        'latitude' => $lat,
        'longitude' => $long,
        'currently' => { 'time' => $time , 'summary' => 'something'},
        'daily' => {'data' => 1},
        'hourly' => {'data' => 1},
    };
});

my $forecast = DarkSky::API->new(
    key       => 'something',
    longitude => $long,
    latitude  => $lat,
    'time'    => $time
);

is( sprintf( "%.4f", $forecast->{latitude} ),  $lat );
is( sprintf( "%.4f", $forecast->{longitude} ), $long );
is( $forecast->{currently}->{'time'}, $time );
ok( exists( $forecast->{daily}->{data} ) );
ok( exists( $forecast->{hourly}->{data} ) );
ok( exists( $forecast->{currently}->{summary} ) );
