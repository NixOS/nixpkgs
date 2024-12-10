{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
  alsa-lib,
  curl,
  flac,
  fluidsynth,
  freetype,
  libjpeg,
  libmad,
  libmpeg2,
  libogg,
  libtheora,
  libvorbis,
  libGLU,
  libGL,
  SDL2,
  zlib,
  Cocoa,
  AudioToolbox,
  Carbon,
  CoreMIDI,
  AudioUnit,
  cctools,
}:

stdenv.mkDerivation rec {
  pname = "scummvm";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "scummvm";
    repo = "scummvm";
    rev = "v${version}";
    hash = "sha256-8/q16MwHhbbmUxiwJOHkjNxrnBB4grMa7qw/n3KLvRc=";
  };

  nativeBuildInputs = [ nasm ];

  buildInputs =
    lib.optionals stdenv.isLinux [
      alsa-lib
      libGLU
      libGL
    ]
    ++ lib.optionals stdenv.isDarwin [
      Cocoa
      AudioToolbox
      Carbon
      CoreMIDI
      AudioUnit
    ]
    ++ [
      curl
      freetype
      flac
      fluidsynth
      libjpeg
      libmad
      libmpeg2
      libogg
      libtheora
      libvorbis
      SDL2
      zlib
    ];

  dontDisableStatic = true;

  enableParallelBuilding = true;

  configurePlatforms = [ "host" ];
  configureFlags = [
    "--enable-release"
  ];

  # They use 'install -s', that calls the native strip instead of the cross
  postConfigure =
    ''
      sed -i "s/-c -s/-c -s --strip-program=''${STRIP@Q}/" ports.mk
    ''
    + lib.optionalString stdenv.isDarwin ''
      substituteInPlace config.mk \
        --replace x86_64-apple-darwin-ranlib ${cctools}/bin/ranlib \
        --replace aarch64-apple-darwin-ranlib ${cctools}/bin/ranlib
    '';

  meta = with lib; {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    mainProgram = "scummvm";
    homepage = "https://www.scummvm.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.peterhoeg ];
    platforms = platforms.unix;
  };
}
