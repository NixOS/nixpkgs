{ lib
, stdenv
, fetchurl
, autoconf
, automake
, SDL
, SDL_mixer
, SDL_image
, libmikmod
, tinyxml
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tecnoballz";
  version = "0.93.1";

  src = fetchurl {
    url = "https://linux.tlk.fr/games/TecnoballZ/download/tecnoballz-${finalAttrs.version}.tgz";
    sha256 = "sha256-WRW76e+/eXE/KwuyOjzTPFQnKwNznbIrUrz14fnvgug=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];

  buildInputs = [
    SDL
    SDL_mixer
    SDL_image
    libmikmod
    tinyxml
  ];

  # Newer compilers introduced warnings
  postPatch = ''
    substituteInPlace configure.ac \
      --replace "-Werror" ""
  '';

  preConfigure = ''
    ./bootstrap
  '';

  installFlags = [
    # Default is $(out)/games
    "gamesdir=$(out)/bin"
    # We set the scoredir to $TMPDIR at install time.
    # Otherwise it will try to write in /var/games at install time
    "scoredir=$(TMPDIR)"
  ];

  meta = with lib; {
    homepage = "https://linux.tlk.fr/games/TecnoballZ/";
    downloadPage = "https://linux.tlk.fr/games/TecnoballZ/download/";
    description = "A brick breaker game with a sophisticated system of weapons and bonuses";
    mainProgram = "tecnoballz";
    longDescription = ''
      A exciting Brick Breaker with 50 levels of game and 11 special levels,
      distributed on the 2 modes of game to give the player a sophisticated
      system of attack weapons with an enormous power of fire that can be build
      by gaining bonuses. Numerous decors, musics and sounds complete this great
      game. This game was ported from the Commodore Amiga.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
})
