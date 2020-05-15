{ stdenv, lib, fetchurl, pkgconfig
, curl, SDL2, libGLU, libGL, glew, ncurses, c-ares
, Carbon, CoreServices }:

stdenv.mkDerivation rec {
  pname = "bzflag";
  version = "2.4.20";

  src = fetchurl {
    url = "https://download.bzflag.org/${pname}/source/${version}/${pname}-${version}.tar.bz2";
    sha256 = "16brxqmfiyz4j4lb8ihzjcbwqmpsms6vm3ijbp34lnw0blbwdjb2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ curl SDL2 libGLU libGL glew ncurses c-ares ]
    ++ lib.optionals stdenv.isDarwin [ Carbon CoreServices ];

  meta = with lib; {
    description = "Multiplayer 3D Tank game";
    homepage = "https://bzflag.org/";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
