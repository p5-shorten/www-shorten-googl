
package WWW::Shorten::Googl;

use 5.006;
use strict;
use warnings;

use base qw( WWW::Shorten::generic Exporter );
our @EXPORT = qw( makeashorterlink makealongerlink );
our $VERSION = '1.02';

{
    # As docs advice you use this module as "use WWW::Shorten 'Googl'"
    # that module takes care of the importing.. so let's hack this in here
    no strict 'refs';
    *{"main::getlinkstats"} = *{"WWW::Shorten::Googl::getlinkstats"};
}

use JSON::Any;
use Carp;

use constant API_URL     => 'https://www.googleapis.com/urlshortener/v1/url';
use constant HISTORY_URL => 'https://www.googleapis.com/urlshortener/v1/url/history';

# 2015-03-31 adding a DEBUG variable to run in DEBUG mode
#my $DEBUG = 1;
my $DEBUG = 0;

# 2015-03-31 - by bennythejudge (github)
# use an environment variable - GOOGLE_API_KEY - to pass
# the required Google API Key
sub makeashorterlink ($) {
    my $url = shift or croak 'No URL passed to makeashorterlink';
    
    # check if the API key is available in the environment
    my $google_api_key;
    if (  ! $ENV{ GOOGLE_API_KEY } ) {
      croak 'No GOOGLE_API_KEY environment variable set. Please check the documentation.';
    }
    $google_api_key = $ENV{ GOOGLE_API_KEY };
    ($DEBUG) && print "DEBUG: google_api_key: $google_api_key \n";

    my $json = JSON::Any->new;
    my $content = $json->objToJson({
        longUrl => $url,
    });

    # 2015-03-31 - modifying to pass the Google API Key
    #my $res = _request( 'post', API_URL, Content => $content);
    my $res = _request( 'post', API_URL . '?key=' . $google_api_key , Content => $content);
    return $res->{ id } if ( $res->{ id } );
    return undef;
}

sub makealongerlink ($) {
    my $url = shift
        or croak 'No goo.gl key / URL passed to makealongerlink';

    $url = "http://goo.gl/$url"
        unless $url =~ m!^http://!i;

    my $res = _request( 'get', API_URL . '?shortUrl=' . $url);
    return $res->{ longUrl } if ( $res->{ longUrl } );
    return undef;
}

sub getlinkstats ($) {
    my $url = shift
        or croak 'No goo.gl key / URL passed to makealongerlink';

    $url = "http://goo.gl/$url"
        unless $url =~ m!^http://!i;

    my $res = _request( 'get', API_URL . '?projection=FULL&shortUrl=' . $url);
    return $res;
}

sub _request {
    my ( $method, $url, @args ) = @_;

    my $ua = __PACKAGE__->ua();
    my %headers = ();
    if ( $ENV{ GOOGLE_USERNAME } && $ENV{ GOOGLE_PASSWORD } ) {
        $headers{ Authorization } = _authorize( $ENV{ GOOGLE_USERNAME }, $ENV{ GOOGLE_PASSWORD } );
    }
    $headers{ 'Content-Type' } = 'application/json';

    my $resp = $ua->$method( $url, %headers, @args );
    die "Request failed - " . $resp->status_line unless $resp->is_success;

    my $json = JSON::Any->new;
    my $obj = $json->jsonToObj( $resp->content );
    return $obj;
}

sub _authorize {
    my ( $username, $password ) = @_;

    eval "require Net::Google::AuthSub";
    if ( $@ ) {
        die "You need to install Net::Google::AuthSub to enable URL tracking";
    }

    my $auth = Net::Google::AuthSub->new(
        service => 'urlshortener',
        source  => 'perl/www-shorten-googl',
    );
    my $res = $auth->login( $username, $password );
    unless ( $res and $res->is_success ) {
        die "Authentication failed - " . $res->error;
    }
    unless ( $auth->authorized ) {
        die "Not authorized";
    }
    return 'GoogleLogin auth=' . $auth->auth_token;
}

1;

__END__


=head1 NAME

WWW::Shorten::Googl - Perl interface to goo.gl

=head1 SYNOPSIS

  use WWW::Shorten::Googl;
  use WWW::Shorten 'Googl';

  $short_url = makeashorterlink($long_url);

  $long_url  = makealongerlink($short_url);

  # Note - this function is specific to the Googl shortener
  $stats = getlinkstats( $short_url );

=head1 DESCRIPTION

A Perl interface to the goo.gl URL shortening service. Googl simply maintains
a database of long URLs, each of which has a unique identifier.

=head1 Functions

=head2 makeashorterlink

The function C<makeashorterlink> will call the Googl web site passing
it your long URL and will return the shorter Googl version.

If you provide your Google username and password, the link will be added
to your list of shortened URLs at L<http://goo.gl/>. See AUTHENTICATION for details.

=head2 makealongerlink

The function C<makealongerlink> does the reverse. C<makealongerlink>
will accept as an argument either the full goo.gl URL or just the
goo.gl identifier.

=head2 getlinkstats

Given a goo.gl URL, returns a hash ref with statistics about the URL.

See L<http://code.google.com/apis/urlshortener/v1/reference.html#resource_url>
for information on which data can be present in this hash ref.

=head1 AUTHENTICATION

If you provide your Google username and password, all shortened URLs will be
available for viewing at L<http://goo.gl/>

You provide these details by setting the environment variables GOOGLE_USERNAME
and GOOGLE_PASSWORD, such as

 GOOGLE_USERNAME=your.username@gmail.com
 GOOGLE_PASSWORD=somethingVerySecret

=head1 EXPORT

makeashorterlink, makealongerlink

=head1 SUPPORT, LICENCE, THANKS and SUCH

See the main L<WWW::Shorten> docs.

=head1 AUTHOR

Magnus Erixzon <magnus@erixzon.com>

=head1 SEE ALSO

L<WWW::Shorten>, L<http://goo.gl/>, L<http://code.google.com/apis/urlshortener/v1/reference.html#resource_url>

=cut
