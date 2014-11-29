package Publishr::Channel::Vk;

use strict;
use warnings;

use LWP::UserAgent;
use JSON ();
use Publishr;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{access_token} = $params{access_token};
    $self->{user_id}      = $params{user_id};
    $self->{group_id}     = $params{group_id};

    return $self;
}

sub publish {
    my $self = shift;
    my ($message) = @_;

    my @attachments = '';
    push @attachments, $message->{link} if $message->{link};

    my $base_url = 'https://api.vk.com/method';

    if ($message->{image}) {
        my $res = $self->_request(
            "$base_url/photos.getWallUploadServer",
            {
                access_token => $self->{access_token},
                $self->{group_id} ? (gid => $self->{group_id}) : ()
            }
        );

        my $upload_url = URI->new($res->{response}->{upload_url});
        my %query      = $upload_url->query_form;

        $res = $self->_request(
            $upload_url,
            Content_Type => 'multipart/form-data',
            Content      => [
                'act'       => $query{'act'},
                'mid'       => $query{'mid'},
                'aid'       => $query{'aid'},
                'gid'       => $query{'gid'},
                'hash'      => $query{'hash'},
                'rhash'     => $query{'rhash'},
                'swfupload' => $query{'swfupload'},
                'api'       => $query{'api'},
                'wallphoto' => $query{'wallphoto'},
                'photo'     => [$message->{image}],
            ],
        );

        $res = $self->_request(
            "$base_url/photos.saveWallPhoto",
            {
                $self->{user_id}  ? (mid => $self->{user_id})  : (),
                $self->{group_id} ? (gid => $self->{group_id}) : (),
                server       => $res->{server},
                photo        => $res->{photo},
                hash         => $res->{hash},
                access_token => $self->{access_token},
            }
        );

        push @attachments, $res->{response}->[0]->{id};
    }

    my $text = $message->{status};
    $text .= "\n\n" . $message->{text} if $message->{text};

    $self->_request(
        "$base_url/wall.post",
        {
            owner_id     => ($self->{user_id} || -$self->{group_id}),
            access_token => $self->{access_token},
            message      => $text,
            attachments  => join(',', @attachments)
        }
    );

    return $self;
}

sub build_agent {
    my $self = shift;

    return LWP::UserAgent->new(user_agent => "Publishr/$Publishr::VERSION");
}

sub _request {
    my $self = shift;
    my ($url, @args) = @_;

    my $ua = $self->build_agent;

    my $res = $ua->post($url, @args);
    die $res->status_line unless $res->is_success;

    $res = JSON::decode_json($res->content);

    die "$res->{error}->{error_msg}\n" if $res->{error};

    return $res;
}

1;
