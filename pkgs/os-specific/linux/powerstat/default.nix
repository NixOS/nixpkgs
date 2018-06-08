{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "powerstat-${version}";
  version = "0.02.17";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/powerstat/powerstat-${version}.tar.gz";
    sha256 = "1lxzrvwlf6h35i0d8v1yj1ka63i9i0yvv3adhy3pa3fl8arpvycs";
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
