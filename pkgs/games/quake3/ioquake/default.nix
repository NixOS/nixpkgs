{ lib, stdenv, fetchFromGitHub, which, pkgconfig, xlibsWrapper, SDL2, mesa, openalSoft
, curl, speex, opusfile, libogg, libopus, libjpeg, mumble, freetype
}:

stdenv.mkDerivation rec {
  name = "ioquake3-git-${version}";
  version = "2016-04-05";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "1f6703821f11be9c711c6ee42371ab290dd12776";
    sha256 = "0jbn4lv85khfcmn1dc3mrx7zxldj3p4cggx85hdfpiwmnsjl4w67";
  };

  nativeBuildInputs = [ which pkgconfig ];
  buildInputs = [ xlibsWrapper SDL2 mesa openalSoft curl speex opusfile libogg libopus libjpeg freetype mumble ];

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
