package Publishr::Message;

use strict;
use warnings;

use Encode;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub parse {
    my $self = shift;
    my ($content) = @_;

    $content = Encode::decode('UTF-8', $content);

    my $message = {};

    if ($content =~ s{^Status:\s*(.*?)$}{}ms) {
        $message->{status} = $1;
    }
    if ($content =~ s{^Link:\s*(.*?)$}{}ms) {
        $message->{link} = $1;
    }
    if ($content =~ s{^Image:\s*(.*?)$}{}ms) {
        $message->{image} = $1;
    }
    if ($content =~ s{^Tags:\s*(.*?)$}{}ms) {
        $message->{tags} = $1;
    }

    $content =~ s{^\s+}{};
    $content =~ s{\s+$}{};
    $message->{text} = $content;

    $self->{parsed}++;

    return $message;
}

1;
