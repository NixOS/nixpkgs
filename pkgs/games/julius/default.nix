{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_mixer
, cmake
, libpng
}:

stdenv.mkDerivation rec {
  pname = "julius";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "bvschaik";
    repo = "julius";
    rev = "v${version}";
    hash = "sha256-I5GTaVWzz0ryGLDSS3rzxp+XFVXZa9hZmgwon/6r83A=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 SDL2_mixer libpng ];

  meta = with lib; {
    homepage = "https://github.com/bvschaik/julius";
    description = "An open source re-implementation of Caesar III";
    mainProgram = "julius";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Thra11 ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
