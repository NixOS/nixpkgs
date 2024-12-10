{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ncurses5,
  enableSdl2 ? false,
  SDL2,
  SDL2_image,
  SDL2_sound,
  SDL2_mixer,
  SDL2_ttf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "angband";
  version = "4.2.5";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = finalAttrs.version;
    hash = "sha256-XH2FUTJJaH5TqV2UD1CKKAXE4CRAb6zfg1UQ79a15k0=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs =
    [ ncurses5 ]
    ++ lib.optionals enableSdl2 [
      SDL2
      SDL2_image
      SDL2_sound
      SDL2_mixer
      SDL2_ttf
    ];

  configureFlags = lib.optional enableSdl2 "--enable-sdl2";

  installFlags = [ "bindir=$(out)/bin" ];

  meta = with lib; {
    homepage = "https://angband.github.io/angband";
    description = "A single-player roguelike dungeon exploration game";
    mainProgram = "angband";
    maintainers = [ maintainers.kenran ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
})
