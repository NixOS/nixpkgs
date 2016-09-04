{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "forkstat-${version}";
  version = "0.01.14";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/forkstat/forkstat-${version}.tar.gz";
    sha256 = "0yj3mhf9b2nm8fnz4vf2fqdd8417g30p2sgv3ilq3zwy4hbg9bav";
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
