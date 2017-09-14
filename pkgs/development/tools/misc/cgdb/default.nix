{ stdenv, fetchurl, ncurses, readline, flex, texinfo }:

stdenv.mkDerivation rec {
  name = "cgdb-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "http://cgdb.me/files/${name}.tar.gz";
    sha256 = "08slzg3702v5nivjhdx2bciqxc5vqcn8pc4i4lsgkcwdcrj94ymz";
  };

  buildInputs = [ ncurses readline flex texinfo ];

  meta = with stdenv.lib; {
    description = "A curses interface to gdb";

    homepage = https://cgdb.github.io/;

    repositories.git = git://github.com/cgdb/cgdb.git;

    license = licenses.gpl2Plus;

    platforms = with platforms; linux ++ cygwin;
    maintainers = with maintainers; [ viric vrthra ];
  };
}
