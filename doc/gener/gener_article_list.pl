#!/usr/bin/perl


# ***********************************************************
# ** Description: Random article list generator - for testing
# **
# ** (c) Jiri Tyr 2007
# ***********************************************************


use strict;
use warnings;
use utf8;

my $begin = 1;
my $end = 10000;
my @cat = (1..8);

open F, '>xml/ArticleList.xml' or die 'Can not open file!';

print F '<?xml version="1.0" encoding="utf-8"?>'."\n";
print F '<article_list>'."\n";

for (my $id=$end; $id>$begin-1; $id--) {
	my $date = sprintf("%0.2d.%0.2d.%d %0.2d:%0.2d:%0.2d", int(rand(28)), int(rand(12)), 2007, int(rand(24)), int(rand(60)), int(rand(60)));
	my $cat_count = int(rand(5)) + 1;

	my @cat_tmp;
	foreach my $cat_id (@cat) {
		if (int(rand(5)) == 3) {
			push @cat_tmp, $cat_id;
		}
	}

	if (scalar @cat_tmp > 0) {
		print F '<a d="'.$date.'" i="'.$id.'">';
		print F '<c i="0"/>';
		foreach my $tmp (@cat_tmp) {
			print F '<c i="'.$tmp.'"/>';
		}
		print F '</a>'."\n";
	} else {
		print F '<a d="'.$date.'" i="'.$id.'"/>'."\n";
	}
}

print F '</article_list>'."\n";
close F or die 'Can not close file!';

exit 0;
