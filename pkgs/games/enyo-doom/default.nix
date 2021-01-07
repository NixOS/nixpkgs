{ mkDerivation, stdenv, fetchFromGitLab, cmake, qtbase }:

mkDerivation rec {
  pname = "enyo-doom";
  version = "2.0.2";

  src = fetchFromGitLab {
    owner = "sdcofer70";
    repo = "enyo-doom";
    rev = version;
    sha256 = "1s1vpwrrpb9c7r2b0k1j7dlsfasfzmi6prcwql4mxwixrl7f8ms1";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://gitlab.com/sdcofer70/enyo-doom";
    description = "Frontend for Doom engines";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.tadfisher ];
  };
}
