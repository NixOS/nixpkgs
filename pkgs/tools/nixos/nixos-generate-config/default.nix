{ substituteAll
, btrfs-progs
, perl
, perlPackages
, lib
, release ? lib.trivial.release
}:
substituteAll {
  name = "nixos-generate-config";
  dir = "bin";
  isExecutable = true;
  src = ./nixos-generate-config.pl;
  path = [ btrfs-progs ];
  perl = "${perl}/bin/perl -I${perlPackages.FileSlurp}/lib/perl5/site_perl";
  inherit release;
}
