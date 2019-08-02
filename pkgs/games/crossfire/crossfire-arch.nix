{ stdenv, lib, fetchsvn,
  version, rev, sha256 }:

stdenv.mkDerivation rec {
  version = "r${toString rev}";
  name = "crossfire-arch-${version}";

  src = fetchsvn {
    url = "http://svn.code.sf.net/p/crossfire/code/arch/trunk/";
    sha256 = sha256;
    rev = rev;
  };

  hydraPlatforms = [];
  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    mkdir -p "$out"
    cp -a . "$out/"
  '';

  meta = with lib; {
    description = "Archetype data for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
