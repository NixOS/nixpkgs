{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "powerstat";
  version = "0.02.21";
  
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "00396dyn3mw3virx9h2g9kzw9ai10x7wpn8zclnvvidn9g0jhf31";
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
