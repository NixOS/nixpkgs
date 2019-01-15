{ stdenv, fetchFromGitLab, cmake, qtbase }:

stdenv.mkDerivation rec {
  name = "enyo-doom-${version}";
  version = "1.06";

  src = fetchFromGitLab {
    owner = "sdcofer70";
    repo = "enyo-doom";
    rev = version;
    sha256 = "17f9qq8gnim6glqlrg7189my4d5y40v76cbpaqgpvrhpyc7z9vf6";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://gitlab.com/sdcofer70/enyo-doom";
    description = "Frontend for Doom engines";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.tadfisher ];
  };
}
