{ lib
, stdenv
, fetchFromGitHub
, which
, pkg-config
, SDL2
, libGL
, openalSoft
, curl
, speex
, opusfile
, libogg
, libvorbis
, libopus
, libjpeg
, mumble
, freetype
}:

stdenv.mkDerivation {
  pname = "ioquake3";
  version = "unstable-2022-11-24";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "70d07d91d62dcdd2f2268d1ac401bfb697b4c991";
    sha256 = "sha256-WDjR0ik+xAs6OA1DNbUGIF1MXSuEoy8nNkPiHaegfF0=";
  };

  nativeBuildInputs = [ which pkg-config ];
  buildInputs = [
    SDL2
    libGL
    openalSoft
    curl
    speex
    opusfile
    libogg
    libvorbis
    libopus
    libjpeg
    freetype
    mumble
  ];

  enableParallelBuilding = true;

  makeFlags = [ "USE_INTERNAL_LIBS=0" "USE_FREETYPE=1" "USE_OPENAL_DLOPEN=0" "USE_CURL_DLOPEN=0" ];

  installTargets = [ "copyfiles" ];

  installFlags = [ "COPYDIR=$(out)" "COPYBINDIR=$(out)/bin" ];

  preInstall = ''
    mkdir -p $out/baseq3 $out/bin
  '';

  meta = with lib; {
    homepage = "https://ioquake3.org/";
    description = "First person shooter engine based on the Quake 3: Arena and Quake 3: Team Arena";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rvolosatovs eelco abbradar ];
  };
}
