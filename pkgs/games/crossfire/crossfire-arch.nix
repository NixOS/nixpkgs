{ stdenv, lib, fetchgit
, rev, hash, version ? "git+${builtins.substring 0 7 rev}"
}:

stdenv.mkDerivation rec {
  pname = "crossfire-arch";
  inherit version;

  src = fetchgit {
    url = "http://git.code.sf.net/p/crossfire/crossfire-arch";
    inherit rev hash;
  };

  installPhase = ''
    mkdir -p "$out"
    cp -a . "$out/"
  '';

  meta = with lib; {
    description = "Archetype data for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    hydraPlatforms = [];
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
