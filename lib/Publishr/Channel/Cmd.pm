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
    $self->{env} = $params{env} || {};

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    $message->{text} =~ s{\n}{\\n}g;

    my $cmd = $self->{cmd};

    for my $key (keys %$message) {
        $cmd =~ s{%$key%}{$message->{$key}}ge;
    }

    for my $env (keys %{$self->{env}}) {
        $ENV{$env} = $self->{env}->{$env};
    }

    system $cmd;

    return $self;
}

1;
