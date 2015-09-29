{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  name = "eventstat-${version}";
  version = "0.02.02";
  src = fetchzip {
    url = "http://kernel.ubuntu.com/~cking/tarballs/eventstat/eventstat-${version}.tar.gz";
    sha256 = "1l1shcj3c0pxv1g6sqc10ka1crbx0cm2gldxbyrzqv2lmlfnmm44";
  };
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
