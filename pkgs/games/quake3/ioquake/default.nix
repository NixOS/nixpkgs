{ lib, stdenv, fetchFromGitHub, which, pkgconfig, xlibsWrapper, SDL2, mesa, openalSoft
, curl, speex, opusfile, libogg, libopus, libjpeg, mumble, freetype
}:

stdenv.mkDerivation rec {
  name = "ioquake3-git-${version}";
  version = "2017-01-27";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "468da0fabca2f21b811a501c184b986e270c5113";
    sha256 = "14mhkqn6h2mbmz90j4ns1wp72ca5w9481sbyw2ving8xpw376i58";
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
    homepage = "http://ioquake3.org/";
    description = "First person shooter engine based on the Quake 3: Arena and Quake 3: Team Arena";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco lib.maintainers.abbradar ];
  };
}
