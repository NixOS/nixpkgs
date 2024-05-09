{ lib, stdenv, fetchurl, ncurses, readline, flex, texinfo }:

stdenv.mkDerivation rec {
  pname = "cgdb";
  version = "0.8.0";

  src = fetchurl {
    url = "https://cgdb.me/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-DTi1JNN3JXsQa61thW2K4zBBQOHuJAhTQ+bd8bZYEfE=";
  };

  buildInputs = [ ncurses readline flex texinfo ];

  meta = with lib; {
    description = "A curses interface to gdb";
    mainProgram = "cgdb";

    homepage = "https://cgdb.github.io/";

    license = licenses.gpl2Plus;

    platforms = with platforms; linux ++ cygwin;
    maintainers = with maintainers; [ vrthra ];
  };
}
