{ stdenv, fetchurl, flex, bison, zlib, libpng, ncurses, ed, automake }:

stdenv.mkDerivation {
  name = "tetex-3.0";

  src = fetchurl {
    url = http://mirrors.ctan.org/obsolete/systems/unix/teTeX/3.0/distrib/tetex-src-3.0.tar.gz;
    sha256 = "16v44465ipd9yyqri9rgxp6rbgs194k4sh1kckvccvdsnnp7w3ww";
  };

  texmf = fetchurl {
    url = http://mirrors.ctan.org/obsolete/systems/unix/teTeX/3.0/distrib/tetex-texmf-3.0.tar.gz;
    sha256 = "1hj06qvm02a2hx1a67igp45kxlbkczjlg20gr8lbp73l36k8yfvc";
  };

  buildInputs = [ flex bison zlib libpng ncurses ed ];

  hardeningDisable = [ "format" ];

  # fixes "error: conflicting types for 'calloc'", etc.
  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 57d texk/kpathsea/c-std.h
  '';

  preConfigure = if stdenv.isCygwin then ''
    find ./ -name "config.guess" -exec rm {} \; -exec ln -s ${automake}/share/automake-*/config.guess {} \;
  '' else null;

  patches = [ ./environment.patch ./getline.patch ./clang.patch ./extramembot.patch ];

  setupHook = ./setup-hook.sh;

  configureFlags =
    [ "--disable-multiplatform" "--without-x11" "--without-xdvik"
      "--without-oxdvik" "--without-texinfo" "--without-texi2html"
      "--with-system-zlib" "--with-system-pnglib" "--with-system-ncurses" ]
    # couldn't get gsftopk working on darwin
    ++ stdenv.lib.optional stdenv.isDarwin "--without-gsftopk";

  postUnpack = ''
    mkdir -p $out/share/texmf
    mkdir -p $out/share/texmf-dist
    gunzip < $texmf | (cd $out/share/texmf-dist && tar xvf -)

    substituteInPlace ./tetex-src-3.0/configure --replace /usr/bin/install $(type -P install)
  '';

  meta = with stdenv.lib; {
    description  = "A full-featured (La)TeX distribution";
    homepage     = http://www.tug.org/tetex/;
    maintainers  = with maintainers; [ lovek323 ];
    platforms    = platforms.unix;
    hydraPlatforms = [];
  };
}

