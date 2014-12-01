package Publishr::Channel::Email;

use strict;
use warnings;

use MIME::Base64;
use Publishr;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    eval {
        require Email::MIME;
        require Email::Sender::Simple;
        require Email::Sender::Transport::SMTP::TLS;
    }
      or die "Email::MIME, "
      . "Email::Sender::Simple and "
      . "Email::Sender::Transport::SMTP::TLS are required\n";

    $self->{headers}   = $params{headers}   || [];
    $self->{transport} = $params{transport} || {};

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    my @parts = (
        Email::MIME->create(
            attributes => {
                content_type => 'text/plain',
                charset      => 'UTF-8',
                encoding     => 'base64'
            },
            body_str => $message->{text}
        )
    );

    my $subject =
      MIME::Base64::encode_base64(Encode::encode('UTF-8', $message->{status}));
    $subject =~ s{\s}{}g;
    my $email = Email::MIME->create(
        header => [
            Subject => '=?UTF-8?B?' . $subject . '?=',
            @{$self->{headers}},
        ],
        parts => [@parts],
    );
    $email->charset_set('UTF-8');

    my $transport =
      Email::Sender::Transport::SMTP::TLS->new(%{$self->{transport}});

    Email::Sender::Simple->send($email, {transport => $transport});

    return $self;
}

1;
