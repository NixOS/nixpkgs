{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "scummvm";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "scummvm";
    repo = "scummvm";
    rev = "v${version}";
    hash = "sha256-4/h1bzauYWNvG7skn6afF79t0KEdgYLZoeqeqRudH7I=";
  };

  nativeBuildInputs = [ nasm ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libGLU
      libGL
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace config.mk \
        --replace x86_64-apple-darwin-ranlib ${cctools}/bin/ranlib \
        --replace aarch64-apple-darwin-ranlib ${cctools}/bin/ranlib
    '';

  NIX_CFLAGS_COMPILE = [ "-fpermissive" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    mainProgram = "scummvm";
    homepage = "https://www.scummvm.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.peterhoeg ];
    platforms = platforms.unix;
  };
}
