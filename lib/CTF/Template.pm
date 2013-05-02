package CTF::Template;

use strict;
use warnings;
use Encode;
use utf8;
use Template;

sub new {
	my ($class) = @_;
	my $self = bless {
		tmpl => Template->new({ENCODING => 'utf-8', 
#			PRE_PROCESS => 'templates/header.tt',
#			POST_PROCESS => 'templates/footer.tt',
		}),
	}, $class;
	return $self;
}

sub process {
	my ($self, $file, $vars) = @_;
	my $tmpl = $self->{tmpl};

	$tmpl->process($file, $vars, \my $out) or die $tmpl->error;
	
	return encode_utf8($out);
}

1;
