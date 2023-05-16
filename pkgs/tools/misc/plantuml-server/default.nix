{ lib, stdenv, fetchurl }:

let
<<<<<<< HEAD
  version = "1.2023.10";
=======
  version = "1.2023.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
stdenv.mkDerivation rec {
  pname = "plantuml-server";
  inherit version;
  src = fetchurl {
    url = "https://github.com/plantuml/plantuml-server/releases/download/v${version}/plantuml-v${version}.war";
<<<<<<< HEAD
    sha256 = "sha256-EIdqY8sonLaHZCfOfAaUhm4M1XOek2M1OqPZkb/CTg4=";
=======
    sha256 = "sha256-ECzmT6VMjuoJT91iEYOS2ov0bsmNuwIKTwBgsLqwgDI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/plantuml.war"
  '';

  meta = with lib; {
    description = "A web application to generate UML diagrams on-the-fly.";
    homepage = "https://plantuml.com/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ truh ];
  };
}
