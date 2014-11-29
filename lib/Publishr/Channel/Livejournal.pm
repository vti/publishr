package Publishr::Channel::Livejournal;

use strict;
use warnings;

use Digest::MD5 ();
use Publishr;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    eval { require WebService::LiveJournal }
      or die "WebService::LiveJournal is required\n";

    $self->{username}   = $params{username};
    $self->{password}   = $params{password};
    $self->{usejournal} = $params{usejournal};

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    my $client = $self->build_agent;
    my $ua     = $client->useragent;

    if ($message->{image}) {
        my $res = $ua->get(
            "http://pics.livejournal.com/interface/simple",
            'X-FB-Mode' => 'UploadPic',
            'X-FB-User' => $self->{username},
            'X-FB-Mode' => 'GetChallenge',
        );

        my ($challenge) = $res->content =~ m{<Challenge>(.*?)</Challenge>};
        my $auth = join ':', 'crp', $challenge,
          Digest::MD5::md5_hex($challenge,
            Digest::MD5::md5_hex($self->{password}));

        $res = $ua->put(
            "http://pics.livejournal.com/interface/simple",
            'X-FB-Mode' => 'UploadPic',
            'X-FB-User' => $self->{username},
            'X-FB-Auth' => $auth,
            Content =>
              do { local $/; open my $fh, '<', $message->{image}; <$fh> }
        );

        my ($image_url) = $res->content =~ m{<URL>(.*?)</URL>};

        my $thumb_image_url = $image_url;
        $thumb_image_url =~ s{_original}{_300};

        $message->{text} =
            qq{<a href="$image_url">}
          . qq{<img src="$thumb_image_url" align="left" style="margin-right:10px" alt="pp" title="pp">}
          . qq{</a>}
          . $message->{text};
    }

    my $event = $client->create(
        subject => $message->{status},
        event   => $message->{text},
        props   => {
            taglist      => $message->{tags},
            external_url => $message->{link},
        },
        $self->{usejournal} ? (usejournal => $self->{usejournal}) : ()
    );
    $event->update;

    return $self;
}

sub build_agent {
    my $self = shift;

    return WebService::LiveJournal->new(
        username => $self->{username},
        password => $self->{password}
    );
}

1;
