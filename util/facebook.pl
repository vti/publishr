use strict;
use warnings;

use lib 'lib';

use JSON;

my ($app_id, $secret) = @ARGV;
die "Usage: <app_id> <secret>\n" unless $app_id && $secret;

use Facebook::OpenGraph;
my $token_ref = Facebook::OpenGraph->new(
    +{
        app_id => $app_id,
        secret => $secret,
    }
)->get_app_token;

print $token_ref->{access_token}, "\n";
