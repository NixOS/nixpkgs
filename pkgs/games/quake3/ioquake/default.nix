{ lib, stdenv, fetchFromGitHub, which, pkgconfig, xlibsWrapper, SDL2, mesa, openalSoft
, curl, speex, opusfile, libogg, libopus, libjpeg, mumble, freetype
}:

stdenv.mkDerivation rec {
  name = "ioquake3-git-${version}";
  version = "2016-11-02";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "1c1e1f61f180596c925a4ac0eddba4806d1369cd";
    sha256 = "1sx78hzvcbc05g2ikxcmnm6lq7bhgd86dzxnfzqpibcvgrlgsmy1";
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
