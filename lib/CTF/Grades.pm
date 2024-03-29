package CTF::Grades;

use strict;
use warnings;

use utf8;
use Encode;
use Exporter;
use DBIx::Simple;
use SQL::Abstract;
use YAML::Syck;
use JSON::XS;

my @ISA = qw(Exporter);
my @EXPORT = ();

sub new {
	my ($class) = @_;
	my $confFile = (! -e '../etc/config.yml') ? 'etc/config.yml' : '../etc/config.yml';
	my $conf = YAML::Syck::LoadFile($confFile);
	my $dbh = DBIx::Simple->connect(
		"dbi:mysql:$conf->{sql}->{dbname}",
		$conf->{sql}->{username},
		$conf->{sql}->{password},
	) or die DBIx::Simple->error;
	$dbh->{dbh}->{'mysql_enable_utf8'} = 1;
	$dbh->{dbh}->do('SET NAMES utf8');
	$dbh->abstract = SQL::Abstract->new;
	my $self = bless { dbh => $dbh }, $class;
	return $self;
}

sub getGrades {
	my ($self, $userid) = @_;
	my $dbh = $self->{dbh};
	my $result = $dbh->select('grades', 'grades_json', { userid => $userid })->array;
	return decode_json($result->[0]);
}

1;
