{ stdenv, lib, fetchurl, deliantra-server }:

stdenv.mkDerivation rec {
  name = "deliantra-arch-${version}";
  version = "3.1";

  src = fetchurl {
    url = "http://dist.schmorp.de/deliantra/${name}.tar.xz";
    sha256 = "1xzhv48g90hwkzgx9nfjm81ivg6hchkik9ldimi8ijb4j393kvsz";
  };

  hydraPlatforms = [];
  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    mkdir -p "$out"
    export DELIANTRA_DATADIR="$out"
    ${deliantra-server}/bin/cfutil --install-arch .
  '';

  meta = with lib; {
    description = "Archetype data for the Deliantra free MMORPG";
    homepage = "http://www.deliantra.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
