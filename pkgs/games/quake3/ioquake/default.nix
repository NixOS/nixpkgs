{ stdenv, fetchFromGitHub, which, pkgconfig, SDL2, libGLU_combined, openalSoft
, curl, speex, opusfile, libogg, libvorbis, libopus, libjpeg, mumble, freetype
}:

stdenv.mkDerivation rec {
  name = "ioquake3-git-${version}";
  version = "2018-12-14";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "b0d2b141e702aafc3dcf77a026e12757f00e45ed";
    sha256 = "17qkqi22f2fyh6bnfcf1zz2lycgv08d6aw52sf0hqw7r3qq86d08";
  };

  nativeBuildInputs = [ which pkgconfig ];
  buildInputs = [
    SDL2 libGLU_combined openalSoft curl speex opusfile libogg libvorbis libopus libjpeg
    freetype mumble
  ];

  enableParallelBuilding = true;

  makeFlags = [ "USE_INTERNAL_LIBS=0" "USE_FREETYPE=1" "USE_OPENAL_DLOPEN=0" "USE_CURL_DLOPEN=0" ];

  installTargets = [ "copyfiles" ];

  installFlags = [ "COPYDIR=$(out)" ];

  preInstall = ''
    mkdir -p $out/baseq3
  '';

  meta = with stdenv.lib; {
    homepage = https://ioquake3.org/;
    description = "First person shooter engine based on the Quake 3: Arena and Quake 3: Team Arena";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rvolosatovs eelco abbradar ];
  };
}
