{stdenv, fetchurl, libX11}:

stdenv.mkDerivation {
  name = "xtrace-1.0.1";
  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/3149/xtrace_1.0.1.orig.tar.gz";
    sha256 = "042rifm93mws7xbw86z0m1rmdijprlkijsi2882as1yf6gdbdqbm";
  };
  buildInputs = [libX11];

  meta = {
    homepage = http://xtrace.alioth.debian.org/;
    description = "Trace X protocol connections";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
