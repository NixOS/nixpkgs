#! /usr/bin/perl -w

use strict;
use FileHandle;
use File::Spec;
use Digest::MD5;

my $path = $ENV{"PATH_INFO"};

# Sanitise path.
die unless $path =~ /^(\/[A-Za-z0-9-][A-Za-z0-9-\.]+)+$/;

my $fullpath = "/home/eelco/public_html/nix/$path";

open FILE, "< $fullpath" or die "cannot open $fullpath";
# !!! error checking
my $hash = Digest::MD5->new->addfile(*FILE)->hexdigest;
close FILE;

print "Content-Type: text/plain\n\n"; 
print "$hash";
