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
  libX11,
  SDL2,
  zlib,
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
      libX11
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
        --replace-fail ${stdenv.hostPlatform.config}-ranlib ${cctools}/bin/ranlib
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
