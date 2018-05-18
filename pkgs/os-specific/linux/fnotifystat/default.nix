{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "fnotifystat-${version}";
  version = "0.02.00";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/fnotifystat/fnotifystat-${version}.tar.gz";
    sha256 = "0sfzmggfhhhp3vxn1s61b5bacr2hz6r7y699n3nysdciaa2scgdq";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "File activity monitoring tool";
    homepage = http://kernel.ubuntu.com/~cking/fnotifystat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
