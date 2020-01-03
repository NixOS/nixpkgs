{ stdenv, fetchurl, ncurses, readline, flex, texinfo }:

stdenv.mkDerivation rec {
  pname = "cgdb";
  version = "0.7.1";

  src = fetchurl {
    url = "https://cgdb.me/files/${pname}-${version}.tar.gz";
    sha256 = "1671gpz5gx5j0zga8xy2x7h33vqh3nij93lbb6dbb366ivjknwmv";
  };

  buildInputs = [ ncurses readline flex texinfo ];

  meta = with stdenv.lib; {
    description = "A curses interface to gdb";

    homepage = https://cgdb.github.io/;

    repositories.git = git://github.com/cgdb/cgdb.git;

    license = licenses.gpl2Plus;

    platforms = with platforms; linux ++ cygwin;
    maintainers = with maintainers; [ vrthra ];
  };
}
