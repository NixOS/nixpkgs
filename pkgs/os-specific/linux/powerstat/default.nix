{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "powerstat-${version}";
  version = "0.02.11";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/powerstat/powerstat-${version}.tar.gz";
    sha256 = "0iid3b3284sf89pfp68i1k5mwmr31bqjzasb8clm2sa45ivafx52";
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
