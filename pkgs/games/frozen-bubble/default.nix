{ lib, makeDesktopItem, copyDesktopItems, fetchurl, perlPackages, pkgconfig, SDL, SDL_mixer, SDL_Pango, glib }:

perlPackages.buildPerlModule {
  pname = "frozen-bubble";
  version = "2.212";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KT/KTHAKORE/Games-FrozenBubble-2.212.tar.gz";
    sha256 = "721e04ff69c5233060656bfbf4002aa1aeadd96c95351f0c57bb85b6da35a305";
  };
  patches = [ ./fix-compilation.patch ];

  nativeBuildInputs = [ pkgconfig copyDesktopItems ];

  buildInputs =  [ glib SDL SDL_mixer SDL_Pango perlPackages.SDL perlPackages.FileSlurp ];
  propagatedBuildInputs = with perlPackages; [ AlienSDL CompressBzip2 FileShareDir FileWhich IPCSystemSimple LocaleMaketextLexicon ];

  perlPreHook = "export LD=$CC";

  desktopItems = [ (makeDesktopItem {
    name = "frozen-bubble";
    exec = "frozen-bubble";
    icon = "frozen-bubble";
    desktopName = "Frozen Bubble";
    comment     = "Pop out the bubbles!";
    categories  = "Game;ArcadeGame;";
  }) ];

  postInstall = ''
    for size in 16x16 32x32 48x48 64x64; do
      install -Dm644 share/icons/frozen-bubble-icon-$size.png $out/share/icons/hicolor/$size/apps/frozen-bubble.png
    done
  '';

  meta = with lib; {
    description = "Puzzle with Bubbles";
    license = licenses.gpl2;
    maintainers = with maintainers; [ puckipedia ];
  };
}
