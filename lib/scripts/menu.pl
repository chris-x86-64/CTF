use strict;
use warnings;
use Encode;
use utf8;

use lib './lib';
use CTF::Template;

our $session;
our $q;

my $tempfile = 'templates/main.tt';
my $temphtml = CTF::Template->new;

print $q->header;
print $temphtml->process($tempfile, {
		loggedin => $session->param('~logged-in'),
		teacher => $session->param('TEACHER'),
		username => $session->param('USERNAME')
	},
);

1;
