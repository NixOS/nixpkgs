{ stdenv, lib, fetchurl, deliantra-server }:

stdenv.mkDerivation rec {
  name = "deliantra-maps-${version}";
  version = "3.1";

  src = fetchurl {
    url = "http://dist.schmorp.de/deliantra/${name}.tar.xz";
    sha256 = "0zbwzya28s1xpnbrmqkqvfrzns03zdjd8a9w9nk665aif6rw2zbz";
  };

  hydraPlatforms = [];
  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    mkdir -p "$out/maps"
    export DELIANTRA_DATADIR="$out"
    ${deliantra-server}/bin/cfutil --install-maps .
  '';

  meta = with lib; {
    description = "Map data for the Deliantra free MMORPG";
    homepage = "http://www.deliantra.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
