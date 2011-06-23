use Test::More tests => 9;

BEGIN { use_ok WWW::Shorten::Googl };

# These tests only work if we don't auth
$ENV{ GOOGLE_USERNAME } = undef;
$ENV{ GOOGLE_PASSWORD } = undef;

my $url = 'http://search.cpan.org/dist/WWW-Shorten/';
my $return = makeashorterlink($url);
my ($code) = $return =~ /(\w+)$/;
my $prefix = 'http://goo.gl/';
is ( makeashorterlink($url), $prefix.$code, 'make it shorter - ' . $return);
is ( makealongerlink($prefix.$code), $url, 'make it longer - ' . $url);
is ( makealongerlink($code), $url, 'make it longer by Id',);

my $stats = getlinkstats( $return );
is ( ref $stats, 'HASH', 'Got a stats hash');
is ( $stats->{ status }, 'OK', "...OK status");
ok ( defined $stats->{ created }, "..got created value");

eval { &makeashorterlink() };
ok($@, 'makeashorterlink fails with no args');
eval { &makealongerlink() };
ok($@, 'makealongerlink fails with no args');
