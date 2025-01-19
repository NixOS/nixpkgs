{
  stdenv,
  lib,
  fetchsvn,
  version,
  rev,
  sha256,
}:

stdenv.mkDerivation rec {
  pname = "crossfire-arch";
  version = rev;

  src = fetchsvn {
    url = "http://svn.code.sf.net/p/crossfire/code/arch/trunk/";
    inherit sha256;
    rev = "r${rev}";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -a . "$out/"
  '';

  meta = {
    description = "Archetype data for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [ ToxicFrog ];
  };
}
