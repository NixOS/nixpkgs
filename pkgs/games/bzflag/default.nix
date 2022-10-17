{ stdenv, lib, fetchurl, pkg-config
, curl, SDL2, libGLU, libGL, glew, ncurses, c-ares
, Carbon, CoreServices }:

stdenv.mkDerivation rec {
  pname = "bzflag";
  version = "2.4.24";

  src = fetchurl {
    url = "https://download.bzflag.org/${pname}/source/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-X4Exvrf8i6UeMjoG7NfY6rkVN8NCzoehE+XrbqmM48Q=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ curl SDL2 libGLU libGL glew ncurses c-ares ]
    ++ lib.optionals stdenv.isDarwin [ Carbon CoreServices ];

  meta = with lib; {
    description = "Multiplayer 3D Tank game";
    homepage = "https://bzflag.org/";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
