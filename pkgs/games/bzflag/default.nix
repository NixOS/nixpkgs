{ stdenv, lib, fetchurl, pkgconfig
, curl, SDL2, libGLU_combined, glew, ncurses, c-ares
, Carbon, CoreServices }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bzflag";
  version = "2.4.18";

  src = fetchurl {
    url = "https://download.bzflag.org/${pname}/source/${version}/${name}.tar.bz2";
    sha256 = "1gmz31wmn3f8zq1bfilkgbf4qmi4fa0c93cs76mhg8h978pm23cx";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ curl SDL2 libGLU_combined glew ncurses c-ares ]
    ++ lib.optionals stdenv.isDarwin [ Carbon CoreServices ];

  meta = with lib; {
    description = "Multiplayer 3D Tank game";
    homepage = https://bzflag.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
