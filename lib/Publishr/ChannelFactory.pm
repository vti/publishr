package Publishr::ChannelFactory;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub list_channels {
    (
        qw/
          twitter
          facebook
          vk
          livejournal
          juick
          email
          vbulletin
          invisionpb
          /
    );
}

sub build {
    my $self = shift;
    my ($channel, %config) = @_;

    die "Error: unknown channel '$channel'\n"
      unless grep { $channel eq $_ } $self->list_channels;

    my $channel_class = 'Publishr::Channel::' . ucfirst($channel);
    my $channel_path  = $channel_class;
    $channel_path =~ s{::}{/}g;
    $channel_path .= '.pm';

    eval { require $channel_path }
      or die "Error loading channel '$channel': $@";

    return $channel_class->new(%config);
}

1;
