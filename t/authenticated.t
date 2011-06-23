use Test::More;

BEGIN { use_ok WWW::Shorten::Googl };

plan skip_all => 'no GOOGLE_USERNAME or GOOGLE_PASSWORD set in the environment'
    unless $ENV{GOOGLE_USERNAME} and $ENV{GOOGLE_PASSWORD};

my $url = 'http://search.cpan.org/dist/WWW-Shorten/';
my $return = makeashorterlink($url);
my $stats = getlinkstats( $return );
is ( ref $stats, 'HASH', 'Got a stats hash');
is ( $stats->{ status }, 'OK', "...OK status");
ok ( defined $stats->{ created }, "..got created value");
ok ( defined $stats->{ analytics }, "..got analytics value");

done_testing;
