package Publishr::Channel::Facebook;

use strict;
use warnings;

use Scalar::Util qw(blessed);
use Publishr;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    eval { require Facebook::OpenGraph }
      or die "Facebook::OpenGraph is required\n";

    $self->{app_id}       = $params{app_id};
    $self->{secret}       = $params{secret};
    $self->{access_token} = $params{access_token};
    $self->{group_id}     = $params{group_id};

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    my $fb = Facebook::OpenGraph->new(
        {
            app_id       => $self->{app_id},
            secret       => $self->{secret},
            access_token => $self->{access_token},
        }
    );

    $fb->post("/$self->{group_id}/feed",
        {message => $message->{message}, link => $message->{link}});

    return $self;
}

1;
