{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "gocode-${version}";
  version = "20150904-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "680a0fbae5119fb0dbea5dca1d89e02747a80de0";
  
  goPackagePath = "github.com/nsf/gocode";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/nsf/gocode";
    sha256 = "1ay2xakz4bcn8r3ylicbj753gjljvv4cj9l4wfly55cj1vjybjpv";
  };
}
