#WWW::Shorten::Googl
##Perl interface to goo.gl

### SYNOPSIS

    use WWW::Shorten::Googl;
    use WWW::Shorten 'Googl';

    $short_url = makeashorterlink($long_url);

    $long_url  = makealongerlink($short_url);

    # Note - this function is specific to the Googl shortener
    $stats = getlinkstats( $short_url );

### DESCRIPTION

A Perl interface to the goo.gl URL shortening service. Googl simply maintains
a database of long URLs, each of which has a unique identifier.

### Functions

#### makeashorterlink

The function C<makeashorterlink> will call the Googl web site passing
it your long URL and will return the shorter Googl version.

If you provide your Google username and password, the link will be added
to your list of shortened URLs at <http://goo.gl/>. See AUTHENTICATION for details.

#### makealongerlink

The function **makealongerlink** does the reverse.

**makealongerlink**
will accept as an argument either the full goo.gl URL or just the
goo.gl identifier.

#### getlinkstats

Given a goo.gl URL, returns a hash ref with statistics about the URL.

See L<http://code.google.com/apis/urlshortener/v1/reference.html#resource_url>
for information on which data can be present in this hash ref.

### Google API Key (added March 2015)
At the time of adding this, it is necessary to provide a API Key to Google to perform the URL shortening and other services.
Check [here](https://developers.google.com/url-shortener/v1/getting_started#APIKey) for the documentation on how to obtain a Google API key.
The module expects to find an environment variable GOOGLE_API_KEY containing a valid key.
If the variable is not found, the module will bail out.
If the varibale is found but is not valid, the operation will fail and it will be reported (rather brutally) by the WWW::Shorten::generic (UserAgent).

### AUTHENTICATION

If you provide your Google username and password, all shortened URLs will be
available for viewing at <http://goo.gl/>

You provide these details by setting the environment variables GOOGLE_USERNAME
and GOOGLE_PASSWORD, such as

 GOOGLE_USERNAME=your.username@gmail.com
 GOOGLE_PASSWORD=somethingVerySecret

### EXPORT

makeashorterlink, makealongerlink

###SUPPORT, LICENCE, THANKS and SUCH

See the main <WWW::Shorten> docs.

###AUTHOR

Magnus Erixzon <magnus@erixzon.com>

###SEE ALSO

<WWW::Shorten>
<http://goo.gl/>
<http://code.google.com/apis/urlshortener/v1/reference.html#resource_url>
