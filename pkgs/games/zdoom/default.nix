{stdenv, fetchurl, cmake, SDL, nasm, p7zip, zlib, flac, fmod, libjpeg}:

stdenv.mkDerivation {
  name = "zdoom-2.6.1";
  src = fetchurl {
    url = http://zdoom.org/files/zdoom/2.6/zdoom-2.6.1-src.7z;
    sha256 = "1ha7hygwf243vkgw0dfh4dxphf5vffb3kkci1p1p75a7r1g1bir8";
  };

  # XXX: shouldn't inclusion of p7zip handle this?
  unpackPhase = ''
  mkdir zdoom
  cd zdoom
  7z x $src
  '';

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

