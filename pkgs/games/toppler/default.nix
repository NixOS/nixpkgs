{ lib
, stdenv
, fetchFromGitLab

, pkg-config
, gettext
, povray
, imagemagick
, gimp

, SDL2
, SDL2_mixer
, SDL2_image
, libpng
, zlib
}:

stdenv.mkDerivation rec {
  pname = "toppler";
  version = "1.3";

  src = fetchFromGitLab {
    owner = "roever";
    repo = "toppler";
    rev = "v${version}";
    sha256 = "sha256-ecEaELu52Nmov/BD9VzcUw6wyWeHJcsKQkEzTnaW330=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    povray
    imagemagick
    gimp
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_image
    libpng
    zlib
  ];

  # GIMP needs a writable home
  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Jump and run game, reimplementation of Tower Toppler/Nebulus";
    homepage = "https://gitlab.com/roever/toppler";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
