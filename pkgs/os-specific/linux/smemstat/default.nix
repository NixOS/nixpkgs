{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "smemstat-${version}";
  version = "0.01.18";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/smemstat/smemstat-${version}.tar.gz";
    sha256 = "0g262gilj2jk365wj4yl93ifppgvc9rx7dmlw6ychbv72v2pbv6w";
  };
  buildInputs = [ ncurses ];
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Memory usage monitoring tool";
    homepage = http://kernel.ubuntu.com/~cking/smemstat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
