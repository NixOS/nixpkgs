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
  name = "gnuplot-4.2.6";
  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/gnuplot-4.2.6.tar.gz";
    sha256 = "10lfmbib3wrzfhvjqk7ffc29fb2aw6m84p4cx6znmgbpc3mw5yw1";
  };

  configureFlags = if x11Support then ["--with-x"] else ["--without-x"];

  buildInputs = [zlib gd texinfo readline emacs] ++
    (if x11Support then [libX11 libXt libXpm libXaw] else []) ++
    (if wxGTK != null then [wxGTK pango cairo pkgconfig] else []);
}
