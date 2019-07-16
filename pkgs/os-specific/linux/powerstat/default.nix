{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "powerstat";
  version = "0.02.19";
  
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0yh6l2mx5gfdgrfx406hxbi03c12cgi29pwlzgdfrpz6zs2icaw5";
  };
  
  installFlags = [ "DESTDIR=${placeholder "out"}" ];
  
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  
  meta = with lib; {
    description = "Laptop power measuring tool";
    homepage = https://kernel.ubuntu.com/~cking/powerstat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
