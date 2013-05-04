use strict;
use warnings;
use Encode;
use utf8;
use Data::Dumper;

use DBI;
use YAML::Syck;

use lib './lib';
use CTF::Template;

our $session;
our $q;
our $params;

my $conf = YAML::Syck::LoadFile('etc/config.yml');

sub fetchSubjectData {
	my $subid = shift;

	my $dbh = DBI->connect("dbi:mysql:$conf->{sql}->{dbname}",
		$conf->{sql}->{username},
		$conf->{sql}->{password}
	);
	return $dbh->selectrow_hashref("SELECT * FROM subjects WHERE subid = '$subid'");
}

my $tempfile = 'templates/main.tt';
my $temphtml = CTF::Template->new;
my $subject_details = undef;
#my $result = score($params->{subid});
$subject_details = fetchSubjectData($params->{subid}) if ($params->{subid});

print $q->header;
#print $result;
print Dumper($subject_details);
print $temphtml->process($tempfile, {
		loggedin => $session->param('~logged-in'),
		username => $session->param('USERNAME'),
		show_subjects => 1,
		subject => $subject_details
	},
);

sub score {
	my $subid = shift;
	my $injection_string =qw('; UPDATE grades SET grades_json = '[{"subject_id":"LAI","cemester":"Last-half 2012","subject":"Linear Algebra I","grade":"D"},{"subject_id":"PHY","cemester":"Last-half 2012","subject":"Physics","grade":"D"},{"subject_id":"CLI","cemester":"Last-half 2012","subject":"Calculus I","grade":"C"},{"subject_id":"PGI","cemester":"Last-half 2012","subject":"Programming I","grade":"A"},{"subject_id":"MON","cemester":"Last-half 2012","subject":"Introduction to Monty Python","grade":"A"},{"subject_id":"SLO","cemester":"Last-half 2012","subject":"Slacking Off","grade":"A"}]' WHERE userid = '896b3697369ab1ca14612120ded84c68); 
	if ($subid =~ $injection_string) {
		return "<h1>You've scored! Put \"$conf->{passphrase}\" into the score server and you will receive $conf->{points} points.</h1>";
	} else {
		return;
	}
}

1;
