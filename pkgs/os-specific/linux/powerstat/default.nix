{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "powerstat-${version}";
  version = "0.02.12";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/powerstat/powerstat-${version}.tar.gz";
    sha256 = "16ls3rs1wfckl0b2szqqgiv072afy4qjd3r4kz4vf2qj77kjm06w";
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
