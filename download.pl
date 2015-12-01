#!/user/bin/perl
use strict;
use warnings;
use utf8;

undef $/;
#Get local download version 
my $ori_stage;
my $ori_shiphome;
open FR, 'version.txt' or die "open file failed : $!";
my $row = <FR>;
($ori_shiphome, $ori_stage) = split(/\n:/,$row);
close FR;

#Get latest release version
my $lines;
my $line1;
my $shiphome;
my $stage;
while (<>) {
		#get main-content section
		if ($_ =~ /<div id="main-content".*?\n\s*<\/div>/gs) {
			print "content exists\n";
			$lines = $&;
		}
		#get Infra section
		if ($lines =~ /<h[1-9] id="FMW12.2.2.0.0ShiphomeAnnouncementstoQA-Stage[1-9]InfraShiphomes\d\d\/\d\d\/\d\d".*?<h[1-9]/gs) {
			print "matched\n";
			$line1 = $&;
		}
		$line1 = $line1.">";
		#strip out tags
		if ($line1 =~ s/<.*?>//gs) {
			print "stripped\n";
		}
		#get stage info
		if ($line1 =~ /Stage [0-9] Infra Shiphomes \d\d\/\d\d\/\d\d/gs) {
			print "====================\n";
			print "stage getted\n";
			$stage = $&;
			print $stage."\n";;
		}
		#get shiphome path
		if ($line1 =~ /From Linux: \/ade_autofs\/gd17_fmw\/ASKERNEL_12.2.2.0.0_GENERIC.rdd\/.*?\/askernel\/shiphome/gs) {
			print "====================\n";
			print "path getted\n";
			$shiphome = $&;
			$shiphome =~ s/From Linux: //gs;
			print $shiphome;
		}

	}

	open FW, '> version.txt' or die "open file failed : $!";
	print FW $stage."\n";
	print FW $shiphome;
	close FW;

	if (0) {
		#print "do do" =~ /(\w+) \1/
		my $s = "do/ re/";
		my $t = "";
		$t =~ /(\w+\/)/;
		print $t;
	}
#close FW;
