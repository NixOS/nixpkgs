{ lib, stdenv, fetchurl, makeDesktopItem, copyDesktopItems, SDL, lua5_1, pkg-config, SDL_mixer, SDL_image, SDL_ttf }:

stdenv.mkDerivation rec {
  pname = "fish-fillets-ng";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/fillets/fillets-ng-${version}.tar.gz";
    sha256 = "1nljp75aqqb35qq3x7abhs2kp69vjcj0h1vxcpdyn2yn2nalv6ij";
  };
  data = fetchurl {
    url = "mirror://sourceforge/fillets/fillets-ng-data-${version}.tar.gz";
    sha256 = "169p0yqh2gxvhdilvjc2ld8aap7lv2nhkhkg4i1hlmgc6pxpkjgh";
  };

  nativeBuildInputs = [ pkg-config copyDesktopItems ];
  buildInputs = [ SDL lua5_1 SDL_mixer SDL_image SDL_ttf ];

  desktopItems = [ (makeDesktopItem {
    name = "fish-fillets-ng";
    exec = "fillets";
    icon = "fish-fillets-ng";
    desktopName = "Fish Fillets";
    comment     = "Puzzle game about witty fish saving the world sokoban-style";
    categories  = [ "Game" "LogicGame" ];
  }) ];

  postInstall = ''
    mkdir -p $out/share/games/fillets-ng
    tar -xf ${data} -C $out/share/games/fillets-ng --strip-components=1
    install -Dm644 ${./icon.xpm} $out/share/pixmaps/fish-fillets-ng.xpm
  '';

  meta = with lib; {
    description = "A puzzle game";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "http://fillets.sourceforge.net/";
  };
}
