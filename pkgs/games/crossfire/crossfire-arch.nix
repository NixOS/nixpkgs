{ stdenv, lib, fetchsvn,
  version, rev, sha256 }:

stdenv.mkDerivation rec {
  pname = "crossfire-arch";
  version = "r${toString rev}";

  src = fetchsvn {
    url = "http://svn.code.sf.net/p/crossfire/code/arch/trunk/";
    sha256 = sha256;
    rev = rev;
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
