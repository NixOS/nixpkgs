{ callPackage
, fetchFromGitHub
}:

callPackage ./generic.nix rec {
  pname = "rat-king-adventure";
  version = "1.5.2a";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Rat-King-Adventure";
    rev = version;
    hash = "sha256-UgUm7GIn1frS66YYrx+ax+oqMKnQnDlqpn9e1kWwDzo=";
  };

  depsHash = "sha256-yE6zuLnFLtNq76AhtyE+giGLF2vcCqF7sfIvcY8W6Lg=";

  desktopName = "Rat King Adventure";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Rat-King-Adventure";
    downloadPage = "https://github.com/TrashboxBobylev/Rat-King-Adventure/releases";
    description = "An expansive fork of RKPD2, itself a fork of the Shattered Pixel Dungeon roguelike";
  };
}
