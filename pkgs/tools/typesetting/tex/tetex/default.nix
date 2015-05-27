{ stdenv, fetchurl, flex, bison, zlib, libpng, ncurses, ed, automake }:

stdenv.mkDerivation {
  name = "tetex-3.0";
  
  src = fetchurl {
    url = ftp://cam.ctan.org/tex-archive/systems/unix/teTeX/current/distrib/tetex-src-3.0.tar.gz;
    md5 = "944a4641e79e61043fdaf8f38ecbb4b3";
  };

  texmf = fetchurl {
    url = ftp://cam.ctan.org/tex-archive/systems/unix/teTeX/current/distrib/tetex-texmf-3.0.tar.gz;
    md5 = "11aa15c8d3e28ee7815e0d5fcdf43fd4";
  };

  buildInputs = [ flex bison zlib libpng ncurses ed ];

  # fixes "error: conflicting types for 'calloc'", etc.
  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 57d texk/kpathsea/c-std.h
  '';

  preConfigure = if stdenv.isCygwin then ''
    find ./ -name "config.guess" -exec rm {} \; -exec ln -s ${automake}/share/automake-*/config.guess {} \;
  '' else null;

  patches = [ ./environment.patch ./getline.patch ./clang.patch ];

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
  '';

  meta = with stdenv.lib; {
    description  = "A full-featured (La)TeX distribution";
    homepage     = http://www.tug.org/tetex/;
    matintainers = with maintainers; [ lovek323 ];
    platforms    = platforms.unix;
    hydraPlatforms = platforms.linux;
  };
}

