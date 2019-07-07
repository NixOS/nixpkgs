{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "forkstat-${version}";
  version = "0.02.09";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/forkstat/forkstat-${version}.tar.xz";
    sha256 = "1h5ha9w6rawh9kx39swjxs029202qxi0j9w38y7ilwq5pj447bxw";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Process fork/exec/exit monitoring tool";
    homepage = https://kernel.ubuntu.com/~cking/forkstat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
