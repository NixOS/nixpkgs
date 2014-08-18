{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "inotify-tools-3.13";

  src = fetchurl {
    url = mirror://sourceforge/inotify-tools/inotify-tools/3.13/inotify-tools-3.13.tar.gz;
    sha256 = "0icl4bx041axd5dvhg89kilfkysjj86hjakc7bk8n49cxjn4cha6";
  };

  meta = {
    homepage = http://sourceforge.net/projects/inotify-tools/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
