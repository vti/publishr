use strict;
use warnings;

use Test::More;
use Publishr::Message;

subtest 'parses message' => sub {
    my $message = _build_message();

    my $output = $message->parse(<<'EOM');
Status: New article is out
Link: http://mywebsite.com
Image: /path/to/image
Tags: perl

Just a long text
with
multilines...
EOM

    is $output->{status}, 'New article is out';
    is $output->{link}, 'http://mywebsite.com';
    is $output->{image}, '/path/to/image';
    is $output->{tags}, 'perl';
    is $output->{text}, "Just a long text\nwith\nmultilines...";
};

sub _build_message {
    Publishr::Message->new;

}

done_testing;
