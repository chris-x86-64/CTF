use strict;
use warnings;
use Encode;
use utf8;

use lib './lib';
use CTF::Template;
use CTF::Grades;

our $session;
our $q;

my $tempfile = 'templates/main.tt';
my $temphtml = CTF::Template->new;

my $db = CTF::Grades->new;

print $q->header;
print $temphtml->process($tempfile, {
		loggedin => $session->param('~logged-in'),
		teacher => $session->param('TEACHER'),
		username => $session->param('USERNAME'),
		grades => $db->getGrades($session->param('~userid'))
	},
);

1;

