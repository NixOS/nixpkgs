{ lib, stdenv, fetchFromGitHub, which, pkg-config, SDL2, libGL, openalSoft
, curl, speex, opusfile, libogg, libvorbis, libopus, libjpeg, mumble, freetype
}:

stdenv.mkDerivation {
  pname = "ioquake3-git";
  version = "2020-12-26";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "05180e32dcfb9a4552e1b9652b56127248a9950c";
    sha256 = "0hcxxa1ambpdwhg7nb5hvb32g49rl5p9dcflpzcv5cax9drn166i";
  };

  nativeBuildInputs = [ which pkg-config ];
  buildInputs = [
    SDL2 libGL openalSoft curl speex opusfile libogg libvorbis libopus libjpeg
    freetype mumble
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
