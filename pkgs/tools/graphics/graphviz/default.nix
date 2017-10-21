{ stdenv, fetchurl, pkgconfig, libpng, libjpeg, expat
, yacc, libtool, fontconfig, pango, gd, xorg, gts, libdevil, gettext, cairo
, flex
, ApplicationServices
}:

stdenv.mkDerivation rec {
  version = "2.40.1";
  name = "graphviz-${version}";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/${name}.tar.gz";
    sha256 = "08d4ygkxz2f553bxj6087da56a23kx1khv0j8ycxa102vvx1hlna";
  };

  hardeningDisable = [ "fortify" ];

  patches = [ ];

  buildInputs =
    [ pkgconfig libpng libjpeg expat yacc libtool fontconfig gd gts libdevil flex pango
    ] ++ stdenv.lib.optionals (xorg != null)
      (with xorg; [ xlibsWrapper libXrender libXaw libXpm ])
    ++ stdenv.lib.optionals (stdenv.isDarwin) [ ApplicationServices gettext ];

  CPPFLAGS = stdenv.lib.optionalString (xorg != null && stdenv.isDarwin)
    "-I${cairo.dev}/include/cairo";

  configureFlags = stdenv.lib.optional (xorg == null) "--without-x";

  postPatch = (stdenv.lib.optionalString stdenv.isDarwin ''
    for foo in cmd/dot/Makefile.in cmd/edgepaint/Makefile.in \
                    cmd/mingle/Makefile.in plugin/gdiplus/Makefile.in; do
      substituteInPlace "$foo" --replace "-lstdc++" "-lc++"
    done
  '') + ''
      substituteInPlace "plugin/xlib/vimdot.sh" --replace "/usr/bin/vim" "\$(command -v vim)"
  '';

  preBuild = ''
    sed -e 's@am__append_5 *=.*@am_append_5 =@' -i lib/gvc/Makefile
  '';

  # "command -v" is POSIX, "which" is not
  postInstall = stdenv.lib.optionalString (xorg != null) ''
    sed -i 's|`which lefty`|"'$out'/bin/lefty"|' $out/bin/dotty
    sed -i 's|which|command -v|' $out/bin/vimdot
  '';

  meta = {
    homepage = http://www.graphviz.org/;
    description = "Open source graph visualization software";

    longDescription = ''
      Graphviz is open source graph visualization software. Graph
      visualization is a way of representing structural information as
      diagrams of abstract graphs and networks. It has important
      applications in networking, bioinformatics, software engineering,
      database and web design, machine learning, and in visual
      interfaces for other technical domains.
    '';

    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ bjornfor raskin ];
    downloadPage = "http://www.graphviz.org/pub/graphviz/ARCHIVE/";
    inherit version;
    updateWalker = true;
  };
}
