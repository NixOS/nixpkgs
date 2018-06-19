{ stdenv, lib, fetchzip, ncurses }:

stdenv.mkDerivation rec {
  name = "eventstat-${version}";
  version = "0.04.04";
  src = fetchzip {
    url = "http://kernel.ubuntu.com/~cking/tarballs/eventstat/eventstat-${version}.tar.gz";
    sha256 = "034xpdr3ip4w9k713wjc45x66k3nz6wg9wkzmchrjifxk4dldbd8";
  };
  buildInputs = [ ncurses ];
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Simple monitoring of system events";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
