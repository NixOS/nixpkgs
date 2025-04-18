{
  stdenv,
  lib,
  fetchgit,
  version,
  rev,
  hash,
}:

stdenv.mkDerivation {
  pname = "crossfire-maps";
  version = rev;

  src = fetchgit {
    url = "https://git.code.sf.net/p/crossfire/crossfire-maps";
    inherit hash rev;
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
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
