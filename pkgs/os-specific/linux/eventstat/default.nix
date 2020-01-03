{ stdenv, lib, fetchzip, ncurses }:

stdenv.mkDerivation rec {
  pname = "eventstat";
  version = "0.04.07";
  src = fetchzip {
    url = "https://kernel.ubuntu.com/~cking/tarballs/eventstat/eventstat-${version}.tar.gz";
    sha256 = "05gl060lgm6i10ayk0hri49k7vln1sdqkqqy1kjgck6gkbamk7a5";
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
