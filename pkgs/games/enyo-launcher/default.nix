{ mkDerivation, lib, fetchFromGitLab, cmake, qtbase }:

mkDerivation rec {
  pname = "enyo-launcher";
  version = "2.0.5";

  src = fetchFromGitLab {
    owner = "sdcofer70";
    repo = "enyo-launcher";
    rev = version;
    sha256 = "sha256-qdVP5QN2t0GK4VBWuFGrnRfgamQDZGRjwaAe6TIK604=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase ];

  meta = {
    homepage = "https://gitlab.com/sdcofer70/enyo-launcher";
    description = "Frontend for Doom engines";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.usrfriendly ];
  };
}
