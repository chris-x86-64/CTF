use strict;
use CGI::Session;
use Encode;
use utf8;

use lib './lib';
use CTF::Login;

our $q;
our $session = CGI::Session->new(undef, $q, {Directory => '/tmp', charset => 'utf8'});
my $login = CTF::Login->new($q, $session);

if ($q->param('log_username') and $q->param('password')) {

	print $login->logIn($q->param('log_username'), $q->param('password'));

} elsif ($q->param('log_username') or $q->param('password')) {

	print $session->header;
	print $login->showLoginScreen('Enter both username and password.');

} else {

	print $session->header;
	print $login->showLoginScreen;

}

1;
