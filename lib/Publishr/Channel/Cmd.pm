package Publishr::Channel::Cmd;

use strict;
use warnings;

use Publishr;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{cmd} = $params{cmd};

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    $message->{text} =~ s{\n}{\\n}g;

    my @args = map { "'$_'" } $message->{status},
      $message->{link},
      $message->{tags}, $message->{text};

    my $cmd = join ' ', $self->{cmd}, @args;

    system $cmd;

    return $self;
}

1;
