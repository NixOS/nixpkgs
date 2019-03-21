{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "pgmetrics";
  version = "1.6.1";

  goPackagePath = "github.com/rapidloop/pgmetrics";

  src = fetchFromGitHub {
    owner  = "rapidloop";
    repo   = "pgmetrics";
    rev    = "refs/tags/v${version}";
    sha256 = "0dj4b4gghzzwnzb0fdix1ps97scfr24f6dfa7d0vwak95ds5vz3s";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://pgmetrics.io/;
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
