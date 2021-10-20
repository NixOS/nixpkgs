{ lib, stdenv, fetchFromGitHub, cmake, SDL2, SDL2_mixer, libpng }:

stdenv.mkDerivation rec {
  pname = "augustus";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "Keriew";
    repo = "augustus";
    rev = "v${version}";
    sha256 = "03pmnwq6bahq854vh1vmv1vabb8cs0alca8f36id8dlz8bw95nik";
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
