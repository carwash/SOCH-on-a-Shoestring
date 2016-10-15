#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use 5.014;
use LWP::Simple;
use XML::XPath;
use open qw(:utf8 :std);

# Search K-samsök using Perl XML tools:
say "Enter search term:";
my $query = readline();
say "Number of results (max 500)?";
my $number = readline();
chomp for ($query, $number);
die "Not a number!\n" unless ($number =~ /^\d+$/);
die "Max 500 results!\n" unless ($number <= 500);
my $xml = get("http://kulturarvsdata.se/ksamsok/sru?operation=searchRetrieve&version=1.1&maximumRecords=$number&x-api=test&query=text=$query");
die "Failed to fetch results.\n" unless (defined $xml);
my $xp = XML::XPath->new($xml);
my $objects = $xp->find('srw:searchRetrieveResponse/srw:records/srw:record/srw:recordData/pres:item');
my @results;
for my $node ($objects->get_nodelist()) {
  my @fields;
	for my $field (qw{organization id type entityUri}) {
		push @fields, $xp->find("./pres:$field/text()", $node);
	}
	next unless @fields;
	push @results, join(' 'x12, map {s!/(object|media|fmi)/!/$1/html/!g; $_} @fields);
}
say 'No results returned.' unless @results;
say for sort @results;
