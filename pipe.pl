#! /usr/local/bin/perl
if (open(MAILBODY, 'ls -lt|')) {
	while (<MAILBODY>) {
		print $_;
	}
}
