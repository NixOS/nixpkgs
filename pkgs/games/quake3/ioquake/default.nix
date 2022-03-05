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
  version = "unstable-2021-07-20";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "bc8737d707595aebd7cc11d6d5a5d65ede750f59";
    sha256 = "1icrkaw6c5c5ndy886bn65lycwnxzxwvz0ndz4p9i6r716k11add";
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

  installFlags = [ "COPYDIR=$(out)" ];

  preInstall = ''
    mkdir -p $out/baseq3
  '';

  meta = with lib; {
    homepage = "https://ioquake3.org/";
    description = "First person shooter engine based on the Quake 3: Arena and Quake 3: Team Arena";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rvolosatovs eelco abbradar ];
  };
}
