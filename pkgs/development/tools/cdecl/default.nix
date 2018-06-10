{stdenv, fetchurl, yacc, flex, readline, ncurses, gnused}:

stdenv.mkDerivation {
  name = "cdecl-2.5";
  src = fetchurl {
    url = "http://www.cdecl.org/files/cdecl-blocks-2.5.tar.gz";
    sha256 = "1b7k0ra30hh8mg8fqv0f0yzkaac6lfg6n376drgbpxg4wwml1rly";
  };

  patches = [ ./cdecl-2.5-lex.patch ];
  preBuild = ''
    ${gnused}/bin/sed 's/getline/cdecl_getline/g' -i cdecl.c;
    makeFlagsArray=(CFLAGS="-DBSD -DUSE_READLINE -std=gnu89" LIBS=-lreadline);
    makeFlags="$makeFlags PREFIX=$out BINDIR=$out/bin MANDIR=$out/man1 CATDIR=$out/cat1 CC=$CC";
    mkdir -p $out/bin;
  '';
  buildInputs = [yacc flex readline ncurses];

  meta = {
    description = "Translator English -- C/C++ declarations";
    license = stdenv.lib.licenses.publicDomain;
    maintainers = with stdenv.lib.maintainers; [viric joelteon];
    platforms = stdenv.lib.platforms.unix;
  };
}
