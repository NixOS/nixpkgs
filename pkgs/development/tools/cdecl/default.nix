{stdenv, fetchurl, yacc, flex, readline, ncurses, gnused}:

stdenv.mkDerivation {
  name = "cdecl-2.5";
  src = fetchurl {
    url = "http://cdecl.org/files/cdecl-blocks-2.5.tar.gz";
    md5 = "c1927e146975b1c7524cbaf07a7c10f8";
  };

  patches = [ ./cdecl-2.5-lex.patch ];
  preBuild = ''
    ${gnused}/bin/sed 's/getline/cdecl_getline/g' -i cdecl.c;
    makeFlagsArray=(CFLAGS="-DBSD -DUSE_READLINE -std=gnu89" LIBS=-lreadline);
    makeFlags="$makeFlags PREFIX=$out BINDIR=$out/bin MANDIR=$out/man1 CATDIR=$out/cat1";
    mkdir -p $out/bin;
  '';
  buildInputs = [yacc flex readline ncurses];

  meta = {
    description = "Translator English -- C/C++ declarations";
    license = "Public Domain";
    maintainers = with stdenv.lib.maintainers; [viric joelteon];
    platforms = stdenv.lib.platforms.unix;
  };
}
