{ stdenv, lib, fetchzip, ncurses }:

stdenv.mkDerivation rec {
  pname = "eventstat";
  version = "0.04.12";
  src = fetchzip {
    url = "https://kernel.ubuntu.com/~cking/tarballs/eventstat/eventstat-${version}.tar.gz";
    sha256 = "sha256-XBSs/jZodCpI9BHgAF8+bE23gRCr2uebYiMJxxB8T5E=";
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
