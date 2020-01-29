{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "fnotifystat";
  version = "0.02.03";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/fnotifystat/fnotifystat-${version}.tar.gz";
    sha256 = "1b5s50dc8ag6k631nfp09chrqfpwai0r9ld822xqwp3qlszp0pv9";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "File activity monitoring tool";
    homepage = https://kernel.ubuntu.com/~cking/fnotifystat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
