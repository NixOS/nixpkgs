{ stdenv, lib, fetchzip, ncurses }:

stdenv.mkDerivation rec {
  pname = "eventstat";
  version = "0.04.11";
  src = fetchzip {
    url = "https://kernel.ubuntu.com/~cking/tarballs/eventstat/eventstat-${version}.tar.gz";
    sha256 = "0hsi5w8dmqwwdahnqvs83bam3j1cagw1ggm06d35dfwy5xknc5i4";
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
