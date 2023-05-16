<<<<<<< HEAD
{ lib, stdenv, fetchFromSourcehut }:
=======
{ lib, stdenv, fetchFromGitHub }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

{
  # : string
  pname
  # : string
, version
  # : string
, sha256
  # : string
, description
  # : list Maintainer
, maintainers
  # : license
, license ? lib.licenses.isc
  # : string
<<<<<<< HEAD
, owner ? "~flexibeast"
=======
, owner ? "flexibeast"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # : string
, rev ? "v${version}"
}:

let
  manDir = "${placeholder "out"}/share/man";

<<<<<<< HEAD
  src = fetchFromSourcehut {
=======
  src = fetchFromGitHub {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit owner rev sha256;
    repo = pname;
  };
in

stdenv.mkDerivation {
  inherit pname version src;

  makeFlags = [
<<<<<<< HEAD
    "MAN_DIR=${manDir}"
=======
    "MANPATH=${manDir}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  dontBuild = true;

  meta = with lib; {
    inherit description license maintainers;
    inherit (src.meta) homepage;
    platforms = platforms.all;
  };
}
