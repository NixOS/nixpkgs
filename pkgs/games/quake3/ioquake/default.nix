{ stdenv, fetchFromGitHub, which, pkgconfig, SDL2, libGLU_combined, openalSoft
, curl, speex, opusfile, libogg, libvorbis, libopus, libjpeg, mumble, freetype
}:

stdenv.mkDerivation rec {
  name = "ioquake3-git-${version}";
  version = "2018-02-23";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "0d6edd227a13f1447938da1d1b020303c2545eb2";
    sha256 = "1nsagyzrai8cxhabcv2my8bbwmwckvri288j6x4qi5bmp78xl4hx";
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
    maintainers = with maintainers; [ eelco abbradar ];
  };
}
