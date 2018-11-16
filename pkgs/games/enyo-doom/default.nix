{ stdenv, fetchFromGitLab, cmake, qtbase }:

stdenv.mkDerivation rec {
  name = "enyo-doom-${version}";
  version = "1.05";

  src = fetchFromGitLab {
    owner = "sdcofer70";
    repo = "enyo-doom";
    rev = version;
    sha256 = "1bmpgqwcp7640dbq1w8bkbk6mkn4nj5yxkvmjrl5wnlg0m1g0jr7";
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
