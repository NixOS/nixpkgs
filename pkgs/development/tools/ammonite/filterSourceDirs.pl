#!/usr/bin/env perl

# it checks if paths like "./amm/compiler/src/main/scala-not-2.12.13+-2.13.1+/ammonite/compiler/MakeReporter.scala" are suitable for a particular scala version

use strict;
use List::Util qw(any);

my $scalaVersion = $ARGV[0];
die unless $scalaVersion =~ /^(\d+)\.(\d+)\.(\d+)(-.+)?$/;
my ($major, $minor, $patch) = @{^CAPTURE};

sub check {
  my $code = shift;
  return !check($1)                                                    if $code =~ /^not-(.+)/;                   # negation
  return any { check($_) } split(/-/,$code)                            if $code =~ /-/;                           # ANY-sequence
  return $major eq $1                                                  if $code =~ /^(\d+)$/;                     # exact major version
  return $major eq $1 && $minor eq $2                                  if $code =~ /^(\d+)\.(\d+)$/;              # exact major.minor version
  return $major eq $1 && $minor eq $2 && $3 <= $patch                  if $code =~ /^(\d+)\.(\d+)\.(\d+)\+?$/;    # open range
  return $major eq $1 && $minor eq $2 && $3 <= $patch && $patch <= $4  if $code =~ /^(\d+)\.(\d+)\.(\d+)_(\d+)$/; # closed range
  die "unknown predicate $code\n";
}

while (<STDIN>) {
  next if /\/scala-([^\/]+)\// && !check($1);
  print
}
