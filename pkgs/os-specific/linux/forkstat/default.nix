{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "forkstat-${version}";
  version = "0.02.00";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/forkstat/forkstat-${version}.tar.gz";
    sha256 = "07df2lb32lbr2ggi84h9pjy6ig18n2961ksji4x1hhb4cvc175dg";
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
