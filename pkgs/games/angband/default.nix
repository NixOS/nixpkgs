{ lib, stdenv, fetchFromGitHub, autoreconfHook, ncurses5
, enableSdl2 ? false, SDL2, SDL2_image, SDL2_sound, SDL2_mixer, SDL2_ttf
}:

stdenv.mkDerivation rec {
  pname = "angband";
<<<<<<< HEAD
  version = "4.2.5";
=======
  version = "4.2.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-XH2FUTJJaH5TqV2UD1CKKAXE4CRAb6zfg1UQ79a15k0=";
=======
    sha256 = "sha256-Fp3BGCZYYdQCKXOLYsT4zzlibNRlbELZi26ofrbGGPQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };


  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses5 ]
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
    maintainers = [ maintainers.kenran ];
    license = licenses.gpl2;
  };
}
