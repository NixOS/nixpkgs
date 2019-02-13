{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "tegola-${version}";
  version = "0.8.1";
  rev = "8b2675a63624ad1d69a8d2c84a6a3f3933e25ca1";

  goPackagePath = "github.com/go-spatial/tegola";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = "tegola";
    inherit rev;
    sha256 = "1f70vsrj3i1d0kg76a8s741nps71hrglgyyrz2xm6a8b31w833pi";
  };

  meta = with stdenv.lib; {
    homepage = https://www.tegola.io/;
    description = "Mapbox Vector Tile server";
    maintainers = with maintainers; [ ingenieroariel ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
