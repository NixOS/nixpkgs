{ stdenv, buildGo114Package, fetchFromGitHub }:

buildGo114Package rec {
  pname = "exoscale-cli";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner  = "exoscale";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "04ym7mfv565icj3lmd2nrvq9asawwmmzg09681pj9py61ws56bxr";
  };

  goPackagePath = "github.com/exoscale/cli";
  goDeps = ./deps.nix;

  # ensures only the cli binary is built and we don't clutter bin/ with submodules
  subPackages = [ "." ];

  # we need to rename the resulting binary but can't use buildFlags with -o here
  # because these are passed to "go install" which does not recognize -o
  postBuild = ''
    mv go/bin/cli go/bin/exo
  '';

  meta = {
    description = "Command-line tool for everything at Exoscale: compute, storage, dns";
    homepage    = "https://github.com/exoscale/cli";
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ dramaturg ];
  };
}
