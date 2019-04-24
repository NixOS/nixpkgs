{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "fnotifystat-${version}";
  version = "0.02.01";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/fnotifystat/fnotifystat-${version}.tar.gz";
    sha256 = "18p6rqb3bhs2ih6mnp57j0cyawjm0iwky6y3ays54alkxqaz8gmx";
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
