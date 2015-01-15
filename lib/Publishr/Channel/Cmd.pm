package Publishr::Channel::Cmd;

use strict;
use warnings;

use Carp qw(croak);
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

    $message->{text} =~ s{\n}{\\n}g if defined $message->{text};

    my $cmd = $self->{cmd};

    for my $key (keys %$message) {
        $cmd =~ s{%$key%}{$message->{$key}}g;
    }

    for my $env (keys %{$self->{env}}) {
        $ENV{$env} = $self->{env}->{$env};
    }

    $self->_system($cmd);

    return $self;
}

sub _system {
    my $self = shift;
    my ($cmd) = @_;

    system $cmd;
}

1;
