#! /usr/bin/perl -w

use strict;

my $uploadpath = $ENV{"PATH_INFO"};

# Sanitise upload path.
die unless $uploadpath =~ /^(\/[A-Za-z0-9-][A-Za-z0-9-\.]+)+$/;

my $dst = "/home/eelco/public_html/nix/$uploadpath";
my $tmp = "${dst}_$$";

open OUT, ">$tmp" or die;
while (<STDIN>) {
    print OUT "$_" or die;
}
close OUT or die;

rename $tmp, $dst or die;

print "Content-Type: text/plain\n\n"; 
print "upload succesful\n";
print "upload path: $uploadpath\n"; 
