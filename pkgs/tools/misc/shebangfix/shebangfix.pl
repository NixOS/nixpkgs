#!/bin/perl
use warnings;
use strict;

#usage PATH=< : separated path list> perl <this script>  file1 file2

print "TODO fix space trouble. This script won't work if your paths contain spaces";

sub findInPath{
  my $file = shift(@_);
  foreach (split(/:/, $ENV{'PATH'})){
    my $f =  "$_/$file";
    if (-x "$f"){
      return $f;
    }
  }
  print "unable to find $file in on of ".$ENV{'PATH'};
  exit 1
}

foreach (@ARGV)
{
  my $file = $_;
  open(FILE, $file);
  my $content = do { local $/; <FILE> };

  close(FILE); 

  (my $name = $content) =~ /^#![^ ]*\/([^ \n\r]*)/;
  my $fullpath =  ($1 eq 'sh') ? "/bin/sh" : findInPath($1);
  $content =~ s/^#![^ \n\r]*/#!$fullpath/;
  open(FILE, ">$file");
  print FILE $content;
  close($file);
}
