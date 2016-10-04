{ lib, stdenv, fetchFromGitHub, which, pkgconfig, xlibsWrapper, SDL2, mesa, openalSoft
, curl, speex, opusfile, libogg, libopus, libjpeg, mumble, freetype
}:

stdenv.mkDerivation rec {
  name = "ioquake3-git-${version}";
  version = "2016-08-11";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "1cf0b21cda562bade9152958f1525e5ac281ab9c";
    sha256 = "104yrgi9dnfb493pm9wvk2kn80nazcr1nllb5vd7di66jnvcjks0";
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
