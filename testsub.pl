#!/usr/local/bin/perl

open(MEMBERS, "./members") || die "./members: $!";
while(<MEMBERS>) {
	next if /^#/o;
	chop;
	if (/.+ \<(.+[%@].+)\>/o) {
		$entry = $1;
	} elsif (/(.+[%@].+) \(.+\)/o) {
		$entry = $1;
	} else {
		$entry = $_;
	}
	$fullnames{$entry} = $_;
	($id, $address) = split(/[%@]/o, $entry);
	$memberdic{$id} .= "$entry\n";
	$addressAssocDic{$address} = $address;
}

close(MEMBERS);

@addressdic = keys(%addressAssocDic);
@iddic = keys(%memberdic);

undef %addressAssocDic;

print "\nresult = ".do hokan($ARGV[0])."\n";

sub hokan {
	$_ = $_[0];
	if (/[%@]/o) {
		($id, $address) = split(/[%@]/o, $_[0]);
	} else {
		@ids = grep(/^$_[0]/, @iddic);
		$id = $ids[0];
		$address = '';
	}
	@matchmembers = split(/\n/o, $memberdic{$id});
	if ($#matchmembers == 0) {
		if (/[%@]/o) {
			$id1 = $_[0];
			$id1 =~ s/^(.+[%@]).+/$1/o;
			$address1 = $_[0];
			$address1 =~ s/^.+[%@](.+)/$1/o;
			@hokanaddrs = grep(/^$address1/, @addressdic);
			$hokanaddr = $id1.$hokanaddrs[0];
			if ($matchmembers[0] eq $hokanaddr
				 || $hokanaddr eq $id1) {
				return $matchmembers[0];
			} else {
			#	return $_[0];
				return $hokanaddr;
			}
		} else {
			return $matchmembers[0];
		}
	} elsif ($#matchmembers > 0) {
		$realaddr = '';
		$tempaddr2 = '';
		foreach $matchmember (@matchmembers) {
			($id1, $address1) = split(/[%@]/o, $matchmember);
			$tempaddr = $address;
			for (; index($address1, $tempaddr) < 0
				&& index($tempaddr, "\.") >= 0; ) {
				$tempaddr = substr($tempaddr, 
						index($tempaddr, "\.") + 1);
			}
			if (length($tempaddr) > length($tempaddr2)) {
				$tempaddr2 = $tempaddr;
				$realaddr = $matchmember;
			}
		}
		if ($tempaddr2 eq '') {
			return $_[0];
		} else {
			return $realaddr;
		}
	} else {
		$id1 = $_[0];
		$id1 =~ s/^(\w+[%@]).+/$1/o;
		$address1 = $_[0];
		$address1 =~ s/^\w+[%@](\w+)/$1/o;
		@hokanaddrs = grep(/^$address1/, @addressdic);
		$hokanaddr = $id1.$hokanaddrs[0];
		if ($hokanaddr eq $id1) {
			return $_[0];
		} else {
			return $hokanaddr;
		}
	}
}
