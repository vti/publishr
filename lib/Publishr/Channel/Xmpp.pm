package Publishr::Channel::Xmpp;

use strict;
use warnings;

use Publishr;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    eval { require Net::XMPP }
      or die "Net::XMPP is required\n";

    $self->{hostname} = $params{hostname};
    $self->{username} = $params{username};
    $self->{password} = $params{password};
    $self->{to}       = $params{to};

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    my $conn = Net::XMPP::Client->new;

    my $status = $conn->Connect(hostname => $self->{hostname});
    die $! unless defined $status;

    my @auth = $conn->AuthSend(
        username => $self->{username},
        password => $self->{password},
        resource => "Publishr/$Publishr::VERSION"
    );
    die "$auth[0] - $auth[1]" unless $auth[0] eq 'ok';

    my @text;
    push @text, join ' ', map { "*$_" } split /\s*,\s*/, $message->{tags};
    push @text, $message->{status} if $message->{status};
    push @text, $message->{link}   if $message->{link};

    $conn->MessageSend(
        to   => $self->{to},
        body => join(' ', @text),
        type => 'chat',
    );

    $conn->Disconnect;

    return $self;
}

1;
