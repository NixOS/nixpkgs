{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "pgmetrics-${version}";
  version = "1.5.0";

  goPackagePath = "github.com/rapidloop/pgmetrics";

  src = fetchFromGitHub {
    owner  = "rapidloop";
    repo   = "pgmetrics";
    rev    = "refs/tags/v${version}";
    sha256 = "1l3vd1lvp4a6irx0zpjb5bkskkb9krx9j7pwii8jy9dcjy4gj24f";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://pgmetrics.io/;
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
