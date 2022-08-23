{ lib, stdenv, fetchFromGitHub, autoreconfHook, ncurses5
, enableSdl2 ? false, SDL2, SDL2_image, SDL2_sound, SDL2_mixer, SDL2_ttf
}:

stdenv.mkDerivation rec {
  pname = "angband";
  version = "4.2.4";

  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = version;
    sha256 = "sha256-Fp3BGCZYYdQCKXOLYsT4zzlibNRlbELZi26ofrbGGPQ=";
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
    maintainers = [ ];
    license = licenses.gpl2;
  };
}
