package Publishr::Channel::Twitter;

use strict;
use warnings;

use Encode ();
use Scalar::Util qw(blessed);
use Publishr;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    eval { require Net::Twitter::Lite::WithAPIv1_1 }
      or die "Net::Twitter::Lite is required\n";

    $self->{consumer_key}        = $params{consumer_key};
    $self->{consumer_secret}     = $params{consumer_secret};
    $self->{access_token}        = $params{access_token};
    $self->{access_token_secret} = $params{access_token_secret};

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    my $nt = $self->build_agent;

    my $status = $message->{status};
    $status .= ' ' . $message->{link} if $message->{link};

    $status = Encode::encode('UTF-8', $status) if Encode::is_utf8($status);

    eval {
        if ($message->{image}) {
            $nt->update_with_media($status, [$message->{image}]);
        }
        else {
            $nt->update($status);
        }
    } or do {
        my $e = $@;

        die $e unless blessed $e && $e->isa('Net::Twitter::Lite::Error');

        die $e->error . "\n";
    };

    return $self;
}

sub build_agent {
    my $self = shift;

    return Net::Twitter::Lite::WithAPIv1_1->new(
        clientname          => 'Publishr',
        clientver           => $Publishr::VERSION,
        clienturl           => 'http://github.com/vti/publishr',
        useragent           => "Publishr/$Publishr::VERSION",
        consumer_key        => $self->{consumer_key},
        consumer_secret     => $self->{consumer_secret},
        access_token        => $self->{access_token},
        access_token_secret => $self->{access_token_secret},
        legacy_lists_api    => 0,
        ssl                 => 1,
        apiurl              => 'https://api.twitter.com/1.1',
    );
}

1;
