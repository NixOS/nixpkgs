{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  cctools,
  pkg-config,
  SDL2,
  SDL2_mixer,
  SDL2_sound,
  qtbase,
  qtwayland,
  cmake,
  wrapQtAppsHook,
  libvorbis,
  smpeg
}:

stdenv.mkDerivation rec {
  pname = "gargoyle";
  version = "2023.1";

  src = fetchFromGitHub {
    owner = "garglk";
    repo = "garglk";
    rev = version;
    hash = "sha256-XsN5FXWJb3DSOjipxr/HW9R7QS+7iEaITERTrbGEMwA=";
  };

  nativeBuildInputs = [ pkg-config cmake wrapQtAppsHook ] ++ lib.optional stdenv.isDarwin cctools;

  buildInputs = [ SDL2 SDL2_mixer SDL2_sound qtbase ]
    ++ lib.optionals stdenv.isDarwin [ smpeg libvorbis ]
    ++ lib.optionals (!stdenv.isDarwin) [ qtwayland ];
  cmakeFlags = [
    "-DWITH_QT6=true"
  ];
  # Workaround build failure on -fno-common toolchains:
  #   ld: build/linux.release/alan3/Location.o:(.bss+0x0): multiple definition of
  #     `logFile'; build/linux.release/alan3/act.o:(.bss+0x0): first defined here
  # TODO: drop once updated to 2022.1 or later.
  # env.NIX_CFLAGS_COMPILE = "-fcommon";

  # Fix the paths in .pc, even though it's unclear if these .pc are really useful.
  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/garglk.pc \
      --replace '=''${prefix}//' '='
  '';


  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "http://ccxvii.net/gargoyle/";
    license = licenses.gpl2Plus;
    description = "Interactive fiction interpreter GUI";
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
