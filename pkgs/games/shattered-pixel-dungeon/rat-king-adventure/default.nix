{ callPackage
, fetchFromGitHub
}:

callPackage ../generic.nix rec {
  pname = "rat-king-adventure";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Rat-King-Adventure";
    rev = version;
    hash = "sha256-RobFWEqIxI2gdgbJqaUWJ9MpOcAeOGOaJlrIY2NNUs8=";
  };

  desktopName = "Rat King Adventure";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Rat-King-Adventure";
    downloadPage = "https://github.com/TrashboxBobylev/Rat-King-Adventure/releases";
    description = "An expansive fork of RKPD2, itself a fork of the Shattered Pixel Dungeon roguelike";
  };
}
