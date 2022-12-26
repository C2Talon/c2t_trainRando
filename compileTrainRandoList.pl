#!/usr/bin/perl
#compileTrainRandoList
#c2t

#used to compile the list that c2t_trainRando uses from a google spreadsheet

use strict;
use warnings;
use LWP::Simple;
use File::Copy;


my $target = 'kolmafia/data/c2t_trainRandoTargets.txt';
my $data = 'data.tsv';
my $url = 'https://docs.google.com/spreadsheets/d/1N-9Ohjv11ch8bhivYxqYs6JHdTx8Ug2vMeGNLDzMH70/export?format=tsv&range=A5:M';
my ($buffer,$temp,$res);

#delete backed-up data file and backup last data file
if (-e "$data.bak") {
	unlink("$data.bak");
}
if (-e $data) {
	move($data,"$data.bak");
}

#download spreadsheet
print "Downloading spreadsheet to $data...\n";
$res = getstore($url,$data);
if (is_error($res)) {
	die "getstore <$url> failed: $res";
}

#read file into buffer
print "Reading $data...\n";
open FILE, $data or die $!;
while ((read FILE, $temp, 1_000_000)) {
	$buffer .= $temp;
}
undef $temp;
close FILE;

#double check it's not the just error page
$temp = $buffer =~ tr/\n//;
if ($temp < 3) {
	die "Something wrong with spreadsheet likely.";
}

#string manip
print "Running regexes...\n";
$buffer =~ s/^([^\t]*\t){12}(?!y$).*$//gmi;
$buffer =~ s/^([^\t]+\t){12}.*$//gm;
$buffer =~ s/^[^\t\(]+\(#?(\d+)\)/$1/gm;
$buffer =~ s/\s*\(.*\)//gm;
$buffer =~ s/\t.*$//gm;
$buffer =~ s/\s+$//gm;
$buffer =~ s/^\n*//g;
$buffer .= "\n";

#write to file
print "Writing to $target...\n";
open FILE, ">$target" or die $!;
print FILE $buffer;
close FILE;
