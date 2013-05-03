use strict;
use warnings;
use Encode;
use utf8;

use DBI;
use YAML::Syck;

use lib './lib';
use CTF::Template;

our $session;
our $q;
our $params;

sub fetchSubjectData {
	my $subid = shift;

	my $conf = YAML::Syck::LoadFile('etc/config.yml')->{sql};
	my $dbh = DBI->connect("dbi:mysql:$conf->{dbname}",
		$conf->{username},
		$conf->{password}
	);
	return $dbh->selectrow_hashref("SELECT * FROM subjects WHERE subid = '$subid'");
}

my $tempfile = 'templates/main.tt';
my $temphtml = CTF::Template->new;
my $subject_details = undef;
$subject_details = fetchSubjectData($params->{subid}) if ($params->{subid});

print $q->header;
print $temphtml->process($tempfile, {
		loggedin => $session->param('~logged-in'),
		username => $session->param('USERNAME'),
		show_subjects => 1,
		subject => $subject_details
	},
);

1;
