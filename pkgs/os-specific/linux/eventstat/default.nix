{ stdenv, lib, fetchzip, ncurses }:

stdenv.mkDerivation rec {
  name = "eventstat-${version}";
  version = "0.03.02";
  src = fetchzip {
    url = "http://kernel.ubuntu.com/~cking/tarballs/eventstat/eventstat-${version}.tar.gz";
    sha256 = "1bwv0m9pk9l0jfibvsfjggc5pp9lyyrsfr10h6jm6kf1v6r6hf5s";
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
