{ stdenv, fetchurl, flex, bison, zlib, libpng, ncurses, ed }:

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

  patches = [ ./environment.patch ./getline.patch ];

  setupHook = ./setup-hook.sh;

  configureFlags =
    [ "--disable-multiplatform"
      "--without-x11"
      "--without-xdvik"
      "--without-oxdvik"
      "--without-texinfo"
      "--without-texi2html"
      "--with-system-zlib"
      "--with-system-pnglib"
      "--with-system-ncurses"
    ];

  postUnpack =
    ''
      mkdir -p $out/share/texmf
      mkdir -p $out/share/texmf-dist
      gunzip < $texmf | (cd $out/share/texmf-dist && tar xvf -)
    '';

  meta = {
    description = "A full-featured (La)TeX distribution";
  };
}
