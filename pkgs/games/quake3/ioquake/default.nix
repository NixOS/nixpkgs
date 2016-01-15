{ lib, stdenv, fetchgit, xlibsWrapper, SDL2, mesa, openalSoft
, curl, speex, opusfile, libogg, libopus, libjpeg, mumble, freetype
}:

stdenv.mkDerivation {
  name = "ioquake3-git-20151228";

  src = fetchgit {
    url = "https://github.com/ioquake/ioq3";
    rev = "fe619680f8fa9794906fc82a9c8c6113770696e6";
    sha256 = "5462441df63eebee6f8ed19a8326de5f874dad31e124d37f73d3bab1cd656a87";
  };

  buildInputs = [ xlibsWrapper SDL2 mesa openalSoft curl speex opusfile libogg libopus libjpeg freetype mumble ];

  NIX_CFLAGS_COMPILE = [ "-I${SDL2}/include/SDL2" "-I${opusfile}/include/opus" "-I${libopus}/include/opus" ];
  NIX_CFLAGS_LINK = [ "-lSDL2" ];

  enableParallelBuilding = true;

  makeFlags = [ "USE_INTERNAL_LIBS=0" "USE_FREETYPE=1" "USE_OPENAL_DLOPEN=0" "USE_CURL_DLOPEN=0" ];

  installTargets = [ "copyfiles" ];

  installFlags = [ "COPYDIR=$(out)" ];

  preInstall = ''
    mkdir -p $out/baseq3
  '';

  meta = {
    homepage = http://ioquake3.org/;
    description = "First person shooter engine based on the Quake 3: Arena and Quake 3: Team Arena";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco lib.maintainers.abbradar ];
  };
}
