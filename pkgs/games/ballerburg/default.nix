{ lib, stdenv, fetchurl, cmake, SDL, makeDesktopItem, copyDesktopItems
, imagemagick }:

let

  icon = fetchurl {
    url = "https://baller.tuxfamily.org/king.png";
    sha256 = "1xq2h87s648wjpjl72ds3xnnk2jp8ghbkhjzh2g4hpkq2zdz90hy";
  };

in stdenv.mkDerivation rec {
  pname = "ballerburg";
  version = "1.2.0";

  src = fetchurl {
    url = "https://download.tuxfamily.org/baller/ballerburg-${version}.tar.gz";
    sha256 = "sha256-BiX0shPBGA8sshee8rxs41x+mdsrJzBqhpDDic6sYwA=";
  };

  nativeBuildInputs = [ cmake copyDesktopItems imagemagick ];

  buildInputs = [ SDL ];

  desktopItems = [
    (makeDesktopItem {
      name = "Ballerburg";
      desktopName = "Ballerburg SDL";
      exec = "_NET_WM_ICON=ballerburg ballerburg";
      comment = meta.description;
      icon = "ballerburg";
      categories = [ "Game" ];
    })
  ];

  postInstall = ''
    # Generate and install icon files
    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert ${icon} -sample "$size"x"$size" \
        -background white -gravity south -extent "$size"x"$size" \
        $out/share/icons/hicolor/"$size"x"$size"/apps/ballerburg.png
    done
  '';

  meta = with lib; {
    description = "Classic cannon combat game";
    longDescription = ''
      Two castles, separated by a mountain, try to defeat each other with their cannonballs,
      either by killing the opponent's king or by weakening the opponent enough so that the king capitulates.'';
    homepage = "https://baller.tuxfamily.org/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.j0hax ];
    platforms = platforms.all;
  };
}
