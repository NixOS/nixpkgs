{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "filtron";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "filtron";
    rev = "v${version}";
    sha256 = "18d3h0i2sfqbc0bjx26jm2n9f37zwp8z9z4wd17sw7nvkfa72a26";
  };

  goPackagePath = "github.com/asciimoo/filtron";

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Reverse HTTP proxy to filter requests by different rules.";
    homepage = "https://github.com/asciimoo/filtron";
    license = licenses.agpl3;
    maintainers = [ maintainers.dasj19 ];
    platforms = platforms.linux;
  };
}
