{ stdenv, lib, fetchgit
, rev, hash, version ? "git+${builtins.substring 0 7 rev}"
}:

stdenv.mkDerivation rec {
  pname = "crossfire-maps";
  inherit version;

  src = fetchgit {
    url = "http://git.code.sf.net/p/crossfire/crossfire-maps";
    inherit rev hash;
  };

  installPhase = ''
    mkdir -p "$out"
    cp -a . "$out/"
  '';

  meta = with lib; {
    description = "Map data for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    hydraPlatforms = [];
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
