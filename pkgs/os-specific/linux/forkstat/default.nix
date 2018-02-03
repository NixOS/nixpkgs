{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "forkstat-${version}";
  version = "0.02.02";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/forkstat/forkstat-${version}.tar.gz";
    sha256 = "02iqi4xjg2hl4paw88fz9jb88a9p4zprvq3g56cd7jwfx3vmw5a4";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Process fork/exec/exit monitoring tool";
    homepage = http://kernel.ubuntu.com/~cking/forkstat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
