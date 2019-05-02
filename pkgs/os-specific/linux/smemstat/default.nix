{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "smemstat-${version}";
  version = "0.02.03";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/smemstat/smemstat-${version}.tar.xz";
    sha256 = "04q06wb37n4g1dlsjl8j2bwzd7qis4wanm0f4xg8y29br6skljx1";
  };
  buildInputs = [ ncurses ];
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Memory usage monitoring tool";
    homepage = https://kernel.ubuntu.com/~cking/smemstat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
