{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "gox-${version}";
  version = "20140904-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "e8e6fd4fe12510cc46893dff18c5188a6a6dc549";

  
  goPackagePath = "github.com/mitchellh/gox";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/mitchellh/gox";
    sha256 = "14jb2vgfr6dv7zlw8i3ilmp125m5l28ljv41a66c9b8gijhm48k1";
  };

  goDeps = ./deps.json;
}
