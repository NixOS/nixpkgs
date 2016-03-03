{ lib, stdenv, fetchFromGitHub, xlibsWrapper, SDL2, mesa, openalSoft
, curl, speex, opusfile, libogg, libopus, libjpeg, mumble, freetype
}:

stdenv.mkDerivation rec {
  name = "ioquake3-git-${version}";
  version = "2016-02-18";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "a331637745fb82266f3627fb438f2d58d53e366c";
    sha256 = "0l9ppv1msd73bhqmdiv5lsvkr5i6khqgi6gi322gbnndr20arn4n";
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
