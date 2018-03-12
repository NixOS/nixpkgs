{ stdenv, lib, fetchurl, pkgconfig
, curl, SDL2, libGLU_combined, glew, ncurses, c-ares }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bzflag";
  version = "2.4.12";

  src = fetchurl {
    url = "https://download.bzflag.org/${pname}/source/${version}/${name}.tar.bz2";
    sha256 = "0380y47kgl97ld3dybjgjr2zwxqky8f938k9z7vad647cic3m8d8";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ curl SDL2 libGLU_combined glew ncurses c-ares ];

  meta = with lib; {
    description = "Multiplayer 3D Tank game";
    homepage = https://bzflag.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
