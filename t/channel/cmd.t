use strict;
use warnings;

use Test::More;
use Test::MonkeyMock;
use Publishr::Channel::Cmd;

subtest 'builds simple command' => sub {
    my $channel = _build_channel();

    $channel->publish({text => 'foo'});

    my ($cmd) = $channel->mocked_call_args('_system');

    is $cmd, 'echo';
};

subtest 'builds command with substitution' => sub {
    my $channel = _build_channel(cmd => 'echo %text%');

    $channel->publish({text => 'foo'});

    my ($cmd) = $channel->mocked_call_args('_system');

    is $cmd, 'echo foo';
};

subtest 'replaces \n in text' => sub {
    my $channel = _build_channel(cmd => 'echo %text%');

    $channel->publish({text => "foo\n"});

    my ($cmd) = $channel->mocked_call_args('_system');

    is $cmd, 'echo foo\n';
};

subtest 'builds command with env' => sub {
    my $channel = _build_channel(cmd => 'echo', env => {foo => 'bar'});

    local $ENV{foo};
    $channel->publish({text => 'foo'});

    is $ENV{foo}, 'bar';
};

sub _build_channel {
    my (%params) = @_;
    my $channel = Publishr::Channel::Cmd->new(
        cmd => $params{cmd} || 'echo',
        env => $params{env}
    );
    $channel = Test::MonkeyMock->new($channel);
    $channel->mock(_system => sub { });
    return $channel;
}

done_testing;
