#!/usr/bin/env perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/; # Remove this on production state.
use CGI::Session ('-ip_match');
use Data::Dumper;

our $session = CGI::Session->load;
our $q = CGI->new;
$q->charset('utf8');
our $cgiuserid = $session->param("~userid");
our $params = $q->Vars;

if ( $session->is_expired or $session->is_empty or $session->param('~logged-in') != 1) {
    require './lib/scripts/login.pl';
}
else {

    if (!$params->{'mode'} or $params->{'mode'} eq 'menu') {

    	require './lib/scripts/menu.pl';

	} elsif ($params->{'mode'} eq 'logout') {

		$q->cookie(-expires => 'now');
		$session->delete;
		print $session->header(-location => 'index.pl');

	} else {

		my $scriptfile = $params->{'mode'};
		if ($scriptfile =~ /\x00$/);
			# Null-byte poisoning
		}
		$scriptfile =~ s/[^\w]//g;
		eval {
			require './lib/scripts/' . $scriptfile . '.pl';
		};
		warn $@ if ($@);

	}

}
