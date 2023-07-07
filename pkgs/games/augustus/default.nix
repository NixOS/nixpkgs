{ lib, stdenv, fetchFromGitHub, cmake, SDL2, SDL2_mixer, libpng }:

stdenv.mkDerivation rec {
  pname = "augustus";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "Keriew";
    repo = "augustus";
    rev = "v${version}";
    sha256 = "sha256-NS6ijgI/wLsGF5KabjaR7ElKWFXIdjpmPYHVmI4oMzQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 SDL2_mixer libpng ];

  meta = with lib; {
    description = "An open source re-implementation of Caesar III. Fork of Julius incorporating gameplay changes";
    homepage = "https://github.com/Keriew/augustus";
    license = licenses.agpl3Only;
    platforms = platforms.all;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ Thra11 ];
  };
}
