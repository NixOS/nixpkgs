{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "powerstat";
  version = "0.02.24";
  
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0yrc1xi9flxn2mvmzp0b0vd0md5z4p8fd4y8bszc67xy12qiqy0j";
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
