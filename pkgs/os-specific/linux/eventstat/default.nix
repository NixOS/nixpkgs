{ stdenv, lib, fetchzip, ncurses }:

stdenv.mkDerivation rec {
  name = "eventstat-${version}";
  version = "0.04.05";
  src = fetchzip {
    url = "https://kernel.ubuntu.com/~cking/tarballs/eventstat/eventstat-${version}.tar.gz";
    sha256 = "1s9d6wl7f8cyn21fwj894dhfvl6f6f2h5xv26hg1yk3zfb5rmyn7";
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
