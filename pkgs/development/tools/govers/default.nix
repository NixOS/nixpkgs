{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "govers-${version}";
  version = "20150109-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "3b5f175f65d601d06f48d78fcbdb0add633565b9";
  
  goPackagePath = "github.com/rogpeppe/govers";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/rogpeppe/govers";
    sha256 = "0din5a7nff6hpc4wg0yad2nwbgy4q1qaazxl8ni49lkkr4hyp8pc";
  };

  dontRenameImports = true;
}
