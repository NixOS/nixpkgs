{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "statik";
  version = "unstable-2019-07-31";
  goPackagePath = "github.com/rakyll/statik";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = "statik";
    rev = "925a23bda946b50bb0804894f340c5da2b95603b";
    sha256 = "15wwgrprfq36pa13b9anp7097q1fqcad28hirvivybmc011p0fri";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/rakyll/statik";
    description = "Embed files into a Go executable ";
    license = licenses.asl20;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
