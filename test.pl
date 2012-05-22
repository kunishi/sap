#! /usr/local/bin/perl
# sap: hml.pl's summary analyses program
# 91/01/22 14:41:34 Ver.1 [3:yutaka@sys1.cpg] Harmony-Mailing-List announce (1)
# 
# 92/10/20 Ver.2.00 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         (1) 'hokan' subroutine was added.
#         (2) eval function was used in order to get high-speed run time.
#
# 92/10/23 Ver.2.01 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         Use some speeding-up techniques:
#          * Cashing the return values of 'hokan'.
#          * Use An Associative Array as a Member Dictionary
#
# 92/10/25 Ver.2.02 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         Strict heuristics were used when one or no member 
#         which have the same ID part as that of $_[0] was found in 'member'.
#
# 92/10/27 Ver.2.03 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         Some bugs were fixed.
#
# 92/11/04 Ver.2.04 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         The way to evaluate regular expressions was changed
#         from by 'eval' function to by the 'o' option of the regular
#         expressions.
#
# 92/11/25 Ver.2.05 by Kunishima Takeo (kunishi@kuis.kyoto-u.ac.jp)
#      Modified point:
#         Summarized Mail Numbers are printed out.
#

# Initialize for 'hokan' subroutine.
open(MEMBERS, "./members") || die "./members: $!";
while(<MEMBERS>) {
	next if /^#/o;
	chop;
	$entry = $_;
	if (/.+ \<.+[%@].+\>/) {
		$entry =~ s/.+ \<(.+[%@].+)\>/$1/;
	} elsif (/.+[%@].+ \(.+\)/) {
		$entry =~ s/(.+[%@].+) \(.+\)/$1/;
	}
	print "$entry\n";
}
