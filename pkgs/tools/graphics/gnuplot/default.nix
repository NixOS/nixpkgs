{ stdenv, fetchurl, zlib, gd, texinfo
, emacs ? null
, libX11 ? null
, libXt ? null
, libXpm ? null
, libXaw ? null
, wxGTK ? null
, pango ? null
, cairo ? null
, pkgconfig ? null
, x11Support ? false
, readline
}:

assert x11Support -> ((libX11 != null) &&
    (libXt != null) && (libXpm != null) &&
    (libXaw != null));

assert (wxGTK != null) -> x11Support;

stdenv.mkDerivation {
  name = "gnuplot-4.2.5";
  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/gnuplot-4.2.5.tar.gz";
    sha256 = "1y0imxy9bflzny98n1wvv19bqxfsvsxbl8z12k46qnna0vg7wiw9";
  };

  configureFlags = if x11Support then ["--with-x"] else ["--without-x"];

  buildInputs = [zlib gd texinfo readline emacs] ++
    (if x11Support then [libX11 libXt libXpm libXaw] else []) ++
    (if wxGTK != null then [wxGTK pango cairo pkgconfig] else []);
}
