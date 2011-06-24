use Test::More;
use WWW::Shorten::Googl;

if (! $ENV{GOOGLE_USERNAME} or ! $ENV{GOOGLE_PASSWORD}) {
    plan skip_all =>
        'no GOOGLE_USERNAME or GOOGLE_PASSWORD set in the environment';
    done_testing;
    exit;
}

my $url = 'http://search.cpan.org/dist/WWW-Shorten/';
my $return = makeashorterlink($url);
my $stats = getlinkstats( $return );
is ( ref $stats, 'HASH', 'Got a stats hash');
is ( $stats->{ status }, 'OK', "...OK status");
ok ( defined $stats->{ created }, "..got created value");
ok ( defined $stats->{ analytics }, "..got analytics value");

done_testing;
