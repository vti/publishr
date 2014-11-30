package Publishr::Channel::Juick;

use strict;
use warnings;

use Publishr;

my $TARGET_JID = 'juick@juick.com';

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    eval { require Net::XMPP::Client::GTalk }
      or die "Net::XMPP::Client::GTalk is required\n";

    $self->{username} = $params{jid};
    $self->{password} = $params{password};

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    my $client = $self->build_agent;

    my $tag_line = join ' ', map { "*$_" } split /,\s*/, $message->{tags};
    my $res = $client->send_message($TARGET_JID, <<"MESSAGE");
$tag_line
$message->{status}

$message->{text}

$message->{link}
MESSAGE

    return $self;
}

sub build_agent {
    my $self = shift;

    # only Google Talk registered JIDs supported for now
    $self->{username} =~ s/(\@.*)//;

    return Net::XMPP::Client::GTalk->new(
        USERNAME => $self->{username},
        PASSWORD => $self->{password},
        RESOURCE => "Publishr/$Publishr::VERSION",
    );
}

1;
