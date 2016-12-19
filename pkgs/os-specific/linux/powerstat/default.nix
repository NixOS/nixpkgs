{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "powerstat-${version}";
  version = "0.02.10";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/powerstat/powerstat-${version}.tar.gz";
    sha256 = "11n2k20h27j7m8j0l524w23xlkjhapsb3ml1qpx1si7gf0pkglcl";
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
