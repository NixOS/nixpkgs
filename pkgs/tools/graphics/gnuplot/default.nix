{ stdenv, fetchurl, zlib, gd, texinfo
, texLive ? null
, lua ? null
, emacs ? null
, libX11 ? null
, libXt ? null
, libXpm ? null
, libXaw ? null
, wxGTK ? null
, pango ? null
, cairo ? null
, pkgconfig ? null
, readline
}:

stdenv.mkDerivation rec {
  name = "gnuplot-4.4.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/${name}.tar.gz";
    sha256 = "1r799l6ww9w21qnklqfn335jkfc6y0ilhv3sv4x4mf4ghgacis1p";
  };

  configureFlags = if libX11 != null then ["--with-x"] else ["--without-x"];

  buildInputs =
    [ zlib gd texinfo readline emacs lua texLive libX11 libXt libXpm libXaw
      wxGTK pango cairo pkgconfig
    ];

  meta = {
    homepage = http://www.gnuplot.info;
    description = "A portable command-line driven graphing utility for many platforms";
    platforms = stdenv.lib.platforms.all;
  };
}
