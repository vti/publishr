use strict;
use warnings;

use lib 'lib';

use JSON;
use Publishr::Channel::Twitter;

my ($key, $secret) = @ARGV;
die "Usage: <key> <secret>\n" unless $key && $secret;

my $nt = Publishr::Channel::Twitter->new(
    consumer_key    => $key,
    consumer_secret => $secret
)->build_agent;

print "Authorize this app at ", $nt->get_authorization_url,
  " and enter the\nPIN: ";

my $pin = <STDIN>;
chomp $pin;

my ($access_token, $access_token_secret, $user_id, $screen_name) =
  $nt->request_access_token(verifier => $pin);

print JSON::encode_json(
    {
        twitter => {
            consumer_key        => $key,
            consumer_secret     => $secret,
            access_token        => $access_token,
            access_token_secret => $access_token_secret
        }
    }
  ),
  "\n";
