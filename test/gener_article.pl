#!/usr/bin/perl


# ***********************************************************
# ** Description: Random articles generator - for testing
# **
# ** (c) Jiri Tyr 2007
# ***********************************************************


use strict;
use warnings;
use utf8;

my $begin = 1;
my $end = 10000;

my $min_length = 350;
my $source = "Load balancing software uses multiple hardware devices to spread work around and thereby speed performance. While Linux Virtual Server may be the best-known option for Linux networks, another alternative, BalanceNG, a simple, lightweight utility, may be a better choice for some organizations. SpecSoft's Linux-powered RaveHD DDR-VTR system is not a video editing tool for home users or small-time professionals. It's a system that stores, manipulates, and plays back uncompressed video that can be turned into film clear enough to fill a Hollywood movie theater's wide screen. It's what you need when the file size of each frame in your video is measured in gigabytes and your whole project takes up multiple terabytes of storage, and you have not just one or two but 100 or 200 animators and post-production people working for you. At this level of video and film production, says SpecSoft co-founder Ramona Howard, the question isn't why you develop your utility programs in Linux, but why you would even consider using a proprietary operating system. BalanceNG Balance Next Generation is user-mode load balancing software with its own network stacks that runs over Linux and Solaris. All the work is done by the software; the operating system is used only for accessing the physical network interfaces and TCP/IP functions. It supports many different load balancing methods, including round robin, random, hash, and least resource. The load-balancing service takes around 400KB of disk space and the agent takes around 100KB. You need to run the balancing service on a machine that will act as your virtual server, and a balancing agent on all nodes that are part of the cluster, which are called targets in BalanceNG parlance. The software generates minimal network (UDP) traffic. The software can provide load balancing not only for Web servers, but almost any kind of service, including HTTP, FTP, SQL, POP3, IMAP, and SMTP. Ramona Howard and her son Jason founded SpecSoft in 1997. They have used Linux as their primary development platform from day one. They didn't originally focus on the broadcast and film industries, but worked on a US government software project. At almost the exact time funding for that project ran out, Ramona says, We were approached and asked to write a driver for the StillStore board. So we did. Within a weekend. BalanceNG is not open source. You can download and use the software for free on one virtual server and two targets, which is enough for a small or home business. If you need more, you can upgrade the basic license so that you can have up to 512 virtual servers and up to 1,024 target servers.";
my @words = split /\s/, $source;
my $words_count = scalar(@words)-1;

foreach my $id (@{[$begin..$end]}) {
	open F, '>xml/articles/Article-'.$id.'.xml' or die 'Can not open file!';

	my $length = $min_length + int(rand(300));
	my $text;

	my $big = 1;
	while (1) {
		my $word = $words[int(rand($words_count))];

		if ($big == 1) {
		    $word = ucfirst $word;
		}

		$text .= $word.' ';

		if (length $text > $length) {
		    $text =~ s/\s$//;
		    $text .= '.';
		    last;
		}

		$big = 0;
		if ($word =~ /\.$/) {
			$big = 1;
		}
	}

	$text =~ s/\s{2,}/ /g;

	print F <<END;
<?xml version="1.0" encoding="utf-8"?>

<?xml-stylesheet type="text/xsl" href="../xsl/Article.xsl"?>

<article id="$id">
        <title>Article $id</title>
        <text>
$text
        </text>
</article>
END

	close F or die 'Can not close file!';
}

exit 0;
