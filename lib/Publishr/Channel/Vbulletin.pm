package Publishr::Channel::Vbulletin;

use strict;
use warnings;

use Encode ();
use IO::HTML ();
use Publishr;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    eval { require WWW::Mechanize }
      or die "WWW::Mechanize is required\n";

    $self->{base_url} = $params{base_url};
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

    $mech->submit_form(
        fields => {
            vb_login_username => $self->{username},
            vb_login_password => $self->{password}
        }
    );

    die 'Error: Login failed'
      unless $mech->content =~ m/http-equiv="Refresh"/;

    my $charset = IO::HTML::find_charset_in($mech->content);
    if ($charset && $charset !~ /utf-?8/i) {
        for (keys %$message) {
            my $value = Encode::encode('UTF-8', $message->{$_});
            Encode::from_to($value, 'UTF-8', $charset);
            $message->{$_} = $value;
        }
    }

    $mech->get($self->{category_url});

    $mech->follow_link(url_regex => qr/newthread/);

    $mech->submit_form(
        fields => {
            subject => $message->{status},
            message => $message->{text}
        },
    );

    return $self;
}

1;
