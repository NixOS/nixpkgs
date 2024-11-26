{ mkDerivation, lib, fetchFromGitLab, cmake, qtbase }:

mkDerivation rec {
  pname = "enyo-launcher";
  version = "2.0.6";

  src = fetchFromGitLab {
    owner = "sdcofer70";
    repo = "enyo-launcher";
    rev = version;
    hash = "sha256-k6Stc1tQOcdS//j+bFUNfnOUlwuhIPKxf9DHU+ng164=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase ];

  meta = {
    homepage = "https://gitlab.com/sdcofer70/enyo-launcher";
    description = "Frontend for Doom engines";
    mainProgram = "enyo-launcher";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.usrfriendly ];
  };
}
