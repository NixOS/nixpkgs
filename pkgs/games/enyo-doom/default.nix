{ mkDerivation, stdenv, fetchFromGitLab, cmake, qtbase }:

mkDerivation rec {
  pname = "enyo-doom";
  version = "1.06.9";

  src = fetchFromGitLab {
    owner = "sdcofer70";
    repo = "enyo-doom";
    rev = version;
    sha256 = "0vx5zy47cqrqdgyx31wg56ivva0qqiyww8bp1x32ax99danymjyf";
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
