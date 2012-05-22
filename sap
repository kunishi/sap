#! /usr/local/bin/perl
# sap: hml.pl's summary analyses program

# $Id: sap,v 2.10 1998/06/10 04:59:31 kunishi Exp $

# $Log: sap,v $
# Revision 2.10  1998/06/10 04:59:31  kunishi
# Modified by SAITO Yutaka.  <5681.897454033@bve27.vsp.cpg.sony.co.jp>
#
# Revision 2.9  1996/10/31 04:33:56  kunishi
# Ver. 2.09 by Kunishima Takeo <kunishi@is.aist-nara.ac.jp>
# 	The regular expression to get mail addresses from summary line
# 	was improved.
# 	Special thanks to SAITO Yutaka <yutaka@vsp.cpg.sony.co.jp>.
#
# Revision 2.8  1994/05/20 04:28:01  kunishi
# 94/05/20 Ver.2.08 by Kunishima Takeo <kunishi@is.aist-nara.ac.jp>
#         The configuration part is separated from the algorithm part.
#
# Revision 2.7  1994/05/20  04:26:56  kunishi
# 93/09/01 Ver.2.07 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#         '-j' option are supported.  When '-j' option are added,
#         the members' Japanese names are also printed out.
#
# Revision 2.6  1994/05/20  03:32:06  kunishi
# 93/08/05 Ver.2.06 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#         Some bugs are fixed.
#
# Revision 2.5  1994/05/20  03:30:08  kunishi
# 92/11/26 Ver.2.05 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         The start no. and the last no. of summarized mails are printed out.
#         Some Address Formats are supported.
#           Supported ones are like the following:
#              Kunishima Takeo <kunishi@kuis.kyoto-u.ac.jp>
#              kunishi@kuis.kyoto-u.ac.jp (Kunishima Takeo)
#
# Revision 2.4  1994/05/20  03:28:46  kunishi
# 92/11/04 Ver.2.04 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         The way to evaluate regular expressions was changed
#         from by 'eval' function to by the 'o' option of the regular
#         expressions.
#
# Revision 2.3  1994/05/20  03:27:42  kunishi
# 92/10/27 Ver.2.03 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         Some bugs were fixed.
#
# Revision 2.2  1994/05/20  03:26:51  kunishi
# 92/10/25 Ver.2.02 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         Strict heuristics were used when one or no member
#          which have the same ID part as that of $_[0] was found in 'member'.
#
# Revision 2.1.1.1  1994/05/20  03:26:15  kunishi
# 92/10/23 Ver.2.01 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         Use some speeding-up techniques:
#          * Cashing the return values of 'hokan'.
#          * Use An Associative Array as a Member Dictionary
#
# Revision 2.1  1994/05/20  03:25:20  kunishi
# 92/10/20 Ver.2.00 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         (1) 'hokan' subroutine was added.
#         (2) eval function was used in order to get high-speed run time.
#
# Revision 1.1  1994/05/20  03:23:39  kunishi
# Initial revision
# 91/01/22 14:41:34 Ver.1 [3:yutaka@sys1.cpg] Harmony-Mailing-List announce (1)
#

# CONFIGURATION PART
# 'members' File
$membersFile         = "./members";
# 'summary' File
$summaryFile         = "./summary";
# a correspondence table between members' addresses and their real names.
# Its format is as follows:
#  Kanji_Name   Hiragana_Name   Real_Internet_Address
# Separator is '\s+'.  Actually, 'Hiragana_Name' field is not used now.
$japaneseMembersFile = "./whois/HarmonyMembers";
#
# END OF CONFIGURATION PART

# Initialize for 'hokan' subroutine.
open(MEMBERS, $membersFile) || die "$membersFile: $!";
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
# End of Initialize

if ($ARGV[0] eq '-j') {
	$japanesename = 1;
	open(JAPANESENAME, $japaneseMembersFile)
		 || die "$japaneseMembersFile: $!";
	while (<JAPANESENAME>) {
		chop;
		($jname, $yomi, $tempaddress) = split(/\s+/o, $_);
		$jnamedic{$tempaddress} = $jname;
		$yomidic{$tempaddress} = $yomi;
	}
	close(JAPANESENAME);
}

open(SUMMARY, $summaryFile) || die "$summaryFile: $!";
$total = 0;
$beginnum = $endnum = 0;
while(<SUMMARY>){
    if (/^9[0-9][0-9\/]+ [0-9:]+ \[(\d+):([-@%\d\w\\.]+)\] .*/o) {
	if ($beginnum == 0) {
		$beginnum = $1;
	}
	$endnum = $1;
	if ($cashetab{$2} eq '') {
		$realaddr = do hokan($2);
		if ($realaddr eq $2) {
			$realaddr = do hokan2($2);
		}
		$cashetab{$2} = $realaddr;
		if ($fullnames{$realaddr} eq '') {
			$fullnames{$realaddr} = $realaddr;
		}
	} else {
		$realaddr = $cashetab{$2};
	}
	$members{$realaddr}++;
	$members_last{$realaddr} = $1;
	$total++; 	
    } else {
	print $_,"\n";
    }
}
close(SUMMARY);
undef %cashetab;
#
# Merge realaddr into the newest one by %members_last
#
if ($japanesename) {
    local($newest);
    while(($key,$value) = each %members) {
	$newest = do newest($key);
	if ($newest && ($newest ne $key)) {
	    $members{$newest} += $value;
	    undef $members{$key};
	}
    }
}
#
#
print "Summarized Mails  : from No. ", $beginnum, " to No. ", $endnum, "\n";
print "Total number of mails   = ", $total, "\n";
@a = keys(%members);
#
@a = grep(defined($members{$_}), @a);
#
print "Total number of posters = ", $#a, "\n";
$b=0;
foreach $member (sort {-($members{$a} <=> $members{$b});} @a){
    if ($members{$member} != $b) {
	if ($japanesename == 1 && $jnamedic{$member} ne '') {
		printf "%4d\t%s <%s>\n", $members{$member}, 
		    $jnamedic{$member}, $fullnames{$member};
	} else {
		printf "%4d\t%s\n", $members{$member}, $fullnames{$member};
	}
	$b=$members{$member};
    }
    else {
	if ($japanesename == 1 && $jnamedic{$member} ne '') {
		print "\t", $jnamedic{$member}, " <$fullnames{$member}>", "\n";
	} else {
		print "\t", $fullnames{$member}, "\n";
	}
    }
}

exit(0);

# hokan subroutine
# Usage: do hokan($0);
#        $0: An Incomplete Address
# Function: Find the correct address of $0 into the 'members' file
#           heuristically, and return it.  
#           If not found, return $0.
#           For the outline of this heuristic algorithm, see README.hokan.
#
sub hokan {
	$_ = $_[0];
	if (/[%@]/o) {
		($id, $address) = split(/[%@]/o, $_);
	} else {
		@ids = grep(/^$_[0]/, @iddic);
		$id = $ids[0];
		$address = '';
	}
	if (length($id) > 10) {
		return &hokan2($_);
	}
	@matchmembers = split(/\n/o, $memberdic{$id});
	#print join(',', $_, $#matchmembers,@matchmembers)."\n";
	if ($#matchmembers == 0) {
		if (/^\w+\.\w+/o) { # Fullname-style ID
			return $matchmembers[0];
		} elsif (/[%@]/o) {
			$id1 = $_;
			$id1 =~ s/^(.+[%@]).+/$1/o;
			$address1 = $_;
			$address1 =~ s/^.+[%@](.+)/$1/o;
			@hokanaddrs = grep(/^$address1/, @addressdic);
			if ($hokanaddrs[0] eq '' ||
			    $matchmembers[0] eq join('',$id1,$hokanaddrs[0])) {
				return $matchmembers[0];
			} else {
			#	return $_;
				return join('',$id1,$hokanaddrs[0]);
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
			return $_;
		} else {
			return $realaddr;
		}
	} else {
		$id1 = $_;
		$id1 =~ s/^(.+[%@]).+/$1/o;
		$address1 = $_;
		$address1 =~ s/^.+[%@](.+)/$1/o;
		@hokanaddrs = grep(/^$address1/, @addressdic);
		if ($hokanaddrs[0] eq '') {
			return $_;
		} else {
			return join('',$id1,$hokanaddrs[0]);
		}
	}
}

# hokan2 subroutine
# Usage: do hokan($0);
#        $0: An Incomplete Address
# Function: Find the correct address of $0 into the 'HarmonyMembers' file
#           ,and return it.  
#           If not found, return $0.
#
sub hokan2 {
	local($incomplete_address) = $_[0];
	local($keys);
	return $incomplete_address unless $japanesename;

	foreach $keys (keys %jnamedic) {
		return $keys if ($keys =~ /$incomplete_address/);
	}
}

# newest subroutine
# Usage: do newest($0);
#	$0: An complete Address
sub newest {
	local($tempaddress) = $_[0];
	local($jname) = $jnamedic{$tempaddress};
	local($yomi)  =	$yomidic{$tempaddress};
	local($key, $value);
	local(@addresses) = (); 
	local($ad, $newest);
	while(($key,$value) = each %jnamedic) {
		if (($jname eq $value) &&
		   ($yomi eq $yomidic{$key})) {
		   push(@addresses, $key);
		}
	}
	$newest = $tempaddress;
	foreach $ad (@addresses) {
	    $newest = $ad if ($members_last{$ad} > $members_last{$tempaddress});
	}
	return $newest;
}
#
# sap2 END
#
