#!/usr/bin/env perl

# annotate contigs based on sample name

use strict;
use warnings;
use v5.24;

my $arg_prefix=$ARGV[0];
my $counter=0;

# my $prefix = $arg_prefix =~ s/[^[:alpha:]]/_/gr;

while (<STDIN>) {
    if ($_ =~ /^>/) {
        chomp;
        print ">${arg_prefix}_$counter\n";
        $counter += 1;
    } else {
        print $_;
    }
}
