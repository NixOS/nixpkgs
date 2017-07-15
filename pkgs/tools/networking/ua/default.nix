{ stdenv, buildGoPackage, fetchFromGitHub
, pkgconfig
, glib, libxml2
}:

buildGoPackage rec {
  name = "ua-unstable-${version}";
  version = "2017-02-24";
  rev = "325dab92c60e0f028e55060f0c288aa70905fb17";

  goPackagePath = "github.com/sloonz/ua";

  src = fetchFromGitHub {
    inherit rev;
    owner = "sloonz";
    repo = "ua";
    sha256 = "0452qknc8km9495324g6b5ja3shvk8jl7aa9nrjhdylf09dp2nif";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libxml2 ];

  meta = {
    homepage = "https://github.com/sloonz/ua";
    license = stdenv.lib.licenses.isc;
    shortDescription = "Universal Aggregator";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
