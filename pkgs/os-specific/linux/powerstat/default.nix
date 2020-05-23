{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "powerstat";
  version = "0.02.23";
  
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1yj8ja0hw92wscazxh9vr3qdz24wpw2fgd3w7w088srfzg2aqf3a";
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
