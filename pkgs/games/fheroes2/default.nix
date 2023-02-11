{ stdenv, lib, fetchFromGitHub
, gettext, glibcLocalesUtf8, libpng, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, zlib

, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "fheroes2";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ihhub";
    repo = "fheroes2";
    rev = version;
    sha256 = "sha256-l7MFvcUOv1jA7moA8VYcaQO15eyK/06x6Jznz5jsNNg=";
  };

  buildInputs = [ gettext glibcLocalesUtf8 libpng SDL2 SDL2_image SDL2_mixer SDL2_ttf zlib ];

  makeFlags = [
    "FHEROES2_STRICT_COMPILATION=1"
    "FHEROES2_DATA=\"${placeholder "out"}/share/fheroes2\""
  ];

  enableParallelBuilding = true;

  postBuild = ''
    # Pick guaranteed to be present UTF-8 locale.
    # Otherwise `iconv` calls fail to produce valid translations.
    LANG=en_US.UTF_8 make -C files/lang
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 $PWD/src/dist/fheroes2 $out/bin/fheroes2

    install -Dm644 -t $out/share/fheroes2/files/lang $PWD/files/lang/*.mo
    install -Dm644 -t $out/share/fheroes2/files/data $PWD/files/data/resurrection.h2d

    runHook postInstall
  '';

  passthru = {
    updateScript = gitUpdater {
      url = "https://github.com/ihhub/fheroes2.git";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/ihhub/fheroes2";
    description = "Free implementation of Heroes of Might and Magic II game engine";
    longDescription = ''
        In order to play this game, an original game data is required.
        Please refer to README of the project for instructions.
        On linux, the data can be placed in ~/.local/share/fheroes2 folder.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.karolchmist ];
    platforms = platforms.linux;
  };
}
