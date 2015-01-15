requires 'Email::MIME';
requires 'Email::Sender::Simple';
requires 'Email::Sender::Transport::SMTP::TLS';
requires 'Facebook::OpenGraph';
requires 'IO::HTML';
requires 'JSON';
requires 'LWP::UserAgent';
requires 'Net::Twitter';
requires 'Net::XMPP';
requires 'Net::XMPP::Client::GTalk';
requires 'WWW::Mechanize';
requires 'WebService::LiveJournal';

on 'test' => {
    requires 'Test::More';
    requires 'Test::MonkeyMock';
};
