{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "trunk-io";
<<<<<<< HEAD
  version = "1.2.7";

  src = fetchurl {
    url = "https://trunk.io/releases/launcher/${version}/trunk";
    hash = "sha256-i2m+6Y6gvkHYwzESJv0DkLcHkXqz+g4e43TV6u1UTj8=";
=======
  version = "1.2.4";

  src = fetchurl {
    url = "https://trunk.io/releases/launcher/${version}/trunk";
    hash = "sha256-ylQ4tcPVO367PtLtBkw+MKxoIY7b14Gse3IxnIxMtqc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D $src $out/bin/trunk
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://trunk.io/";
    description = "Developer experience toolkit used to check, test, merge, and monitor code";
    license = licenses.unfree;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
