{ stdenv, fetchFromGitHub, cmake, fmod, mesa, SDL }:

stdenv.mkDerivation {
  name = "zdoom-2.7.1";
  src = fetchFromGitHub {
    #url = "https://github.com/rheit/zdoom";
    owner = "rheit";
    repo = "zdoom";
    rev = "2.7.1";
    sha256 = "00bx4sgl9j1dyih7yysfq4ah6msxw8580g53p99jfym34ky5ppkh";
  };

  buildInputs = [ cmake fmod mesa SDL ];

  cmakeFlags = [
    "-DFMOD_LIBRARY=${fmod}/lib/libfmodex.so"
    "-DSDL_INCLUDE_DIR=${SDL.dev}/include"
  ];

  NIX_CFLAGS_COMPILE = [ "-I ${SDL.dev}/include/SDL" ];
   
  preConfigure = ''
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
    maintainers = [ stdenv.lib.maintainers.lassulus ];
  };
}

