{ stdenv, lib, fetchurl, deliantra-maps, deliantra-arch, deliantra-server, symlinkJoin }:

symlinkJoin rec {
  name = "deliantra-data-${version}";
  version = "M${deliantra-maps.version}+A${deliantra-arch.version}";

  hydraPlatforms = [];
  paths = [deliantra-maps deliantra-arch "${deliantra-server}/share/deliantra-server"];

  meta = with lib; {
    description = "Combined game data (maps + archetypes) for the Deliantra free MMORPG";
    homepage = "http://www.deliantra.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
