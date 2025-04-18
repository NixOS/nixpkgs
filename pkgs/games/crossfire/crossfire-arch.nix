{
  stdenv,
  lib,
  fetchgit,
  version,
  rev,
  hash,
}:

stdenv.mkDerivation {
  pname = "crossfire-arch";
  version = rev;

  src = fetchgit {
    url = "https://git.code.sf.net/p/crossfire/crossfire-arch";
    inherit hash rev;
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
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
