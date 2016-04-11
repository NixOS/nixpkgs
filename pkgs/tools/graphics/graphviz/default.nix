{ stdenv, fetchurl, pkgconfig, libpng, libjpeg, expat, libXaw
, yacc, libtool, fontconfig, pango, gd, xorg, gts, libdevil, gettext, cairo
, flex
}:

stdenv.mkDerivation rec {
  version = "2.38.0";
  name = "graphviz-${version}";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/${name}.tar.gz";
    sha256 = "17l5czpvv5ilmg17frg0w4qwf89jzh2aglm9fgx0l0aakn6j7al1";
  };

  hardeningDisable = [ "fortify" ];

  patches =
    [ ./0001-vimdot-lookup-vim-in-PATH.patch

      # NOTE: Once this patch is removed, flex can probably be removed from
      # buildInputs.
      ./cve-2014-9157.patch
    ];

  buildInputs =
    [ pkgconfig libpng libjpeg expat yacc libtool fontconfig gd gts libdevil flex pango
    ] ++ stdenv.lib.optionals (xorg != null) [ xorg.xlibsWrapper xorg.libXrender libXaw ]
    ++ stdenv.lib.optional (stdenv.system == "x86_64-darwin") gettext;

  CPPFLAGS = stdenv.lib.optionalString (xorg != null && stdenv.system == "x86_64-darwin")
    "-I${cairo}/include/cairo";

  configureFlags =
    [ "--with-pngincludedir=${libpng}/include"
      "--with-pnglibdir=${libpng}/lib"
      "--with-jpegincludedir=${libjpeg}/include"
      "--with-jpeglibdir=${libjpeg}/lib"
      "--with-expatincludedir=${expat}/include"
      "--with-expatlibdir=${expat}/lib"
    ]
    ++ stdenv.lib.optional (xorg == null) "--without-x";

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    for foo in cmd/dot/Makefile.in cmd/edgepaint/Makefile.in \
                    cmd/mingle/Makefile.in plugin/gdiplus/Makefile.in; do
      substituteInPlace "$foo" --replace "-lstdc++" "-lc++"
    done
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
    homepage = "http://www.graphviz.org/";
    description = "Open source graph visualization software";

    longDescription = ''
      Graphviz is open source graph visualization software. Graph
      visualization is a way of representing structural information as
      diagrams of abstract graphs and networks. It has important
      applications in networking, bioinformatics, software engineering,
      database and web design, machine learning, and in visual
      interfaces for other technical domains.
    '';

    hydraPlatforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ simons bjornfor raskin ];
    downloadPage = "http://www.graphviz.org/pub/graphviz/ARCHIVE/";
    inherit version;
    updateWalker = true;
  };
}
