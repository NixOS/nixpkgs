{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "forkstat";
  version = "0.02.14";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/forkstat/forkstat-${version}.tar.xz";
    sha256 = "10kibb5psb5gqdmq9lfb7qw566diwg54gdb49b5zd71qwpybk3dl";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Process fork/exec/exit monitoring tool";
    homepage = "https://kernel.ubuntu.com/~cking/forkstat/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
