{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "powerstat";
  version = "0.02.25";

  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-C6MCOXnElDI69QkLKd2X2SLved8cRCN0Q6BhUvvqsTY=";
  };

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';

  meta = with lib; {
    description = "Laptop power measuring tool";
    homepage = "https://kernel.ubuntu.com/~cking/powerstat/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
