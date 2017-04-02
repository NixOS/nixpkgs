{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "smemstat-${version}";
  version = "0.01.16";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/smemstat/smemstat-${version}.tar.gz";
    sha256 = "14n3s6ibm9bq58drvpiasqn11ci6mrwswfpcbpbsimx6fh2j4bi3";
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
