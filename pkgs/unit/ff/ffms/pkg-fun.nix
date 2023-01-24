{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, ffmpeg_4
, zlib
}:

stdenv.mkDerivation rec {
  pname = "ffms";
  version = "2.40";

  src = fetchFromGitHub {
    owner = "FFMS";
    repo = "ffms2";
    rev = version;
    sha256 = "sha256-3bPxt911T0bGpAIS2RxBjo+VV84xW06eKcCj3ZAcmvw=";
  };

  NIX_CFLAGS_COMPILE = "-fPIC";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preAutoreconf = ''
    mkdir src/config
  '';

  buildInputs = [
    ffmpeg_4
    zlib
  ];

  # ffms includes a built-in vapoursynth plugin, see:
  # https://github.com/FFMS/ffms2#avisynth-and-vapoursynth-plugin
  postInstall = ''
    mkdir $out/lib/vapoursynth
    ln -s $out/lib/libffms2.so $out/lib/vapoursynth/libffms2.so
  '';

  meta = with lib; {
    homepage = "https://github.com/FFMS/ffms2/";
    description = "FFmpeg based source library for easy frame accurate access";
    license = licenses.mit;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.unix;
  };
}
