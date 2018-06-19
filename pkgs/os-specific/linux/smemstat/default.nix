{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "smemstat-${version}";
  version = "0.02.00";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/smemstat/smemstat-${version}.tar.gz";
    sha256 = "16in8bzsrrcz7mc5qvyvjkxgpzz4bnq8zvkb7vsv6qfgyd3xr1dp";
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
