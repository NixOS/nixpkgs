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

  patches = [
    # Fix building with Freetype 2.13.3. Remove after next release.
    (fetchpatch {
      url = "https://github.com/scummvm/scummvm/commit/65977961b20ba97b1213b5267da0cb1efb49063b.patch?full_index=1";
      hash = "sha256-e5dJd3gP8OAD3hEJlvOhMemsNErCKTn7avlprApFig0=";
    })
  ];

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

  meta = with lib; {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    mainProgram = "scummvm";
    homepage = "https://www.scummvm.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.peterhoeg ];
    platforms = platforms.unix;
  };
}
