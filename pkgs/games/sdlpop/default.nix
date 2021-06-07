{ lib, stdenv
, makeWrapper
, makeDesktopItem, copyDesktopItems
, fetchFromGitHub
, pkg-config
, SDL2, SDL2_image
}:

stdenv.mkDerivation rec {
  pname = "sdlpop";
  version = "1.21";

  src = fetchFromGitHub {
    owner = "NagyD";
    repo = "SDLPoP";
    rev = "v${version}";
    sha256 = "1q4mnyg8v4420f1bp24v8lgi335vijdv61yi3fan14jgfzl38l7w";
  };

  nativeBuildInputs = [ pkg-config makeWrapper copyDesktopItems ];
  buildInputs = [ SDL2 SDL2_image ];

  makeFlags = [ "-C" "src" ];

  preBuild = ''
    substituteInPlace src/Makefile --replace "CC = gcc" "CC = ${stdenv.cc.targetPrefix}gcc"
  '';

  # The prince binary expects two things of the working directory it is called from:
  # (1) There is a subdirectory "data" containing the level data.
  # (2) The working directory is writable, so save and quicksave files can be created.
  # Our solution is to ensure that ~/.local/share/sdlpop is the working
  # directory, symlinking the data files into it. This is the task of the
  # prince.sh wrapper.

  installPhase = ''
    runHook preInstall

    install -Dm755 prince $out/bin/.prince-bin
    substituteAll ${./prince.sh} $out/bin/prince
    chmod +x $out/bin/prince

    mkdir -p $out/share/sdlpop
    cp -r data doc mods SDLPoP.ini $out/share/sdlpop

    install -Dm755 data/icon.png $out/share/icons/hicolor/32x32/apps/sdlpop.png

    runHook postInstall
  '';

  desktopItems = [ (makeDesktopItem {
    name = "sdlpop";
    icon = "sdlpop";
    exec = "prince";
    desktopName = "SDLPoP";
    comment = "An open-source port of Prince of Persia";
    categories = "Game;AdventureGame;";
  }) ];

  meta = with lib; {
    description = "Open-source port of Prince of Persia";
    homepage = "https://github.com/NagyD/SDLPoP";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ iblech ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
