{ stdenv, buildGoPackage, fetchgit }:

with builtins;

buildGoPackage rec {
  pname = "gawp";
  version = "20160121-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "5db2d8faa220e8d6eaf8677354bd197bf621ff7f";

  goPackagePath = "github.com/martingallagher/gawp";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/martingallagher/gawp";
    sha256 = "0bbmbb1xxdgvqvg1ssn9d4j213li7bbbx3y42iz4fs10xv7x4r0c";
  };

  goDeps = ./deps.nix;

  meta = {
    homepage = "https://github.com/martingallagher/gawp";
    description = "A simple, configurable, file watching, job execution tool";
    license = stdenv.lib.licenses.asl20;
  };
}
