{ stdenv, fetchurl, ncurses, readline, flex, texinfo, help2man }:

stdenv.mkDerivation rec {
  name = "cgdb-${version}";
  version = "0.6.8";

  src = fetchurl {
    url = "http://cgdb.me/files/${name}.tar.gz";
    sha256 = "0hfgyj8jimb7imqlfdpzaln787r6r0yzwzmnk91rfl19pqlkw85y";
  };

  buildInputs = [ ncurses readline flex texinfo help2man ];

  meta = with stdenv.lib; {
    description = "A curses interface to gdb";

    homepage = https://cgdb.github.io/;

    repositories.git = git://github.com/cgdb/cgdb.git;

    license = licenses.gpl2Plus;

    platforms = with platforms; linux ++ cygwin;
    maintainers = with maintainers; [ viric vrthra ];
  };
}
