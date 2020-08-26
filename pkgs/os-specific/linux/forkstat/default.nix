{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "forkstat";
  version = "0.02.15";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/forkstat/forkstat-${version}.tar.xz";
    sha256 = "11dvg7bbklpfywx6i6vb29vvc28pbfk3mff0g18n5imxvzsd7jxs";
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
