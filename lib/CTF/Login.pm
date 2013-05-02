package CTF::Login;

use strict;
use warnings;

use utf8;
use Encode;
use CGI::Session::Auth::DBI;
use Digest::SHA1 'sha1_hex';
use YAML::Syck;

use lib './lib';
use CTF::Template;

sub new {
	my ($class, $q, $session) = @_;
	my $conffile = (! -e '../etc/config.yml') ? 'etc/config.yml' : '../etc/config.yml';
	my $conf = YAML::Syck::LoadFile($conffile);

	my $self = bless {
		auth => CGI::Session::Auth::DBI->new({
				CGI => $q,
				Session => $session,
				DSN => "DBI:mysql:$conf->{sql}->{dbname}",
				UserTable => "users",
				DBUser => $conf->{sql}->{username},
				DBPasswd => $conf->{sql}->{password},
			}
		),
		session => $session,
		cgi => $q,
		tmpl => CTF::Template->new,
	}, $class;
	return $self;
}

sub logIn {
	my ($self, $username, $password) = @_;
	my $auth = $self->{auth};
	my $q = $self->{cgi};
	my $session = $self->{session};

	if ($username and $password) {
		$q->param('log_password', sha1_hex($password));
		$q->param('log_username', $username);
		$auth->authenticate;

		if ($auth->loggedIn) {
			$self->_setAttributes($auth->{profile});
			return $session->header(-location => 'index.pl?mode=menu');
		} else {
			return  $session->header . $self->showLoginScreen('Invalid username/password.');
		}
	} else {
	}
}

sub _setAttributes {
	my ($self, $profile) = @_;
	my $session = $self->{session};

# ToDo: Handle errors when these parameters are neither 1 nor 0.
	$session->param('USERNAME', $profile->{username});
}

sub showLoginScreen {
	my ($self, $msg) = @_;
	my $template = $self->{tmpl};

	return $template->process('templates/main.tt', {message => $msg});
}

1;
