{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "bar-1.11.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/clpbar/clpbar/bar-1.11.1/bar_1.11.1.tar.gz";
    sha256 = "00v5cb6vzizyyhflgr62d3k8dqc0rg6wdgfyyk11c0s0r32mw3zs";
  };

  meta = {
    description = "Console progress bar";
    homepage = http://clpbar.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.rdnetto ];
    platforms = stdenv.lib.platforms.all;
  };
}
