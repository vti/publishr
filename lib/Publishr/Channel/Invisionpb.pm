package Publishr::Channel::Invisionpb;

use strict;
use warnings;
use utf8;

use Publishr;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    eval { require WWW::Mechanize }
      or die "WWW::Mechanize is required\n";

    $self->{base_url}     = $params{base_url};
    $self->{category_url} = $params{category_url};
    $self->{username}     = $params{username};
    $self->{password}     = $params{password};

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    my $mech = WWW::Mechanize->new;

    $mech->get($self->{base_url});
    $mech->follow_link(url_regex => qr/act-Login/);
    $mech->submit_form(fields =>
          {UserName => $self->{username}, PassWord => $self->{password}});

    die 'Error: Login failed' if $mech->content =~ m/UserName/;

    $mech->get($self->{category_url});

    $mech->follow_link(url_regex => qr/act-Post/);

    $mech->submit_form(
        fields => {
            TopicTitle => $message->{status},
            chpyKey    => $message->{tags},
            Post       => $message->{text}
        }
    );

    return $self;
}

1;
