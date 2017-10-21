{ stdenv, lib, fetchzip, ncurses }:

stdenv.mkDerivation rec {
  name = "eventstat-${version}";
  version = "0.03.04";
  src = fetchzip {
    url = "http://kernel.ubuntu.com/~cking/tarballs/eventstat/eventstat-${version}.tar.gz";
    sha256 = "1sqf1mfafrw6402qx457gh8yxgsw80311qi0lp4cjl9dfz7vl2x1";
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
