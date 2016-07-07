#!/user/bin/perl
use strict;
use warnings;
use utf8;
use Cwd;

undef $/;
#Get local download version 
my $ori_stage="";
my $ori_shiphome="";
my $verfile="";
my $wd = Cwd::getcwd();
$verfile=$wd.'/version.txt';
print $verfile, "\n";

open FR, $verfile or die "open file failed : $!";
my $row = <FR>;
($ori_shiphome, $ori_stage) = split(/\n:/,$row);
close FR;
	#print $ori_stage;
	#print $ori_shiphome;

#Get latest release version
my $lines="";
my $line1="";
my $shiphome="";
#my $fileName="wls_jrf_generic.jar";
my $fileName="fmw_12.2.1.1.0_infrastructure_generic.jar";
my $sshHost="\@slc02qjt.us.oracle.com:";
my $stage="";
my $cwd="";
my $value="";
my $cmdStr="";
while (<>) {
		#$lines = $_."/n";
		#get main-content section
		if ($_ =~ /<div id="main-content".*?\n\s*<\/div>/gs) {
			print "content exists\n";
			#print $&."\n";
			$lines = $&;
		}
		#get Infra section
		if ($lines =~ /<h[1-9] id="FMW12.2.1.1.0ShiphomeAnnouncementstoQA-Stage[1-9]+InfraShiphomes(\d+)\/(\d+)\/(\d+)".*?<h[1-9]/gs) {
			print "matched\n";
			$line1 = $&;
		}
		$line1 = $line1.">";
		#strip out tags
		if ($line1 =~ s/<.*?>//gs) {
			print "stripped\n";
		}
		#get stage info
		if ($line1 =~ /Stage [0-9]+ Infra Shiphomes (\d+)\/(\d+)\/(\d+)/gs) {
			print "====================\n";
			print "stage getted\n";
			$stage = $&;
			print $stage."\n";;
		}
		#get shiphome path
		if ($line1 =~ /From Linux: \/ade_autofs\/gd17_fmw\/ASKERNEL_12.2.1.1.0_GENERIC.rdd\/.*?\/askernel\/shiphome/gs) {
			print "====================\n";
			print "path getted\n";
			$shiphome = $&;
			$shiphome =~ s/From Linux: //gs;
			$shiphome = $shiphome."/";
			print $shiphome."\n";
		}
	}

	open FW, '> version.txt' or die "open file failed : $!";
	print FW $stage."\n";
	print FW $shiphome;
	close FW;
	#print "============================\n";
	#print $ori_stage;
	#print $ori_shiphome;
	#print "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n";
	#print $stage;
	#print $shiphome;
	if (($ori_stage eq $stage) and ($ori_shiphome eq $shiphome)) 
	{
		print "nothing to download and quit the job";
	}
	else 
	{
		print "download the latest;\n";
		$cmdStr = "sshpass -p ".$ENV{'sshPasswd'}." scp -o StrictHostKeyChecking=no ".$ENV{'sshUser'}.${sshHost}.${shiphome}.${fileName}." ./";
		print $cmdStr."\n";
		$value = `/bin/bash -c "${cmdStr}"`; 
		print $value;

	}
	#$cmdStr="git branch -d master";
	#$value = `/bin/bash -c "${cmdStr}"`; 
	#$cmdStr="git checkout -b master";
	#$value = `/bin/bash -c "${cmdStr}"`; 
	#$cmdStr="git add version.txt";
	#$value = `/bin/bash -c "${cmdStr}"`; 
	#print ${value}."\n";
	#$cmdStr="git commit -m ver_update";
	#$value = `/bin/bash -c "${cmdStr}"`; 
	#$cmdStr="git push autodownload";
	#$value = `/bin/bash -c "${cmdStr}"`; 
	#print ${value}."\n";
	if (0) {
		#print "do do" =~ /(\w+) \1/
		my $s = "do/ re/";
		my $t = "";
		$t =~ /(\w+\/)/;
		print $t;
	}
