{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "powerstat-${version}";
  version = "0.02.16";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/powerstat/powerstat-${version}.tar.gz";
    sha256 = "14sx37l40038sjygsnp95542fkbhhc911vd9k5rf85czmvndz29m";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Laptop power measuring tool";
    homepage = http://kernel.ubuntu.com/~cking/powerstat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
