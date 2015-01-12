package Publishr::Channel::Irc;

use strict;
use warnings;

use Encode ();
use IO::Socket::INET;
use Publishr;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{hostname} = $params{hostname};
    $self->{channel}  = $params{channel};
    $self->{port}     = $params{port} || 6667;
    $self->{nick}     = $params{nick} || 'publishr';

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    my $sock = IO::Socket::INET->new(
        PeerAddr => $self->{hostname},
        PeerPort => $self->{port},
        Proto    => 'tcp'
    );

    die $! unless $sock;

    my $nick    = $self->{nick};
    my $channel = $self->{channel};
    my $text    = $message->{status} . ' ' . $message->{link};
    $text = Encode::encode('UTF-8', $text);

    sleep 1;

    <$sock>;

    print $sock join "\n", "NICK $nick", "USER $nick 8 * : $nick",
      "JOIN $channel", "PRIVMSG $channel :$text", "QUIT";

    <$sock>;

    sleep 1;

    close $sock;

    return $self;
}

1;
