{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gawp";
  version = "unstable-2016-01-21";

  goPackagePath = "github.com/martingallagher/gawp";

  src = fetchFromGitHub {
    owner = "martingallagher";
    repo = "gawp";
    rev = "5db2d8faa220e8d6eaf8677354bd197bf621ff7f";
    sha256 = "sha256-DGTSz+4gaEd+FMSPvtY6kY4gJGnJah3exvu13sNadS0=";
  };

  goDeps = ./deps.nix;

  meta = {
    homepage = "https://github.com/martingallagher/gawp";
    description = "A simple, configurable, file watching, job execution tool";
    license = lib.licenses.asl20;
  };
}
