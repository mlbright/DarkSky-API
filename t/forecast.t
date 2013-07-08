use Test::More tests => 3;

use Forecast::IO;

my $lat      = 43.6667;
my $long     = -79.4167;
my $time     = 1373241600;
my $obj      = Forecast::IO->new( key => '3f8d314e139bc4f3c4934803fdbf45d1' );
my $forecast = $obj->get( $lat, $long, $time );

is($forecast->{latitude}, 43.6667);
is($forecast->{currently}->{'time'}, $time);
is($forecast->{currently}->{'temperature'}, 22.32);
