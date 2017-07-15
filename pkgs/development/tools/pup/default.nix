{ stdenv, lib, buildGoPackage, fetchFromGitHub, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "pup-${version}";
  version = "20160425-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "e76307d03d4d2e0f01fb7ab51dee09f2671c3db6";

  goPackagePath = "github.com/ericchiang/pup";

  src = fetchFromGitHub {
    inherit rev;
    owner = "ericchiang";
    repo = "pup";
    sha256 = "15lwas4cjchlwhrwnd5l4gxcwqdfgazdyh466hava5qzxacqxrm5";
  };
}
