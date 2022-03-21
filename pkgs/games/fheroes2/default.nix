{ stdenv, lib, fetchFromGitHub
, gettext, libpng, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, zlib

# updater only
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "fheroes2";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "ihhub";
    repo = "fheroes2";
    rev = version;
    sha256 = "sha256-+VAgS7NR/D0HD/Fy7idSUTMJPp2ctpirMpcFooo+bEg=";
  };

  buildInputs = [ gettext libpng SDL2 SDL2_image SDL2_mixer SDL2_ttf zlib ];

  makeFlags = [
    "FHEROES2_STRICT_COMPILATION=1"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $PWD/src/dist/fheroes2 $out/bin/fheroes2

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
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
