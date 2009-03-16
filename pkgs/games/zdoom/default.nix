{stdenv, fetchsvn, cmake, SDL, nasm, p7zip, zlib, flac, fmod, libjpeg}:

stdenv.mkDerivation {
  name = "zdoom-svn-1424";
  src = fetchsvn {
    url = http://mancubus.net/svn/hosted/zdoom/zdoom/trunk;
    rev = 1424;
  };
  buildInputs = [cmake nasm SDL p7zip zlib flac fmod libjpeg];

  cmakeFlags = [ "-DSDL_INCLUDE_DIR=${SDL}/include/SDL" ];
   
  preConfigure=''
    sed s@zdoom.pk3@$out/share/zdoom.pk3@ -i src/version.h
 '';

  installPhase = ''
    mkdir -p $out/bin
    cp zdoom $out/bin
    mkdir -p $out/share
    cp zdoom.pk3 $out/share
  '';

  meta = {
    homepage = http://zdoom.org/;
    description = "Enhanced port of the official DOOM source code";
  };
}

