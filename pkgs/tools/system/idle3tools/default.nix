{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "idle3-tools";
  version = "0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/idle3-tools/idle3-tools-${version}.tgz";
    sha256 = "00ia7xq9yldxyl9gz0mr4xa568nav14p0fnv82f2rbbkg060cy4p";
  };

  preInstall = ''
    installFlags=DESTDIR=$out
  '';

  meta = {
    homepage = "https://idle3-tools.sourceforge.net/";
    description = "Tool to get/set the infamous idle3 timer in WD HDDs";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
    mainProgram = "idle3ctl";
  };
}
