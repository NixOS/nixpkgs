{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "idle3-tools-0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/idle3-tools/idle3-tools-0.9.1.tgz";
    sha256 = "00ia7xq9yldxyl9gz0mr4xa568nav14p0fnv82f2rbbkg060cy4p";
  };

  preInstall = ''
    installFlags=DESTDIR=$out
  '';

  meta = {
    homepage = http://idle3-tools.sourceforge.net/;
    description = "Tool to get/set the infamous idle3 timer in WD HDDs";
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
