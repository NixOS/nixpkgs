{ stdenv, lib, fetchzip, ncurses }:

stdenv.mkDerivation rec {
  pname = "eventstat";
  version = "0.04.10";
  src = fetchzip {
    url = "https://kernel.ubuntu.com/~cking/tarballs/eventstat/eventstat-${version}.tar.gz";
    sha256 = "0rmg49m56qxji7gwci03pkk4f4hnaq1n2x1348dqkaf5zs5nhi6b";
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
