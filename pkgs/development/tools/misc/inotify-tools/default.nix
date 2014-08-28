{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "inotify-tools-${version}";
  version = "3.14";

  src = fetchurl {
    url = "http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-${version}.tar.gz";
    sha256 = "0icl4bx041axd5dvhg89kilfkysjj86hjakc7bk8n49cxjn4cha6";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/rvoicilas/inotify-tools/wiki;
    license = licenses.gpl2;
    maintainers = with maintainers; [ marcweber pSub ];
    platforms = platforms.linux;
  };
}
